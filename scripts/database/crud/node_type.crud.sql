/*******************************************************************************
Test-Automation CRUD DDL for table ta.node_type
History:
  02/27/2017  Todd Morley   initial file creation
  03/08/2017  Todd Morley   added support for clock_speed_ghz
  03/23/2017  Todd Morley   added getNodeTypeDescription, dropped update
                            function, dropped description column
  04/17/2017  Todd Morley   bug fixes
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createNodeType(
  coreCountIn in integer,
  ramGbIn in integer,
  clockSpeedGHzIn in numeric,
  operatingSystemTypeIdIn in bigint,
  databaseTypeIdIn in bigint,
  alteryxTypeIdIn in bigint
)
returns bigint
as $$
  declare
    tempOsTypeCount integer;
    tempDbTypeCount integer;
    tempAlteryxTypeCount integer;
    tempId bigint;
  begin
    select count(*)
      into tempOsTypeCount
      from ta.operating_system_type
      where
        id = operatingSystemTypeIdIn and
        end_datetime is null;
    if(databaseTypeIdIn is not null) then
      select count(*)
        into tempDbTypeCount
        from ta.database_type
        where
          id = databaseTypeIdIn and
          end_datetime is null;
    end if;
    if(alteryxTypeIdIn is not null) then
      select count(*)
        into tempAlteryxTypeCount
        from ta.alteryx_type
        where
          id = alteryxTypeIdIn and
          end_datetime is null;
    end if;
    if(
      coreCountIn is null or
      ramGbIn is null or
      clockSpeedGHzIn is null or
      operatingSystemTypeIdIn is null or
      tempOsTypeCount = 0 or
      (databaseTypeIdIn is not null and tempDbTypeCount = 0) or
      (alteryxTypeIdIn is not null and tempAlteryxTypeCount = 0)
    ) then
      raise exception 'invalid input passed to ta.createNodeType';
    end if;
    begin
      select id 
        into strict tempId
        from ta.node_type 
        where 
          core_count = coreCountIn and
          ram_gb = ramGbIn and
          clock_speed_ghz = clockSpeedGHzIn and
          operating_system_type_id = operatingSystemTypeIdIn and
          (
            (database_type_id is null and databaseTypeIdIn is null) or 
            database_type_id = databaseTypeIdIn
          ) and
          (
            (alteryx_type_id is null and alteryxTypeIdIn is null) or 
            alteryx_type_id = alteryxTypeIdIn
          ) and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.node_type_id_s') into tempId;
    insert into ta.node_type(
      id,
      core_count,
      ram_gb,
      clock_speed_ghz,
      create_datetime,
      end_datetime,
      operating_system_type_id,
      database_type_id,
      alteryx_type_id
    ) values(
      tempId,
      coreCountIn,
      ramGbIn,
      clockSpeedGHzIn,
      current_timestamp,
      null,
      operatingSystemTypeIdIn,
      databaseTypeIdIn,
      alteryxTypeIdIn
    );
    return(tempId);
  end
$$
language plpgsql;

/*******************************************************************************
GetId function returns the surrogate primary key (ID) of the entity with the 
input natural-key value, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getNodeTypeId(
  coreCountIn in integer,
  ramGbIn in integer,
  clockSpeedGHzIn in numeric,
  operatingSystemTypeIdIn in bigint,
  databaseTypeIdIn in bigint,
  alteryxTypeIdIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id 
      into strict tempId
      from ta.node_type 
      where 
        core_count = coreCountIn and
        ram_gb = ramGbIn and
        clock_speed_ghz_in = clockSpeedGHzIn and
        operating_system_type_id = operatingSystemTypeIdIn and
        (
          (database_type_id is null and databaseTypeIdIn is null) or 
          database_type_id = databaseTypeIdIn
        ) and
        (
          (alteryx_type_id is null and alteryxTypeIdIn is null) or 
          alteryx_type_id = alteryxTypeIdIn
        ) and
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
create or replace function ta.getNodeType(idIn in bigint)
returns ta.node_type
as $$
  declare
    tempRecord ta.node_type%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.node_type 
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
getNodeTypeDescription returns a text description of the node type with ID idIn,
or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getNodeTypeDescription(idIn in bigint)
returns text
as $$
  declare
    tempDescription text;
  begin
    select
      clock_speed_ghz ||
      ' GHz ' ||
      core_count ||
      ' cores ' ||
      ram_gb ||
      ' GB ' ||
      ta.getOperatingSystemTypeDescription(idIn = ta.node_type.operating_system_type_id) ||
      ' ' ||
      ta.getAlteryxTypeDescription(idIn = ta.node_type.alteryx_type_id) ||
      ' ' ||
      ta.getDatabaseTypeDescription(idIn = ta.node_type.database_type_id)
      into strict tempDescription
      from ta.node_type
      where 
        id = idIn and 
        end_datetime is null;
    return(tempDescription);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
The node_type table doesn't have an update function, because all attribute
columns belong to the natural primary key.
*******************************************************************************/

/*******************************************************************************
Delete function returns deleted entity's ID in a variable of type bigint, if the
entity was found (and deleted), otherwise null.
*******************************************************************************/
create or replace function ta.deleteNodeType(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.node_type 
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
