resource "harvester_image" "ubuntu-encrypted" {
  name               = var.harvester_image_name
  namespace          = var.harvester_namespace

  storage_class_name = var.longhorn_storage_class

  source_type        = "download"
  url                = var.base_image_url
  display_name       = var.img_display_name
  #storage_class_name = kubernetes_storage_class.encrypted_storage.metadata[0].name

  depends_on = [ kubernetes_secret.encryption_key, kubernetes_storageclass.ubuntu-encrypted ]
}   