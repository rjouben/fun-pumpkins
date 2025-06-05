resource "harvester_image" "encrypted_image" {
  name               = "ubuntu-server-encrypted"
  namespace          = "default"
  source_type        = "download"
  url                = "http://pixie.fun-pumpkins.net/ubuntu-server/24.04_LTS/ubuntu-24.04.1-live-server-amd64.iso"
  #storage_class_name = "volume-encryption"
  display_name       = "Ubuntu Server 24.04 Encrypted Image"
  storage_class_name = kubernetes_storage_class.encrypted_storage.metadata[0].name
}   