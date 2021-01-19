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

####################
# Returns the staging uri for a given phab callsign.
# Arguments:
#   A phab callsign | ex: 'WEBCODR'
# Returns:
#   Phab repo metadata, which includes primary and staging uri's
####################
get_repo_info() {
  local callsign=$1
  curl -s -X POST \
  --data-urlencode "params={\"callsigns\":[\"${callsign}\"],\"__conduit__\":{\"token\":\"${CONDUIT_TOKEN}\"}}" \
  'https://code.uberinternal.com/api/repository.query'
}

# removes everything in the current working directory
clean_workspace() {
  find . -maxdepth 1 -mindepth 1 -print0 | xargs -0 -I {} rm -rf {}
}
