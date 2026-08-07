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

consul {
  address = "127.0.0.1:8500"
  auto_advertise = true
  server_auto_join = true
  client_auto_join = true
}
