package cmd

import (
	"testing"
)

func TestParser(t *testing.T) {
	config, err := parseConfig([]byte(`
apiVersion: 1
<<<<<<< HEAD
image: bash:latest
steps:
  - name: print date
    run:
=======
steps:
  - name: print date
    run:
      image: bash:latest
>>>>>>> main
      command: ["/url/local/bin/bash"]
      args:
      - -c
      - >-
          (date +'%s %H:%M:%S %Z'; echo "Hi there") | tee /message.txt
    `))

	if err != nil {
		t.Errorf("%v", err)
	}

	if len(config.Steps) < 1 {
		t.Errorf("Wrong number of steps")
	}

	if config.Image != "bash:latest" {
		t.Errorf("Wrong image")
	}

	step := config.Steps[0]

	if step.Run.Command == nil {
		t.Errorf("Wrong command")
	}

	if step.Name != "print date" {
		t.Errorf("Wrong step name: %s", config.Steps[0].Name)
	}

	if step.Copy != nil {
		t.Errorf("Wrong run and copy conflict")
	}

	if config.ApiVersion != "1" {
		t.Errorf("Expected API version")
	}
}
