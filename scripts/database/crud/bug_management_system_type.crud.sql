/*******************************************************************************
Test-Automation CRUD DDL for table ta.bug_management_system_type
History:
  02/22/2017  Todd Morley   initial file creation
  03/13/2017  Todd Morley   added get-description function
  03/31/2017  Todd Morley   added support for version column
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createBugManagementSystemType(
  nameIn in text,
  versionIn in text
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    begin
      select id 
        into strict tempId
        from ta.bug_management_system_type 
        where 
          name = lower(nameIn) and
          version = lower(versionIn) and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.bug_management_system_type_id_s') into tempId;
    insert into ta.bug_management_system_type(
      id,
      name,
      version,
      create_datetime,
      end_datetime
    ) values(
      tempId,
      lower(nameIn),
      lower(versionIn),
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
create or replace function ta.getBugManagementSystemTypeId(
  nameIn in text,
  versionIn in text
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.bug_management_system_type
      where 
        name = lower(nameIn) and 
        version = lower(versionIn) and
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
create or replace function ta.getBugManagementSystemType(idIn in bigint)
returns ta.bug_management_system_type
as $$
  declare
    tempRecord ta.bug_management_system_type%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.bug_management_system_type 
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
create or replace function ta.getBugManagementSystemTypeName(idIn in bigint)
returns text
as $$
  declare
    tempName text;
  begin
    select name
      into strict tempName
      from ta.bug_management_system_type 
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
GetVersion function returns version in a variable of type text, or null if no
entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getBugManagementSystemTypeVersion(idIn in bigint)
returns text
as $$
  declare
    tempVersion text;
  begin
    select version
      into strict tempVersion
      from ta.bug_management_system_type 
      where 
        id = idIn and 
        end_datetime is null;
    return(tempVersion);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
getBugManagementSystemTypeDescription function returns a description of the 
input bug-management system type, or null if no object with the input ID was
found.
*******************************************************************************/
create or replace function ta.getBugManagementSystemTypeDescription(
  idIn in bigint
)
returns text
as $$
  declare
    tempDescription text;
  begin
    select 
      name || ' ' || version
      into tempDescription
      from ta.bug_management_system_type
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
There is no update function, because the table's name column is
the natural key, and is the only exposed property.
*******************************************************************************/

/*******************************************************************************
Delete function returns deleted entity's ID in a variable of type bigint, if the
entity was found (and deleted), otherwise null.
*******************************************************************************/
create or replace function ta.deleteBugManagementSystemType(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.bug_management_system_type 
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
