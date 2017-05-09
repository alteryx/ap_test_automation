
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
