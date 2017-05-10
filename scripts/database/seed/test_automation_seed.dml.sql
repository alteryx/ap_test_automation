/*******************************************************************************
Test-Automation seed-data DML
History:
  02/22/2017  Todd Morley   initial file creation
*******************************************************************************/

/*******************************************************************************
First, clear all the tables.
*******************************************************************************/
truncate table ta.test_execution_time_fact;
truncate table ta.test_result_atomic_fact;
truncate table ta.test_request_status_change_fact;
truncate table ta.event_atomic_fact;
truncate table ta.date_dim;
truncate table ta.test_result;
truncate table ta.test_request;
truncate table ta.module_event;
truncate table ta.source_file_event;
truncate table ta.event;
truncate table ta.case_dim_allowed_value_test;
truncate table ta.node_node_group;
truncate table ta.module_module;
truncate table ta.source_file_module;
truncate table ta.module_test;
truncate table ta.bug_test;
truncate table ta.case_dim_allowed_value;
truncate table ta.node;
truncate table ta.node_type;
truncate table ta.test;
truncate table ta.module;
truncate table ta.person;
truncate table ta.source_file;
truncate table ta.team;
truncate table ta.bug_management_server;
truncate table ta.source_control_branch;
truncate table ta.source_control_server;
truncate table ta.case_analysis_dimension;
truncate table ta.request_status_type;
truncate table ta.event_type;
truncate table ta.node_group;
truncate table ta.natural_language;
truncate table ta.alteryx_type;
truncate table ta.database_type;
truncate table ta.operating_system_type;
truncate table ta.test_result_type;
truncate table ta.test_priority_level;
truncate table ta.role;
truncate table ta.bug_management_system_type;
truncate table ta.source_control_system_type;
truncate table ta.data_type;

/*******************************************************************************
(Re)generate data in date_dim.
*******************************************************************************/
select ta.populateDateDim();

/*******************************************************************************
(Re)generate data in operational tables.
*******************************************************************************/
-- ta.data_type
select ta.createDataType(nameIn := 'decimal');
select ta.createDataType(nameIn := 'integer');
select ta.createDataType(nameIn := 'date');
select ta.createDataType(nameIn := 'datetime');
select ta.createDataType(nameIn := 'string');
select ta.createDataType(nameIn := 'character');

-- ta.source_control_system_type
select ta.createSourceControlSystemType(
  nameIn := 'Subversion',
  versionIn := '1.9.5'
);
select ta.createSourceControlSystemType(
  nameIn := 'GitHub',
  versionIn := 'current'
);

-- ta.bug_management_system_type
select ta.createBugManagementSystemType(
  nameIn := 'Rally',
  versionIn := 'almci-master-21447'
);

-- ta.role
select ta.createRole(nameIn := 'read only');
select ta.createRole(nameIn := 'user');
select ta.createRole(nameIn := 'team lead');
select ta.createRole(nameIn := 'administrator');

-- ta.test_priority_level
select ta.createTestPriorityLevel(nameIn := 'check in');
select ta.createTestPriorityLevel(nameIn := 'nightly');
select ta.createTestPriorityLevel(nameIn := 'integration');

-- ta.test_result_type
select ta.createTestResultType2(
  nameIn := 'start datetime',
  dataTypeNameIn := 'datetime'
);
select ta.createTestResultType2(
  nameIn := 'end datetime',
  dataTypeNameIn := 'datetime'
);
select ta.createTestResultType2(
  nameIn := 'peak memory utilization (GB)',
  dataTypeNameIn := 'decimal'
);
select ta.createTestResultType2(
  nameIn := 'correct YN',
  dataTypeNameIn := 'character'
);

-- ta.operating_system_type
select ta.createOperatingSystemType(
  nameIn := 'Windows',
  versionIn := '7.1'
);

-- ta.database_type
select ta.createDatabaseType(
  nameIn := 'SQL Server',
  versionIn := '13.0'
);

-- ta.alteryx_version
select ta.createAlteryxVersion(
  versionIn := '11.0',
  supportStartDateIn := to_date('01-Jan-2017', 'DD-Mon-YYYY'),
  supportEndDateIn := NULL
);
select ta.createAlteryxVersion(
  versionIn := '10.6',
  supportStartDateIn := to_date('12-Jul-2016', 'DD-Mon-YYYY'),
  supportEndDateIn := NULL
);

