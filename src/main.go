package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"

	"github.com/uber-workflow/checkout/utils"
)

func main() {
	// test: execute a shell binary
	bkLogGroup("running ls -al")
	run("ls", "-al")

	// test: call git
	bkLogGroup("testing git commands")
	_, err1 := run("git", "--version")
	if err1 != nil {
		logAndExit(err1, 1)
	}

	// test: call aws
	bkLogGroup("testing aws")
	_, err2 := run("aws", "--version")
	if err2 != nil {
		logAndExit(err2, 1)
	}

	// test: log out all env variables
	bkLogGroup("testing env variables")
	for _, e := range os.Environ() {
		pair := strings.SplitN(e, "=", 2)
		fmt.Println(pair[0])
	}

	// test: call function from another package in module
	bkLogGroup("testing function call Foo() from utils.go")
	fmt.Println(utils.Foo())

	// test: call function from remote package
	bkLogGroup("testing function call Hello() from utils.go")
	fmt.Println(utils.Hello())

}

func logAndExit(err error, code int) {
	fmt.Println(err.Error())
	os.Exit(code)
}

func bkLogGroup(str string) {
	fmt.Printf("~~~ %s\n", str)
}

func run(name string, args ...string) (string, error) {
	cmd := exec.Command(name, args...)
	stdoutStderr, err := cmd.CombinedOutput()
	fmt.Println(string(stdoutStderr))
	if err != nil {
		return "", err
	}
	return string(stdoutStderr), nil
}
