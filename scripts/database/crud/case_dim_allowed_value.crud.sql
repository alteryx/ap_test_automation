/*******************************************************************************
Test-Automation CRUD DDL for table ta.case_dim_allowed_value
History:
  02/28/2017  Todd Morley   initial file 
  03/21/2017  Todd Morley   added GetCaseDimAllowedValueDescription
  04/24/2017  Todd Morley   bug fix
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createCaseDimAllowedValue(
  serializedValueIn in text,
  caseAnalysisDimensionIdIn in bigint
)
returns bigint
as $$
  declare
    tempCount integer;
    tempId bigint;
  begin
    select count(*)
      from ta.case_analysis_dimension
      where
        id = caseAnalysisDimensionIdIn and
        end_datetime is null;
    if(
      tempCount = 0 or
      serializedValueIn is null or
      caseAnalysisDimensionIdIn is null
    ) then
      raise exception 'invalid input passed to ta.createCaseDimAllowedValue';
    end if;
    begin
      select id 
        into strict tempId
        from ta.case_dim_allowed_value 
        where
          serialized_value = serializedValueIn and
          case_analysis_dimension_id = caseAnalysisDimensionIdIn and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.case_dim_allowed_value_id_s') into tempId;
    insert into ta.case_dim_allowed_value(
      id,
      serialized_value,
      create_datetime,
      end_datetime,
      case_analysis_dimension_id
    ) values(
      tempId,
      serializedValueIn,
      current_timestamp,
      null,
      caseAnalysisDimensionIdIn
    );
    return(tempId);
  end
$$
language plpgsql;

/*******************************************************************************
GetId function returns the surrogate primary key (ID) of the entity with the 
input natural-key value, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getCaseDimAllowedValueId(
  serializedValueIn in text,
  caseAnalysisDimensionIdIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    if(
      serializedValueIn is null or 
      caseAnalysisDimensionIdIn is null
    ) then
      raise exception 'invalid input passed to ta.getCaseDimAllowedValueId';
    end if;
    select id 
      into strict tempId
      from ta.case_dim_allowed_value 
      where
      serialized_value = serializedValueIn and
      case_analysis_dimension_id = caseAnalysisDimensionIdIn and
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
create or replace function ta.getCaseDimAllowedValue(idIn in bigint)
returns ta.case_dim_allowed_value
as $$
  declare
    tempRecord ta.case_dim_allowed_value%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.case_dim_allowed_value 
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
GetCaseDimAllowedValueDescription function returns a description of the case
dimension's allowed value. 
*******************************************************************************/
create or replace function ta.GetCaseDimAllowedValueDescription(
  caseAnalysisDimensionIdIn in bigint
)
returns text
as $$
  declare
    tempDescription text;
  begin
    select 
      ta.case_dim_allowed_value.serialized_value ||
      ' of case ' ||
      ta.case_analysis_dimension.name
      into tempDescription
      from 
        ta.case_dim_allowed_value,
        ta.case_analysis_dimension
      where 
        ta.case_dim_allowed_value.id = caseAnalysisDimensionIdIn and 
        ta.case_analysis_dimension.id = 
          ta.case_dim_allowed_value.case_analysis_dimension_id and
        ta.case_dim_allowed_value.end_datetime is null and
        ta.case_analysis_dimension.end_datetime is null;
    return(tempDescription);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
GetCaseDimAllowedValues function returns a table of text values that are all of
the serialized allowed values for the input case-analysis dimension.
*******************************************************************************/
create or replace function ta.getCaseDimAllowedValues(caseAnalysisDimensionIdIn in bigint)
returns table(serialized_value text)
as $$
  declare
  begin
    return query select 
      serialized_value
      from ta.case_dim_allowed_value 
      where 
        id = caseAnalysisDimensionIdIn and 
        end_datetime is null;
    exception
      when no_data_found then return;
  end
$$
language plpgsql;

/*******************************************************************************
No update function, because all exposed attributes belong to the natural key.
*******************************************************************************/

/*******************************************************************************
Delete function returns deleted entity's ID in a variable of type bigint, if the
entity was found (and deleted), otherwise null.
*******************************************************************************/
create or replace function ta.deleteCaseDimAllowedValue(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.case_dim_allowed_value 
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
