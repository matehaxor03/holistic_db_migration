USE `holistic`;
CREATE TABLE IF NOT EXISTS `DomainName` (
    `domain_name_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `name` VARCHAR(255) NOT NULL DEFAULT '' comment '{"rules":["domain_name"]}', 
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
     CONSTRAINT `name` UNIQUE (`name`));

INSERT INTO `DomainName` (`name`) VALUES ('github.com');

CREATE TABLE IF NOT EXISTS `BuildStepGroup` (
    `build_step_group_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `order` BIGINT NOT NULL DEFAULT -1, 
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
     CONSTRAINT `name` UNIQUE (`name`)) comment '{"cache":true}';

INSERT INTO `BuildStepGroup` (`name`,`order`) VALUES ('Setup', -100000);
INSERT INTO `BuildStepGroup` (`name`,`order`) VALUES ('Run', 0);
INSERT INTO `BuildStepGroup` (`name`,`order`) VALUES ('Teardown', 100000);

SET @build_step_group_id_setup = (SELECT build_step_group_id FROM BuildStepGroup WHERE `name` = 'Setup' LIMIT 1);
SET @build_step_group_id_run = (SELECT build_step_group_id FROM BuildStepGroup WHERE `name` = 'Run' LIMIT 1);
SET @build_step_group_id_teardown = (SELECT build_step_group_id FROM BuildStepGroup WHERE `name` = 'TearDown' LIMIT 1);

CREATE TABLE IF NOT EXISTS `BuildStep` (
    `build_step_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `build_step_group_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"BuildStepGroup","column_name":"build_step_group_id","type":"uint64"}}', 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `order` BIGINT NOT NULL DEFAULT -1, 
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
     CONSTRAINT `name,order` UNIQUE (`name`,`order`)) comment '{"cache":true}';

INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_Sync', -100000, @build_step_group_id_run);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_NotStarted', -21000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_Start', -20000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_CreateSourceFolder', -19000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_CreateDomainNameFolder', -18000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_CreateRepositoryAccountFolder', -17000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_CreateRepositoryFolder', -16000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_CreateBranchesFolder', -15000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_CreateTagsFolder', -14000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_CreateBranchInstancesFolder', -13000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_CreateTagInstancesFolder', -12000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_CreateBranchOrTagFolder', -11000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_CloneBranchOrTagFolder', -10000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_PullLatestBranchOrTagFolder', -9000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_DeleteInstanceFolder', -8000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_CreateInstanceFolder', -7000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_CopyToInstanceFolder', -6000, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_Clean', 0, @build_step_group_id_setup);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_Lint', 1000, @build_step_group_id_run);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_Build', 2000, @build_step_group_id_run);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_UnitTests', 3000, @build_step_group_id_run);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_IntegrationTests', 4000, @build_step_group_id_run);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_IntegrationTestSuite', 5000, @build_step_group_id_run);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_DeleteInstanceFolder', 15000, @build_step_group_id_teardown);
INSERT INTO `BuildStep` (`name`,`order`,`build_step_group_id`) VALUES ('Run_End', 16000, @build_step_group_id_teardown);

CREATE TABLE IF NOT EXISTS `BuildStepStatus` (
    `build_step_status_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
     CONSTRAINT `name` UNIQUE (`name`)) comment '{"cache":true}';

INSERT INTO `BuildStepStatus` (`name`) VALUES ('Not Started');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('Running');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('Passed');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('Failed');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('Pending');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('Skipped');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('Stopped');

CREATE TABLE IF NOT EXISTS `ProgrammingLanguage` (
    `programming_language_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
    CONSTRAINT `name` UNIQUE (`name`));

INSERT INTO `ProgrammingLanguage` (`name`) VALUES ('Go');

CREATE TABLE IF NOT EXISTS `RepositoryAccount` (
    `repository_account_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `domain_name_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"DomainName","column_name":"domain_name_id","type":"uint64"}}', 
    `name` VARCHAR(255) NOT NULL DEFAULT '' comment '{"rules":["repository_account_name"]}', 
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
    CONSTRAINT `name` UNIQUE (`name`));

CREATE TABLE IF NOT EXISTS `Repository` (
    `repository_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `repository_account_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"RepositoryAccount","column_name":"repository_account_id","type":"uint64"}}',
    `name` VARCHAR(255) NOT NULL DEFAULT '' comment '{"rules":["repository_name"]}', 
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
    CONSTRAINT `name` UNIQUE (`name`));

