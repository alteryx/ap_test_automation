/*******************************************************************************
Test-Automation CRUD DDL for table ta.person
History:
  02/27/2017  Todd Morley   initial file creation
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createPerson(
	fullNameIn in text,
	activeDirectoryObjectGuidIn in text,
	emailIn in text,
	cellPhoneIn in text,
	teamIdIn in bigint,
	roleIdIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    if(
      fullNameIn is null or
      activeDirectoryObjectGuidIn is null or
      emailIn is null or
      teamIdIn is null or
      roleIdIn is null
    ) then
      raise exception 'invalid input passed to ta.createPerson';
    end if;
    begin
      select id 
        into strict tempId
        from ta.person 
        where 
          active_directory_object_guid = activeDirectoryObjectGuidIn and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.person_id_s') into tempId;
    insert into ta.person(
      id,
      full_name,
      active_directory_object_guid,
      email,
      cell_phone,
      create_datetime,
      end_datetime,
      team_id,
      role_id
    ) values(
      tempId,
      fullNameIn,
      activeDirectoryObjectGuidIn,
      emailIn,
      cellPhoneIn,
      current_timestamp,
      null,
      teamIdIn,
      roleIdIn
    );
    return(tempId);
  end
$$
language plpgsql;

/*******************************************************************************
GetId function returns the surrogate primary key (ID) of the entity with the 
input natural-key value, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getPersonId(
  activeDirectoryObjectGuidIn in text
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.person
      where 
        active_directory_object_guid = activeDirectoryObjectGuidIn and 
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
create or replace function ta.getPerson(idIn in bigint)
returns ta.person
as $$
  declare
    tempRecord ta.person%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.person 
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
GetPersonFullName function returns full_name in a variable of type text, or 
null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getPersonFullName(idIn in bigint)
returns text
as $$
  declare
    tempFullName text;
  begin
    select full_name
      into strict tempFullName
      from ta.person 
      where 
        id = idIn and 
        end_datetime is null;
    return(tempFullName);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
The update function upates all entity properties that are not part of the
entity type's natural primary key.
*******************************************************************************/
create or replace function ta.updatePerson(
  idIn in bigint,
	fullNameIn in text,
	emailIn in text,
	cellPhoneIn in text,
	teamIdIn in bigint,
	roleIdIn in bigint
)
returns bigint
as $$
  declare
    tempTeamCount integer;
    tempRoleCount integer;
    tempRow ta.person%rowtype;
    tempTimestamp timestamp;
  begin
    if(
      fullNameIn is null or
      emailIn is null or
      teamIdIn is null or
      roleIdIn is null
    ) then
      raise exception 'invalid input passed to ta.updatePerson';
    end if;
    select count(*)
      into tempTeamCount
      from ta.team
      where
        id = teamIdIn and
        end_datetime is null;
    select count(*)
      into tempRoleCount
      from ta.role
      where
        id = roleIdIn and
        end_datetime is null;
    if(
      tempTeamCount = 0 or 
      tempRoleCount = 0 or
      sourceControlBranchIdIn is null
     ) then
      raise exception 'invalid input passed to ta.updatePerson';
    end if;
    select * 
      into tempRow 
      from ta.person
      where
        id = idIn and
        end_datetime is null;
    tempTimestamp := current_timestamp;
    update ta.person
      set end_datetime = tempTimestamp
      where 
        id = idIn and
        end_datetime is null;
    insert into ta.person(
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
    insert into ta.person(
      id,
      full_name,
      active_directory_object_guid,
      email,
      cell_phone,
      create_datetime,
      end_datetime,
      team_id,
      role_id
    ) values(
      idIn,
      fullNameIn,
      tempRow.active_directory_object_guid,
      emailIn,
      cellPhoneIn,
      tempTimestamp,
      null,
      teamIdIn,
      roleIdIn
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
create or replace function ta.deletePerson(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.person 
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
