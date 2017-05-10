/*******************************************************************************
Test-Automation CRUD DDL for relation table ta.case_dim_allowed_value_test
History:
  02/28/2017  Todd Morley   initial file creation
*******************************************************************************/

/*******************************************************************************
Create function returns void (even if the target relation already
exists), and raises an exception upon error.  
*******************************************************************************/
create or replace function ta.createCaseDimAllowedValueTest(
  caseDimAllowedValueIdIn in bigint,
  testIdIn in bigint
)
returns void
as $$
  declare
    tempCaseDimAllowedValueTestCount integer;
    tempCaseDimAllowedValueCount integer;
    tempTestCount integer;
  begin
    select count(*)
      into tempCaseDimAllowedValueCount
      from ta.case_dimension_allowed_value
      where
        id = caseDimAllowedValueIdIn and
        end_datetime is null;
    select count(*)
      into tempTestCount
      from ta.test
      where
        id = testIdIn and
        end_datetime is null;
    if(
      tempCaseDimAllowedValueCount = 0 or 
      tempTestCount = 0 or
      caseDimAllowedValueIdIn is null or
      testIdIn is null
    ) then
      raise exception 'invalid input passed to ta.createCaseDimAllowedValueTest';
    end if;
    select count(*)
      into tempCaseDimAllowedValueTestCount
      from ta.case_dim_allowed_value_test
      where
        case_dim_allowed_value_id = caseDimAllowedValueIdIn and
        test_id = testIdIn and
        end_datetime is null;
    if(tempCaseDimAllowedValueTestCount > 0) then
      return;
    end if;
    insert into ta.case_dim_allowed_value_test(
      create_datetime,
      end_datetime,
      case_dimension_allowed_value_id,
      test_id
    ) values(
      current_timestamp,
      null,
      caseDimAllowedValueIdIn,
      testIdIn
    );
    return;
  end
$$
language plpgsql;

/*******************************************************************************
GetCaseDimAllowedValueTests function returns a table of IDs of tests for the input case_dimension_allowed_value.
*******************************************************************************/
create or replace function ta.getCaseDimAllowedValueTests(
  caseDimAllowedValueIdIn in bigint
)
returns table(test_id bigint)
as $$
  declare
  begin
    return query select 
      test_id
      from ta.case_dim_allowed_value_test 
      where 
        case_dimension_allowed_value_id = caseDimAllowedValueIdIn and
        end_datetime is null;
    exception
      when no_data_found then return;
  end
$$
language plpgsql;

/*******************************************************************************
GetTestCaseDimAllowedValues function returns a table of IDs of case_dimension_allowed_values tested by the input test. 
*******************************************************************************/
create or replace function ta.GetTestCaseDimAllowedValues(testIdIn in bigint)
returns table(case_dimension_allowed_value_id bigint)
as $$
  declare
  begin
    return query select 
      case_dimension_allowed_value_id
      from ta.case_dim_allowed_value_test
      where 
        test_id = testIdIn and
        end_datetime is null;
    exception
      when no_data_found then return;
  end
$$
language plpgsql;

/*******************************************************************************
No update function; all exposed attributes are in key.
*******************************************************************************/

/*******************************************************************************
Delete function deletes a (case_dimension_allowed_value, test) relation and
returns void.
*******************************************************************************/
create or replace function ta.deleteCaseDimAllowedValueTest(
  caseDimAllowedValueIdIn in bigint,
  testIdIn in bigint
)
returns void
as $$
  declare
  begin
     update ta.case_dim_allowed_value_test 
      set end_datetime = current_timestamp
      where
        case_dimension_allowed_value_id = caseDimAllowedValueIdIn and
        test_id = testIdIn and
        end_datetime is null;
    return;
  end
$$
language plpgsql;
