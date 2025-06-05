terraform {
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = ">= 0.3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }
}

provider "harvester" {
  kubeconfig = var.kube_config
}

provider "kubernetes" {
  config_path = var.kube_config
}

# Generate a secure 32-byte encryption key
resource "random_password" "harvester_encryption_key" {
  length  = 256
  special = false
}

locals {
  #encryption_key      = random_password.encryption_key.result
  encryption_key      = "astrobelleblueanddoug"
  encryption_key_b64  = base64encode(local.encryption_key)
  encryption_key_hash = base64encode(sha256(local.encryption_key))
}