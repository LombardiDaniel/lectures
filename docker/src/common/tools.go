package common

import "os"

// GetEnvVarDefault retrieves the value of the specified environment variable.
// Returns a default value if the variable is not set.
func GetEnvVarDefault(name string, def string) string {
	envVar, ok := os.LookupEnv(name)
	if !ok {
		return def
	}

	return envVar
}
