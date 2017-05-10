/*******************************************************************************
Test-Automation DDL for operational tables
History:
  02/28/2017  Todd Morley   initial file creation
  03/08/2017  Todd Morley   completed coding/compiling
  04/10/2017  Todd Morley   bug fixes
  04/17/2017  Todd Morley   bug fixes
  04/18/2017  Todd Morley   bug fixes
  04/26/2017  Todd Morley   bug fixes
*******************************************************************************/

/*******************************************************************************
dependentModuleClosure is a recursive function that closes an event's 
touched-module list.  When you call this function, pass it recursionLevelIn = 1.
At present the function stops 100 levels deep.
*******************************************************************************/
create or replace function ta.dependentModuleClosure(
  moduleIdIn in timestamp,
  eventIdIn in bigint,
  recursionLevelIn in integer
)
returns void
as $$
  declare
    i integer;
    tempEventCount integer;
    tempModuleCount integer;
    tempModuleIds bigint[];
    tempUpperLimit integer;
    tempRecursionLevel integer;
  begin
    -- Check inputs
    tempRecursionLevel := recursionLevelIn + 1;
    select count(*)
      into tempModuleCount
      from ta.module
      where
        id = moduleIdIn and
        end_datetime is null;
    select count(*)
      into tempEventCount
      from ta.event
      where id = eventIdIn;
    if
      tempEventCount = 0 or
      tempModuleCount = 0 or
      moduleIdIn is null or 
      eventIdIn is null
    then
      raise exception 'invalid input passed to ta.dependentModuleClosure';
    end if;
    if tempRecursionLevel > 100 then
      raise exception 'The function ta.dependentModuleClosure is recursing too deeply!';
    end if;
    -- Fetch modules that depend on the input module.
    tempModuleIds := array(
      select depending_module_id
        from ta.module_module
        where 
          depended_module_id = moduleIdIn and
          end_datetime is null
    );
    -- Add the depending modules to the event's touched-module list.
    insert into ta.module_event(
      module_id,
      event_id
    ) values(
      unnest(tempModuleIds),
      eventIdIn
    );
    -- Recurse.
    tempUpperLimit := array_count(tempModuleIds);
    for i in 1 .. tempUpperLimit loop
      select ta.dependentModuleClosure(
        moduleIdIn := tempModuleIds[i],
        eventIdIn := eventIdIn,
        recursionLevelIn := tempRecursionLevel
      );      
    end loop;
  end
$$
language plpgsql;

