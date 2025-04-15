package view

import (
	"context"
	"encoding/json"
	"fmt"
	"myblog/auth"
	"myblog/ui"
	"net/http"
	"os"
	"strconv"
)

var (
	SignUpWebView = View{
		Route:   "/signup",
		Handler: http.HandlerFunc(SignupView),
	}
	ActivateEmailWebView = View{
		Route:   "/activate/",
		Handler: http.HandlerFunc(ActivateEmailView),
	}
)

func SignupView(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodPost {
		email := r.FormValue("email")
		password := r.FormValue("password")
		confirmpassword := r.FormValue("confirm-password")
		alert := make(map[string]string)

		if password != confirmpassword {
			alert["password"] = "password mismatch"
			component := ui.Base("immanu3l", ui.Signup(alert))
			component.Render(context.Background(), w)
			return
		}

		url := os.Getenv("DOMAIN")

		signup := auth.Signup(email, password, url)
		if signup["error"] != "" {
			w.WriteHeader(http.StatusBadRequest)
			return
		}
		sign := auth.ConvertMap(signup)
		jsonData, err := json.Marshal(sign)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		signupresponse := auth.SignupResponse{}
		err = json.Unmarshal(jsonData, &signupresponse)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		component := ui.Base("immanu3l", ui.ActivateEmailSent())
		component.Render(context.Background(), w)
		return
	}

	component := ui.Base("immanu3l", ui.Signup(nil))
	component.Render(context.Background(), w)
}

func ActivateEmailView(w http.ResponseWriter, r *http.Request) {
	queryParams := r.URL.Query()
	token := queryParams.Get("token")
	if token == "" {
		fmt.Println("no token")
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	// url := os.Getenv("DOMAIN")
	/*user := auth.CurrentUser(token)
	if user["email"] == "" {
		w.WriteHeader(http.StatusBadRequest)
		return
	}*/

	if r.Method == http.MethodGet {
		data := make(map[string]string)
		data = map[string]string{
			"token": token,
		}

		req := auth.ActivateEmail(data)
		status, err := strconv.Atoi(req["status"])
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		if status != http.StatusOK {
			fmt.Println("no token status")
			fmt.Println(status)
			w.WriteHeader(status)
			return
		}

		// html page; email has been activated
		component := ui.Base("immanu3l", ui.SuccessActivateEmail())
		component.Render(context.Background(), w)
		return
	}

}

func LoginView(w http.ResponseWriter, r *http.Request) {
	session, err := store.Get(r, "auth")
	if err != nil {
		SendData(http.StatusInternalServerError, map[string]string{"error": err.Error()}, w, r)
		return
	}

	_, ok := session.Values["auth"].(auth.TokenResponse)
	if ok {
		SendData(http.StatusSeeOther, nil, w, r)
		return
	}

	if r.Method == http.MethodPost {
		data := make(map[string]string)
		code, errstring := GetData(&data, w, r) // get data
		if code != http.StatusOK {
			SendData(code, map[string]string{"error": errstring}, w, r)
			return
		}

		login := auth.Login(data["email"], data["password"])
		if login["error"] != "" {
			SendData(http.StatusBadRequest, map[string]string{"error": login["error"]}, w, r)
			return
		}
		loginany := auth.ConvertMap(login)
		jsonData, err := json.Marshal(loginany)
		if err != nil {
			SendData(http.StatusInternalServerError, map[string]string{"error": err.Error()}, w, r)
			return
		}
		loginresponse := auth.TokenResponse{}
		err = json.Unmarshal(jsonData, &loginresponse)
		if err != nil {
			SendData(http.StatusInternalServerError, map[string]string{"error": errstring}, w, r)
			return
		}

		session.Values["auth"] = loginresponse
		err = session.Save(r, w) // Save the session
		if err != nil {
			SendData(http.StatusInternalServerError, map[string]string{"error": err.Error()}, w, r)
			return
		}

		SendData(http.StatusOK, nil, w, r)
	}

}

func LogoutView(w http.ResponseWriter, r *http.Request) {
	session, err := store.Get(r, "auth")
	if err != nil {
		SendData(http.StatusInternalServerError, map[string]string{"error": err.Error()}, w, r)
		return
	}

	tokenresponse, ok := session.Values["auth"].(auth.TokenResponse)
	if !ok {
		SendData(http.StatusSeeOther, nil, w, r)
		return
	}

	if r.Method == http.MethodPost {
		logoutresponse := auth.Logout(tokenresponse.AccessToken)
		if logoutresponse["status"] == "" {
			SendData(http.StatusInternalServerError, map[string]string{"error": "logout request did not go through"}, w, r)
			return
		}
		status, err := strconv.Atoi(logoutresponse["status"])
		if err != nil {
			SendData(http.StatusInternalServerError, map[string]string{"error": err.Error()}, w, r)
			return
		}
		if status != http.StatusOK {
			SendData(http.StatusInternalServerError, map[string]string{"error": "failed to logout"}, w, r)
			return
		}

		session.Values["auth"] = nil
		err = session.Save(r, w)
		if err != nil {
			SendData(http.StatusInternalServerError, map[string]string{"error": err.Error()}, w, r)
			return
		}
	}

}

func ResetPassword(w http.ResponseWriter, r *http.Request) {

}
