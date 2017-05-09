/*******************************************************************************
Test-Automation CRUD DDL for table ta.case_analysis_dimension
History:
  02/22/2017  Todd Morley   initial file creation
  02/27/2017  Todd Morley   column re-ordering
  03/13/2017  Todd Morley   added get-description function
  04/05/2017  Todd Morley   added createCaseAnalysisDimension2
*******************************************************************************/

/*******************************************************************************
Create function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
*******************************************************************************/
create or replace function ta.createCaseAnalysisDimension(
  nameIn in text,
  moduleIdIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    begin
      select id 
        into strict tempId
        from ta.case_analysis_dimension 
        where 
          name = lower(nameIn) and
          module_id = moduleIdIn and
          end_datetime is null;
      return(tempId);
      exception
        when no_data_found then null; -- not return(null); continue to below
    end;
    select nextval('ta.case_analysis_dimension_id_s') into tempId;
    insert into ta.case_analysis_dimension(
      id,
      name,
      create_datetime,
      end_datetime,
      module_id
    ) values(
      tempId,
      lower(nameIn),
      current_timestamp,
      null,
      moduleIdIn
    );
    return(tempId);
  end
$$
language plpgsql;

/*******************************************************************************
Create2 function returns ID in a variable of type bigint, whether or not the 
entity antedated the call.  (An attempt to re-create the entity is harmless.)
This version of the create function takes a module' natural key, rather than
its ID, as an input, to avoid a separate ancillary call to get a module ID.
*******************************************************************************/
create or replace function ta.createCaseAnalysisDimension2(
  nameIn in text,
  moduleNameIn in text,
  teamNameIn in text
)
returns bigint
as $$
  declare
    tempModuleId bigint;
  begin
    begin
      select ta.module.id
        into strict tempModuleId
        from 
          ta.module,
          ta.team
        where 
          ta.module.name = lower(moduleNameIn) and
          ta.team.name = lower(teamNameIn) and
          ta.module.owning_team_id = ta.team.id and
          ta.module.end_datetime is null and
          ta.team.end_datetime is null;
      exception
        when no_data_found then 
          raise exception 'invalid module or team name passed to ta.createCaseAnalysisDimension2';
    end;
    return(
      ta.createCaseAnalysisDimension(
        nameIn = nameIn,
        moduleIdIn = tempModuleId
      )
    );
  end
$$
language plpgsql;

/*******************************************************************************
GetId function returns the surrogate primary key (ID) of the entity with the 
input natural-key value, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getCaseAnalysisDimensionId(
  nameIn in text,
  moduleIdIn in bigint
)
returns bigint
as $$
  declare
    tempId bigint;
  begin
    select id
      into strict tempId
      from ta.case_analysis_dimension
      where 
        name = lower(nameIn) and 
        module_id = moduleIdIn and
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
create or replace function ta.getCaseAnalysisDimension(idIn in bigint)
returns ta.case_analysis_dimension
as $$
  declare
    tempRecord ta.case_analysis_dimension%rowtype;
  begin
    select * 
      into strict tempRecord
      from ta.case_analysis_dimension 
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
create or replace function ta.getCaseAnalysisDimensionName(idIn in bigint)
returns text
as $$
  declare
    tempName text;
  begin
    select name
      into strict tempName
      from ta.case_analysis_dimension 
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
getCaseAnalysisDimensionModuleId function returns the ID of the owning module 
in a variable of type bigint, or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getCaseAnalysisDimensionModuleId(idIn in bigint)
returns bigint
as $$
  declare
    tempModuleId bigint;
  begin
    select module_id
      into strict tempModuleId
      from ta.case_analysis_dimension 
      where 
        id = idIn and 
        end_datetime is null;
    return(tempModuleId);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
getCaseAnalysisDescription function returns a description of the input object, 
or null if no entity with the input ID was found.
*******************************************************************************/
create or replace function ta.getCaseAnalysisDimensionDescription(
  idIn in bigint
)
returns text
as $$
  declare
    tempDescription text;
  begin
    select 
      ta.case_analysis_dimension.name ||
      ' of ' ||
      ta.module.name
      into strict tempDescription
      from 
        ta.case_analysis_dimension,
        ta.module
      where 
        ta.case_analysis_dimension.id = idIn and 
        ta.case_analysis_dimension.module_id = ta.module.id and
        ta.case_analysis_dimension.end_datetime is null and
        ta.module.end_datetime is null;
    return(tempDescription);
    exception
      when no_data_found then return(null);
  end
$$
language plpgsql;

/*******************************************************************************
The update function upates all entity properties that are not part of the
entity type's natural primary key, in this case the module ID.
*******************************************************************************/
create or replace function ta.updateCaseAnalysisDimension(
  idIn in bigint,
  moduleIdIn in bigint
)
returns bigint
as $$
  declare
    tempRow ta.case_analysis_dimension%rowtype;
    tempTimestamp timestamp;
  begin
    select * 
      into tempRow 
      from ta.case_analysis_dimension
      where
        id = idIn and
        end_datetime is null;
    tempTimestamp := current_timestamp;
    update ta.case_analysis_dimension
      set end_datetime = tempTimestamp
      where 
        id = idIn and
        end_datetime is null;
    insert into ta.case_analysis_dimension(
      id,
      name,
      create_datetime,
      end_datetime,
      module_id
    ) values(
      idIn,
      tempRow.name,
      tempTimestamp,
      null,
      moduleIdIn
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
create or replace function ta.deleteCaseAnalysisDimension(idIn in bigint)
returns bigint
as $$
  declare
    tempId bigint;
  begin
     update ta.case_analysis_dimension 
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
