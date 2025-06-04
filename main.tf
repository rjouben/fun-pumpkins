resource "harvester_image" "Ubuntu-Server-24.04-LTS" {
  name             = "Ubuntu-Server-24.04-LTS"
  namespace        = "harvester-public"

  display_name     = "ubuntu-24.04.1-live-server-amd64"
  source_type      = "download"
  url              = "http://pixie.fun-pumpkins.net/ubuntu-server/24.04_LTS/ubuntu-24.04.1-live-server-amd64.iso" # or local file path
  description      = "A description of the image"
  # ... other image attributes
}