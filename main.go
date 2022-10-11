package main

import (
	//"database/sql"
	//"encoding/base64"
	"fmt"
	"os"
	"strings"
	"io/ioutil"
	"bufio"

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

	db_hostname, db_port_number, db_name, migration_db_username, _, migration_details_errors := getDetails("holistic_migration")
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

	_, table_errors := database.GetTable("DatabaseMigration")
	if table_errors != nil {
		return table_errors
	}



	/*

	migration_db_password = base64.StdEncoding.EncodeToString([]byte(migration_db_password))

	cfg_migration := mysql.Config{
		User:   migration_db_username,
		Passwd: migration_db_password,
		Net:    "tcp",
		Addr:   db_hostname + ":" + db_port_number,
		DBName: db_name,
	}

	db, dberr := sql.Open("mysql", cfg_migration.FormatDSN())

	if dberr != nil {
		errors = append(errors, dberr)
		defer db.Close()
		return errors
	}
	defer db.Close()

	db_results, count_err := db.Query("SELECT COUNT(*) FROM DatabaseMigration")
	if count_err != nil {
		fmt.Println("error fetching count of records for DatabaseMigration")
		errors = append(errors, count_err)
		defer db.Close()
		return errors
	}
	defer db_results.Close()
	
	var count int
	for db_results.Next() {
		if err := db_results.Scan(&count); err != nil {
			errors = append(errors, err)
			defer db.Close()
			return errors
		}
	}
	db_results.Close()

	if count != 1 {
		errors = append(errors, fmt.Errorf("did not find correct number of records for DatabaseMigration %d records found", count))
		defer db.Close()
		return errors
	}

	var databaseMigrationId int
	var current int
	var desired int
	
	db_results, count_err = db.Query("SELECT databaseMigrationId, current, desired FROM DatabaseMigration")
	if count_err != nil {
		fmt.Println("error fetching details for DatabaseMigration")
		errors = append(errors, count_err)
		defer db.Close()
		return errors
	}

	for db_results.Next() {
		if err := db_results.Scan(&databaseMigrationId, &current, &desired); err != nil {
			errors = append(errors, err)
			defer db.Close()
			return errors
		}
	}
	db_results.Close()

	if current == desired {
		fmt.Printf("no schema changes detected current: %d desired: %d\n", current, desired)
		return nil
	}
	
	if current < desired {
		fmt.Printf("database upgrading from current: %d desired: %d\n", current, desired)

		for current < desired {
			current = current + 1
			errors := executeMigrationScript(db, databaseMigrationId, current, "upgrade")
			if errors != nil {
				return errors
			}
		}
	} else {
		for current > desired {	
			errors := executeMigrationScript(db, databaseMigrationId, current, "downgrade")
			if errors != nil {
				return errors
			}
			current = current - 1
		}
	}
	*/
	return nil
}

