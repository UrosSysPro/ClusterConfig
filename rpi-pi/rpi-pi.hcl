datacenter = "bedroom"
data_dir = "/opt/nomad"

# disable plugins
plugin "java" {
  enabled = false
}
plugin "exec" {
  enabled = false
}

client {
  enabled = true

  servers = ["192.168.31.15:4647"]

  meta {
    name = "rpi-pi"
  }
}
