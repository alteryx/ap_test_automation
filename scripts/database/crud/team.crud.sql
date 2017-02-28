/*******************************************************************************
Test-Automation CRUD DDL for table ta.team
History:
  02/27/2017  Todd Morley   initial file creation
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createTeam(
  nameIn in text,
  sourceControlBranchIdIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    if(
      nameIn is null or
      sourceControlBranchIdIn is null
    ) then
      raise exception 'invalid input passed to ta.createTeam';
    end if;
    begin
      select id 
        into strict tempId
        from ta.team 
        where 
          name = lower(nameIn) and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.team_id_s') into tempId;
    insert into ta.team(
      id,
      name,
      create_datetime,
      end_datetime,
      source_control_branch_id
    ) values(
      tempId,
      lower(nameIn),
      current_timestamp,
      null,
      sourceControlBranchIdIn
    );
    return(tempId);
  end
$$
language plpgsql;

/*******************************************************************************
GetId function returns the surrogate primary key (ID) of the entity with the 
input natural-key value, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getTeamId(
  nameIn in text
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.team
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
create or replace function ta.getTeam(idIn in bigint)
returns ta.team
as $$
  declare
    tempRecord ta.team%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.team 
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
create or replace function ta.getTeamName(idIn in bigint)
returns text
as $$
  declare
    tempName text;
  begin
    select name
      into strict tempName
      from ta.team 
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
The update function upates all entity properties that are not part of the
entity type's natural primary key.
*******************************************************************************/
create or replace function ta.updateTeam(
  idIn in bigint,
  sourceControlBranchIdIn in bigint
)
returns bigint
as $$
  declare
    tempCount integer;
    tempRow ta.team%rowtype;
    tempTimestamp timestamp;
  begin
    select count(*)
      into tempCount
      from ta.source_control_branch
      where
        id = sourceControlBranchIdIn and
        end_datetime is null;
    if(
      tempCount = 0 or 
      sourceControlBranchIdIn is null
     ) then
      raise exception 'invalid input passed to ta.updateTeam';
    end if;
    select * 
      into tempRow 
      from ta.team
      where
        id = idIn and
        end_datetime is null;
    tempTimestamp := current_timestamp;
    update ta.team
      set end_datetime = tempTimestamp
      where 
        id = idIn and
        end_datetime is null;
    insert into ta.team(
      id,
      name,
      create_datetime,
      end_datetime,
      source_control_branch_id
    ) values(
      idIn,
      tempRow.name,
      tempTimestamp,
      null,
      sourceControlBranchIdIn
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
create or replace function ta.deleteTeam(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.team 
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