/*
func executeMigrationScript(db *sql.DB, databaseMigrationId int, scriptId int, mode string) []error {
	var errors []error
	filname := fmt.Sprintf("./scripts/sql/%d-%s.sql", scriptId, mode)
	
	fmt.Printf("reading filename for %s\n", filname)
	raw_sql_command, err := os.ReadFile(filname) 
	if err != nil {
		fmt.Printf("reading filename for %d\n", filname)
		errors = append(errors, err)
		return errors
	}

	fmt.Printf("db.Begin() for %d\n", scriptId)
	tx, begin_transaction_err := db.Begin()
	if begin_transaction_err != nil {
		fmt.Printf("error db.Begin() for %d\n", scriptId)
		errors = append(errors, begin_transaction_err)
		return errors
	}

	sql_command := string(raw_sql_command) 
	fmt.Printf("db.Exec() for %s\n", filname)
	_, update_error := db.Exec(sql_command)
	if update_error != nil {
		tx.Rollback()
		fmt.Printf("error db.Exec() for %s\n", scriptId)
		errors = append(errors, update_error)
		return errors
	}

	fmt.Printf("tx.Commit() for %d\n", scriptId)
	commit_error := tx.Commit()
	if commit_error != nil {
		tx.Rollback()
		fmt.Printf("error tx.Commit() for %d\n", scriptId)
		errors = append(errors, update_error)
		return errors
	}

	if mode == "downgrade" {
		scriptId -= 1
	}

	fmt.Printf("db.Begin() version %s to %d\n", mode, scriptId)
	tx, begin_transaction_err = db.Begin()
	if begin_transaction_err != nil {
		fmt.Printf("error db.Begin() version %s to %d\n", mode, scriptId)
		errors = append(errors, begin_transaction_err)
		return errors
	}

	fmt.Printf("db.Exec() version %s to %d\n", mode, scriptId)
	_, update_error = db.Exec("UPDATE DatabaseMigration SET current = ? WHERE databaseMigrationId = ?", scriptId,  databaseMigrationId)
	if update_error != nil {
		tx.Rollback()
		fmt.Printf("error db.Exec() version %s to %d\n", mode, scriptId)
		errors = append(errors, update_error)
		return errors
	}

	fmt.Printf("tx.Commit() version %s to %d\n", mode, scriptId)
	commit_error = tx.Commit()
	if commit_error != nil {
		tx.Rollback()
		fmt.Printf("error tx.Commit() version %s to %d\n", mode, scriptId)
		errors = append(errors, update_error)
		return errors
	}

	return nil
}

func getDatabaseName() string {
	return os.Getenv("HOLISTIC_DB_NAME")
}

func validateDatabaseName(db_name string) []error {
	var errors []error
	db_name_regex_name_exp := `^[A-Za-z]+$`
	db_name_regex_name_matcher, db_name_regex_name_matcher_errors := regexp.Compile(db_name_regex_name_exp)
	if db_name_regex_name_matcher_errors != nil {
		errors = append(errors, fmt.Errorf("database name regex %s did not compile %s", db_name_regex_name_exp, db_name_regex_name_matcher_errors.Error()))
		return errors
	}

	if !db_name_regex_name_matcher.MatchString(db_name) {
		errors = append(errors, fmt.Errorf("database name %s did not match regex %s", db_name, db_name_regex_name_exp))
	}

	if len(errors) > 0 {
		return errors
	}

	return nil
}

func getPortNumber() string {
	return os.Getenv("HOLISTIC_DB_PORT_NUMBER")
}

func validatePortNumber(db_port_number string) []error {
	var errors []error
	portnumber_regex_name_exp := `\d+`
	portnumber_regex_name_matcher, port_number_regex_name_matcher_errors := regexp.Compile(portnumber_regex_name_exp)
	if port_number_regex_name_matcher_errors != nil {
		errors = append(errors, fmt.Errorf("portnumber regex %s did not compile %s", portnumber_regex_name_exp, port_number_regex_name_matcher_errors.Error()))
		return errors
	}

	if !portnumber_regex_name_matcher.MatchString(db_port_number) {
		errors = append(errors, fmt.Errorf("portnumber %s did not match regex %s", db_port_number, portnumber_regex_name_exp))
	}

	if len(errors) > 0 {
		return errors
	}

	return nil
}

func getDatabaseHostname() string {
	return os.Getenv("HOLISTIC_DB_HOSTNAME")
}

func validateHostname(db_hostname string) []error {
	var errors []error

	simpleHostname := false
	ipAddress := true
	complexHostname := true

	hostname_regex_name_exp := `^[A-Za-z]+$`
	hostname_regex_name_matcher, hostname_regex_name_matcher_errors := regexp.Compile(hostname_regex_name_exp)
	if hostname_regex_name_matcher_errors != nil {
		errors = append(errors, fmt.Errorf("username regex %s did not compile %s", hostname_regex_name_exp, hostname_regex_name_matcher_errors.Error()))
	}

	simpleHostname = hostname_regex_name_matcher.MatchString(db_hostname)

	parts := strings.Split(db_hostname, ".")
	if len(parts) == 4 {
		for _, value := range parts {
			_, err := strconv.Atoi(value)
			if err != nil {
				ipAddress = false
			}
		}
	}

	for _, value := range parts {
		if !hostname_regex_name_matcher.MatchString(value) {
			complexHostname = false
		}
	}

	if !(simpleHostname || complexHostname || ipAddress) {
		errors = append(errors, fmt.Errorf("hostname name is invalid %s", db_hostname))
	}

	if len(errors) > 0 {
		return errors
	}

	return nil
}

func getCredentials(label string) (string, string) {
	username := os.Getenv("HOLISTIC_DB_" + label + "_USERNAME")
	password := os.Getenv("HOLISTIC_DB_" + label + "_PASSWORD")
	return username, password
}

func validateCredentials(username string, password string) []error {
	var errors []error

	username_regex_exp := `^[A-Za-z]+$`
	username_regex_matcher, username_regex_errors := regexp.Compile(username_regex_exp)
	if username_regex_errors != nil {
		errors = append(errors, fmt.Errorf("username regex %s did not compile %s", username_regex_exp, username_regex_errors.Error()))
	}

	if !username_regex_matcher.MatchString(username) {
		errors = append(errors, fmt.Errorf("username %s did not match regex %s", username, username_regex_exp))
	}

	password_errors := validatePassword(password)
	if password_errors != nil {
		errors = append(errors, password_errors...)
	}

	return errors
}

func validatePassword(password string) []error {
	var uppercasePresent bool
	var lowercasePresent bool
	var numberPresent bool
	var specialCharPresent bool
	const minPassLength = 8
	var passLen int
	var errors []error

	for _, ch := range password {
		switch {
		case unicode.IsNumber(ch):
			numberPresent = true
			passLen++
		case unicode.IsUpper(ch):
			uppercasePresent = true
			passLen++
		case unicode.IsLower(ch):
			lowercasePresent = true
			passLen++
		case unicode.IsPunct(ch) || unicode.IsSymbol(ch):
			specialCharPresent = true
			passLen++
		}
	}

	if !lowercasePresent {
		errors = append(errors, fmt.Errorf("lowercase letter missing"))
	}
	if !uppercasePresent {
		errors = append(errors, fmt.Errorf("uppercase letter missing"))
	}
	if !numberPresent {
		errors = append(errors, fmt.Errorf("at least one numeric character required"))
	}
	if !specialCharPresent {
		errors = append(errors, fmt.Errorf("at least one special character required"))

	}
	if passLen <= minPassLength {
		errors = append(errors, fmt.Errorf("password length must be at least %d characters long", minPassLength))
	}

	if len(errors) > 0 {
		return errors
	}

	return nil
}
*/

