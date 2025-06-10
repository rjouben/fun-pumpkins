resource "harvester_storageclass" "encrypted_storage_class" {
  name = "longhorn-${var.harvester_image_name}-encrypted"

  volume_provisioner = "driver.longhorn.io"
  parameters = {
    "encrypted"                     = "true"
    "migratable"                    = "true"
    "numberOfReplicas"              = "1"
    "staleReplicaTimeout"           = "30"
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