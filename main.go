package main

import (
	//"database/sql"
	//"encoding/base64"
	"fmt"
	"os"
	"strings"

	class "github.com/matehaxor03/holistic_db_client/class"
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

	db_hostname, db_port_number, db_name, migration_db_username, _, migration_details_errors := class.GetCredentialDetails("holistic_migration")
	if migration_details_errors != nil {
		errors = append(errors, migration_details_errors...)
	}

	host, host_errors := class.NewHost(&db_hostname, &db_port_number)
	client, client_errors := class.NewClient(host, &migration_db_username, nil)

	if host_errors != nil {
		errors = append(errors, host_errors...)
	}

	if client_errors != nil {
		errors = append(errors, client_errors...)
	}

	if len(errors) > 0 {
		return errors
	}

	database, use_database_errors := client.UseDatabaseByName(db_name)
	if use_database_errors != nil {
		return use_database_errors
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


	data_migration_records, record_errors := database_migration_table.Select(nil, nil, nil)
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
			downgrade_errors := runScript(client, &data_migration_record, current, "upgrade")
			if downgrade_errors != nil {
				return downgrade_errors
			}
		}
	} else if current > desired {
		for current > desired {	
			fmt.Printf("database downgrading from current: %d desired: %d\n", current, desired)
			current = current - 1
			downgrade_errors := runScript(client, &data_migration_record, current, "downgrade")
			if downgrade_errors != nil {
				return downgrade_errors
			}
		}
	} else {
		fmt.Printf("no database schema changes detected current: %d desired: %d\n", current, desired)
	}

	return nil
}

func runScript(client *class.Client, data_migration_record *class.Record, version int64, mode string) []error {
	SQLCommand := class.NewSQLCommand()
	var errors []error
	filname := fmt.Sprintf("./scripts/sql/%d-%s.sql", version, mode)
	raw_sql_command, read_file_error := os.ReadFile(filname) 
	if read_file_error != nil {
		errors = append(errors, read_file_error)
		return errors
	}
	
	raw_sql_command_string := string(raw_sql_command)
	_, stderr, sql_errors := SQLCommand.ExecuteUnsafeCommand(client, &raw_sql_command_string, class.Map{"use_file":true, "transactional":true})
	
	if sql_errors != nil {
		errors = append(errors, sql_errors...)
	}

	if stderr != nil && *stderr != "" {
		if strings.Contains(*stderr, " table exists") {
			errors = append(errors, fmt.Errorf("create table failed most likely the table already exists"))
		} else {
			errors = append(errors, fmt.Errorf(*stderr))
		}
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