func getDetails(label string) (string, string, string, string, string, []error) {
	var errors []error

	files, err := ioutil.ReadDir("./")
    if err != nil {
		errors = append(errors, err)
		return "", "", "", "", "", errors
    }

	filename := ""
    for _, file := range files {
		if file.IsDir() {
			continue
		}

		currentFileName := file.Name()

		if !strings.HasPrefix(currentFileName, "holistic_db_config:") {
			continue
		}

		if !strings.HasSuffix(currentFileName, label + ".config") {
			continue
		}		
		filename = currentFileName
    }

	if filename == "" {
		errors = append(errors, fmt.Errorf("database config for %s not found ust be in the format: holistic_db_config|{database_ip_address}|{database_port_number}|{database_name}|{database_username}.config e.g holistic_db_config|127.0.0.1|3306|holistic|root.config", label))
		return "", "", "", "", "", errors
	}

	parts := strings.Split(filename, ":")
	if len(parts) != 5 {
		errors = append(errors, fmt.Errorf("database config for %s not found ust be in the format: holistic_db_config|{database_ip_address}|{database_port_number}|{database_name}|{database_username}.config e.g holistic_db_config|127.0.0.1|3306|holistic|root.config", label))
		return "", "", "", "", "", errors
	}

	ip_address := parts[1]
	port_number := parts[2]
	database_name := parts[3]

	password := ""
	username := ""
	
	file, err_file := os.Open(filename)

    if err_file != nil {
        errors = append(errors, err_file)
		return "", "", "", "", "", errors
    }

    defer file.Close()

    scanner := bufio.NewScanner(file)

    for scanner.Scan() {
		currentText := scanner.Text()
		if strings.HasPrefix(currentText, "password=") {
			password = currentText[9:len(currentText)]
		}

		if strings.HasPrefix(currentText, "user=") {
			username = currentText[5:len(currentText)]
		}
    }

    if file_errs := scanner.Err(); err != nil {
        errors = append(errors, file_errs)
    }

	if password == "" {
		errors = append(errors, fmt.Errorf("password not found for file: %s", filename))
	}

	if username == "" {
		errors = append(errors, fmt.Errorf("user not found for file: %s", filename))
	}

	if len(errors) > 0 {
		return "", "", "", "", "", errors
	}

	return ip_address, port_number, database_name, username, password, errors
}
