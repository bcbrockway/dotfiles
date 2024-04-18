import requests
import re
import secrets
from urllib.parse import urlparse, parse_qs

OKTA_ROOT = "https://mintel.okta.com"

OKTA_OAUTH_API = OKTA_ROOT + "/oauth2/v1"
REDIRECT_URI = "https://cds-fusion.svc.eu-dev1.dev.mintel.cloud/admin"
CLIENT_ID = "0oa621p0zmypdGLUG5d7"
CLIENT_SECRET = "oDP9wbXD7xsNeHwUlScsVrGZcSDZk_D295OPFp3B"
STATE = secrets.token_urlsafe()
NONCE = secrets.token_urlsafe()

payload = {
  "client_id": CLIENT_ID,
  "response_type": "code",
  "scope": "openid groups",
  "redirect_uri": REDIRECT_URI,
  "state": STATE,
  "nonce": NONCE,
}
r = requests.get(OKTA_OAUTH_API + "/authorize", params=payload)
url = r.url
r = requests.get(url)

match = re.search(r'okta_key=([^&]+)', r.url)
if match:
  auth_code = match.group(1)
else:
  print('ERROR: r.url')
  exit(1)


session = requests.Session()
session.auth = (CLIENT_ID, CLIENT_SECRET)
session.headers.update({"content-type": "application/x-www-form-urlencoded"})
payload = {
  "grant_type": "authorization_code",
  "redirect_uri": REDIRECT_URI,
  "code": auth_code
}
r = session.post(OKTA_OAUTH_API + '/token', params=payload)
print()