CREATE TABLE IF NOT EXISTS `Branch` (
    `branch_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY comment '{"foreign_keys":[{"table_name":"BranchInstance","column_name":"branch_id","type":"uint64"}]}',
    `repository_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"Repository","column_name":"repository_id","type":"uint64"}}',
    `name` VARCHAR(255) NOT NULL DEFAULT '' comment '{"rules":["branch_name"]}', 
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
    CONSTRAINT `name` UNIQUE (`name`));

CREATE TABLE IF NOT EXISTS `TestSuiteBranch` (
    `test_suite_branch_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `branch_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"Branch","column_name":"branch_id","type":"uint64"}}', 
    `parent_test_suite_build_branch_id` BIGINT UNSIGNED NOT NULL DEFAULT 0, 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000');

CREATE TABLE IF NOT EXISTS `TestBranch` (
    `test_branch_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `test_suite_branch_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"TestSuiteBranch","column_name":"test_suite_branch_id","type":"uint64"}}', 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000');

CREATE TABLE IF NOT EXISTS `TestResult` (
    `test_result_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000', 
    CONSTRAINT `name` UNIQUE (`name`)) comment '{"cache":true}';

INSERT INTO `TestResult` (`name`) VALUES ('Passed');
INSERT INTO `TestResult` (`name`) VALUES ('Failed');
INSERT INTO `TestResult` (`name`) VALUES ('Pending');
INSERT INTO `TestResult` (`name`) VALUES ('Skipped');
INSERT INTO `TestResult` (`name`) VALUES ('Unknown');


SET @default_build_step_status_id = (SELECT build_step_status_id FROM BuildStepStatus WHERE `name` = 'Not Started' LIMIT 1);

SET @BuildBranchInstance_Statement := CONCAT('CREATE TABLE IF NOT EXISTS `BranchInstance` (
    `branch_instance_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `branch_id` BIGINT UNSIGNED NOT NULL comment \'{"foreign_key":{"table_name":"Branch","column_name":"branch_id","type":"uint64"}}\',
    `build_step_status_id` BIGINT UNSIGNED NOT NULL DEFAULT ', @default_build_step_status_id, ' comment \'{"foreign_key":{"table_name":"BuildStepStatus","column_name":"build_step_status_id","type":"uint64"}}\',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT \'0000-00-00 00:00:00.000000\');');

PREPARE dynamic_BuildBranchInstance FROM @BuildBranchInstance_Statement;
EXECUTE dynamic_BuildBranchInstance;

SET @BuildBranchInstanceStep_Statement := CONCAT('CREATE TABLE IF NOT EXISTS `BranchInstanceStep` (
    `branch_instance_step_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `branch_instance_id` BIGINT UNSIGNED NOT NULL comment \'{"foreign_key":{"table_name":"BranchInstance","column_name":"branch_instance_id","type":"uint64"}}\',
    `build_step_id` BIGINT UNSIGNED NOT NULL comment \'{"foreign_key":{"table_name":"BuildStep","column_name":"build_step_id","type":"uint64"}}\',
    `build_step_group_id` BIGINT UNSIGNED NOT NULL comment \'{"foreign_key":{"table_name":"BuildStepGroup","column_name":"build_step_group_id","type":"uint64"}}\',
    `build_step_status_id` BIGINT UNSIGNED NOT NULL DEFAULT ', @default_build_step_status_id, ' comment \'{"foreign_key":{"table_name":"BuildStepStatus","column_name":"build_step_status_id","type":"uint64"}}\',
    `order` BIGINT NOT NULL DEFAULT -1, 
    `parameters` VARCHAR(1024) NOT NULL DEFAULT \'{}\',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT \'0000-00-00 00:00:00.000000\');');

PREPARE dynamic_BuildBranchInstanceStep FROM @BuildBranchInstanceStep_Statement;
EXECUTE dynamic_BuildBranchInstanceStep;

CREATE TABLE IF NOT EXISTS `BranchInstanceStepLog` (
    `branch_instance_step_log_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `branch_instance_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"BranchInstance","column_name":"branch_instance_id","type":"uint64"}}',
    `branch_instance_step_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"BranchInstanceStep","column_name":"branch_instance_step_id","type":"uint64"}}',
    `log` VARCHAR(1024) NOT NULL DEFAULT '',
    `stdout` BOOLEAN DEFAULT 1, 
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000');

CREATE TABLE IF NOT EXISTS `BranchInstanceStepTestResult` (
    `branch_instance_step_test_result_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `branch_instance_step_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"BranchInstanceStep","column_name":"branch_instance_step_id","type":"uint64"}}',
    `test_branch_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"TestBranch","column_name":"test_branch_id","type":"uint64"}}',
    `test_result_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"TestResult","column_name":"test_result_id","type":"uint64"}}',
    `duration` DOUBLE NOT NULL DEFAULT -1.00, 
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000');