-- ta.natural_language
select ta.createNaturalLanguage(nameIn := 'English');
select ta.createNaturalLanguage(nameIn := 'French');
select ta.createNaturalLanguage(nameIn := 'German');
select ta.createNaturalLanguage(nameIn := 'Arrows');

-- This table will require constant updating of the 
-- last-start datetimes.
-- ta.node_group
select ta.createNodeGroup(
  nameIn := 'bogus node group',
  lastStartDatetimeIn = to_date('01-Jan-2000', 'DD-Mon-YYYY')
);

-- ta.event_type
select ta.createEventType(nameIn := 'code check in');
select ta.createEventType(nameIn := 'ad-hoc module-test request');
select ta.createEventType(nameIn := 'scheduled module-test request');

-- ta.request_status_type
select ta.createRequestStatusType(nameIn := 'requested');
select ta.createRequestStatusType(nameIn := 'processing');
select ta.createRequestStatusType(nameIn := 'complete');
select ta.createRequestStatusType(nameIn := 'failed');
select ta.createRequestStatusType(nameIn := 'cancelled');

-- ta.source_control_server
select ta.createSourceControlServer2(
  nameIn := '',
  sourceControlSystemTypeNameIn := 'Subversion',
  sourceControlSystemTypeVersionIn := '',
  staticIpAddressIn := '10.10.15.7',
  dnsNameIn := 'scm.alteryx.com'
);

-- AP team branch, S:/svn/Alteryx/
-- ta.source_control_branch


-- ta.team
select ta.createTeam2(
  nameIn := 'Analytics Products',
  sourceControlBranchNameIn := '',
  sourceControlServerNameIn := '',
  sourceControlServerTypeNameIn := '',
  sourceControlServerTypeVersionIn := ''
);


-- very module specific, and the team owning a module must define these
-- example:  
--   forest-model tool can build two model types, regression and 
--   classification, so model type is a case-analysis dimension for the
--   forest-model tool (module)
select ta.createCaseAnalysisDimension2(
  nameIn in text,
  moduleNameIn in text,
  teamNameIn in text
)



-- engineering Subversion, 1.1.1.1, eng_svn.alteryx.com, 1
-- ta.alteryx_type
-- This table should be populated by a function that gets the 
-- list of builds available at file://den-it-file-07/BuildRepo/.
-- The below just illustrates how that function should create
-- a single Alteryx type (build).
select ta.createAlteryxType2(
  buildIn := '11280',
  alteryxVersionIn := '11.0'
);

create table ta.bug_management_server(
-- AlteryxRDataX.R, S:\Predictive_Development\Alteryx\Plugins\AlteryxRPlugin\Macros\Predictive Tools, 1
create table ta.source_file(
-- self-explanatory, automagic daily update
create table ta.person(
-- anything that can have a test, e.g. a tool or the whole product
create table ta.module(
create table ta.test(
-- description created automagically 
-- ta.node_type

select ta.createNodeType(
  coreCountIn := 4,
  ramGbIn := 8,
  clockSpeedGHzIn := 2.1,
  operatingSystemTypeIdIn := 1,
  databaseTypeIdIn := 1,
  alteryxTypeIdIn := 4
);

-- ta.node

select ta.createNode(
  ipAddressIn := '1.1.1.1',
  dnsNameIn := 'node1.alteryx.com',
  virtualYnIn := 'y',
  lastStartDateIn := to_date('Jan-01-2000', 'Mon-DD-YYYY'),
  nodeTypeIdIn := 1
);

-- for example, 'regression' and 'classification' for model-type 
-- case-analysis dimension of forest-model tool 
-- (teams create this data)
create table ta.case_dim_allowed_value(
create table ta.bug_test(
create table ta.module_test(
create table ta.source_file_module(
create table ta.module_module(
create table ta.node_node_group(
create table ta.case_dim_allowed_value_test(
create table ta.event(
create table ta.source_file_event(
create table ta.module_event(
-- statuses:  'node not assigned', 'node assigned',
-- 'test started', 'test finished', 
-- 'test-execution failed'.
create table ta.test_request(
create table ta.test_result(
create table ta.date_dim(
create table ta.event_atomic_fact(
create table ta.test_request_status_change_fact(
create table ta.test_result_atomic_fact(
create table ta.test_execution_time_fact(
