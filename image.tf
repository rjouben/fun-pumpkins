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