/*******************************************************************************
registerEvent function 
1. registers a new event
2. records the source files the event explicitly touches.
3. records the modules the event explicitly touches.  
4. enriches the touched-module list with modules that contain the input
   source files.
5. recursively enriches the touched-module list with modules depending on the
   modules in the touched-module list.  (That is, computes the closure of the
   touched-module list under the module-module dependency relation.)
6. requests primary (or, optionally, all) tests for the final list of touched
   modules.
7. returns the event's ID.
*******************************************************************************/
create or replace function ta.registerEvent(
  eventDateTimeIn in timestamp,
  eventTypeIdIn in bigint,
  originatingPersonIdIn in bigint,
  primaryTestsOnlyYnIn in char,
  sourceFileIdsIn in bigint[],
  moduleIdsIn in bigint[]
)
returns bigint
as $$
  declare
    i integer;
    tempEventId bigint;
    tempModuleIds bigint[];
    tempRequestStatusTypeId bigint;
    tempRequiredTestIds bigint[];
    tempSourceControlBranchId bigint;
    tempSourceControlServerId bigint;
    tempSourceControlSystemTypeId bigint;
    tempTimestamp timestamp;
    tempUpperLimit integer;
    tempSourceFileCount integer;
    tempModuleCount integer;
  begin
    -- Check inputs
    if
      eventDateTimeIn is null or
      eventTypeIdIn is null or
      originatingPersonIdIn is null or
      primaryTestsOnlyYnIn is null or
      (
        array_length(sourceFileIdsIn, 1) = 0 and
        array_length(moduleIdsIn, 1) = 0
      )
    then
      raise exception 'invalid input passed to ta.registerEvent';
    end if;
     tempRequestStatusTypeId := ta.getRequestStatusTypeId(nameIn := 'node not assigned');
    -- Insert into operational tables.
    tempTimestamp := current_timestamp;
    select nextval('ta.event_id_s') into tempEventId;
    insert into ta.event(
      id,
      date_time,
      event_type_id,
      originating_person_id
    ) values(
      tempEventId,
      eventDateTimeIn,
      eventTypeIdIn,
      originatingPersonIdIn
    );
    insert into ta.source_file_event(
      source_file_id,
      event_id
    ) values(
      unnest(sourceFileIdsIn),
      tempEventId
    );
    insert into ta.module_event(
      module_id,
      event_id
    ) values(
      unnest(moduleIdsIn),
      tempEventId
    );
    -- Insert into data-warehouse tables.
    if(array_length(sourceFileIdsIn, 1) > 0) then
      select
        ta.source_file.source_control_branch_id,
        ta.source_control_branch.source_control_server_id,
        ta.source_control_server.source_control_system_type_id
      into
        tempSourceControlBranchId,
        tempSourceControlServerId,
        tempSourceControlSystemTypeId
      from
        ta.source_file,
        ta.source_control_branch,
        ta.source_control_server
      where
        ta.source_file.id = sourceFileIdsIn[1] and
        ta.source_control_branch.id = ta.source_file.source_control_branch_id and
        ta.source_control_server.id = ta.source_control_branch.source_control_server_id;
    else -- array_length(moduleIdsIn, 1) > 0
      tempSourceControlBranchId := null;
      tempSourceControlServerId := null;
      tempSourceControlSystemTypeId := null;
    end if;
    insert into ta.event_atomic_fact(
      date_time,
      date_dim_id,
      event_type_id,
      originating_person_id,
      source_control_branch_id,
      source_control_server_id,
      source_control_system_type_id
    ) values(
      tempTimestamp,
      ta.getDateId(timestampIn := tempTimestamp),
      eventTypeIdIn,
      originatingPersonIdIn,
      tempSourceControlBranchId,
      tempSourceControlServerId,
      tempSourceControlSystemTypeId
    );
    -- Add the source files' modules to the touched-module list.
    if(array_length(sourceFileIdsIn, 1) > 0) then
      tempModuleIds := ta.getSourceFilesModules(sourceFileIdsIn := sourceFileIdsIn);
      if(array_length(tempModuleIds, 1) > 0) then
        insert into ta.module_event(
          module_id,
          event_id
        ) values(
          unnest(tempModuleIds),
          tempEventId
        );
      end if;
    end if;
    -- Compute the closure of the event's touched modules.
    tempUpperLimit := array_length(tempModuleIds, 1);
    if(tempUpperLimit > 0) then
      for i in 1 .. tempUpperLimit loop
        select ta.dependentModuleClosure(
          moduleIdIn := tempModuleIds[i],
          eventIdIn := tempEventId,
          recursionLevelIn := 1
        );
      end loop;
    end if;
    -- Fetch the set of tests required by the touched modules.
    select ta.module_test.test_id
      into tempRequiredTestIds
      from
        ta.module_test,
        ta.module_event
      where 
        ta.module_test.module_id = ta.module_event.module_id and
        ta.module_event.event_id = tempEventId and
        (
          lower(primaryTestsOnlyYnIn) = 'n' or
          ta.module_test.primary_yn = 'y'
        );
    -- Request tests.
    if(array_length(tempRequiredTestIds, 1) > 0) then
      insert into ta.test_request(
        date_time,
        failure_count,
        event_id,
        test_id,
        node_id,
        node_group_id,
        request_status_type_id
      ) values(
        tempTimestamp,
        0,
        tempEventId,
        unnest(tempRequiredTestIds),
        null,
        null,
        tempRequestStatusTypeId
      );
      insert into ta.test_request_status_change_fact(
        date_time,
        date_dim_id,
        test_id,
        event_id,
        request_status_type_id
      ) values(
        tempTimestamp,
        ta.getDateId(dateIn := tempTimestamp),
        unnest(tempRequiredTestIds),
        tempEventId,
        tempRequestStatusTypeId
      );
    end if;
    return(tempEventId);
  end
$$
language plpgsql;

/*******************************************************************************
getEventTestRequests returns the list of tests requested for the input event.
If unassignedRequestsOnlyYNIn is 'Y', the returned list is limited to tests
that are not yet assigned to a node.  
*******************************************************************************/
create or replace function ta.getEventTestRequests(
  eventIdIn in bigint,
  requestStatusTypeIdsIn in bigint[],
  maximumFailureCountIn in integer default 3
)
returns table(test_id bigint)
as $$
  declare
  begin
    if eventIdIn is null then
      raise exception 'invalid input passed to ta.getEventTestRequests';
    end if;
    return query
      select ta.test_request.test_id
      from ta.test_request
      where 
        event_id = eventIdIn and
        (
          array_length(requestStatusTypeIdsIn, 1) = 0 or
          request_status_type_id = any(requestStatusTypeIdsIn)
        ) and
        failure_count <= maximumFailureCountIn;
  end
