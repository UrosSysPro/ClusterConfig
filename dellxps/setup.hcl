datacenter = "bedroom"
data_dir = "/opt/nomad"

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
  host_volume "jellyfin" {
    path      = "/mnt/containers/jellyfin"
    read_only = false
  }
}
