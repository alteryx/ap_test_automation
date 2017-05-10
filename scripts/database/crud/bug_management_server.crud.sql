/*******************************************************************************
Test-Automation CRUD DDL for table ta.bug_management_server
History:
  02/27/2017  Todd Morley   initial file creation
  03/13/2017  Todd Morley   added get-description function
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
Name is the natural key.
*******************************************************************************/
create or replace function ta.createBugManagementServer(
  nameIn in text,
  bugManagementSystemTypeIdIn in bigint,
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
      bugManagementSystemTypeIdIn is null or
      (
        staticIpAddressIn is null and
        dnsNameIn is null
      )
    ) then
      raise exception 'invalid input passed to ta.createBugManagementServer';
    end if;
    begin
      select id 
        into strict tempId
        from ta.bug_management_server 
        where 
          name = lower(nameIn) and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.bug_management_server_id_s') into tempId;
    insert into ta.bug_management_server(
      id,
      name,
      static_ip_address,
      dns_name,
      create_datetime,
      end_datetime,
      bug_management_system_type_id
    ) values(
      tempId,
      lower(nameIn),
      staticIpAddressIn,
      dnsNameIn,
      current_timestamp,
      null,
      bugManagementSystemTypeIdIn
    );
    return(tempId);
  end
$$
language plpgsql;

/*******************************************************************************
GetId function returns the surrogate primary key (ID) of the entity with the 
input natural-key value, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getBugManagementServerId(
  nameIn in text
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.bug_management_server
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
create or replace function ta.getBugManagementServer(idIn in bigint)
returns ta.bug_management_server
as $$
  declare
    tempRecord ta.bug_management_server%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.bug_management_server 
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
create or replace function ta.getBugManagementServerName(idIn in bigint)
returns text
as $$
  declare
    tempName text;
  begin
    select name
      into strict tempName
      from ta.bug_management_server 
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
getBugManagementServerNetworkInfo function returns a networkInfoType, or null 
if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getBugManagementServerNetworkInfo(idIn in bigint)
returns ta.networkInfoType
as $$
  declare
    tempNetworkInfo ta.networkInfoType;
  begin
    select 
      static_ip_address,
      dns_name
      into strict tempNetworkInfo
      from ta.bug_management_server 
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
getBugManagementServerDescription function returns a description of the input
bug-management server, or null if no object with the input ID was found.
*******************************************************************************/
create or replace function ta.getBugManagementServerDescription(idIn in bigint)
returns text
as $$
  declare
    tempDescription text;
  begin
    select 
      ta.bug_management_system_type.name ||
      ' ' ||
      ta.bug_management_server.name ||
      ' @ ' ||
      coalesce(
        ta.bug_management_system_type.static_ip_address,
        ta.bug_management_system_type.dns_name
      )
      into strict tempDescription
      from 
        ta.bug_management_system_type,
        ta.bug_management_server 
      where 
        ta.bug_management_server.id = idIn and 
        ta.bug_management_server.bug_management_system_type_id = 
          bug_management_system_type.id and
        ta.bug_management_server.end_datetime is null and
        ta.bug_management_server.end_datetime is null;
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

create or replace function ta.updateBugManagementServer(
  idIn in bigint,
  staticIpAddressIn in text,
  dnsNameIn in text
)
returns bigint
as $$
  declare
    tempRow ta.bug_management_server%rowtype;
    tempTimestamp timestamp;
  begin
    if(
      staticIpAddressIn is null and
      dnsNameIn is null
    ) then
      raise exception 'invalid input passed to ta.updateBugManagementServer';
    end if;
    select * 
      into tempRow 
      from ta.bug_management_server 
      where
        id = idIn and
        end_datetime is null;
    tempTimestamp := current_timestamp;
    update ta.bug_management_server
      set end_datetime = tempTimestamp
      where 
        id = idIn and
        end_datetime is null;
    insert into ta.bug_management_server(
      id,
      static_ip_address,
      dns_name,
      create_datetime,
      end_datetime,
      bug_management_system_type_id
    ) values(
      idIn,
      tempRow.name,
      staticIpAddressIn,
      dnsNameIn,
      tempTimestamp,
      null,
      tempRow.bug_management_system_type_id
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
create or replace function ta.deleteBugManagementServer(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.bug_management_server 
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
