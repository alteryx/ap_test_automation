/*******************************************************************************
Test-Automation CRUD DDL for table ta.source_control_server
History:
  02/27/2017  Todd Morley   initial file creation
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
Name is the natural key.
*******************************************************************************/
create or replace function ta.createSourceControlServer(
  nameIn in text,
  sourceControlSystemTypeIdIn in bigint,
  staticIpAddressIn in text default null,
  dnsNameIn in text default null
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    if(
      nameIn is null or
      sourceControlSystemTypeIdIn is null or
      (
        staticIpAddressIn is null and
        dnsNameIn is null
      )
    ) then
      raise exception 'invalid input passed to ta.createSourceControlServer';
    end if;
    begin
      select id 
        into strict tempId
        from ta.source_control_server 
        where 
          name = lower(nameIn) and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.source_control_server_id_s') into tempId;
    insert into ta.source_control_server(
      id,
      name,
      static_ip_address,
      dns_name,
      create_datetime,
      end_datetime,
      source_control_system_type_id
    ) values(
      tempId,
      lower(nameIn),
      staticIpAddressIn,
      dnsNameIn,
      current_timestamp,
      null,
      sourceControlSystemTypeIdIn
    );
    return(tempId);
  end
$$
language plpgsql;

/*******************************************************************************
GetId function returns the surrogate primary key (ID) of the entity with the 
input natural-key value, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getSourceControlServerId(
  nameIn in text
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.source_control_server
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
create or replace function ta.getSourceControlServer(idIn in bigint)
returns ta.source_control_server
as $$
  declare
    tempRecord ta.source_control_server%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.source_control_server 
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
create or replace function ta.getSourceControlServerName(idIn in bigint)
returns text
as $$
  declare
    tempName text;
  begin
    select name
      into strict tempName
      from ta.source_control_server 
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
GetSourceControlServerNetworkInfo function returns a networkInfoType, or null 
if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getSourceControlServerNetworkInfo(idIn in bigint)
returns ta.networkInfoType
as $$
  declare
    tempNetworkInfo ta.networkInfoType;
  begin
    select 
      static_ip_address,
      dns_name
      into strict tempNetworkInfo
      from ta.source_control_server 
      where 
        id = idIn and 
        end_datetime is null;
    return(tempNetworkInfo);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
The update function upates all entity properties that are not part of the
entity type's natural primary key.
*******************************************************************************/

create or replace function ta.updateSourceControlServer(
  idIn in bigint,
  staticIpAddressIn in text,
  dnsNameIn in text
)
returns bigint
as $$
  declare
    tempRow ta.source_control_server%rowtype;
    tempTimestamp timestamp;
  begin
    if(
      staticIpAddressIn is null and
      dnsNameIn is null
    ) then
      raise exception 'invalid input passed to ta.updateSourceControlServer';
    end if;
    select * 
      into tempRow 
      from ta.source_control_server 
      where
        id = idIn and
        end_datetime is null;
    tempTimestamp := current_timestamp;
    update ta.source_control_server
      set end_datetime = tempTimestamp
      where 
        id = idIn and
        end_datetime is null;
    insert into ta.source_control_server(
      id,
      static_ip_address,
      dns_name,
      create_datetime,
      end_datetime,
      source_control_system_type_id
    ) values(
      idIn,
      tempRow.name,
      staticIpAddressIn,
      dnsNameIn,
      tempTimestamp,
      null,
      tempRow.source_control_system_type_id
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
create or replace function ta.deleteSourceControlServer(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.source_control_server 
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
