package main

import (
	"fmt"
	"os"
	class "github.com/matehaxor03/holistic_db_client/class"
	json "github.com/matehaxor03/holistic_json/json"

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

	client_manager, client_manager_errors := class.NewClientManager()
	if client_manager_errors != nil {
		return client_manager_errors
	}

	migration_database_connection_string := "holistic_db_config:127.0.0.1:3306:holistic:holistic_migration"
	database_client, database_client_errors := client_manager.GetClient(migration_database_connection_string)
	if database_client_errors != nil {
		return database_client_errors
	}
	
	database, database_errors := database_client.GetDatabase()
	if database_errors != nil {
		return database_errors
	}

	if len(errors) > 0 {
		return errors
	}

	database_migration_table, table_errors := database.GetTable("DatabaseMigration")
	if table_errors != nil {
		return table_errors
	}

	count, count_errors := database_migration_table.Count()
	if count_errors != nil {
		return count_errors
	}

	if *count != 1 {
		errors = append(errors, fmt.Errorf("did not find correct number of records for DatabaseMigration %d records found", *count))
		return errors
	}

	data_migration_records, record_errors := database_migration_table.ReadRecords(nil, nil, nil, nil)
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

	if current < desired {
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

func runScript(database *class.Database, data_migration_record *class.Record, version int64, mode string) []error {
	var errors []error
	filename := fmt.Sprintf("./scripts/sql/%d-%s.sql", version, mode)
	raw_sql_command, read_file_error := os.ReadFile(filename)
	if read_file_error != nil {
		errors = append(errors, read_file_error)
		return errors
	}

	raw_sql_command_string := string(raw_sql_command)
	_, sql_errors := database.ExecuteUnsafeCommand(&raw_sql_command_string, json.Map{"use_file": true, "transactional": true})

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
