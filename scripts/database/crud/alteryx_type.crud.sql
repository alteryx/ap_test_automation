/*******************************************************************************
Test-Automation CRUD DDL for table ta.alteryx_type
History:
  02/22/2017  Todd Morley   initial file creation
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
Version is the natural key.
*******************************************************************************/
create or replace function ta.createAlteryxType(
  versionIn in text,
  supportStartDateIn in date,
  supportEndDateIn in date default null
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    if(
      supportStartDateIn is null OR
      (
        supportEndDateIn is not null AND
        supportStartDateIn >= supportEndDateIn
      )
    ) then
      raise exception 'invalid support period passed to ta.createAlteryxType';
    end if;
    begin
      select id 
        into strict tempId
        from ta.alteryx_type 
        where 
          version = lower(versionIn) and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.alteryx_type_id_s') into tempId;
    insert into ta.alteryx_type(
      id,
      version,
      support_start_date,
      support_end_date,
      create_datetime,
      end_datetime
    ) values(
      tempId,
      lower(versionIn),
      supportStartDateIn,
      supportEndDateIn,
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
create or replace function ta.getAlteryxTypeId(
  versionIn in text
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
    select version
      into strict tempVersion
      from ta.alteryx_type 
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
GetSupportPeriod function returns a periodType, or null if no
entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getAlteryxTypeSupportPeriod(idIn in bigint)
returns ta.periodType
as $$
  declare
    tempPeriod ta.periodType;
  begin
    select 
      support_start_date,
      support_end_date
      into strict tempPeriod
      from ta.alteryx_type 
      where 
        id = idIn and 
        end_datetime is null;
    return(tempPeriod);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
The update function upates all entity properties that are not part of the
entity type's natural primary key, in this case the support-period dates.
*******************************************************************************/

create or replace function ta.updateAlteryxType(
  idIn in bigint,
  supportStartDateIn in date,
  supportEndDateIn in date default null
)
returns bigint
as $$
  declare
    tempRow ta.alteryx_type%rowtype;
    tempTimestamp timestamp;
  begin
    if(
      supportStartDateIn is null or
      (
        supportEndDateIn is not null and
        supportStartDateIn >= supportEndDateIn
      )
    ) then
      raise exception 'invalid support period passed to ta.createAlteryxType';
    end if;
    select * 
      into tempRow 
      from ta.alteryx_type 
      where
        id = idIn and
        end_datetime is null;
    tempTimestamp := current_timestamp;
    update ta.alteryx_type
      set end_datetime = tempTimestamp
      where 
        id = idIn and
        end_datetime is null;
    insert into ta.alteryx_type(
      id,
      version,
      support_start_date,
      support_end_date,
      create_datetime,
      end_datetime
    ) values(
      idIn,
      tempRow.version,
      supportStartDateIn,
      supportEndDateIn,
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
