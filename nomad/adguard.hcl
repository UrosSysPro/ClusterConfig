job "adguard-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "adguard-group"{
    count = 1

    volume "adguard-conf"{
      type = "host"
      read_only = false
      source = "adguard-conf"
    }

    volume "adguard-work"{
      type = "host"
      read_only = false
      source = "adguard-work"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    network {
      port "dns"{
        to = 53
        static = 53
      }
      port "http"{
        to = 80
        static = 8082
      }
      port "https"{
        to = 443
        static = 8443
      }
      port "dashboard"{
        to = 3000
      }
      port "dot"{
        to = 853
        static = 853
      }
      port "dtls"{
        to = 784
        static = 784
      }
      port "doq"{
        to = 8853
        static = 8853
      }
      port "tcp"{
        to = 5443
        static = 5443
      }
    }

    task "adguard-container"{
      driver = "docker"

      volume_mount {
        volume      = "adguard-conf"
        destination = "/opt/adguardhome/conf"
        read_only   = false
      }
      volume_mount {
        volume      = "adguard-work"
        destination = "/opt/adguardhome/work"
        read_only   = false
      }

      resources {
        cpu    = 100
        memory = 256
      }

      config{
        image = "adguard/adguardhome"

        privileged = true

        ports = [
          "dns",
          "http",
          "https",
          "dashboard",
          "dot",
          "dtls",
          "doq",
          "tcp",
        ]
      }
    }

    service {
      name = "adguard-job"
      port = "dashboard"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.adguard-job.rule=Host(`adguard.karaleic.com`)",
        "traefik.http.routers.adguard-job.entrypoints=websecure",
        # "traefik.http.services.vaultwarden-job.loadbalancer.server.port=51821",
        "traefik.http.routers.adguard-job.tls.certresolver=cloudflare",
      ]
    }
  }
}
