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

INSERT INTO `BuildStep` (`name`,`order`) VALUES ('processor-> ensure branch or tag instance steps exist', -11000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('processor-> ensure source folder exists', -10000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('processor-> ensure repsitory account folder exists', -9000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('processor-> ensure repsitory folder exists', -8000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('processor-> ensure ensure branches or tags folder exists', -8000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('processor-> ensure clone latest branch or tag folder', -7000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('processor-> ensure pull latest for branch or tag folder', -6000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('processor-> ensure copy branch or tag folder to branch or tag instance folder', -5000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('processor-> ensure user exists branch or tag instance folder', -4000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('processor-> ensure user has permission to read, write and execute only for branch or tag instance folder', -3000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('user-> ensure pull latest for branch or tag instance folder', -2000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('user-> clean', 0);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('user-> lint', 100);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('user-> build', 200);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('user-> unit tests', 300);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('user-> delete branch or tag instance folder', 10000);
INSERT INTO `BuildStep` (`name`,`order`) VALUES ('processor-> delete user for branch or tag instance folder', 11000);

CREATE TABLE IF NOT EXISTS `BuildStepStatus` (
    `build_step_status_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
     CONSTRAINT UC_BuildStepStatus_name UNIQUE (`name`));

INSERT INTO `BuildStepStatus` (`name`) VALUES ('not started');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('running');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('success');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('failed');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('pending');
INSERT INTO `BuildStepStatus` (`name`) VALUES ('skipped');


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

CREATE TABLE IF NOT EXISTS `Build` (
    `build_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `domain_name_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"DomainName","column_name":"domain_name_id","type":"uint64"}}', 
    `repository_account_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"RepositoryAccount","column_name":"repository_account_id","type":"uint64"}}',
    `repository_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"Repository","column_name":"repository_id","type":"uint64"}}',
    `name` VARCHAR(1) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000', 
    FOREIGN KEY(`domain_name_id`) REFERENCES `DomainName`(`domain_name_id`),   
    FOREIGN KEY(`repository_account_id`) REFERENCES `RepositoryAccount`(`repository_account_id`),
    FOREIGN KEY(`repository_id`) REFERENCES `Repository`(`repository_id`),
    CONSTRAINT UC_Build_id UNIQUE (`domain_name_id`,`repository_account_id`,`repository_id`));

CREATE TABLE IF NOT EXISTS `TestSuite` (
    `test_suite_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `build_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"Build","column_name":"build_id","type":"uint64"}}', 
    `parent_test_suite_id` BIGINT UNSIGNED NOT NULL DEFAULT 0, 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000', 
    FOREIGN KEY(`build_id`) REFERENCES `Build`(`build_id`));

CREATE TABLE IF NOT EXISTS `Test` (
    `test_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `test_suite_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"TestSuite","column_name":"test_suite_id","type":"uint64"}}', 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000', 
    FOREIGN KEY(`test_suite_id`) REFERENCES `TestSuite`(`test_suite_id`));

CREATE TABLE IF NOT EXISTS `TestResult` (
    `test_result_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `name` VARCHAR(255) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000', 
    CONSTRAINT UC_TestResult_name UNIQUE (`name`));

INSERT INTO `TestResult` (`name`) VALUES ('passed');
INSERT INTO `TestResult` (`name`) VALUES ('failed');
INSERT INTO `TestResult` (`name`) VALUES ('pending');
INSERT INTO `TestResult` (`name`) VALUES ('skipped');

CREATE TABLE IF NOT EXISTS `BuildBranch` (
    `build_branch_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `build_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"Build","column_name":"build_id","type":"uint64"}}', 
    `branch_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"Branch","column_name":"branch_id","type":"uint64"}}', 
    `name` VARCHAR(1) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000', 
    FOREIGN KEY(`build_id`) REFERENCES `Build`(`build_id`),
    FOREIGN KEY(`branch_id`) REFERENCES `Branch`(`branch_id`),
    CONSTRAINT UC_BuildBranch_id UNIQUE (`build_id`,`branch_id`));

CREATE TABLE IF NOT EXISTS `BuildBranchInstance` (
    `build_branch_instance_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `build_branch_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"BuildBranch","column_name":"build_branch_id","type":"uint64"}}',
    `name` VARCHAR(1) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
    FOREIGN KEY(`build_branch_id`) REFERENCES `BuildBranch`(`build_branch_id`));

CREATE TABLE IF NOT EXISTS `BuildBranchInstanceStep` (
    `build_branch_instance_step_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `build_branch_instance_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"BuildBranchInstance","column_name":"build_branch_instance_id","type":"uint64"}}',
    `build_step_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"BuildStep,"column_name":"build_step_id","type":"uint64"}}',
    `build_step_status_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"BuildStepStatus","column_name":"build_step_status_id","type":"uint64"}}',
    `name` VARCHAR(1) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
    FOREIGN KEY(`build_branch_instance_id`) REFERENCES `BuildBranchInstance`(`build_branch_instance_id`),
    FOREIGN KEY(`build_step_id`) REFERENCES `BuildStep`(`build_step_id`),
    FOREIGN KEY(`build_step_status_id`) REFERENCES `BuildStepStatus`(`build_step_status_id`));

CREATE TABLE IF NOT EXISTS `BuildBranchInstanceStepLog` (
    `build_branch_instance_step_log_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `build_branch_instance_step_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"BuildBranchInstanceStep","column_name":"build_branch_instance_step_id","type":"uint64"}}',
    `log` VARCHAR(1024) NOT NULL DEFAULT '',
    `name` VARCHAR(1) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
    FOREIGN KEY(`build_branch_instance_step_id`) REFERENCES `BuildBranchInstanceStep`(`build_branch_instance_step_id`));

CREATE TABLE IF NOT EXISTS `BuildBranchInstanceStepTestResult` (
    `build_branch_instance_step_test_result_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    `build_branch_instance_step_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"BuildBranchInstanceStep","column_name":"build_branch_instance_step_id","type":"uint64"}}',
    `test_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"Test","column_name":"test_id","type":"uint64"}}',
    `test_result_id` BIGINT UNSIGNED NOT NULL comment '{"foreign_key":{"table_name":"TestResult","column_name":"test_result_id","type":"uint64"}}',
    `name` VARCHAR(1) NOT NULL DEFAULT '',
    `active` BOOLEAN DEFAULT 1, 
    `archieved` BOOLEAN DEFAULT 0, 
    `created_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `last_modified_date` TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6), 
    `archieved_date` TIMESTAMP(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000',
    FOREIGN KEY(`build_branch_instance_step_id`) REFERENCES `BuildBranchInstanceStep`(`build_branch_instance_step_id`),
    FOREIGN KEY(`test_id`) REFERENCES `Test`(`test_id`),
    FOREIGN KEY(`test_result_id`) REFERENCES `TestResult`(`test_result_id`));



