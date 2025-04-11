package main

import (
	"database/sql"
	"os"

	_ "github.com/joho/godotenv/autoload"
	_ "github.com/lib/pq"
)

func main() {
	// connection string
	psqlconn := os.Getenv("SUPABASEDB")

	// open database
	db, err := sql.Open("postgres", psqlconn)

	if err != nil {
		panic(err)
	}

	// close database
	defer db.Close()
}
