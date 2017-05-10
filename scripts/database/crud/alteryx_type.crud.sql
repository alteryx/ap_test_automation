/*******************************************************************************
Test-Automation CRUD DDL for table ta.alteryx_type
History:
  02/22/2017  Todd Morley   initial file creation
  03/13/2017  Todd Morley   added get-description function
  03/31/2017  Todd Morley   added support for build column, moved version into
                            separate ta.alteryx_version table
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createAlteryxType(
  buildIn in text,
  alteryxVersionIdIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    begin
      select id 
        into strict tempId
        from ta.alteryx_type 
        where 
          build = lower(buildIn) and
          alteryx_version_id = alteryxVersionIdIn and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.alteryx_type_id_s') into tempId;
    insert into ta.alteryx_type(
      id,
      build,
      create_datetime,
      end_datetime,
      alteryx_version_id
    ) values(
      tempId,
      lower(buildIn),
      current_timestamp,
      null,
      alteryxVersionIdIn
    );
    return(tempId);
  end
$$
language plpgsql;

/*******************************************************************************
Create2 function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
This version of the create function takes natural-key inputs for entities
referenced by foreign keys, for ease of use.  The function fails in the 
referenced foreign key does not currently exist.
*******************************************************************************/
create or replace function ta.createAlteryxType2(
  buildIn in text,
  alteryxVersionIn in text
)
returns bigint
as $$
  declare
    tempId bigint;
    tempVersionId bigint;
  begin
    begin
      select id
        into tempVersionId
        from ta.alteryx_version
        where
          version = lower(alteryxVersionIn) and
          end_datetime is null;
      exception
        when no_data_found then 
          raise exception 'invalid Alteryx version passed to ta.createAlteryxType2';
    end;
    begin
      select id 
        into strict tempId
        from ta.alteryx_type 
        where 
          build = lower(buildIn) and
          alteryx_version_id = tempVersionId and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.alteryx_type_id_s') into tempId;
    insert into ta.alteryx_type(
      id,
      build,
      create_datetime,
      end_datetime,
      alteryx_version_id
    ) values(
      tempId,
      lower(buildIn),
      current_timestamp,
      null,
      tempVersionId
    );
    return(tempId);
  end
$$
language plpgsql;

/*******************************************************************************
GetId function returns the surrogate primary key (ID) of the entity with the 
input natural-key value, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getAlteryxTypeId(
  buildIn in text,
  alteryxVersionIdIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.alteryx_type
      where 
        build = lower(buildIn) and
        alteryx_version_id = alteryxVersionIdIn and 
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
create or replace function ta.getAlteryxType(idIn in bigint)
returns ta.alteryx_type
as $$
  declare
    tempRecord ta.alteryx_type%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.alteryx_type 
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
GetVersion function returns version in a variable of type text, or null if no
entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getAlteryxTypeVersion(idIn in bigint)
returns text
as $$
  declare
    tempVersion text;
  begin
    select ta.alteryx_version.version
      into strict tempVersion
      from 
        ta.alteryx_version,
        ta.alteryx_type 
      where 
        ta.alteryx_type.id = idIn and 
        ta.alteryx_version.id = ta.alteryx_type.alteryx_version_id and
        ta.alteryx_type.end_datetime is null and
        ta.alteryx_version.end_datetime is null;
    return(tempVersion);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
GetVersionID function returns the ID of the Alteryx type's version, or null if 
no type with the input ID was found.
*******************************************************************************/
create or replace function ta.getAlteryxTypeVersionId(idIn in bigint)
returns bigint
as $$
  declare
    tempVersionId bigint;
  begin
    select alteryx_version_id
      into strict tempVersionId
      from ta.alteryx_type 
      where 
        ta.alteryx_type.id = idIn and 
        ta.alteryx_type.end_datetime is null;
    return(tempVersionId);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
getAlteryxTypeDescription function returns a description of the input Alteryx
type, or null if no object with the input ID was found.
*******************************************************************************/
create or replace function ta.getAlteryxTypeDescription(idIn in bigint)
returns text
as $$
  declare
    tempDescription text;
  begin
    select 
      ta.getAlteryxVersionDescription(alteryx_version_id), ||
      ' build ' ||
      build
      into strict tempDescription
      from ta.alteryx_type 
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
No update function, for the usual reason.
*******************************************************************************/

/*******************************************************************************
Delete function returns deleted entity's ID in a variable of type bigint, if the
entity was found (and deleted), otherwise null.
*******************************************************************************/
create or replace function ta.deleteAlteryxType(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.alteryx_type 
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
