/*******************************************************************************
SourceFile-Automation CRUD DDL for relation table ta.source_file_module
History:
  02/28/2017  Todd Morley   initial file creation
  03/08/2017  Todd Morley   added GetSourceFilesModules
  04/10/2017  Todd Morley   bug fix
  04/24/2017  Todd Morley   bug fix
*******************************************************************************/

/*******************************************************************************
Create function returns void (even if the target relation already
exists), and raises an exception upon error.  
*******************************************************************************/
create or replace function ta.createSourceFileModule(
  sourceFileIdIn in bigint,
  moduleIdIn in bigint
)
returns void
as $$
  declare
    tempSourceFileModuleCount integer;
    tempModuleCount integer;
    tempSourceFileCount integer;
  begin
    select count(*)
      into tempSourceFileCount
      from ta.source_file
      where
        id = sourceFileIdIn and
        end_datetime is null;
    select count(*)
      into tempModuleCount
      from ta.module
      where
        id = moduleIdIn and
        end_datetime is null;
    if(
      tempSourceFileCount = 0 or 
      tempModuleCount = 0 or
      sourceFileIdIn is null or
      moduleIdIn is null
    ) then
      raise exception 'invalid input passed to ta.createSourceFileModule';
    end if;
    select count(*)
      into tempSourceFileModuleCount
      from ta.source_file_module
      where
        source_file_id = sourceFileIdIn and
        module_id = moduleIdIn and
        end_datetime is null;
    if(tempSourceFileModuleCount > 0) then
      return;
    end if;
    insert into ta.source_file_module(
      create_datetime,
      end_datetime,
      source_file_id,
      module_id
    ) values(
      current_timestamp,
      null,
      sourceFileIdIn,
      moduleIdIn
    );
    return;
  end
$$
language plpgsql;

/*******************************************************************************
GetSourceFileModules function returns a table of IDs of modules for the input 
source file.  
*******************************************************************************/
create or replace function ta.getSourceFileModules(sourceFileIdIn in bigint)
returns table(module_id bigint)
as $$
  declare
  begin
    return query select 
      module_id
      from ta.source_file_module 
      where 
        source_file_id = sourceFileIdIn and
        end_datetime is null;
    exception
      when no_data_found then return;
  end
$$
language plpgsql;

/*******************************************************************************
GetSourceFilesModules function returns a table of IDs of modules for the input 
source files (plural).  
*******************************************************************************/
create or replace function ta.getSourceFilesModules(sourceFileIdsIn in bigint[])
returns table(module_id bigint)
as $$
  declare
  begin
    return query select 
      ta.source_file_module.module_id -- the compiler wanted the schema.table
      from ta.source_file_module 
      where 
        source_file_id = any(sourceFileIdsIn) and
        end_datetime is null;
    exception
      when no_data_found then return;
  end
$$
language plpgsql;

/*******************************************************************************
GetModuleSourceFiles function returns a table source-file IDs for the input
module.  
*******************************************************************************/
create or replace function ta.getModuleSourceFiles(moduleIdIn in bigint)
returns table(
  source_file_id bigint
)
as $$
  declare
  begin
    return query select 
      source_file_id
      from ta.source_file_module 
      where 
        module_id = moduleIdIn and
        end_datetime is null;
    exception
      when no_data_found then return;
  end
$$
language plpgsql;

/*******************************************************************************
No update function; all exposed attributes are in key.
*******************************************************************************/

/*******************************************************************************
Delete function deletes a (source_file, module) relation and returns void.
*******************************************************************************/
create or replace function ta.deleteSourceFileModule(
  sourceFileIdIn in bigint,
  moduleIdIn in bigint
)
returns void
as $$
  declare
  begin
     update ta.source_file_module 
      set end_datetime = current_timestamp
      where
        module_id = moduleIdIn and
        source_file_id = sourceFileIdIn and
        end_datetime is null;
    return;
  end
$$
language plpgsql;
