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

plugin "docker" {
  config {
    allow_caps = [
      "audit_write", "chown", "dac_override", "fowner", "fsetid",
      "kill", "mknod", "net_bind_service", "setfcap", "setgid",
      "setpcap", "setuid", "sys_chroot",
      "net_admin", "sys_module"
    ]

    allow_privileged = true
  }
}
