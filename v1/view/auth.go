package view

import (
	"encoding/json"
	"myblog/auth"
	"net/http"
)

func SignupView(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodPost {
		data := make(map[string]string)
		code, errstring := GetData(&data, w, r) // get data
		if code != http.StatusOK {
			SendData(code, map[string]string{"error": errstring}, w, r)
			return
		}

		if _, ok := data["email"]; !ok {
			SendData(code, map[string]string{"error": "email not provided"}, w, r)
			return
		}

		if _, ok := data["password"]; !ok {
			SendData(http.StatusBadRequest, map[string]string{"error": "passwords not provided"}, w, r)
			return
		}

		if _, ok := data["confirm_password"]; !ok {
			SendData(http.StatusBadRequest, map[string]string{"error": "passwords not provided"}, w, r)
			return
		}

		if data["password"] != data["confirm_password"] {
			SendData(http.StatusBadRequest, map[string]string{"error": "passwords mismatch"}, w, r)
			return
		}

		signup := auth.Signup(data["email"], data["password"])
		if signup["error"] != "" {
			SendData(http.StatusBadRequest, map[string]string{"error": signup["error"]}, w, r)
			return
		}
		sign := auth.ConvertMap(signup)
		jsonData, err := json.Marshal(sign)
		if err != nil {
			SendData(http.StatusInternalServerError, map[string]string{"error": err.Error()}, w, r)
			return
		}
		signupresponse := auth.SignupResponse{}
		err = json.Unmarshal(jsonData, &signupresponse)
		if err != nil {
			SendData(http.StatusInternalServerError, map[string]string{"error": errstring}, w, r)
			return
		}

		SendData(http.StatusOK, nil, w, r)

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

}

func ResetPassword(w http.ResponseWriter, r *http.Request) {

}
