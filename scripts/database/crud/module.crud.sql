/*******************************************************************************
Test-Automation CRUD DDL for table ta.module
History:
  02/22/2017  Todd Morley   initial file creation
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createModule(
  nameIn in text,
  owningTeamIdIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    begin
      select id 
        into strict tempId
        from ta.module 
        where 
          name = lower(nameIn) and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.module_id_s') into tempId;
    insert into ta.module(
      id,
      name,
      create_datetime,
      end_datetime,
      owning_team_id
    ) values(
      tempId,
      lower(nameIn),
      current_timestamp,
      null,
      owningTeamIdIn
    );
    return(tempId);
  end
$$
language plpgsql;

/*******************************************************************************
GetId function returns the surrogate primary key (ID) of the entity with the 
input natural-key value, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getModuleId(
  nameIn in text,
  owningTeamIdIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.module
      where 
        name = lower(nameIn) and 
        owning_team_id = owningTeamIdIn and
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
create or replace function ta.getModule(idIn in bigint)
returns ta.module
as $$
  declare
    tempRecord ta.module%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.module 
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
create or replace function ta.getModuleName(idIn in bigint)
returns text
as $$
  declare
    tempName text;
  begin
    select name
      into strict tempName
      from ta.module 
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
GetOwningTeamId function returns the ID of the owning team in a variable of type 
bigint, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getOwningTeamId(idIn in bigint)
returns bigint
as $$
  declare
    tempOwningTeamId bigint;
  begin
    select owning_team_id
      into strict tempOwningTeamId
      from ta.module 
      where 
        id = idIn and 
        end_datetime is null;
    return(tempOwningTeamId);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
There is no update function, because all exposed attributes pertain to the 
natural key.
*******************************************************************************/

/*******************************************************************************
Delete function returns deleted entity's ID in a variable of type bigint, if the
entity was found (and deleted), otherwise null.
*******************************************************************************/
create or replace function ta.deleteModule(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.module 
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
