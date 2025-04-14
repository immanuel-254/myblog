package view

import (
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"os"
	"strings"

	"github.com/gorilla/sessions"
)

type View struct {
	Route       string
	Middlewares []func(http.Handler) http.Handler
	Handler     http.Handler
}

var store = sessions.NewCookieStore([]byte(os.Getenv("SESSION_KEY")))

// Middleware chaining
func chainMiddlewares(handler http.Handler, middlewares []func(http.Handler) http.Handler) http.Handler {
	for i := 0; i < len(middlewares); i++ { // Apply middlewares in normal order
		handler = middlewares[i](handler)
	}
	return handler
}

// Routes function
func Routes(mux *http.ServeMux, views []View) {
	for _, view := range views {
		handlerWithMiddlewares := chainMiddlewares(view.Handler, view.Middlewares)
		mux.HandleFunc(view.Route, func(w http.ResponseWriter, r *http.Request) {
			handlerWithMiddlewares.ServeHTTP(w, r)
		})

	}
}

func GetData(data *map[string]string, w http.ResponseWriter, r *http.Request) (int, string) {
	if err := json.NewDecoder(r.Body).Decode(&data); err != nil {
		if errors.Is(err, io.EOF) {
			return http.StatusBadRequest, "empty request body"
		}
		if _, ok := err.(*json.SyntaxError); ok {
			return http.StatusBadRequest, "invalid json syntax"
		}
		return http.StatusBadRequest, strings.ToLower(err.Error())
	}

	// Check if the decoded data is empty
	if data == nil || len(*data) == 0 {
		return http.StatusBadRequest, strings.ToLower("no data provided")
	}

	return http.StatusOK, ""
}

func SendData(status int, data any, w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(status)
	w.Header().Set("Content-Type", "application/json")

	if err := json.NewEncoder(w).Encode(data); err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
}
