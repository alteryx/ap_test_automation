/***************************************************************************************************
  Entity Type:  module
  Description:  A module is a collection of code that one can test with a functional test.  In
                Analytic Products, modules include R tools, macros, and packages.  A module's 
                natural key (human-readable unique identifier) includes all three arguments to 
                createModule.  As the entity type has no other properties, no update operation
                is possible.  The surrogate (system generated) key is the bigint value returned 
                by createModule.
***************************************************************************************************/
create or replace function createModule(
  nameIn text,
  typeIn text,
  languageIn text
) returns bigint;
create or replace function getModuleId(
  nameIn text,
  typeIn text,
  languageIn text
) returns bigint;
create or replace function deleteModule(
  nameIn text,
  typeIn text,
  languageIn text
) returns boolean;
create or replace function deleteModuleById(
  idIn bigint
) returns boolean;
create or replace function getModuleList(
  nameIn text,
  typeIn text,
  languageIn text
) returns table;

/***************************************************************************************************
  Entity Type:  test
  Description:  A test is an executable that produces at least one result reflecting the 
                correctness or performance of at least one module.  Results are serialized name/
                value pairs.  A test's natural key includes all three arguments to createTest, so
                no update operation is possible.  That function returns a bigint surrogate key.
***************************************************************************************************/
create or replace function createTest(
  nameIn text,
  typeIn text,
  languageIn text
) returns bigint;
create or replace function getTestId(
  nameIn text,
  typeIn text,
  languageIn text
) returns bigint;
create or replace function deleteTest(
  nameIn text,
  typeIn text,
  languageIn text
) returns boolean;
create or replace function deleteTestById(
  idIn bigint
) returns boolean;

/***************************************************************************************************
  Entity Type:  build
  Description:  A build is the set of operations triggered by a source-control pull request that
                transforms the related source code into an executable module (such as an R package
                or an Alteryx tool).  
***************************************************************************************************/
create or replace function createBuild(
  pullRequestNumber bigint
) returns bigint;
create or replace function setBuildStatusComplete(
  idIn bigint
) boolean;
create or replace function deleteBuild(
  pullRequestNumber bigint
) returns boolean;

/***************************************************************************************************
  Entity Type:  test-module map
  Description:  A test-module map is a relation between a test and a module asserting that the test
                tests the module.  
***************************************************************************************************/
create or replace function createTestModuleMap(
  testNameIn text,
  testTypeIn text,
  testLanguageIn text
  moduleNameIn text,
  moduleTypeIn text,
  moduleLanguageIn text
) returns boolean;
create or replace function createTestModuleMapByIds(
  testIdIn bigint,
  moduleIdIn bigint
) returns boolean;
create or replace function deleteTestModuleMap(
  testNameIn text,
  testTypeIn text,
  testLanguageIn text
  moduleNameIn text,
  moduleTypeIn text,
  moduleLanguageIn text
) returns boolean;
create or replace function deleteTestModuleMapById(
  testIdIn bigint,
  moduleIdIn bigint
) returns boolean;
-- getTestList returns a list of all tests matching the (non-null) input values.
create or replace function getTestList(
  testNameIn text,
  testTypeIn text,
  testLanguageIn text
  moduleNameIn text,
  moduleTypeIn text,
  moduleLanguageIn text
) returns table;
-- Call reportTestStart to record the date and time when a given test started executing for a
-- given build.
create or replace function reportTestStart(
  buildIdIn bigint,
  testIdIn bigint
) returns boolean;
-- Call reportTestFinish to record the date and time when a given test finished executing for a
-- given build, and to report the test's results (including success or failure).
create or replace function reportTestFinish(
  buildIdIn bigint,
  testIdIn bigint,
  resultsIn table
) returns boolean;
