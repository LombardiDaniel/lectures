package common

import (
	"encoding/json"
	"io"
	"net/http"
)

// ReadBody reads the request body into the s struct as JSON
func ReadBody(r *http.Request, s any) error {
	b, err := io.ReadAll(r.Body)
	if err != nil {
		return err
	}

	err = json.Unmarshal(b, s)
	return err
}
