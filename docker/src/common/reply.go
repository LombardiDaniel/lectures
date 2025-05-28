package common

import (
	"encoding/json"
	"fmt"
	"html/template"
	"log/slog"
	"net/http"
	"net/url"
)

// String writes the given string into the response body.
func String(w http.ResponseWriter, code int, s string) {
	setStatus(w, code)

	_, err := fmt.Fprint(w, s)
	if err != nil {
		slog.Error(fmt.Sprintf("Could not write response:%s", err))
		return
	}
	Header(w, "Content-Type", "text/plain; charset=utf-8")
}

// JSON serializes the given struct as JSON into the response body.
// It also sets the Content-Type as "application/json".
func JSON(w http.ResponseWriter, code int, obj any) {
	setStatus(w, code)

	b, err := json.Marshal(obj)
	if err != nil {
		slog.Error(fmt.Sprintf("Could not Marshal obj: %s", err))
		return
	}

	_, err = fmt.Fprint(w, string(b))
	if err != nil {
		slog.Error(fmt.Sprintf("Could not write response: %s", err))
		return
	}

	Header(w, "Content-Type", "application/json; charset=utf-8")
}

func HTML(w http.ResponseWriter, code int, tmpl *template.Template, data any) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	w.WriteHeader(code)
	if err := tmpl.Execute(w, data); err != nil {
		slog.Error(fmt.Sprintf("Could not execute template: %s", err))
	}
}
func Redirect(w http.ResponseWriter, r *http.Request, path string) {
	http.Redirect(w, r, path, http.StatusSeeOther)
}

// Header sets a Header in the response
func Header(w http.ResponseWriter, key string, value string) {
	if value == "" {
		w.Header().Del(key)
		return
	}
	w.Header().Set(key, value)
}

// SetCookie sets a cookie in he browser
func SetCookie(w http.ResponseWriter, name string, value string, maxAge int, path, domain string, secure, httpOnly bool) {
	if path == "" {
		path = "/"
	}
	http.SetCookie(w, &http.Cookie{
		Name:     name,
		Value:    url.QueryEscape(value),
		MaxAge:   maxAge,
		Path:     path,
		Domain:   domain,
		SameSite: http.SameSiteDefaultMode, // TODO: change this, impl via a wrapper struct?
		Secure:   secure,
		HttpOnly: httpOnly,
	})
}

func setStatus(w http.ResponseWriter, status int) {
	w.WriteHeader(status)
}
