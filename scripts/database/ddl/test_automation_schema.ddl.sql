/*******************************************************************************
Test-Automation PostgreSQL Schema DDL
History:
  02/14/2017  Todd Morley   initial file creation
  02/22/2017  Todd Morley   corrections, initial execution on test_automation
                            schema
  02/27/2017  Todd Morley   added several types, plus natural-key annotations
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

/*******************************************************************************
lookup tables with no foreign keys
*******************************************************************************/

create table ta.source_control_system_type(
  id bigint not null,
  name text not null, -- nk
  version text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.source_control_system_type_id_s;

create table ta.bug_management_system_type(
  id bigint not null,
  name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.bug_management_system_type_id_s;

create table ta.role(
  id bigint not null,
  name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.role_id_s;

create table ta.test_priority_level(
  id bigint not null,
	name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.test_priority_level_id_s;

create table ta.test_result_type(
  id bigint not null,
  name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.test_result_type_id_s;

create table ta.operating_system_type(
  id bigint not null,
  name text not null, -- nk
  version text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.operating_system_type_id_s;

create table ta.database_type(
  id bigint not null,
  name text not null, -- nk
  version text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.database_type_id_s;

create table ta.alteryx_type(
  id bigint not null,
  version text not null, -- nk
  support_start_date date not null,
  support_end_date date default null,
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.alteryx_type_id_s;

create table ta.natural_language(
  id bigint not null,
  name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.natural_language_id_s;

create table ta.node_group(
  id bigint not null,
	name text not null, -- nk
  last_start_datetime timestamp not null,
	create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.node_group_id_s;

create table ta.event_type(
  id bigint not null,
  name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null
);
create sequence ta.event_type_id_s;

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

create table ta.case_analysis_dimension(
  id bigint not null,
  name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  module_id bigint not null -- nk
);
create sequence ta.case_analysis_dimension_id_s;

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

create table ta.source_control_branch(
  id bigint not null,
  name text not null, -- nk
  path text not null,
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  source_control_server_id bigint not null -- nk
);
create sequence ta.source_control_branch_id_s;

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

create table ta.team(
  id bigint not null,
  name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  source_control_branch_id bigint not null
);
create sequence ta.team_id_s;

create table ta.source_file(
  id bigint not null,
  name text not null, -- nk
  path text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  source_control_branch_id bigint not null -- nk
);
create sequence ta.source_file_id_s;

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

create table ta.module(
  id bigint not null,
	name text not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null,
	owning_team_id bigint not null -- nk
);
create sequence ta.module_id_s;

create table ta.test(
  id bigint not null,
	file_name text not null, -- nk
	path text not null, -- nk
	description text default null,
  create_datetime timestamp not null,
  end_datetime timestamp default null,
	source_control_server_id bigint not null, -- nk
	test_priority_level_id bigint not null
);
create sequence ta.test_id_s;

create table ta.node_type(
  id bigint not null,
  description text not null,
  core_count integer not null, -- nk
  ram_gb integer not null, -- nk
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  operating_system_type_id bigint not null, -- nk
  database_type_id bigint default null, -- nk
  alteryx_type_id bigint default null -- nk
);
create sequence ta.node_type_id_s;

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

create table ta.case_dim_allowed_value(
  id bigint not null,
  serialized_value text not null,
  create_datetime timestamp not null,
  end_datetime timestamp default null,
  case_analysis_dimension_id bigint not null
);
create sequence ta.case_dim_allowed_value_id_s;

/*******************************************************************************
relation tables
*******************************************************************************/

create table ta.bug_test(
  bug_id_in_mgt_system text not null,
  test_id bigint not null,
  bug_management_server_id bigint not null
);

create table ta.module_test(
  module_id bigint not null,
  test_id bigint not null,
  primary_yn char not null
);

create table ta.source_file_module(
  source_file_id bigint not null,
  module_id bigint not null
);

create table ta.module_module(
  depending_module_id bigint not null,
  depended_module_id  bigint not null
);

create table ta.node_node_group(
  node_id bigint not null,
  node_group_id bigint not null
);

create table ta.case_dim_allowed_value_test(
  case_dim_allowed_value_id bigint not null,
  test_id bigint not null
);

/*******************************************************************************
operational tables
*******************************************************************************/

create table ta.event(
  id bigint not null,
  date_time timestamp not null,
  event_type_id bigint not null,
  originating_person_id bigint not null
);
create sequence ta.event_id_s;

create table ta.source_file_event(
  source_file_id bigint not null,
  event_id bigint not null
);

create table ta.request(
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
  test_id bigint not null
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

create table ta.request_result_atomic_fact(
  test_id bigint not null,
  node_id bigint default null,
  node_group_id bigint default null,
  natural_language_id bigint not null,
  operating_system_type_id bigint not null,
  database_type_id bigint not null,
  alteryx_type_id bigint not null,
  date_dim_id bigint not null,
  total_failure_count integer not null
);

create table ta.event_atomic_fact(
  event_type_id bigint not null,
  source_control_branch_id bigint not null,
  source_control_server_id bigint not null,
  source_control_system_type_id bigint not null,
  date_dim_id bigint not null
);

create table ta.test_result_atomic_fact(
  test_id bigint not null,
  case_dim_allowed_value_id bigint not null,
  source_file_id bigint not null,
  module_id bigint not null,
  natural_language_id bigint not null,
  test_result_type_id bigint not null,
  operating_system_type_id bigint not null,
  database_type_id bigint not null,
  alteryx_type_id bigint not null,
  date_dim_id bigint not null,
  serialized_result_value text not null
);

/*******************************************************************************
star-schema accumulating-snapshot fact tables  
*******************************************************************************/

/*******************************************************************************
star-schema periodic-snapshot fact tables  
*******************************************************************************/

