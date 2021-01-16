#!/bin/bash
#
# A collection of utilities used by hooks/

####################
# Returns the staging uri for a given phab callsign.
# Arguments:
#   A phab callsign | ex: 'WEBCODR'
# Returns:
#   A staging uri, or empty string if none exists | ex: 'gitolite@code.uber.internal:web-code'
####################
get_staging_uri() {
  local callsign=$1
  curl -s -X POST \
  --data-urlencode "params={\"callsigns\":[\"${callsign}\"],\"__conduit__\":{\"token\":\"${CONDUIT_TOKEN}\"}}" \
  'https://code.uberinternal.com/api/repository.query' | jq -r '.result[0].staging.uri // empty'
}
