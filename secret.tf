resource "kubernetes_secret" "encryption_key" {
  metadata {
    name      = "harvester-encryption-key"
    namespace = "default"
  }

  data = {
    CRYPTO_KEY_VALUE = local.encryption_key_b64
    CRYPTO_KEY_HASH = local.encryption_key_hash
    CRYPTO_KEY_CIPHER = "aes-xts-plain64"
    CRYPTO_KEY_PROVIDER = "secret"
    CRYPTO_KEY_SIZE = "256"
    CRYPTO_PBKDF = "argon2i"
  }

  type = "secret"
}