CREATE TABLE IF NOT EXISTS `DomainName` (
    `domain_name_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `name` VARCHAR(255) NOT NULL DEFAULT '' comment '{"rules":["domain_name"]}', 
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
     CONSTRAINT UC_DomainName_name UNIQUE (`name`));

INSERT INTO `DomainName` (`name`) VALUES ('github.com');

CREATE TABLE IF NOT EXISTS `BuildStep` (
    `build_step_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `order` BIGINT NOT NULL DEFAULT -1, 
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
     CONSTRAINT UC_BuildStep_name UNIQUE (`name`));

INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_NotStarted', -18000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_Start', -17000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_CreateSourceFolder', -16000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_CreateDomainNameFolder', -15000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_CreateRepositoryAccountFolder', -14000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_CreateRepositoryFolder', -13000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_CreateBranchesFolder', -12000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_CreateTagsFolder', -11000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_CreateBranchOrTagFolder', -10000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_CloneBranchOrTagFolder', -9000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_PullLatestBranchOrTagFolder', -7000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_CopyToInstanceFolder', -6000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_CreateGroup', -5000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_CreateUser', -4000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_AssignGroupToUser', -3000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_AssignGroupToInstanceFolder', -2000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_PullLatestInstanceFolder', -1000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_Clean', 0);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_Lint', 1000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_Build', 2000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_UnitTests', 3000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_RemoveGroupFromInstanceFolder', 11000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_RemoveGroupFromUser', 12000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_DeleteGroup', 13000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_DeleteUser', 14000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_DeleteInstanceFolder', 15000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('Run_End', 16000);

CREATE TABLE IF NOT EXISTS `BuildStepStatus` (
    `build_step_status_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
     CONSTRAINT UC_BuildStepStatus_name UNIQUE (`name`));

INSERT INTO `BuildStepStatus` (`name`) VALUES ('Not Started');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('Running');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('Passed');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('Failed');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('Pending');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('Skipped');

CREATE TABLE IF NOT EXISTS `ProgrammingLanguage` (
    `programming_language_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
    CONSTRAINT UC_ProgrammingLanguage_name UNIQUE (`name`));

INSERT INTO `ProgrammingLanguage` (`name`) VALUES ('Go');

CREATE TABLE IF NOT EXISTS `RepositoryAccount` (
    `repository_account_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `name` VARCHAR(255) NOT NULL DEFAULT '' comment '{"rules":["repository_account_name"]}', 
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
    CONSTRAINT UC_RepositoryAccount_name UNIQUE (`name`));

CREATE TABLE IF NOT EXISTS `Repository` (
    `repository_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `name` VARCHAR(255) NOT NULL DEFAULT '' comment '{"rules":["repository_name"]}', 
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
    CONSTRAINT UC_Repository_name UNIQUE (`name`));

CREATE TABLE IF NOT EXISTS `Branch` (
    `branch_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `name` VARCHAR(255) NOT NULL DEFAULT '' comment '{"rules":["branch_name"]}', 
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
    CONSTRAINT UC_Branch_name UNIQUE (`name`));

INSERT INTO `Branch` (`name`) VALUES ('main');
INSERT INTO `Branch` (`name`) VALUES ('master');

CREATE TABLE IF NOT EXISTS `Build` (
    `build_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `domain_name_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"DomainName","column_name":"domain_name_id","type":"uint64"}}', 
    `repository_account_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"RepositoryAccount","column_name":"repository_account_id","type":"uint64"}}',
    `repository_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"Repository","column_name":"repository_id","type":"uint64"}}',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000', 
    FOREIGN KEY(`domain_name_id`) REFERENCES `DomainName`(`domain_name_id`),   
    FOREIGN KEY(`repository_account_id`) REFERENCES `RepositoryAccount`(`repository_account_id`),
    FOREIGN KEY(`repository_id`) REFERENCES `Repository`(`repository_id`),
    CONSTRAINT UC_Build_id UNIQUE (`domain_name_id`,`repository_account_id`,`repository_id`));

CREATE TABLE IF NOT EXISTS `BuildBranch` (
    `build_branch_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `build_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"Build","column_name":"build_id","type":"uint64"}}', 
    `branch_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"Branch","column_name":"branch_id","type":"uint64"}}', 
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000', 
    FOREIGN KEY(`build_id`) REFERENCES `Build`(`build_id`),
    FOREIGN KEY(`branch_id`) REFERENCES `Branch`(`branch_id`),
    CONSTRAINT UC_BuildBranch_id UNIQUE (`build_id`,`branch_id`));

CREATE TABLE IF NOT EXISTS `TestSuiteBuildBranch` (
    `test_suite_build_branch_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `build_branch_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"BuildBranch","column_name":"build_branch_id","type":"uint64"}}', 
    `parent_test_suite_build_branch_id` BIGINT UNSIGNED NOT NULL DEFAULT 0, 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000', 
    FOREIGN KEY(`build_branch_id`) REFERENCES `BuildBranch`(`build_branch_id`));

