/*******************************************************************************
Test-Automation CRUD DDL for table ta.event_type
History:
  02/22/2017  Todd Morley   initial file creation
  03/22/2017  Todd Morley   added getEventTypeDescription
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createEventType(
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
        from ta.event_type 
        where 
          name = lower(nameIn) and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.event_type_id_s') into tempId;
    insert into ta.event_type(
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
create or replace function ta.getEventTypeId(
  nameIn in text
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.event_type
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
create or replace function ta.getEventType(idIn in bigint)
returns ta.event_type
as $$
  declare
    tempRecord ta.event_type%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.event_type 
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
create or replace function ta.getEventTypeName(idIn in bigint)
returns text
as $$
  declare
    tempName text;
  begin
    select name
      into strict tempName
      from ta.event_type 
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
getEventTypeDescription function returns a text description of the event type 
with ID idIn, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getEventTypeDescription(idIn in bigint)
returns text
as $$
  declare
  begin
    return(getEventTypeName(idIn = idIn));
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
create or replace function ta.deleteEventType(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.event_type 
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
