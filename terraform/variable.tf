variable "kube_config" {
    type = string
    default = "~/.kube/config.yaml"
    description = "Path to Harvester Kube Config File"
}
variable "harvester_image_name" {
    type = string
    default = "ubuntu"
}
variable "harvester_namespace" {
    type = string
    default = "default"
}
variable "img_display_name" {
    type = string
    default = "Ubuntu Server 24.04"
}
variable "longhorn_storage_class" {
    type = string
    default = "harvester-longhorn"
}
variable "base_image_url" {
    type = string
    default = "https://releases.ubuntu.com/noble/ubuntu-24.04.2-live-server-amd64.iso"
}
variable "harvester_url" {
    type = string
    default = "https://harvester.local"
}
variable "rancher_url" {
    type = string
    default = "https://rancher.local"  
}
variable "username" {
    type = string
    default = "admin"
}  
variable "password" {
    type = string
    default = "password"
    description = "Harvester administrator password"
}