storage "file" {
    path = "/opt/vault/data"
}

listener "tcp" {
    address     = "0.0.0.0:8200"
    tls_disable = "true"
}

ui = true

api_addr = "http://0.0.0.0:8200"
cluster_addr = "http://0.0.0.0:8201"

# AmbientCapabilities=CAP_IPC_LOCK
# LimitMEMLOCK=infinity

disable_mlock = true

audit_device "file" {
    path   = "/var/log/vault-audit.log"
    format = "json"
}

log_file = "/var/log/vault.log"
log_level = "info"