$$
language plpgsql;

/*******************************************************************************
updateTestRequestNode updates the node and node group of the input test for the
input event.
*******************************************************************************/
create or replace function ta.updateTestRequestNode(
  eventIdIn in bigint,
  testIdIn in bigint,
  nodeIdIn in bigint,
  nodeGroupIdIn in bigint
)  
returns void
as $$
  declare
    tempRequestStatusTypeId bigint;
    tempTimestamp timestamp;
  begin
    if(
      eventIdIn is null or
      testIdIn is null or
      nodeIdIn is null or
      nodeGroupIdIn is null
    ) then
      raise exception 'invalid input passed to ta.updateTestRequestNode';
    end if;
    tempRequestStatusTypeId := ta.getRequestStatusTypeId(nameIn := 'node assigned');
    tempTimestamp := current_timestamp;
    update ta.test_request
      set
        date_time = tempTimestamp,
        node_id = nodeIdIn,
        node_group_id = nodeGroupIdIn,
        request_status_type_id = tempRequestStatusTypeId
      where
        event_id = eventIdIn and
        test_id = testIdIn;
    insert into ta.test_request_status_change_fact(
      date_time,
      date_dim_id,
      test_id,
      event_id,
      request_status_type_id
    ) values(
      tempTimestamp,
      ta.getDateId(timestampIn := tempTimestamp),
      testIdIn,
      eventIdIn,
      tempRequestStatusTypeId
    );
  end
$$
language plpgsql;

/*******************************************************************************
updateTestRequestStatus updates the status of the input requested test for the
input event.  Only use this function to set a request's status to 
'test-execution failed'.  (This list of explicitly updateable statuses may grow 
over time.)  Other operational functions implicitly set the other 
request-status types.  Use instead the reportTestExecutionFailure function
(see below), which is a wrapper for this function for its current use case.
*******************************************************************************/
create or replace function ta.updateTestRequestStatus(
  eventIdIn in bigint,
  testIdIn in bigint,
  requestStatusTypeIdIn in bigint
)
  returns void
as $$
  declare
    tempFailureCount integer;
    tempRequestStatusTypeId bigint;
    tempTimestamp timestamp;
  begin
    tempRequestStatusTypeId := 
      ta.getRequestStatusTypeId(nameIn := 'test-execution failed');
    if(
      eventIdIn is null or
      testIdIn is null or
      requestStatusTypeIdIn is null or
      tempRequestStatusTypeId != requestStatusTypeIdIn
    ) then
      raise exception 'invalid input passed to ta.updateTestRequestNode';
    end if;
    tempTimestamp := current_timestamp;
    select failure_count
      into tempFailureCount
      from ta.test_request
      where
        event_id = eventIdIn and
        test_id = test_idIn;
    update ta.test_request
      set 
        date_time = tempTimestamp,
        failure_count = tempFailureCount + 1,
        request_status_type_id = requestStatusTypeIdIn
      where
        event_id = eventIdIn and
        test_id = test_idIn;
    insert into ta.test_request_status_change_fact(
      date_time,
      date_dim_id,
      test_id,
      event_id,
      request_status_type_id
    ) values(
      tempTimestamp,
      ta.getDateId(timestampIn := tempTimestamp),
      testIdIn,
      eventIdIn,
      tempRequestStatusTypeId
    );
  end
$$
language plpgsql;

/*******************************************************************************
reportTestExecutionFailure reports a failed test execution.
*******************************************************************************/
create or replace function ta.reportTestExecutionFailure(
  eventIdIn in bigint,
  testIdIn in bigint
)
returns void
as $$
  declare
    tempRequestStatusTypeId bigint;
  begin
    tempRequestStatusTypeId := 
      ta.getRequestStatusTypeId(nameIn := 'test-execution failed');
    select ta.updateTestRequestStatus(
      eventIdIn := eventIdIn,
      testIdIn := testIdIn,
      requestStatusTypeIdIn := tempRequestStatusTypeId
    );
  end
$$
language plpgsql;

