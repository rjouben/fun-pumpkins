terraform {
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = ">=0.3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.0"
    }
  }
}

provider "harvester" {
  kubeconfig = "hayseed-kubeconfig.yaml"
}

provider "kubernetes" {
  config_path = "hayseed-kubeconfig.yaml"
}

# Kubernetes Secret for volume encryption
resource "kubernetes_secret" "encryption_key" {
  metadata {
    name      = "harvester-encryption-key"
    namespace = "default"
  }

  data = {
    CRYPTO_KEY_CIPHER    = base64encode("aes-xts-plain64")
    CRYPTO_KEY_HASH      = base64encode("sha256")
    CRYPTO_KEY_PROVIDER  = base64encode("kubernetes_secret")
    CRYPTO_KEY_SIZE      = base64encode("256")
    CRYPTO_KEY_VALUE     = base64encode("astrobelleblueanddoug")
    CRYPTO_PBKDF         = base64encode("argon2i")
  }

  type = "Opaque"
}

# Encrypted Longhorn StorageClass
resource "kubernetes_storage_class" "encrypted_storage" {
  metadata {
    name = "harvester-encrypted"
  }

  storage_provisioner = "driver.longhorn.io"
  parameters = {
    "csi.storage.k8s.io/provisioner-secret-name"       = "harvester-encryption-key"
    "csi.storage.k8s.io/provisioner-secret-namespace"  = "default"
    "csi.storage.k8s.io/node-stage-secret-name"        = "harvester-encryption-key"
    "csi.storage.k8s.io/node-stage-secret-namespace"   = "default"
    "csi.storage.k8s.io/node-publish-secret-name"      = "harvester-encryption-key"
    "csi.storage.k8s.io/node-publish-secret-namespace" = "default"
    encrypted                     = "true"
    migratable                    = "true"
    numberOfReplicas              = "3"
    staleReplicaTimeout           = "300"
  }

  allow_volume_expansion = true
  reclaim_policy         = "Delete"
  volume_binding_mode    = "Immediate"
}

# Harvester VirtualMachineImage for Ubuntu 24.04 using encryption
resource "harvester_image" "encrypted_image" {
  name               = "ubuntu-server-encrypted"
  namespace          = "default"
  source_type        = "download"
  url                = "http://pixie.fun-pumpkins.net/ubuntu-server/24.04_LTS/ubuntu-24.04.1-live-server-amd64.iso"
  #storage_class_name = "volume-encryption"
  display_name       = "Ubuntu Server 24.04 Encrypted Image"
  storage_class_name = kubernetes_storage_class.encrypted_storage.metadata[0].name
}   