package main

import (
	"database/sql"
	"log"
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
		log.Printf("db connection: %v", err)
	}

	// close database
	defer func() {
		if err := db.Close(); err != nil {
			log.Printf("close response body: %v", err)
		}
	}()
}