/*******************************************************************************
recordTestResult function records a test result in the operational test-result
table ta.test_result.  If a previous result for the same (event, test) pair is
already in the database, it will be overwritten.
*******************************************************************************/
create or replace function ta.recordTestResult(
  eventIdIn in bigint,
  testIdIn in bigint,
  testResultTypeIdIn in bigint,
  nodeIdIn in bigint,
  naturalLanguageIdIn in bigint,
  serializedResultValueIn in text
)
returns void
as $$
  declare
    tempCount integer;
    tempDateDimId bigint;
    tempNodeTypeId bigint;
    tempNodeType ta.node_type%rowtype;
    tempRequestStatusTypeId bigint;
    tempTimestamp timestamp;
  begin
    tempTimestamp := current_timestamp;
    if ta.getTestResultTypeName(idIn := testResultTypeIdIn) = 'start datetime' then
      tempRequestStatusTypeId := ta.getRequestStatusTypeId(nameIn := 'test started');
    else
      tempRequestStatusTypeId := ta.getRequestStatusTypeId(nameIn := 'test finished');
    end if;
    -- Check for pre-existence of result data, so function is safe to re-run.    
    select count(*) 
      into tempCount
      from ta.test_result
      where
        test_result_type_id = testResultTypeIdIn and
        event_id = eventIdIn and
        test_id = testIdIn;
    if tempCount > 0 then
      delete from ta.test_result
      where
        test_result_type_id = testResultTypeIdIn and
        event_id = eventIdIn and
        test_id = testIdIn;
    end if;
    -- Record the result in the operational table.
    insert into ta.test_result(
      serialized_result_value,
      test_result_type_id,
      event_id,
      test_id,
      node_id
    ) values(
      serializedResultValueIn,
      testResultTypeIdIn,
      eventIdIn,
      testIdIn,
      nodeIdIn
    );
    -- Update the operational test-request status.
    update ta.test_request
      set
        date_time = tempTimestamp,
        request_status_type_id = tempRequestStatusTypeId
      where
        event_id = eventIdIn and
        test_id = testIdIn;
    -- Merge into the fact table.
    tempDateDimId := ta.getDateId(timestampIn := tempTimestamp);
    tempNodeTypeId := ta.getNodeNodeTypeId(idIn := nodeIdIn);
    tempNodeType := ta.getNodeType(idIn := tempNodeTypeId);
    select count(*)
      into tempCount
      from ta.test_result_atomic_fact
      where
        event_id = eventIdIn and
        test_id = testIdIn;
    if tempCount = 0 then
      insert into ta.test_result_atomic_fact(
        serialized_result_value,
        date_time,
        date_dim_id,
        test_id,
        event_id,
        natural_language_id,
        test_result_type_id,
        node_id,
        node_type_id,
        operating_system_type_id,
        database_type_id,
        alteryx_type_id
      ) values(
        serializedResultValueIn,
        tempTimestamp,
        tempDateDimId,
        testIdIn,
        eventIdIn,
        naturalLanguageIdIn,
        testResultTypeIdIn,
        nodeIdIn,
        tempNodeTypeId,
        tempNodeType.operating_system_type_id,
        tempNodeType.database_type_id,
        tempNodeType.alteryx_type_id
      );
    else
      update ta.test_result_atomic_fact set
        serialized_result_value = serializedResultValueIn,
        date_time = tempTimestamp,
        date_dim_id = tempDateDimId,
        natural_language_id = naturalLanguageIdIn,
        test_result_type_id = testResultTypeIdIn,
        node_id = nodeIdIn,
        node_type_id = tempNodeTypeId,
        operating_system_type_id = tempNodeType.operating_system_type_id,
        database_type_id = tempNodeType.database_type_id,
        alteryx_type_id = tempNodeType.alteryx_type_id
      where
        test_id = testIdIn and
        event_id = eventIdIn;
    end if;
    -- Record the status change in the data warehouse.
    insert into ta.test_request_status_change_fact(
      date_time,
      date_dim_id,
      test_id,
      event_id,
      request_status_type_id
    ) values(
      tempTimestamp,
      tempDateDimId,
      testIdIn,
      eventIdIn,
      tempRequestStatusTypeId
    );
  end
$$
language plpgsql;

/*******************************************************************************
recordTestResults is a convenience wrapper around recordTestResult, so you can
report all of an event's test results at once.
*******************************************************************************/
create or replace function ta.recordTestResults(
  eventIdIn in bigint,
  testResultsIn in ta.testResultType[]
)
returns void
as $$
  declare
    i integer;
    tempUpperLimit integer;
  begin
    tempUpperLimit := array_length(testResultsIn, 1);
    for i in 1 .. tempUpperLimit loop
      select ta.recordTestResult(
        eventIdIn := eventIdIn,
        testIdIn := testResultsIn[i].test_id,
        testResultTypeIdIn := testResultsIn[i].result_type_id,
        nodeIdIn := testResultsIn[i].node_id,
        naturalLanguageIdIn := testResultsIn[i].natural_language_id,
        serializedResultValueIn := testResultsIn[i].serialized_value
      );
    end loop;
  end
$$
language plpgsql;
