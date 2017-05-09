/*******************************************************************************
Test-Automation PostgreSQL Schema DDL
History:
  02/14/2017  Todd Morley   initial file creation
  02/22/2017  Todd Morley   corrections, initial execution on test_automation
                            schema
  02/27/2017  Todd Morley   added several types, plus annotations
  03/08/2017  Todd Morley   added a type, reworked some DW tables
  03/23/2017  Todd Morley   dropped description columns from node_type and test
                            tables
  03/31/2017  Todd Morley   added ta.bug_management_system_type.version column,
                            ta.alteryx_type.build column
*******************************************************************************/

/*******************************************************************************
schema
*******************************************************************************/

create schema ta;

/*******************************************************************************
types
*******************************************************************************/

create type ta.periodType as (
  start_date date, 
  end_date date
);
create type ta.networkInfoType as (
  ip_address text, 
  dns_name text
);
create type ta.branchLocationType as (
  path text, 
  ip_address text, 
  dns_name text
);
create type ta.testLocationType as (
  file_name text, 
  path text, 
  ip_address text, 
  dns_name text
);
create type ta.testResultType as(
  test_id bigint,
  test_result_type_id bigint,
  node_id bigint,
  natural_language_id bigint,
  serialized_value text
);

/*******************************************************************************
lookup tables with no foreign keys
*******************************************************************************/

