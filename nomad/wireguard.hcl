job "wireguard-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "wireguard-group"{
    count = 1

    constraint {
      attribute = "${meta.name}"
      value     = "rpi-pi"
    }

    volume "wireguard-etc"{
      type = "host"
      read_only = false
      source = "wireguard-etc"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    network {
      port "vpn"{
        static = 51820
      }
      port "dashboard"{
        static = 51821
      }
    }

    task "wireguard-container"{
      driver = "docker"

      volume_mount {
        volume      = "wireguard-etc"
        destination = "/etc/wireguard"
        read_only   = true
      }

      resources {
        cpu    = 100
        memory = 128
      }

      config{
        image = "ghcr.io/wg-easy/wg-easy:15"

        ports = ["vpn", "dashboard"]

        cap_add = [
          "NET_ADMIN",
          "SYS_MODULE",
        ]

        volumes = [
          "/lib/modules:/lib/modules:ro",
        ]

        sysctl = {
          "net.ipv4.ip_forward"                 = "1"
          "net.ipv4.conf.all.src_valid_mark"    = "1"
          "net.ipv6.conf.all.disable_ipv6"      = "0"
          "net.ipv6.conf.all.forwarding"        = "1"
          "net.ipv6.conf.default.forwarding"    = "1"
        }
      }
    }
  }
}
