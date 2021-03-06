/*******************************************************************************
Test-Automation CRUD DDL for table ta.node
History:
  02/27/2017  Todd Morley   initial file creation
  03/08/2017  Todd Morley   fixed a typo, added getNodeNodeTypeId
  03/22/2017  Todd Morley   added getNodeDescription
  04/17/2017  Todd Morley   bug fixes
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createNode(
  ipAddressIn in text,
  dnsNameIn in text,
  virtualYnIn in char,
  lastStartDateIn in date,
  nodeTypeIdIn in bigint
)
returns bigint
as $$
  declare
    tempCount integer;
    tempId bigint;
  begin
    select count(*)
      into tempCount
      from ta.node_type
      where
        id = nodeTypeIdIn and
        end_datetime is null;
    if(
      tempCount = 0 or
      (ipAddressIn is null and dnsNameIn is null) or
      virtualYnIn is null or
      lastStartDateIn is null or
      nodeTypeIdIn is null
    ) then
      raise exception 'invalid input passed to ta.createNode';
    end if;
    begin
      select id 
        into strict tempId
        from ta.node 
        where
        (
          (ip_address is null and ipAddressIn is null) or 
          ip_address = ipAddressIn
        ) and
        (
          (dns_name is null and dnsNameIn is null) or 
          dns_name = dnsNameIn
        ) and
        end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.node_id_s') into tempId;
    insert into ta.node(
      id,
      ip_address,
      dns_name,
      virtual_yn,
      last_start_date,
      create_datetime,
      end_datetime,
      node_type_id
    ) values(
      tempId,
      ipAddressIn,
      dnsNameIn,
      virtualYnIn,
      lastStartDateIn,
      current_timestamp,
      null,
      nodeTypeIdIn
    );
    return(tempId);
  end
$$
language plpgsql;

/*******************************************************************************
GetId function returns the surrogate primary key (ID) of the entity with the 
input natural-key value, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getNodeId(
  ipAddressIn in bigint,
  dnsNameIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    if(ipAddressIn is null and dnsNameIn is null) then
      raise exception 'invalid input passed to ta.getNodeId';
    end if;
    select id 
      into strict tempId
      from ta.node 
      where
      (
        (ip_address is null and ipAddressIn is null) or 
        ip_address = ipAddressIn
      ) and
      (
        (dns_name is null and dnsNameIn is null) or 
        dns_name = dnsNameIn
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
create or replace function ta.getNode(idIn in bigint)
returns ta.node
as $$
  declare
    tempRecord ta.node%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.node 
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
GetNodeNodeTypeId function returns a node-type ID, or null if no entity with the 
input ID was found.
*******************************************************************************/
create or replace function ta.getNodeNodeTypeId(idIn in bigint)
returns bigint
as $$
  declare
    tempNodeTypeId bigint;
  begin
    select node_type_id
      into tempNodeTypeId
      from ta.node 
      where 
        id = idIn and 
        end_datetime is null;
    return(tempNodeTypeId);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
GetNetworkInfo function returns a node's network IP address and/or DNS name
in a variable of type networkInfoType, or null if no entity with the input ID 
was found.
*******************************************************************************/
create or replace function ta.getNodeNetworkInfo(idIn in bigint)
returns ta.networkInfoType
as $$
  declare
    tempNetworkInfo ta.networkInfoType;
  begin
    select 
      ip_address,
      dns_name
      into strict tempNetworkInfo
      from ta.node 
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
getNodeDescription returns a text description of the node with ID idIn, or null 
if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getNodeDescription(idIn in bigint)
returns text
as $$
  declare
    tempDescription text;
  begin
    select 
      nvl(ta.node.dns_name, ta.node.ip_address) || 
      ', type ' ||
      ta.node_type.name ||
      case ta.node.virtual_yn when 'y' then ', virtual' end
      into strict tempDescription
      from 
        ta.node,
        ta.node_type
      where 
        ta.node.id = idIn and 
        ta.node_type.id = ta.node.node_type_id and
        ta.node.end_datetime is null and
        ta.node_type.end_datetime is null;
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
create or replace function ta.updateNode(
  idIn in bigint,
  virtualYnIn in char,
  lastStartDateIn in date,
  nodeTypeIdIn in bigint
)
returns bigint
as $$
  declare
    tempCount integer;
    tempRow ta.node%rowtype;
    tempTimestamp timestamp;
  begin
    select count(*)
      into tempCount
      from ta.node_type
      where
        id = nodeTypeIdIn and
        end_datetime is null;
    if(
      tempCount = 0 or 
      nodeTypeIdIn is null
     ) then
      raise exception 'invalid input passed to ta.updateNode';
    end if;
    select * 
      into tempRow 
      from ta.node
      where
        id = idIn and
        end_datetime is null;
    tempTimestamp := current_timestamp;
    update ta.node
      set end_datetime = tempTimestamp
      where 
        id = idIn and
        end_datetime is null;
    insert into ta.node(
      id,
      ip_address,
      dns_name,
      virtual_yn,
      last_start_date,
      create_datetime,
      end_datetime,
      node_type_id
    ) values(
      idIn,
      tempRow.ip_address,
      tempRow.dns_name,
      virtualYnIn,
      lastStartDateIn,
      tempTimestamp,
      null,
      nodeTypeIdIn
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
create or replace function ta.deleteNode(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.node 
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
