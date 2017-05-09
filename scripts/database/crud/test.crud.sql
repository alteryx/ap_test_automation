/*******************************************************************************
Test-Automation CRUD DDL for table ta.test
History:
  02/27/2017  Todd Morley   initial file creation
  03/21/2017  Todd Morley   added getTestDescription
  03/23/2017  Todd Morley   dropped description column, rewrote 
                            getTestDescription
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createTest(
	fileNameIn in text,
	pathIn in text,
	sourceControlServerIdIn in bigint,
	testPriorityLevelIdIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    if(
      fileNameIn is null or
      pathIn is null or
      sourceControlServerIdIn is null or
      testPriorityLevelIdIn is null
    ) then
      raise exception 'invalid input passed to ta.createTest';
    end if;
    begin
      select id 
        into strict tempId
        from ta.test 
        where 
          file_name = fileNameIn and
          path = pathIn and
          source_control_server_id = sourceControlServerIdIn and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.test_id_s') into tempId;
    insert into ta.test(
      id,
      file_name,
      path,
      create_datetime,
      end_datetime,
      source_control_server_id,
      test_priority_level_id
    ) values(
      tempId,
      fileNameIn,
      pathIn,
      current_timestamp,
      null,
      sourceControlServerIdIn,
      testPriorityLevelIdIn
    );
    return(tempId);
  end
$$
language plpgsql;

/*******************************************************************************
GetId function returns the surrogate primary key (ID) of the entity with the 
input natural-key value, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getTestId(
	fileNameIn in text,
	pathIn in text,
	sourceControlServerIdIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.test
      where 
        file_name = fileNameIn and 
        path = pathIn and
        source_control_server_id = sourceControlServerIdIn and
        end_datetime is null;
    return(tempId);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
Get function returns table rowtype, or null if no entity with the input ID was
found.
*******************************************************************************/
create or replace function ta.getTest(idIn in bigint)
returns ta.test
as $$
  declare
    tempRecord ta.test%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.test 
      where 
        id = idIn and 
        end_datetime is null;
    return(tempRecord);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
GetTestLocation function returns the test's location in a variable of type 
testLocationType, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.GetTestLocation(idIn in bigint)
returns ta.testLocationType
as $$
  declare
    tempLocation ta.testLocationType;
  begin
    select
      ta.test.file_name,
      ta.test.path,
      ta.source_control_server.static_ip_address,
      ta.source_control_server.dns_name
      into strict tempLocation
      from 
        ta.test,
        ta.source_control_server
      where 
        ta.test.id = idIn and
        ta.source_control_server.id = ta.test.source_control_server_id and
        ta.test.end_datetime is null and
        ta.source_control_server.end_datetime is null;
    return(tempLocation);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
getTestDescription returns a text description of the test with ID idIn, or null 
if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getTestDescription(idIn in bigint)
returns text
as $$
  declare
    tempDescription text;
  begin
    select 
      ta.test.path || 
      '/' || 
      ta.test.file_name || 
      ' @ ' || 
      nvl(ta.source_control_server.dns_name, ta.source_control_server.static_ip_address) ||
      '(' ||
      ta.test_priority_level.name ||
      ' priority)'
      into strict tempDescription
      from 
        ta.test,
        ta.source_control_server,
        ta.test_priority_level
      where 
        ta.test.id = idIn and
        ta.test.source_control_server_id = ta.source_control_server.id and
        ta.test.test_priority_level_id = ta.test_priority_level.id and
        ta.test.end_datetime is null and
        ta.source_control_server.end_datetime is null and
        ta.test_priority_level.end_datetime is null;
    return(tempDescription);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
The update function upates all entity properties that are not part of the
entity type's natural primary key.
*******************************************************************************/
create or replace function ta.updateTest(
  idIn in bigint,
	testPriorityLevelIdIn in bigint
)
returns bigint
as $$
  declare
    tempCount integer;
    tempRow ta.test%rowtype;
    tempTimestamp timestamp;
  begin
    select count(*)
      into tempCount
      from ta.test_priority_level
      where
        id = testPriorityLevelIdIn and
        end_datetime is null;
    if(
      tempCount = 0 or 
      testPriorityLevelIdIn is null
     ) then
      raise exception 'invalid input passed to ta.updateTest';
    end if;
    select * 
      into tempRow 
      from ta.test
      where
        id = idIn and
        end_datetime is null;
    tempTimestamp := current_timestamp;
    update ta.test
      set end_datetime = tempTimestamp
      where 
        id = idIn and
        end_datetime is null;
    insert into ta.test(
      id,
      file_name,
      path,
      create_datetime,
      end_datetime,
      source_control_server_id,
      test_priority_level_id
    ) values(
      idIn,
      tempRow.file_name,
      tempRow.path,
      tempTimestamp,
      null,
      tempRow.source_control_server_id,
      testPriorityLevelIdIn
    );
    return(idIn);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
Delete function returns deleted entity's ID in a variable of type bigint, if the
entity was found (and deleted), otherwise null.
*******************************************************************************/
create or replace function ta.deleteTest(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.test 
      set end_datetime = current_timestamp
      where
        id = idIn and
        end_datetime is null
      returning id into strict tempId;
    return(tempId);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;
