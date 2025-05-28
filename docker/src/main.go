package main

import (
	"database/sql"
	"errors"
	"html/template"
	"log"
	"net/http"

	"github.com/LombardiDaniel/lectures/docker/src/common"
	_ "github.com/lib/pq"
)

var (
	db  *sql.DB
	mux *http.ServeMux
	t   *template.Template

	err error
)

type IndexHtmlVars struct {
	Users []User
}

type User struct {
	Email string `json:"email"`
}

func getHandler(w http.ResponseWriter, r *http.Request) {
	rows, err := db.Query(`SELECT email FROM users;`)
	if err != nil {
		log.Println(err.Error())
		common.String(w, http.StatusBadGateway, "BadGateway")
		return
	}

	users := []User{}
	for rows.Next() {
		u := User{}
		err := rows.Scan(&u.Email)
		if err != nil {
			log.Println(err.Error())
			common.String(w, http.StatusBadGateway, "BadGateway")
			return
		}
		users = append(users, u)
	}

	common.HTML(w, http.StatusOK, t, IndexHtmlVars{Users: users})
}

func putHandler(w http.ResponseWriter, r *http.Request) {
	var u User
	err := common.ReadBody(r, &u)
	if err != nil {
		log.Println(err.Error())
		common.String(w, http.StatusBadRequest, "BadRequest")
		return
	}
	_, err = db.Exec(`INSERT INTO users (email) VALUES ($1);`, u.Email)
	if err != nil {
		log.Println(err.Error())
		common.String(w, http.StatusBadRequest, "BadRequest")
		return
	}

	common.String(w, http.StatusOK, "OK")
}

func init() {
	pgConnStr := common.GetEnvVarDefault("POSTGRES_URI", "postgres://user:password@localhost:5432/db?sslmode=disable")
	db, err = sql.Open("postgres", pgConnStr)
	if err != nil {
		panic(errors.Join(err, errors.New("could not connect to pgsql")))
	}
	if err := db.Ping(); err != nil {
		panic(errors.Join(err, errors.New("could not ping pgsql")))
	}

	db.Exec(`
		CREATE TABLE users (
    		email VARCHAR(100) PRIMARY KEY
		);`)

	t = template.Must(template.ParseFiles("./index.templ"))

	mux = http.NewServeMux()
	mux.HandleFunc("GET /", getHandler)
	mux.HandleFunc("PUT /users", putHandler)
}

func main() {
	log.Println("Server starting on :8080")
	if err := http.ListenAndServe(":8080", mux); err != nil {
		log.Fatalf("Error starting server: %s", err.Error())
	}
}
