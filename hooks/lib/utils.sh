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
# Returns repo metadata for the given phab URI.
# Arguments:
#   A phab uri | ex: 'gitolite@code.uber.internal:web-code'
# Returns:
#   Phab repo metadata, which includes primary and staging uri's
# ------------------------------------------------------------
function get_repo_info() {
  local uri=$1 # example: 'gitolite@code.uber.internal:web-code'
  curl -s -X POST \
  --data-urlencode "params={\"remoteURIs\":[\"${uri}\"],\"__conduit__\":{\"token\":\"${CONDUIT_TOKEN}\"}}" \
  'https://code.uberinternal.com/api/repository.query'
}