-- decimal number, integer, date, datetime, string
create table ta.data_type(
  id bigint not null,
  name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.data_type_id_s;

-- Subversion 4.1, GitHub [null], GitLab 3.3, etc.
create table ta.source_control_system_type(
  id bigint not null,
  name text not null, -- nk
  version text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.source_control_system_type_id_s;

-- Rally x.x, Bugzilla 5.1, etc.
create table ta.bug_management_system_type(
  id bigint not null,
  name text not null, -- nk
  version text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.bug_management_system_type_id_s;

-- team lead, team member, admin, read only
create table ta.role(
  id bigint not null,
  name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.role_id_s;

-- check in, nightly, weekly, integration
create table ta.test_priority_level(
  id bigint not null,
	name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.test_priority_level_id_s;

-- 'start datetime', 'end datetime', 'peak memory', 
-- 'correct YN' (common to all Alteryx-workflow tests),
-- (Teams will also define their own.)
create table ta.test_result_type(
  id bigint not null,
  name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  data_type_id bigint not null
);
create sequence ta.test_result_type_id_s;

-- 64-bit Windows 7.1
create table ta.operating_system_type(
  id bigint not null,
  name text not null, -- nk
  version text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.operating_system_type_id_s;

-- SQL Server 10.3
create table ta.database_type(
  id bigint not null,
  name text not null, -- nk
  version text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.database_type_id_s;

create table ta.alteryx_version(
  id bigint not null,
  version text not null, -- nk
  support_start_date date not null,
  support_end_date date default null,
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.alteryx_version_id_s;

-- English, Spanish
create table ta.natural_language(
  id bigint not null,
  name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.natural_language_id_s;

-- One node can belong to several node groups.
-- Group nodes however you want.
create table ta.node_group(
  id bigint not null,
	name text not null, -- nk
  last_start_datetime timestamp not null,
	create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.node_group_id_s;

-- code check in, ad-hoc module-test request, scheduled module-test request
create table ta.event_type(
  id bigint not null,
  name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.event_type_id_s;

-- requested, processing, complete, failed, cancelled
create table ta.request_status_type(
  id bigint not null,
  name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.request_status_type_id_s;

/*******************************************************************************
lookup tables with foreign keys
*******************************************************************************/

create table ta.alteryx_type(
  id bigint not null,
  build text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  alteryx_version_id bigint not null -- nk
);
create sequence ta.alteryx_type_id_s;

-- very module specific, and the team owning a module must define these
-- example:  
--   forest-model tool can build two model types, regression and 
--   classification, so model type is a case-analysis dimension for the
--   forest-model tool (module)
create table ta.case_analysis_dimension(
  id bigint not null,
  name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  module_id bigint not null -- nk
);
create sequence ta.case_analysis_dimension_id_s;

-- engineering Subversion, 1.1.1.1, eng_svn.alteryx.com, 1
create table ta.source_control_server(
  id bigint not null,
  name text not null, -- nk
  static_ip_address text default null,
  dns_name text default null,
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  source_control_system_type_id bigint not null -- nk
);
create sequence ta.source_control_server_id_s;

-- AP team branch, S:/svn/Alteryx/, 1
create table ta.source_control_branch(
  id bigint not null,
  name text not null, -- nk
  path text not null,
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  source_control_server_id bigint not null -- nk
);
create sequence ta.source_control_branch_id_s;

-- same story as source_control_server
create table ta.bug_management_server(
  id bigint not null,
  name text not null, -- nk
  static_ip_address text default null,
  dns_name text default null,
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  bug_management_system_type_id bigint not null -- nk
);
create sequence ta.bug_management_server_id_s;

-- Analytics Products, 1 (foreign key of the team's main team branch)
create table ta.team(
  id bigint not null,
  name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  source_control_branch_id bigint not null
);
create sequence ta.team_id_s;

-- AlteryxRDataX.R, S:\Predictive_Development\Alteryx\Plugins\AlteryxRPlugin\Macros\Predictive Tools, 1
create table ta.source_file(
  id bigint not null,
  name text not null, -- nk
  path text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  source_control_branch_id bigint not null -- nk
);
create sequence ta.source_file_id_s;

-- self-explanatory, automagic daily update
create table ta.person(
  id bigint not null,
	full_name text not null,
	active_directory_object_guid text not null, -- nk
	email text not null,
	cell_phone text default null,
  create_datetime timestamp not null,
  end_datetime timestamp default null,
	team_id bigint not null,
	role_id bigint not null
);
create sequence ta.person_id_s;

-- anything that can have a test, e.g. a tool or the whole product
create table ta.module(
  id bigint not null,
	name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null,
	owning_team_id bigint not null -- nk
);
create sequence ta.module_id_s;

-- self-expl
create table ta.test(
  id bigint not null,
	file_name text not null, -- nk
	path text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null,
	source_control_server_id bigint not null, -- nk
	test_priority_level_id bigint not null
);
create sequence ta.test_id_s;

-- description created automagically 
create table ta.node_type(
  id bigint not null,
  core_count integer not null, -- nk
  ram_gb integer not null, -- nk
  clock_speed_ghz numeric not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  operating_system_type_id bigint not null, -- nk
  database_type_id bigint default null, -- nk
  alteryx_type_id bigint default null -- nk
);
create sequence ta.node_type_id_s;

-- self expl
create table ta.node(
  id bigint not null,
  ip_address text default null, -- nk (can't change, except null to non-null)
  dns_name text default null, -- nk (can't change, except null to non-null)
  virtual_yn char not null,
  last_start_date date not null,
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  node_type_id bigint not null
);
create sequence ta.node_id_s;

-- for example, 'regression' and 'classification' for model-type 
-- case-analysis dimension of forest-model tool 
-- (teams create this data)
create table ta.case_dim_allowed_value(
  id bigint not null,
  serialized_value text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  case_analysis_dimension_id bigint not null -- nk
);
create sequence ta.case_dim_allowed_value_id_s;

/*******************************************************************************
relation tables
*******************************************************************************/

create table ta.bug_test(
  bug_id_in_mgt_system text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  test_id bigint not null, -- nk
  bug_management_server_id bigint not null -- nk
);

create table ta.module_test(
  primary_yn char not null,
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  module_id bigint not null, -- nk
  test_id bigint not null -- nk
);

create table ta.source_file_module(
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  source_file_id bigint not null, -- nk
  module_id bigint not null -- nk
);

create table ta.module_module(
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  depending_module_id bigint not null, -- nk
  depended_module_id bigint not null -- nk
);

create table ta.node_node_group(
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  node_id bigint not null, -- nk
  node_group_id bigint not null -- nk
);

create table ta.case_dim_allowed_value_test(
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  case_dim_allowed_value_id bigint not null, -- nk
  test_id bigint not null -- nk
);

/*******************************************************************************
operational tables
*******************************************************************************/

-- (see event_type above)
create table ta.event(
  id bigint not null,
  date_time timestamp not null, -- nk
  event_type_id bigint not null, -- nk
  originating_person_id bigint not null
);
create sequence ta.event_id_s;

create table ta.source_file_event(
  source_file_id bigint not null,
  event_id bigint not null
);

create table ta.module_event(
  module_id bigint not null,
  event_id bigint not null
);

-- statuses:  'node not assigned', 'node assigned',
-- 'test started', 'test finished', 
-- 'test-execution failed'.
create table ta.test_request(
  date_time timestamp not null,
  failure_count integer not null,
  event_id bigint not null,
  test_id bigint not null,
  node_id bigint default null,
  node_group_id bigint default null,
  request_status_type_id bigint not null
);

create table ta.test_result(
  serialized_result_value text not null,
  test_result_type_id bigint not null,
  event_id bigint not null,
  test_id bigint not null,
  node_id bigint not null
);

/*******************************************************************************
star-schema dimension tables  
(Treat lookup tables as type-two slowly changing dimensions, where plausible.)
*******************************************************************************/

create table ta.date_dim(
  id bigint not null,
  the_date date not null,
  year integer not null,
  quarter integer not null,
  month integer not null,
  day integer not null
);
create sequence ta.date_dim_id_s;

/*******************************************************************************
star-schema atomic-fact tables  
*******************************************************************************/

create table ta.event_atomic_fact(
  date_time timestamp not null,
  -- dimension FKs
  date_dim_id bigint not null,
  event_type_id bigint not null,
  originating_person_id bigint not null,
  source_control_branch_id bigint default null,
  source_control_server_id bigint default null,
  source_control_system_type_id bigint default null
);

create table ta.test_request_status_change_fact(
  date_time timestamp not null,
  -- dimension FKs
  date_dim_id bigint not null,
  test_id bigint not null,
  event_id bigint not null,
  request_status_type_id bigint not null
);

create table ta.test_result_atomic_fact(
  serialized_result_value text not null,
  date_time timestamp not null,
  -- dimension FKs
  date_dim_id bigint not null,
  test_id bigint not null,
  event_id bigint not null,
  natural_language_id bigint not null,
  test_result_type_id bigint not null,
  node_id bigint not null,
  node_type_id bigint not null,
  operating_system_type_id bigint not null,
  database_type_id bigint not null,
  alteryx_type_id bigint not null
);

/*******************************************************************************
star-schema accumulating-snapshot fact tables  
*******************************************************************************/

create table ta.test_execution_time_fact(
  execution_time_seconds numeric not null,
  event_date_time timestamp not null,
  -- dimension FKs
  test_id bigint not null,
  date_dim_id bigint not null,
  natural_language_id bigint not null,
  node_id bigint not null,
  node_type_id bigint not null,
  test_result_type_id bigint not null,
  operating_system_type_id bigint not null,
  database_type_id bigint not null,
  alteryx_type_id bigint not null
);

/*******************************************************************************
star-schema periodic-snapshot fact tables  
*******************************************************************************/

