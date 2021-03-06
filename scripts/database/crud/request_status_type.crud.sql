/*******************************************************************************
Test-Automation CRUD DDL for table ta.request_status_type
History:
  02/22/2017  Todd Morley   initial file creation
  02/27/2017  Todd Morley   bug fix:  replaced getRoleId with correct name
  03/22/2017  Todd Morley   added requestStatusTypeDescription
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createRequestStatusType(
  nameIn in text
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    begin
      select id 
        into strict tempId
        from ta.request_status_type 
        where 
          name = lower(nameIn) and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.request_status_type_id_s') into tempId;
    insert into ta.request_status_type(
      id,
      name,
      create_datetime,
      end_datetime
    ) values(
      tempId,
      lower(nameIn),
      current_timestamp,
      null
    );
    return(tempId);
  end
$$
language plpgsql;

/*******************************************************************************
GetId function returns the surrogate primary key (ID) of the entity with the 
input natural-key value, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getRequestStatusTypeId(
  nameIn in text
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.request_status_type
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
create or replace function ta.getRequestStatusType(idIn in bigint)
returns ta.request_status_type
as $$
  declare
    tempRecord ta.request_status_type%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.request_status_type 
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
create or replace function ta.getRequestStatusTypeName(idIn in bigint)
returns text
as $$
  declare
    tempName text;
  begin
    select name
      into strict tempName
      from ta.request_status_type 
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
requestStatusTypeDescription returns a text description of the request status 
type with ID idIn, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.requestStatusTypeDescription(idIn in bigint)
returns text
as $$
  declare
  begin
    return(getRequestStatusTypeName(idIn = idIn));
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
create or replace function ta.deleteRequestStatusType(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.request_status_type 
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
