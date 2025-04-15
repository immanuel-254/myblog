package auth

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"time"
)

var (
	client = &http.Client{
		Timeout: 10 * time.Second,
	}
	key = os.Getenv("API_KEY")
	url = os.Getenv("PROJECT_URL")
)

func Post(data map[string]string, route string) map[string]string {
	// Convert struct to JSON
	jsonData, err := json.Marshal(data)
	if err != nil {
		return map[string]string{"error": err.Error()}
	}

	// Create the POST request
	req, err := http.NewRequest(http.MethodPost, fmt.Sprintf("%s/%s", url, route), bytes.NewBuffer(jsonData))
	if err != nil {
		return map[string]string{"error": err.Error()}
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("apikey", key)

	// Send the POST request
	resp, err := client.Do(req)
	if err != nil {
		return map[string]string{"error": err.Error()}
	}
	defer func() {
		if err := resp.Body.Close(); err != nil {
			log.Printf("close response body: %v", err)
		}
	}()

	// Read and display the response
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return map[string]string{"error": err.Error()}
	}

	return map[string]string{"status": fmt.Sprint(resp.StatusCode), "body": string(body)}
}

func Put(data map[string]string, route string) map[string]string {
	// Convert struct to JSON
	jsonData, err := json.Marshal(data)
	if err != nil {
		return map[string]string{"error": err.Error()}
	}

	// Create the POST request
	req, err := http.NewRequest(http.MethodPut, fmt.Sprintf("%s/%s", url, route), bytes.NewBuffer(jsonData))
	if err != nil {
		return map[string]string{"error": err.Error()}
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("apikey", key)

	// Send the POST request
	resp, err := client.Do(req)
	if err != nil {
		return map[string]string{"error": err.Error()}
	}
	defer func() {
		if err := resp.Body.Close(); err != nil {
			log.Printf("close response body: %v", err)
		}
	}()

	// Read and display the response
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return map[string]string{"error": err.Error()}
	}

	return map[string]string{"status": fmt.Sprint(resp.StatusCode), "body": string(body)}
}

func ConvertMap(m map[string]string) map[string]any {
	result := make(map[string]any)
	for key, value := range m {
		result[key] = value
	}
	return result
}

func Signup(email, password, email_redirect_to string) map[string]string {
	data := map[string]string{
		"email":    email,
		"password": password,
		"options":  fmt.Sprintf(`{"email_redirect_to":"%s"}`, email_redirect_to),
	}
	result := Post(data, "/auth/v1/signup")

	return result
}

func ActivateEmail(data map[string]string) map[string]string {
	result := Post(nil, fmt.Sprintf("/auth/v1/verify?token=%s&type=email&redirect_to=http://localhost:3000/success/?", data["token"]))

	return result
}

func Login(email, password string) map[string]string {
	data := map[string]string{
		"email":    email,
		"password": password,
	}
	result := Post(data, "/auth/v1/token?grant_type=password")

	return result
}

func CurrentUser(userToken string) map[string]string {
	// Create the GET request
	req, err := http.NewRequest(http.MethodGet, fmt.Sprintf("%s/%s", url, "/auth/v1/user"), nil)
	if err != nil {
		return map[string]string{"error": err.Error()}
	}

	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("apikey", key)
	req.Header.Set("Authorization", fmt.Sprintf("Bearer: %s", userToken))

	// Send the POST request
	resp, err := client.Do(req)
	if err != nil {
		return map[string]string{"error": err.Error()}
	}
	defer func() {
		if err := resp.Body.Close(); err != nil {
			log.Printf("close response body: %v", err)
		}
	}()

	// Read and display the response
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return map[string]string{"error": err.Error()}
	}

	return map[string]string{"status": fmt.Sprint(resp.StatusCode), "body": string(body)}
}

func ResetPassword(email string) map[string]string {
	data := map[string]string{
		"email": email,
	}
	result := Put(data, "/auth/v1/recover")

	return result
}

func Logout(userToken string) map[string]string {
	// Create the POST request
	req, err := http.NewRequest(http.MethodPost, fmt.Sprintf("%s/%s", url, "/auth/v1/logout"), nil)
	if err != nil {
		return map[string]string{"error": err.Error()}
	}

	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("apikey", key)
	req.Header.Set("Authorization", fmt.Sprintf("Bearer: %s", userToken))

	// Send the POST request
	resp, err := client.Do(req)
	if err != nil {
		return map[string]string{"error": err.Error()}
	}
	defer func() {
		if err := resp.Body.Close(); err != nil {
			log.Printf("close response body: %v", err)
		}
	}()

	return map[string]string{"status": fmt.Sprint(resp.StatusCode)}
}
