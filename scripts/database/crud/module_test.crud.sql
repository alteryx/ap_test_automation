/*******************************************************************************
Test-Automation CRUD DDL for relation table ta.module_test
History:
  02/28/2017  Todd Morley   initial file creation
  03/08/2017  Todd Morley   added GetModulesTests
  03/22/2017  Todd Morley   added GetModuleTestDescription
  04/24/2017  Todd Morley   bug fix
*******************************************************************************/

/*******************************************************************************
Create function returns void (even if the target relation already
exists), and raises an exception upon error.  
*******************************************************************************/
create or replace function ta.createModuleTest(
  primaryYnIn in char,
  moduleIdIn in bigint,
  testIdIn in bigint
)
returns void
as $$
  declare
    tempModuleTestCount integer;
    tempModuleCount integer;
    tempTestCount integer;
  begin
    select count(*)
      into tempModuleCount
      from ta.module
      where
        id = moduleIdIn and
        end_datetime is null;
    select count(*)
      into tempTestCount
      from ta.test
      where
        id = testIdIn and
        end_datetime is null;
    if(
      tempTestCount = 0 or 
      tempModuleCount = 0 or
      primaryYnIn is null or
      moduleIdIn is null or
      testIdIn is null
    ) then
      raise exception 'invalid input passed to ta.createModuleTest';
    end if;
    select count(*)
      into tempModuleTestCount
      from ta.module_test
      where
        module_id = moduleIdIn and
        test_id = testIdIn and
        end_datetime is null;
    if(tempModuleTestCount > 0) then
      return;
    end if;
    insert into ta.module_test(
      primary_yn,
      create_datetime,
      end_datetime,
      module_id,
      test_id
    ) values(
      primaryYnIn,
      current_timestamp,
      null,
      moduleIdIn,
      testIdIn
    );
    return;
  end
$$
language plpgsql;

/*******************************************************************************
GetModuleTests function returns a table of IDs of tests for the input module.  
*******************************************************************************/
create or replace function ta.getModuleTests(moduleIdIn in bigint)
returns table(test_id bigint)
as $$
  declare
  begin
    return query select 
      test_id
      from ta.module_test 
      where 
        module_id = moduleIdIn and
        end_datetime is null;
    exception
      when no_data_found then return;
  end
$$
language plpgsql;

/*******************************************************************************
GetModulesTests function returns a table of IDs of tests for the input modules
(plural!).  
*******************************************************************************/
create or replace function ta.getModulesTests(moduleIdsIn in bigint[])
returns table(test_id bigint)
as $$
  declare
  begin
    return query select 
      test_id
      from ta.module_test 
      where 
        module_id = any(moduleIdsIn) and
        end_datetime is null;
    exception
      when no_data_found then return;
  end
$$
language plpgsql;

/*******************************************************************************
GetTestModules function returns a table of modules for the input test.  
*******************************************************************************/
create or replace function ta.getTestModules(testIdIn in bigint)
returns table(
  module_id bigint
)
as $$
  declare
  begin
    return query select 
      module_id
      from ta.module_test 
      where 
        test_id = testIdIn and
        end_datetime is null;
    exception
      when no_data_found then return;
  end
$$
language plpgsql;

/*******************************************************************************
getModuleTestDescription function returns text description of the input module-
test pair, if the test tests the module; and otherwise null.  
*******************************************************************************/
create or replace function ta.getModuleTestDescription(
  moduleIdIn in bigint,
  testIdIn in bigint
)
returns text
as $$
  declare
    tempDescription text;
  begin
    select 
      ta.test.name || ' tests ' || ta.module.name
      from 
        ta.module_test,
        ta.module,
        ta.test
      where 
        ta.test.id = testIdIn and 
        ta.module.id = moduleIdIn and
        ta.module_test.test_id = testIdIn and
        ta.module_test.module_id = moduleIdIn and
        ta.test.end_datetime is null and
        ta.module.end_datetime is null and
        ta.module_test.end_datetime is null;
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
Update function updates all exposed non-key attributes.
*******************************************************************************/
create or replace function ta.updateModuleTest(
  primaryYnIn in char,
  moduleIdIn in bigint,
  testIdIn in bigint
)
returns void
as $$
  declare
    tempModuleTestCount integer;
    tempModuleCount integer;
    tempTestCount integer;
    tempRow ta.module_test%rowtype;
    tempTimestamp timestamp;
  begin
    select count(*)
      into tempModuleCount
      from ta.module
      where
        id = moduleIdIn and
        end_datetime is null;
    select count(*)
      into tempTestCount
      from ta.test
      where
        id = testIdIn and
        end_datetime is null;
    select count(*)
      into tempModuleTestCount
      from ta.module_test
      where
        test_id = testIdIn and
        module_id = moduleIdIn and
        end_datetime is null;
    if(
      tempTestCount = 0 or 
      tempModuleCount = 0 or
      tempModuleTestCount = 0 or
      primaryYnIn is null or
      moduleIdIn is null or
      testIdIn is null
    ) then
      raise exception 'invalid input passed to ta.updateModuleTest';
    end if;
    select *
      into tempRow
      from ta.module_test
      where
        test_id = testIdIn and
        module_id = moduleIdIn and
        end_datetime is null;
    tempTimestamp := current_timestamp;
    update ta.module_test
      set end_datetime = tempTimestamp
      where
        module_id = moduleIdIn and
        test_id = testIdIn and
        end_datetime is null;
    insert into ta.module_test(
      primary_yn,
      create_datetime,
      end_datetime,
      module_id,
      test_id
    ) values(
      primaryYnIn,
      tempTimestamp,
      null,
      moduleIdIn,
      testIdIn
    );
    return;
  end
$$
language plpgsql;

/*******************************************************************************
Delete function deletes a (bug, test) relation and returns void.
*******************************************************************************/
create or replace function ta.deleteModuleTest(
  testIdIn in bigint,
  moduleIdIn in bigint
)
returns void
as $$
  declare
    tempId bigint;
  begin
     update ta.module_test 
      set end_datetime = current_timestamp
      where
        module_id = moduleIdIn and
        test_id = testIdIn and
        end_datetime is null;
    return;
  end
$$
language plpgsql;
