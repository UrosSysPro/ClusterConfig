datacenter = "bedroom"
data_dir = "/opt/nomad"

server {
  enabled = true
  bootstrap_expect = 1
}

vault {
  enabled          = true
  address          = "http://192.168.31.192:8200" # Or your internal network IP/Consul service address
  task_token_ttl   = "1h"
  create_from_role = "nomad-cluster"
}
