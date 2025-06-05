variable "kube_config" {
    type = string
    default = "hayseed-kubeconfig.yaml"
    description = "Path to Harvester Kube Config File"
}
variable "harvester_img_name" {
    type = string
    default = "ubuntu-encrypted"
    description = "name of the vm base image"
}
variable "harvester_namespace" {
    type = string
    default = "default"
}
variable "img_display_name" {
    type = string
    default = "Ubuntu Server 24.04 Encrypted Image"
}
variable "longhorn-storage-class" {
    type = string
    default = "harvester-encrypted"
    description = "name of the encrypted stroage class in longhorn"
}
variable "base_image_url" {
    type = string
    default = "http://pixie.fun-pumpkins.net/ubuntu-server/24.04_LTS/ubuntu-24.04.1-live-server-amd64.iso"
    description = "location of image to install"
}

