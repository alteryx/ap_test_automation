/*******************************************************************************
Test-Automation CRUD DDL for table ta.node_type
History:
  02/27/2017  Todd Morley   initial file creation
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createNodeType(
  descriptionIn in text,
  coreCountIn in integer,
  ramGbIn in integer,
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
      from operating_system_type
      where
        id = operatingSystemTypeIdIn and
        end_datetime is null;
    if(databaseTypeIdIn is not null) then
      select count(*)
        into tempDbTypeCount
        from database_type
        where
          id = databaseTypeIdIn and
          end_datetime is null;
    end if;
    if(alteryxTypeIdIn is not null) then
      select count(*)
        into tempAlteryxTypeCount
        from alteryx_type
        where
          id = alteryxTypeIdIn and
          end_datetime is null;
    end if;
    if(
      descriptionIn is null or
      coreCountIn is null or
      ramGbIn is null or
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
      description,
      core_count,
      ram_gb,
      create_datetime,
      end_datetime,
      operating_system_type_id,
      database_type_id,
      alteryx_type_id
    ) values(
      tempId,
      descriptionIn,
      coreCountIn,
      ramGbIn,
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
GetDescription function returns description in a variable of type text, or null 
if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getNodeTypeDescription(idIn in bigint)
returns text
as $$
  declare
    tempDescription text;
  begin
    select description
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
The update function upates all entity properties that are not part of the
entity type's natural primary key.
*******************************************************************************/
create or replace function ta.updateNodeType(
  idIn in bigint,
  descriptionIn in text
)
returns bigint
as $$
  declare
    tempCount integer;
    tempRow ta.node_type%rowtype;
    tempTimestamp timestamp;
  begin
    select * 
      into tempRow 
      from ta.node_type
      where
        id = idIn and
        end_datetime is null;
    tempTimestamp := current_timestamp;
    update ta.node_type
      set end_datetime = tempTimestamp
      where 
        id = idIn and
        end_datetime is null;
    insert into ta.node_type(
      id,
      description,
      core_count,
      ram_gb,
      create_datetime,
      end_datetime,
      operating_system_type_id,
      database_type_id,
      alteryx_type_id
    ) values(
      idIn,
      descriptionIn,
      tempRow.core_count,
      tempRow.ram_gb,
      tempTimestamp,
      null,
      tempRow.operating_system_type_id,
      tempRow.database_type_id,
      tempRow.alteryx_type_id
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
