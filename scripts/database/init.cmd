:: Description: this script will create the postgres schema and subsequent setup
::   for the Test Automation framework

::::::::: TODO :::::::::
:: > check for .sql files not listed here and warn if present
:: > warn if schema has already been created
::::::::::::::::::::::::

@echo off
::set dbname=%1
set /p dbname= What is the name of the database to be initialized? 
set ip=10.10.18.50
set username=postgres
set port=5432

psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\ddl\test_automation_schema.ddl.sql"
::pause

psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\alteryx_type.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\alteryx_version.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\bug_management_server.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\bug_management_system_type.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\bug_test.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\case_analysis_dimension.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\case_dim_allowed_value.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\case_dim_allowed_value_test.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\database_type.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\data_type.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\date.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\event_type.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\module.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\module_module.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\module_test.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\natural_language.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\node.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\node_group.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\node_node_group.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\node_type.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\operating_system_type.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\person.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\request_status_type.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\role.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\source_control_branch.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\source_control_server.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\source_control_system_type.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\source_file.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\source_file_module.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\ta_admin.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\team.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\test.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\test_priority_level.crud.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\crud\test_result_type.crud.sql"
::pause

psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\operational\operational.sql"
::pause

psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\seed\test_automation_seed.ddl.sql"
psql -h %ip% -d %dbname% -U %username% -p %port% -a -q -f ".\seed\test_automation_seed.dml.sql"
pause
