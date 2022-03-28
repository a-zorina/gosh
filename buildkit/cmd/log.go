package cmd

import (
	"fmt"
	"net/http"
	"net/url"
	"os"
	"strings"
)

var WebLogEnabled bool = false

func initWebLog() {
	v := strings.ToLower(strings.TrimSpace(os.Getenv("WEBLOG")))
	if v != "" && v != "0" && v != "no" && v != "false" {
		WebLogEnabled = true
	}
}

func p(msg string) string {
	if WebLogEnabled {
		http.Get("http://localhost:8888/?" + url.Values{"log": {msg}}.Encode())
	}
	return msg
}

func logf(format string, a ...interface{}) string {
	return p(fmt.Sprintf(format, a...))
}
