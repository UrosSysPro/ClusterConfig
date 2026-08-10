datacenter = "bedroom"
data_dir = "/opt/nomad"

server {
  enabled = true
  bootstrap_expect = 1
}

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