CREATE TABLE IF NOT EXISTS `TestBuildBranch` (
    `test_build_branch_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `test_suite_build_branch_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"TestSuiteBuildBranch","column_name":"test_suite_build_branch_id","type":"uint64"}}', 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000', 
    FOREIGN KEY(`test_suite_build_branch_id`) REFERENCES `TestSuiteBuildBranch`(`test_suite_build_branch_id`));

CREATE TABLE IF NOT EXISTS `TestResult` (
    `test_result_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000', 
    CONSTRAINT UC_TestResult_name UNIQUE (`name`));

INSERT INTO `TestResult` (`name`) VALUES ('Passed');
INSERT INTO `TestResult` (`name`) VALUES ('Failed');
INSERT INTO `TestResult` (`name`) VALUES ('Pending');
INSERT INTO `TestResult` (`name`) VALUES ('Skipped');
INSERT INTO `TestResult` (`name`) VALUES ('Unknown');


SET @default_build_step_status_id = (SELECT build_step_status_id FROM BuildStepStatus WHERE `name` = 'Not Started' LIMIT 1);

SET @BuildBranchInstance_Statement := CONCAT('CREATE TABLE IF NOT EXISTS `BuildBranchInstance` (
    `build_branch_instance_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `build_branch_id` BIGINT UNSIGNED NOT NULL comment \'{"foreign_key":{"table_name":"BuildBranch","column_name":"build_branch_id","type":"uint64"}}\',
    `build_step_status_id` BIGINT UNSIGNED NOT NULL DEFAULT ', @default_build_step_status_id, ' comment \'{"foreign_key":{"table_name":"BuildStepStatus","column_name":"build_step_status_id","type":"uint64"}}\',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT \'0000-00-00 00:00:00.000000\',
    FOREIGN KEY(`build_branch_id`) REFERENCES `BuildBranch`(`build_branch_id`),
    FOREIGN KEY(`build_step_status_id`) REFERENCES `BuildStepStatus`(`build_step_status_id`));');

PREPARE dynamic_BuildBranchInstance FROM @BuildBranchInstance_Statement;
EXECUTE dynamic_BuildBranchInstance;

SET @BuildBranchInstanceStep_Statement := CONCAT('CREATE TABLE IF NOT EXISTS `BuildBranchInstanceStep` (
    `build_branch_instance_step_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `build_branch_instance_id` BIGINT UNSIGNED NOT NULL comment \'{"foreign_key":{"table_name":"BuildBranchInstance","column_name":"build_branch_instance_id","type":"uint64"}}\',
    `build_step_id` BIGINT UNSIGNED NOT NULL comment \'{"foreign_key":{"table_name":"BuildStep","column_name":"build_step_id","type":"uint64"}}\',
    `build_step_status_id` BIGINT UNSIGNED NOT NULL DEFAULT ', @default_build_step_status_id, ' comment \'{"foreign_key":{"table_name":"BuildStepStatus","column_name":"build_step_status_id","type":"uint64"}}\',
    `order` BIGINT NOT NULL DEFAULT -1, 
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT \'0000-00-00 00:00:00.000000\',
    FOREIGN KEY(`build_branch_instance_id`) REFERENCES `BuildBranchInstance`(`build_branch_instance_id`),
    FOREIGN KEY(`build_step_id`) REFERENCES `BuildStep`(`build_step_id`),
    FOREIGN KEY(`build_step_status_id`) REFERENCES `BuildStepStatus`(`build_step_status_id`));');

PREPARE dynamic_BuildBranchInstanceStep FROM @BuildBranchInstanceStep_Statement;
EXECUTE dynamic_BuildBranchInstanceStep;

CREATE TABLE IF NOT EXISTS `BuildBranchInstanceStepLog` (
    `build_branch_instance_step_log_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `build_branch_instance_step_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"BuildBranchInstanceStep","column_name":"build_branch_instance_step_id","type":"uint64"}}',
    `log` VARCHAR(1024) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
    FOREIGN KEY(`build_branch_instance_step_id`) REFERENCES `BuildBranchInstanceStep`(`build_branch_instance_step_id`));

CREATE TABLE IF NOT EXISTS `BuildBranchInstanceStepTestResult` (
    `build_branch_instance_step_test_result_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `build_branch_instance_step_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"BuildBranchInstanceStep","column_name":"build_branch_instance_step_id","type":"uint64"}}',
    `test_build_branch_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"TestBuildBranch","column_name":"test_build_branch_id","type":"uint64"}}',
    `test_result_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"TestResult","column_name":"test_result_id","type":"uint64"}}',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
    FOREIGN KEY(`build_branch_instance_step_id`) REFERENCES `BuildBranchInstanceStep`(`build_branch_instance_step_id`),
    FOREIGN KEY(`test_build_branch_id`) REFERENCES `TestBuildBranch`(`test_build_branch_id`),
    FOREIGN KEY(`test_result_id`) REFERENCES `TestResult`(`test_result_id`));



