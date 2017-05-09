/*******************************************************************************
Test-Automation CRUD DDL for table ta.test_result_type
History:
  02/22/2017  Todd Morley   initial file creation
  03/22/2017  Todd Morley   added getTestResultTypeDescription
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createTestResultType(
  nameIn in text,
  dataTypeId in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    begin
      select id 
        into strict tempId
        from ta.test_result_type 
        where 
          name = lower(nameIn) and
          data_type_id = dataTypeId and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.test_result_type_id_s') into tempId;
    insert into ta.test_result_type(
      id,
      name,
      create_datetime,
      end_datetime,
      data_type_id
    ) values(
      tempId,
      lower(nameIn),
      current_timestamp,
      null,
      dataTypeId
    );
    return(tempId);
  end
$$
language plpgsql;

create or replace function ta.createTestResultType2(
  nameIn in text,
  dataTypeNameIn in text
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    begin
      select id 
        into strict tempId
        from ta.test_result_type 
        where 
          name = lower(nameIn) and
          data_type_id = ta.getDataTypeId(nameIn := dataTypeNameIn) and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.test_result_type_id_s') into tempId;
    insert into ta.test_result_type(
      id,
      name,
      create_datetime,
      end_datetime,
      data_type_id
    ) values(
      tempId,
      lower(nameIn),
      current_timestamp,
      null,
      ta.getDataTypeId(nameIn := dataTypeNameIn)
    );
    return(tempId);
  end
$$
language plpgsql;

/*******************************************************************************
GetId function returns the surrogate primary key (ID) of the entity with the 
input natural-key value, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getTestResultTypeId(
  nameIn in text
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.test_result_type
      where 
        name = lower(nameIn) and 
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
create or replace function ta.getTestResultType(idIn in bigint)
returns ta.test_result_type
as $$
  declare
    tempRecord ta.test_result_type%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.test_result_type 
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
GetName function returns name in a variable of type text, or null if no
entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getTestResultTypeName(idIn in bigint)
returns text
as $$
  declare
    tempName text;
  begin
    select name
      into strict tempName
      from ta.test_result_type 
      where 
        id = idIn and 
        end_datetime is null;
    return(tempName);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
getTestResultTypeDescription returns a text description of the test-result type
having the ID idIn, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getTestResultTypeDescription(idIn in bigint)
returns text
as $$
  declare
    tempDescription text;
  begin
    select ta.test_result_type.name || ' of type ' || ta.data_type.name
      into strict tempDescription
      from 
        ta.test_result_type,
        ta.data_type
      where 
        ta.test_result_type.id = idIn and 
        ta.test_result_type.data_type_id = ta.data_type.id and
        ta.test_result_type.end_datetime is null and
        ta.data_type.end_datetime is null;
    return(tempDescription);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
There is no update function, because the table's name column is
the natural key, and is the only exposed property.
*******************************************************************************/

/*******************************************************************************
Delete function returns deleted entity's ID in a variable of type bigint, if the
entity was found (and deleted), otherwise null.
*******************************************************************************/
create or replace function ta.deleteTestResultType(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.test_result_type 
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
