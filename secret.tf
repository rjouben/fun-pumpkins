resource "kubernetes_secret" "encryption_secret" {
  metadata {
    name      = "encryption-secret"
    namespace = "default"
  }

  data = {
    CRYPTO_KEY_CIPHER = "aes-xts-plain64"
    CRYPTO_KEY_HASH = "sha256"
    CRYPTO_KEY_PROVIDER = "secret"
    CRYPTO_KEY_SIZE = "256"
    CRYPTO_KEY_VALUE = local.encryption_key
    CRYPTO_PBKDF = "argon2i"
  }

  type = "secret"
}