resource "kubernetes_storageclass" "ubuntu-encrypted" {
  metadata {
    name = "longhorn-${var.harvester_image_name}"
  }

  volume_provisioner = "driver.longhorn.io"
  parameters = {
    "backingImage" = "${var.harvester_namespace}-${var.harvester_image_name}"
    encrypted                     = "true"
    migratable                    = "true"
    numberOfReplicas              = "3"
    staleReplicaTimeout           = "30"
    "csi.storage.k8s.io/provisioner-secret-name"       = "harvester-encryption-key"
    "csi.storage.k8s.io/provisioner-secret-namespace"  = "default"
    "csi.storage.k8s.io/node-stage-secret-name"        = "harvester-encryption-key"
    "csi.storage.k8s.io/node-stage-secret-namespace"   = "default"
    "csi.storage.k8s.io/node-publish-secret-name"      = "harvester-encryption-key"
    "csi.storage.k8s.io/node-publish-secret-namespace" = "default"
  }

  allow_volume_expansion = true
  reclaim_policy         = "Delete"
  volume_binding_mode    = "Immediate"

  depends_on = [ kubernetes_secret.encryption_key ]
}