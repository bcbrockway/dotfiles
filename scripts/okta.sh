#! /usr/bin/bash

set -ex

OKTA_ROOT="https://mintel.okta.com"
OKTA_OAUTH_API="${OKTA_ROOT}/oauth2/v1"

CLIENT_ID="0oa621p0zmypdGLUG5d7"
CLIENT_SECRET="oDP9wbXD7xsNeHwUlScsVrGZcSDZk_D295OPFp3B"
B64_AUTH_HEADER=$(echo "${CLIENT_ID}:${CLIENT_SECRET}" | base64 -w0)
REDIRECT_URI="https://cds-fusion.svc.eu-dev1.dev.mintel.cloud/admin"
STATE="${RANDOM}"
NONCE="${RANDOM}"

r=$(curl -s -i --fail-with-body "${OKTA_OAUTH_API}/authorize?client_id=${CLIENT_ID}&response_type=code&scope=openid+groups&redirect_uri=${REDIRECT_URI}&state=${STATE}&nonce=${NONCE}" \
  | grep location \
  | awk '{print $2}')

if echo "$r" | grep error >/dev/null; then
  echo "Error requesting authorization code: $r"
  exit 1
fi

auth_code=$(echo "$r" | grep -oP 'okta_key=\S+' | cut -d'=' -f'2')

curl -s -X POST \
  -H "Content-type:application/x-www-form-urlencoded" \
  -H "Authorization: Basic ${B64_AUTH_HEADER}" \
  "${OKTA_OAUTH_API}/token" \
  -d "grant_type=authorization_code&redirect_uri=${REDIRECT_URI}&code=${auth_code}"
