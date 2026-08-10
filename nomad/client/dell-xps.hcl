datacenter = "bedroom"
data_dir = "/opt/nomad"

client {
  enabled = true

  meta {
    name = "dell-xps"
  }
}

consul {
  address = "127.0.0.1:8500"
  auto_advertise = true
  server_auto_join = true
  client_auto_join = true
}
