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