package main

import (
	"fmt"
	"os"
	"os/exec"

	"gopkg.in/alecthomas/kingpin.v2"
)

type Repo struct {
	base string // ex: gitolite@code.uberinternal.com
	name string // ex: infra/buildkite-webhook-proxy
}

var (
	branch         = kingpin.Flag("branch", "Buildkite branch").Envar("BUILDKITE_BRANCH").Required().String()
	commit         = kingpin.Flag("commit", "Buildkite Commit").Envar("BUILDKITE_COMMIT").Required().String()
	buildInitiator = kingpin.Flag("buildInitiator", "DIFF, MAIN, SUBMIT_QUEUE").Envar("BUILD_INITIATOR").Default("MAIN").String()
	diffIds        = kingpin.Flag("diffIds", "Diff Ids").Envar("DIFF_IDS").String()
	repo           = kingpin.Flag("repo", "Main Gitolite Repo").Envar("BUILDKITE_REPO").Required().String()
	stagingRepo    = kingpin.Flag("stagingRepo", "Staging Gitolite Repo").Required().String()
	pipeline       = kingpin.Flag("pipeline", "Buildkite pipeline").Envar("BUILDKITE_PIPELINE").Required().String()
)

func main() {
	kingpin.Parse()
	fmt.Printf("%s, %s, %s, %s, %s, %s, %s", *branch, *commit, *buildInitiator, *diffIds, *repo, *stagingRepo, *pipeline)
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
