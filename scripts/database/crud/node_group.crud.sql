/*******************************************************************************
Test-Automation CRUD DDL for table ta.node_group
History:
  02/22/2017  Todd Morley   initial file creation
  02/22/2017  Todd Morley   added getNodeGroupDescription
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createNodeGroup(
  nameIn in text,
  lastStartDatetimeIn in timestamp
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    begin
      select id 
        into strict tempId
        from ta.node_group 
        where 
          name = lower(nameIn) and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.node_group_id_s') into tempId;
    insert into ta.node_group(
      id,
      name,
      last_start_datetime,
      create_datetime,
      end_datetime
    ) values(
      tempId,
      lower(nameIn),
      lastStartDatetimeIn,
      current_timestamp,
      null
    );
    return(tempId);
  end
$$
language plpgsql;

create or replace function ta.getNodeGroupId(
  nameIn in text
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.node_group 
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
create or replace function ta.getNodeGroup(idIn in bigint)
returns ta.node_group
as $$
  declare
    tempRecord ta.node_group%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.node_group 
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
create or replace function ta.getNodeGroupName(idIn in bigint)
returns text
as $$
  declare
    tempName text;
  begin
    select name
      into strict tempName
      from ta.node_group 
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
GetLastStartDatetime function returns last start datetime in a variable of type 
timestamp, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getNodeGroupLastStartDatetime(idIn in bigint)
returns timestamp
as $$
  declare
    tempLastStartDatetime timestamp;
  begin
    select last_start_datetime
      into strict tempLastStartDatetime
      from ta.node_group 
      where 
        id = idIn and 
        end_datetime is null;
    return(tempLastStartDatetime);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
getNodeGroupDescription returns a text description of the node group with input
idIn, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getNodeGroupDescription(idIn in bigint)
returns text
as $$
  declare
    tempDescription text;
  begin
    select 
      name || 
      ' (last started ' ||
      to_char(last_start_datetime, 'YYYY-MON-DD:HH24-MI-SS')
      ')'
      into strict tempDescription
      from ta.node_group 
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
entity type's natural primary key, in this case the last-start datetime.
*******************************************************************************/
create or replace function ta.updateNodeGroup(
  idIn in bigint,
  lastStartDatetimeIn in timestamp
)
returns bigint
as $$
  declare
    tempRow ta.node_group%rowtype;
    tempTimestamp timestamp;
  begin
    select * 
      into tempRow 
      from ta.node_group
      where
        id = idIn and
        end_datetime is null;
    if(
      lastStartDatetimeIn is null or
        tempRow.last_start_datetime >= lastStartDatetimeIn
    ) then
      raise exception 'invalid last-start datetime passed to ta.updateNodeGroup';
    end if;
    tempTimestamp := current_timestamp;
    update ta.node_group
      set end_datetime = tempTimestamp
      where 
        id = idIn and
        end_datetime is null;
    insert into ta.node_group(
      id,
      name,
      last_start_datetime,
      create_datetime,
      end_datetime
    ) values(
      idIn,
      tempRow.name,
      lastStartDatetimeIn,
      tempTimestamp,
      null
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
create or replace function ta.deleteNodeGroup(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.node_group 
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
