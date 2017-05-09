/*******************************************************************************
SourceFile-Automation CRUD DDL for relation table ta.module_module
History:
  02/28/2017  Todd Morley   initial file creation
  03/22/2017  Todd Morley   added getModuleModuleDescription
*******************************************************************************/

/*******************************************************************************
Create function returns void (even if the target relation already
exists), and raises an exception upon error.  
*******************************************************************************/
create or replace function ta.createModuleModule(
  dependingModuleIdIn in bigint,
  dependedModuleIdIn in bigint
)
returns void
as $$
  declare
    tempModuleModuleCount integer;
    tempDependingModuleCount integer;
    tempDependedModuleCount integer;
  begin
    select count(*)
      into tempDependingModuleCount
      from ta.module_module
      where
        id = dependingModuleIdIn and
        end_datetime is null;
    select count(*)
      into tempDependedModuleCount
      from ta.module_module
      where
        id = dependedModuleIdIn and
        end_datetime is null;
    if(
      tempDependingModuleCount = 0 or 
      tempDependedModuleCount = 0 or
      dependingModuleIdIn is null or
      dependedModuleIdIn is null
    ) then
      raise exception 'invalid input passed to ta.createModuleModule';
    end if;
    select count(*)
      into tempModuleModuleCount
      from ta.module_module
      where
        depending_module_id = dependingModuleIdIn and
        depended_module_id = dependedModuleIdIn and
        end_datetime is null;
    if(tempModuleModuleCount > 0) then
      return;
    end if;
    insert into ta.module_module(
      create_datetime,
      end_datetime,
      depending_module_id,
      depended_module_id
    ) values(
      current_timestamp,
      null,
      dependingModuleIdIn,
      dependedModuleIdIn
    );
    return;
  end
$$
language plpgsql;

/*******************************************************************************
GetDependingModules function returns a table of IDs of depending modules for the
input depended module.  
*******************************************************************************/
create or replace function ta.getDependingModules(dependedModuleIdIn in bigint)
returns table(depending_module_id bigint)
as $$
  declare
  begin
    return query select 
      depending_module_id
      from ta.module_module 
      where 
        depended_module_id = dependedModuleIdIn and
        end_datetime is null;
    exception
      when no_data_found then return;
  end
$$
language plpgsql;

/*******************************************************************************
GetDependedModules function returns a table of IDs of depended modules for the
input depending module.  
*******************************************************************************/
create or replace function ta.getDependedModules(dependingModuleIdIn in bigint)
returns table(depended_module_id bigint)
as $$
  declare
  begin
    return query select 
      depended_module_id
      from ta.module_module 
      where 
        depending_module_id = dependingModuleIdIn and
        end_datetime is null;
    exception
      when no_data_found then return;
  end
$$
language plpgsql;

/*******************************************************************************
getModuleModuleDescription function returns a text description of the relation
between a depending module and a dependent module, or null if no such relation
exists.  
*******************************************************************************/
create or replace function ta.getModuleModuleDescription(
  dependingModuleIdIn in bigint,
  dependentModuleIdIn in bigint
)
returns text
as $$
  declare
    tempDescription text;
  begin
    select 
      dependentModule.name || 
      ' depending on ' || 
      dependingModule.name
      into tempDescription
      from
        ta.module dependentModule,
        ta.module dependingModule,
        ta.module_module
      where 
        ta.module_module.dependent_module_id = dependentModuleIdIn and
        ta.module_module.depending_module_id = dependingModuleIdIn and
        dependentModule.id = dependentModuleIdIn and
        dependingModule.id = dependingModuleIdIn and
        dependentModule.end_datetime is null and
        dependingModule.end_datetime is null;
    return(tempDescription);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
No update function; all exposed attributes are in key.
*******************************************************************************/

/*******************************************************************************
Delete function deletes a (module, module) relation and returns void.
*******************************************************************************/
create or replace function ta.deleteModuleModule(
  dependingModuleIdIn in bigint,
  dependedModuleIdIn in bigint
)
returns void
as $$
  declare
  begin
     update ta.module_module 
      set end_datetime = current_timestamp
      where
        depending_module_id = dependingModuleIdIn and
        depended_module_id = dependedModuleIdIn and
        end_datetime is null;
    return;
  end
$$
language plpgsql;
