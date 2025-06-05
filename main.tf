GNU nano 7.2                                                            main.tf                                                                     terraform {
  required_version = ">= 0.13"
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = "0.6.4"
    }
  }
}

provider "harvester" {
  # Path to kubeconfig file
  kubeconfig = "hayseed-kubeconfig.yaml"

  # Alternatively the base64 encoded contents of the kubeconfig file.
  # CAUTION: When supplying the kubeconfig as base64 encoded string, the
  # content will be preserved in the Terraform state files in the clear.
  # Take appropriate measures to avoid leaking sensitive information.
  #
  # kubeconfig = "YXBpVmVyc2lvb...xvY2FsIgo="

#  kubecontext = "mycontext"
}

resource "harvester_image" "Ubuntu-Server-24_04-LTS" {
  name             = "ubuntu-server-24-04-lts"
  namespace        = "harvester-public"

  display_name     = "Ubuntu Server 24.04.1 live-server amd64"
  source_type      = "download"
  url              = "http://pixie.fun-pumpkins.net/ubuntu-server/24.04_LTS/ubuntu-24.04.1-live-server-amd64.iso"
  description      = "A description of the image"
  # ... other image attributes
}
