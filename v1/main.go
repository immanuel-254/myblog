package main

import (
	"database/sql"
	"fmt"
	"log"
	"myblog/view"
	"net/http"
	"os"
	"time"

	_ "github.com/joho/godotenv/autoload"
	_ "github.com/lib/pq"
)

func Server() {
	mux := http.NewServeMux()

	authviews := []view.View{
		view.SignUpWebView,
		view.ActivateEmailWebView,
	}

	view.Routes(mux, authviews)

	server := &http.Server{
		Addr:         fmt.Sprintf(":%s", os.Getenv("PORT")), // Custom port
		Handler:      mux,
		ReadTimeout:  10 * time.Second, // Set read timeout
		WriteTimeout: 10 * time.Second, // Set write timeout
		IdleTimeout:  30 * time.Second, // Set idle timeout
	}

	if err := server.ListenAndServe(); err != nil {
		log.Println("Error starting server:", err)
	}
}

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

	Server()
}
