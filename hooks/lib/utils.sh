#!/bin/bash

# ------------------------------------------------------------
# Function that exits due to fatal program error
#   Args:
#     1: <?string> Error message (default: "Unknown error")
#     2: <?number> Location to report (default: $(caller))
#     3: <?number> Error code (e.g. 2) (default: 1)
# ------------------------------------------------------------
function exit_with_error() {
  local location=${2:-$(caller)}
  echo "ERROR (@${location}): ${1:-"Unknown Error"}" 1>&2
  exit "${3:-1}"
}

# ------------------------------------------------------------
# Function that checks for the existence of an variable
# Exits with error if variable is not set
#   Args:
#     1: <string> Variable name
# ------------------------------------------------------------
function ensure_var() {
  local name="$1"
  if [ -z "${!name}" ]; then
    exit_with_error "Missing ""$name"" var" "$(caller)"
  else
    echo "'$name' var exists"
  fi
}

# ------------------------------------------------------------
# Returns repo metadata for the given gitolite repository URI.
#   Args:
#     1: <string> A gitolite repository URI, ex: 'gitolite@code.uber.internal:web-code'
#   Returns:
#     Phab repo metadata, which includes primary and staging uri's
# ------------------------------------------------------------
function get_repo_info() {
  local uri=$1
  curl -s -X POST \
  --data-urlencode "params={\"remoteURIs\":[\"${uri}\"],\"__conduit__\":{\"token\":\"${CONDUIT_TOKEN}\"}}" \
  'https://code.uberinternal.com/api/repository.query'
}

# ------------------------------------------------------------
# Quiet git; commands are silent unless they fail
#   Args:
#     ...: git command arguments
# ------------------------------------------------------------
function gitq() {
  if [ "${VERBOSE:-}" = "true" ]; then
    git "$@"
  else
    local set_flags=$-
    local stdout
    stdout=$(mktemp)
    local stderr
    stderr=$(mktemp)
    local exit_code

    if [[ $set_flags =~ e ]]; then set +e; fi
    git "$@" </dev/null >"$stdout" 2>"$stderr"
    exit_code=$?
    if [[ $set_flags =~ e ]]; then set -e; fi

    if [ $exit_code -ne 0 ]; then
      cat "$stderr" >&2
      rm -f "$stdout" "$stderr"
      exit $exit_code
    fi

    rm -f "$stdout" "$stderr"
  fi
}
