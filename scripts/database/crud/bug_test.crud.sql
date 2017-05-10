/*******************************************************************************
Test-Automation CRUD DDL for relation table ta.bug_test
History:
  02/28/2017  Todd Morley   initial file creation
  03/21/2017  Todd Morley   added getBugTestDescription
*******************************************************************************/

/*******************************************************************************
Create function returns void (even if the target relation already
exists), and raises an exception upon error.  
*******************************************************************************/
create or replace function ta.createBugTest(
  bugIdInMgtSystemIn in text,
  testIdIn in bigint,
  bugManagementServerIdIn in bigint
)
returns void
as $$
  declare
    tempBugTestCount integer;
    tempTestCount integer;
    tempBugMgtServerCount integer;
  begin
    -- We don't validate bug IDs; we assume they're right.
    select count(*)
      into tempTestCount
      from ta.test
      where
        id = testIdIn and
        end_datetime is null;
    select count(*)
      into tempBugMgtServerCount
      from ta.bug_management_server
      where
        id = bugManagementServerIdIn and
        end_datetime is null;
    if(
      tempTestCount = 0 or 
      tempBugMgtServerCount = 0 or
      bugIdInMgtSystemIn is null or
      testIdIn is null or
      bugManagementServerIdIn is null
    ) then
      raise exception 'invalid input passed to ta.createBugTest';
    end if;
    select count(*)
      into tempBugTestCount
      from ta.bug_test
      where
        bug_id_in_mgt_system = bugIdInMgtSystemIn and
        test_id = testIdIn and
        bug_management_server_id = bugManagementServerIdIn and
        end_datetime is null;
    if(tempBugTestCount > 0) then
      return;
    end if;
    insert into ta.bug_test(
      bug_id_in_mgt_system,
      test_id,
      bug_management_server_id,
      create_datetime,
      end_datetime
    ) values(
      bugIdInMgtSystemIn,
      testIdIn,
      bugManagementServerIdIn,
      current_timestamp,
      null
    );
    return;
  end
$$
language plpgsql;

/*******************************************************************************
GetBugTests function returns a table of IDs of tests for the input bug.  
*******************************************************************************/
create or replace function ta.getBugTests(
  bugIdInMgtSystemIn in text,
  bugManagementServerIdIn in bigint
)
returns table(test_id bigint)
as $$
  declare
  begin
    return query select 
      test_id
      from ta.bug_test 
      where 
        bug_id_in_mgt_system = bugIdInMgtSystemIn and
        bug_management_server_id = bugManagementServerIdIn and
        end_datetime is null;
    exception
      when no_data_found then return;
  end
$$
language plpgsql;

/*******************************************************************************
GetTestBugs function returns a table of bugs for the input test.  
*******************************************************************************/
create or replace function ta.getTestBugs(testIdIn in bigint)
returns table(
  bug_id_in_mgt_system text, 
  bug_management_server_id bigint
)
as $$
  declare
  begin
    return query select 
      bug_id_in_mgt_system,
      bug_management_server_id
      from ta.bug_test 
      where 
        test_id = testIdIn and
        end_datetime is null;
    exception
      when no_data_found then return;
  end
$$
language plpgsql;

/*******************************************************************************
getBugTestDescription function returns a description for the input test-bug
relation, or null if no such relation is found.
*******************************************************************************/
create or replace function ta.getBugTestDescription(
  bugIdIn in text,
  testIdIn in bigint,
  bugManagementServerIdIn in bigint
)
returns text
as $$
  declare
    tempDescription text;
  begin
    select
      ta.test.description ||
      ' for bug ' ||
      ta.bug_test.bug_id_in_mgt_system ||
      ' in ' ||
      ta.getBugManagementServerDescription(idIn = bugManagementServerIdIn)
      into strict tempDescription
      from 
        ta.bug_test,
        ta.test
      where 
        ta.bug_test.test_id = testIdIn and
        ta.bug_test.bug_id_in_mgt_system = bugIdIn and 
        ta.bug_test.bug_management_server_id = bugManagementServerIdIn and
        ta.bug_test.end_datetime is null and
        ta.test.id = testIdIn and
        ta.test.end_datetime is null;
    return(tempDescription);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;


/*******************************************************************************
No update function, because all exposed attributes belong to the natural key.
*******************************************************************************/

/*******************************************************************************
Delete function deletes a (bug, test) relation and returns void.
*******************************************************************************/
create or replace function ta.deleteBugTest(
  bugIdInMgtSystemIn in text,
  testIdIn in bigint,
  bugManagementServerIdIn in bigint
)
returns void
as $$
  declare
    tempId bigint;
  begin
     update ta.bug_test 
      set end_datetime = current_timestamp
      where
        bug_id_in_mgt_system = bugIdInMgtSystemIn and
        test_id = testIdIn and
        bug_management_server_id = bugManagementServerIdIn and
        end_datetime is null;
    return;
  end
$$
language plpgsql;
