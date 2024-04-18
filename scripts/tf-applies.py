import os
import requests

API_ROOT = "https://app.terraform.io/api/v2"
ORGANIZATION_NAME = "Mintel"
TF_API_KEY = os.environ.get("TF_API_KEY")

s = requests.Session()
s.headers.update({"Authorization": "Bearer " + TF_API_KEY})
s.headers.update({"Content-Type": "application/vnd.api+json"})


workspaces = s.get(API_ROOT + f"/organizations/{ORGANIZATION_NAME}/workspaces").json()

for workspace in workspaces["data"]:
    workspace_id = workspace["id"]
    workspace_name = workspace["attributes"]["name"]
    workspace_state = workspace["attributes"]["state"]
