#!/bin/bash
# shellcheck disable=SC2155,SC2206,SC2124

set -euo pipefail

readonly dir="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
. "$dir"/utils.sh

# pure-git `arc patch` :)
function arc_patch() {
  local diff_id="$1"
  local orig_head_sha="$(git rev-parse HEAD)"
  local diff_head_sha
  local squashed_diff_commit_sha

  echo "Applying diff: $diff_id"
  # fetch diff head
  git fetch --no-tags --tag staging "phabricator/diff/$diff_id"
  diff_head_sha="$(git rev-parse FETCH_HEAD)"

  # checkout diff base
  git fetch --no-tags --tag staging "phabricator/base/$diff_id"
  git checkout "$(git rev-parse FETCH_HEAD)"

  # squash diff head onto diff base
  git merge "$diff_head_sha" --squash
  git add .
  git commit -m "Apply diff $diff_id"
  squashed_diff_commit_sha="$(git rev-parse HEAD)"

  # cherry pick squashed diff commit onto original head
  git checkout "$orig_head_sha"
  git cherry-pick "$squashed_diff_commit_sha"
}

function apply_diffs() {
  local diff_ids_arr=($1)
  # all except the last item
  local base_diff_ids="${diff_ids_arr[@]:0:${#diff_ids_arr[@]} - 1}"
  # last item in list
  local test_diff_id="${diff_ids_arr[${#diff_ids_arr[@]} - 1]}"
  local head_sha="$(git rev-parse HEAD)"

  # git fails to make commits without user info
  if [ -z "$(git config --get user.email)" ]; then
    git config user.email "buildkite-agent@uber.com"
    git config user.name "Buildkite Agent"
  fi

  if [ -n "$base_diff_ids" ]; then
    for diff_id in $base_diff_ids; do
      arc_patch "$diff_id"
    done

    git reset --soft "$head_sha"
    git commit -m "Apply base diffs: $base_diff_ids"
    head_sha="$(git rev-parse HEAD)"
  fi

  # we put the test diff ID (diff directly tied to this queue item) in
  # its own separate commit so that we can trigger CI tests for only
  # its changes. see this doc for more info:
  # https://docs.google.com/document/d/16ZOUTh1JlcUO4xMsUs6R6f2oQyNmWPOHNaxe_ekDErM
  arc_patch "$test_diff_id"
  git reset --soft "$head_sha"
  git commit -m "Apply test diff: $test_diff_id"
}

apply_diffs "${@}"
