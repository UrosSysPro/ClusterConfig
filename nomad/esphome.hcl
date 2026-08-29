job "esphome-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "esphome-group"{
    count = 1

    volume "esphome-config"{
      type = "host"
      read_only = false
      source = "esphome-config"
    }

    volume "esphome-localtime"{
      type = "host"
      read_only = true
      source = "esphome-localtime"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    network {
      port "dashboard"{
        to = 6052
      }
    }

    task "esphome-container"{
      driver = "docker"

      volume_mount {
        volume      = "esphome-config"
        destination = "/config"
        read_only   = false
      }
      volume_mount {
        volume      = "esphome-localtime"
        destination = "/etc/localtime"
        read_only   = true
      }

      resources {
        cpu    = 100
        memory = 256
      }

      config{
        image = "ghcr.io/esphome/esphome"

        privileged = true

        ports = [
          "dashboard"
        ]
      }
    }

    service {
      name = "esphome-job"
      port = "dashboard"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.esphome-job.rule=Host(`esphome.karaleic.com`)",
        "traefik.http.routers.esphome-job.entrypoints=websecure",
        "traefik.http.routers.esphome-job.tls.certresolver=cloudflare",
      ]
    }
  }
}
