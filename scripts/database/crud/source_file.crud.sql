/*******************************************************************************
Test-Automation CRUD DDL for table ta.source_file
History:
  02/27/2017  Todd Morley   initial file creation
  03/22/2017  Todd Morley   added getSourceFileDescription
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createSourceFile(
  nameIn in text,
  pathIn in text,
  sourceControlBranchIdIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    begin
      select id 
        into strict tempId
        from ta.source_file 
        where 
          name = nameIn and
          path = pathIn and
          source_control_branch_id = sourceControlBranchIdIn and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.source_file_id_s') into tempId;
    insert into ta.source_file(
      id,
      name,
      path,
      create_datetime,
      end_datetime,
      source_control_branch_id
    ) values(
      tempId,
      nameIn,
      pathIn,
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
create or replace function ta.getSourceFileId(
  nameIn in text,
  pathIn in text,
  sourceControlBranchIdIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.source_file
      where 
        name = nameIn and 
        path = pathIn and 
        source_control_branch_id = sourceControlBranchIdIn and
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
create or replace function ta.getSourceFile(idIn in bigint)
returns ta.source_file
as $$
  declare
    tempRecord ta.source_file%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.source_file 
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
create or replace function ta.getSourceFileName(idIn in bigint)
returns text
as $$
  declare
    tempName text;
  begin
    select name
      into strict tempName
      from ta.source_file 
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
getSourceFileDescription returns a text description of the source file with ID
idIn, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getSourceFileDescription(idIn in bigint)
returns text
as $$
  declare
    tempDescription text;
  begin
    select 
      path || 
      '/' || 
      name || 
      ' on ' || 
      ta.source_control_branch.name
      into strict tempDescription
      from ta.source_file 
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
create or replace function ta.deleteSourceFile(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.source_file 
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
