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

# Generate a random 256-byte encryption key
resource "random_password" "encryption_key" {
  length  = 256
  special = false
}

locals {
  encryption_key = random_password.encryption_key.result
}

# Create the encryption secret
resource "kubernetes_secret" "encryption_secret" {
  metadata {
    name      = "encryption-secret"
    namespace = "default"
  }

  data = {
    CRYPTO_KEY_CIPHER = "aes-xts-plain64"
    CRYPTO_KEY_HASH = "sha256"
    CRYPTO_KEY_PROVIDER = "secret"
    CRYPTO_KEY_SIZE = "256"
    CRYPTO_KEY_VALUE = local.encryption_key
    CRYPTO_PBKDF = "argon2i"
  }

  type = "secret"
}

# Create the encypted storage class
resource "harvester_storageclass" "encrypted_storage_class" {
  name = "${var.harvester_image_name}-encrypted"
#  name = "longhorn-${var.harvester_image_name}-encrypted"

  volume_provisioner = "driver.longhorn.io"
  parameters = {
    "encrypted"           = "true"
    "migratable"          = "true"
    "numberOfReplicas"    = "1"
    "staleReplicaTimeout" = "30"
    "csi.storage.k8s.io/provisioner-secret-name"       = "encryption-secret"
    "csi.storage.k8s.io/provisioner-secret-namespace"  = "default"
    "csi.storage.k8s.io/node-stage-secret-name"        = "encryption-secret"
    "csi.storage.k8s.io/node-stage-secret-namespace"   = "default"
    "csi.storage.k8s.io/node-publish-secret-name"      = "encryption-secret"
    "csi.storage.k8s.io/node-publish-secret-namespace" = "default"
  }

  allow_volume_expansion = true
  reclaim_policy         = "Delete"
  volume_binding_mode    = "Immediate"

  depends_on = [ kubernetes_secret.encryption_secret ]
}

# Upload the desired image to Harvester
resource "harvester_image" "server_image" {
  name               = var.harvester_image_name
  namespace          = var.harvester_namespace

  storage_class_name = var.longhorn_storage_class

  source_type        = "download"
  url                = var.base_image_url
  display_name       = var.harvester_image_name

# tags               = { "os-type" = "Ubuntu", "image-type" = "ISO"}
}

# Encrypt the uploaded image using a python scripted API call
resource "null_resource" "encrypt_image" {
  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = "python3 encrypt_image.py"
  }

  depends_on = [ harvester_image.server_image ]
}