package cmd

import (
	"fmt"
)

func p(msg string) string {
	// TODO: mount log file via llb.Local
	return msg
}

func logf(format string, a ...interface{}) string {
	return p(fmt.Sprintf(format, a...))
}
