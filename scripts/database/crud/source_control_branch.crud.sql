/*******************************************************************************
Test-Automation CRUD DDL for table ta.source_control_branch
History:
  02/27/2017  Todd Morley   initial file creation
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
Name and source_control_branch_id (translated to source-control server name, 
technically) are the natural key.  
*******************************************************************************/
create or replace function ta.createSourceControlBranch(
  nameIn in text,
  pathIn in text,
  sourceControlServerIdIn in bigint
)
returns bigint
as $$
  declare
    tempCount integer;
    tempId bigint;
  begin
    if(
      nameIn is null or
      pathIn is null or
      sourceControlServerIdIn is null
    ) then
      raise exception 'invalid input passed to ta.createSourceControlBranch';
    end if;
    select count(*)
      into tempCount
      from ta.source_control_branch
      where
        name != lower(nameIn) and
        path = pathIn and
        source_control_server_id = sourceControlServerIdIn and
        end_datetime is null;
    if(tempCount > 0) then
      raise exception 'pre-existing path passed to ta.createSourceControlBranch';
    end if;
    begin
      select id 
        into strict tempId
        from ta.source_control_branch 
        where 
          name = lower(nameIn) and
          source_control_server_id = sourceControlServerIdIn and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.source_control_branch_id_s') into tempId;
    insert into ta.source_control_branch(
      id,
      name,
      path,
      create_datetime,
      end_datetime,
      source_control_server_id
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
create or replace function ta.getSourceControlBranchId(
  nameIn in text,
  sourceControlServerIdIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.source_control_branch
      where 
        name = lower(nameIn) and 
        source_control_server_id = sourceControlServerIdIn and
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
create or replace function ta.getSourceControlBranch(idIn in bigint)
returns ta.source_control_branch
as $$
  declare
    tempRecord ta.source_control_branch%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.source_control_branch 
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
create or replace function ta.getSourceControlBranchName(idIn in bigint)
returns text
as $$
  declare
    tempName text;
  begin
    select name
      into strict tempName
      from ta.source_control_branch 
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
GetSourceControlBranchLocation function returns a branchLocationType, or null 
if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getSourceControlBranchLocation(idIn in bigint)
returns ta.branchLocationType
as $$
  declare
    tempBranchLocation ta.branchLocationType;
  begin
    select 
      ta.source_control_branch.path,
      ta.source_control_server.static_ip_address,
      ta.source_control_server.dns_name
      into strict tempBranchLocation
      from 
        ta.source_control_branch,
        ta.source_control_server
      where 
        ta.source_control_branch.id = idIn and 
        ta.source_control_server.id = ta.source_control_branch.source_control_server_id and
        ta.source_control_branchend_datetime is null and
        ta.source_control_server is null;
    return(tempBranchLocation);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
The update function upates all entity properties that are not part of the
entity type's natural primary key.
*******************************************************************************/

create or replace function ta.updateSourceControlBranch(
  idIn in bigint,
  pathIn in text
)
returns bigint
as $$
  declare
    tempCount integer;
    tempRow ta.source_control_branch%rowtype;
    tempTimestamp timestamp;
  begin
    if(pathIn is null) then
      raise exception 'invalid input passed to ta.updateSourceControlBranch';
    end if;
    select * 
      into tempRow 
      from ta.source_control_branch 
      where
        id = idIn and
        end_datetime is null;
    tempTimestamp := current_timestamp;
    select count(*)
      into tempCount
      from ta.source_control_branch
      where
        name != tempRow.name and
        path = pathIn and
        source_control_server_id = tempRow.source_control_server_id and
        end_datetime is null;
    if(tempCount > 0) then
      raise exception 'pre-existing path passed to ta.updateSourceControlBranch';
    end if;
    update ta.source_control_branch
      set end_datetime = tempTimestamp
      where 
        id = idIn and
        end_datetime is null;
    insert into ta.source_control_branch(
      id,
      name,
      path,
      create_datetime,
      end_datetime,
      source_control_server_id
    ) values(
      idIn,
      tempRow.name,
      pathIn,
      tempTimestamp,
      null,
      tempRow.source_control_server_id
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
create or replace function ta.deleteSourceControlBranch(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.source_control_branch 
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
