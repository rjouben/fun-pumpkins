#!/usr/bin/env python3

import json
import requests
import urllib3

# Disable SSL warnings (not for production use)
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Load tfvars JSON (standard JSON, no special parser needed)
def load_tfvars(filepath="terraform.tfvars.json"):
    with open(filepath, "r") as f:
        return json.load(f)

# Load config
config = load_tfvars()

# Assign variables
RANCHER_URL = config["rancher_url"]
HARVESTER_URL = config["harvester_url"]
USERNAME    = config["username"]
PASSWORD    = config["password"]
IMAGE_URL   = config["base_image_url"]
IMAGE_NAME  = config["harvester_image_name"]
IMAGE_NAMESPACE = config["harvester_namespace"]

# Step 1: Authenticate to get Bearer token
def get_bearer_token():
    login_url = f"{HARVESTER_URL}/v3-public/localProviders/local?action=login"
    headers = {"Content-Type": "application/json"}
    payload = {"username": USERNAME, "password": PASSWORD}

    response = requests.post(login_url, headers=headers, json=payload, verify=False)
    response.raise_for_status()
    return response.json()["token"]

# Step 2: Upload the image to Harvester
def upload_image(token):
    upload_url = f"{HARVESTER_URL}/v1/harvesterhci.io.virtualmachineimages"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    data = {
        "apiVersion": "harvesterhci.io/v1beta1",
        "kind": "VirtualMachineImage",
        "metadata": {
            "name": f"{IMAGE_NAME}-encrypted",
            "annotations": {
                "harvesterhci.io/storageClassName": f"longhorn-{IMAGE_NAME}-encrypted"
            },
            "namespace": IMAGE_NAMESPACE
        },
        "spec": {
            "displayName": f"{IMAGE_NAME}-zencrypted",
            "securityParameters": {
                "cryptoOperation": "encrypt",
                "sourceImageName": "ubuntu-24",
                "sourceImageNamespace": IMAGE_NAMESPACE
             },
            "sourceType": "clone"
        }
    }

    response = requests.post(upload_url, headers=headers, json=data, verify=False)
    if response.status_code == 201:
        print(f"✅ Image '{IMAGE_NAME}' uploaded successfully.")
    else:
        print(f"❌ Failed to upload image: {response.status_code} {response.text}")

# MAIN
if __name__ == "__main__":
    try:
        token = get_bearer_token()
        upload_image(token)
    except requests.RequestException as e:
        print(f"❌ Error: {e}")