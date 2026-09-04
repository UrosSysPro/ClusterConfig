job "home-assistant-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "home-assistant-group"{
    count = 1

    volume "home-assistant-config"{
      type = "host"
      read_only = false
      source = "home-assistant-config"
    }
    volume "home-assistant-localtime"{
      type = "host"
      read_only = true
      source = "home-assistant-localtime"
    }
    volume "home-assistant-dbus"{
      type = "host"
      read_only = true
      source = "home-assistant-dbus"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    network {
      mode = "host"

      port "dashboard"{
        to = 8123
      }
      port "homekit"{
        to = 51827
        static = 51827
      }
      # port "mdns"{
      #   to = 5353
      #   static = 5353
      # }
      port "mqtt"{
        to = 1883
        static = 1883
      }
    }

    task "home-assistant-container"{
      driver = "docker"

      volume_mount {
        volume      = "home-assistant-config"
        destination = "/config"
        read_only   = false
      }
      volume_mount {
        volume      = "home-assistant-localtime"
        destination = "/etc/localtime"
        read_only   = true
      }
      volume_mount {
        volume      = "home-assistant-dbus"
        destination = "/run/dbus"
        read_only   = true
      }

      resources {
        cpu    = 2048
        memory = 2048
      }

      env{
        TZ = "Europe/Belgrade"
      }

      config{
        image = "ghcr.io/home-assistant/home-assistant:stable"

        privileged = true

        ports = [
          "dashboard",
          "homekit",
          "mqtt",
          # "mdns",
        ]
      }
    }

    service {
      name = "home-assistant-job"
      port = "dashboard"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.home-assistant-job.rule=Host(`home-assistant.karaleic.com`)",
        "traefik.http.routers.home-assistant-job.entrypoints=websecure",
        # "traefik.http.services.vaultwarden-job.loadbalancer.server.port=51821",
        "traefik.http.routers.home-assistant-job.tls.certresolver=cloudflare",
      ]
    }
  }
}
