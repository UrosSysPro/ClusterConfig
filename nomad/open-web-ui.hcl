job "open-web-ui-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "open-web-ui-group"{
    count = 1

    volume "open-web-ui"{
      type = "host"
      read_only = false
      source = "open-web-ui"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    network {
      port "dashboard"{
        to = 8080
      }
    }

    task "open-web-ui-container"{
      driver = "docker"

      volume_mount {
        volume      = "open-web-ui"
        destination = "/app/backend/data"
        read_only   = false
      }

      resources {
        cpu    = 100
        memory = 256
      }

      config{
        image = "ghcr.io/open-webui/open-webui:main"

        ports = [
          "dashboard"
        ]
      }
    }

    service {
      name = "searxng-job"
      port = "search"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.open-web-ui-job.rule=Host(`open-web-ui.karaleic.com`)",
        "traefik.http.routers.open-web-ui-job.entrypoints=websecure",
        "traefik.http.routers.open-web-ui-job.tls.certresolver=cloudflare",
      ]
    }
  }
}
