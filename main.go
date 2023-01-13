package main

import (
	"fmt"
	"os"
	dao "github.com/matehaxor03/holistic_db_client/dao"
	common "github.com/matehaxor03/holistic_common/common"
)

func main() {
	errors := migrateDatabase()
	if errors != nil {
		fmt.Println(fmt.Errorf("%s", errors))
		os.Exit(1)
	}
	os.Exit(0)
}

func migrateDatabase() []error {
	var errors []error

	client_manager, client_manager_errors := dao.NewClientManager()
	if client_manager_errors != nil {
		return client_manager_errors
	}

	database_client, database_client_errors := client_manager.GetClient("127.0.0.1", "3306", "holistic", "holistic_migration")
	if database_client_errors != nil {
		return database_client_errors
	}
	
	database := database_client.GetDatabase()
	
	if len(errors) > 0 {
		return errors
	}

	database_migration_table, table_errors := database.GetTable("DatabaseMigration")
	if table_errors != nil {
		return table_errors
	}

	count, count_errors := database_migration_table.Count(nil, nil, nil, nil, nil)
	if count_errors != nil {
		return count_errors
	}

	if *count != 1 {
		errors = append(errors, fmt.Errorf("did not find correct number of records for DatabaseMigration %d records found", *count))
		return errors
	}

	data_migration_records, record_errors := database_migration_table.ReadRecords(nil, nil, nil, nil, nil, nil)
	if record_errors != nil {
		return record_errors
	}

	data_migration_record := (*data_migration_records)[0]

	current_pt, current_errors := data_migration_record.GetInt64("current")
	desired_pt, desired_errors := data_migration_record.GetInt64("desired")

	if current_errors != nil {
		errors = append(errors, current_errors...)
	}

	if desired_errors != nil {
		errors = append(errors, desired_errors...)
	}

	if len(errors) > 0 {
		return errors
	}

	current := *current_pt
	desired := *desired_pt

	if desired == -1 && current == 0 {
		fmt.Printf("database downgrading from current: %d desired: %d\n", current, desired)
			downgrade_errors := runScript(database, &data_migration_record, current, "downgrade")
			if downgrade_errors != nil {
				return downgrade_errors
			} else {
				fmt.Printf("database downgraded from current: %d desired: %d\n", current, desired)
			}
			
			data_migration_record.SetInt64("current", &desired)
			update_errors := data_migration_record.Update()
			if update_errors != nil {
				return update_errors
			}
	} else if current < desired {
		for current < desired {
			fmt.Printf("database upgrading from current: %d desired: %d\n", current, desired)
			current = current + 1
			downgrade_errors := runScript(database, &data_migration_record, current, "upgrade")
			if downgrade_errors != nil {
				return downgrade_errors
			} else {
				fmt.Printf("database upgraded from current: %d desired: %d\n", current, desired)
			}
		}
	} else if current > desired {
		for current > desired {
			fmt.Printf("database downgrading from current: %d desired: %d\n", current, desired)
			current = current - 1
			downgrade_errors := runScript(database, &data_migration_record, current, "downgrade")
			if downgrade_errors != nil {
				return downgrade_errors
			} else {
				fmt.Printf("database downgraded from current: %d desired: %d\n", current, desired)
			}
		}
	} else {
		fmt.Printf("no database schema changes detected current: %d desired: %d\n", current, desired)
	}

	return nil
}

func runScript(database *dao.Database, data_migration_record *dao.Record, version int64, mode string) []error {
	bashCommand := common.NewBashCommand()
	directory_parts := common.GetDataDirectory()
	directory := "/" 
	for index, directory_part := range directory_parts {
		directory += directory_part
		if index < len(directory_parts) - 1 {
			directory += "/"
		}
	}
	
	var errors []error
	filename := fmt.Sprintf("./scripts/sql/%d-%s.sql", version, mode)
	_, read_file_error := os.ReadFile(filename)
	if read_file_error != nil {
		errors = append(errors, read_file_error)
		return errors
	}

	host := database.GetHost()
	host_name := host.GetHostName()
	port_number := host.GetPortNumber()
	database_name := database.GetDatabaseName()
	database_username := database.GetDatabaseUsername()
	
	_, sql_errors := bashCommand.ExecuteUnsafeCommand("/usr/local/mysql/bin/mysql --defaults-extra-file=" + directory + "/holistic_db_config#" + host_name + "#" + port_number + "#" + database_name + "#" + (*database_username) + ".config --host=" + host_name + " --port=" + port_number + " --protocol=TCP --wait --reconnect --batch", nil, nil)

	if sql_errors != nil {
		errors = append(errors, sql_errors...)
	}

	if len(errors) > 0 {
		return errors
	}

	data_migration_record.SetInt64("current", &version)
	update_errors := data_migration_record.Update()
	if update_errors != nil {
		return update_errors
	}

	return nil
}
