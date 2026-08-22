job "vaultwarden-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "vaultwarden-group"{
    count = 1

    volume "vaultwarden"{
      type = "host"
      read_only = false
      source = "vaultwarden"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    network {
      port "http"{
        to = 80
      }
    }

    task "vaultwarden-container"{
      driver = "docker"

      volume_mount {
        volume      = "vaultwarden"
        destination = "/data"
        read_only   = false
      }

      resources {
        cpu    = 100
        memory = 128
      }

      env{
        DOMAIN = "https://vaultwarden.karaleic.com"
      }

      config{
        image = "vaultwarden/server:latest"

        ports = ["http"]
      }
    }

    service {
      name = "vaultwarden-job"
      port = "http"

      # check {
      #   name     = "alive"
      #   type     = "http"
      #   path     = "/"
      #   interval = "10s"
      #   timeout  = "2s"
      # }

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.vaultwarden-job.rule=Host(`vaultwarden.karaleic.com`)",
        "traefik.http.routers.vaultwarden-job.entrypoints=websecure",
        # "traefik.http.services.vaultwarden-job.loadbalancer.server.port=51821",
        "traefik.http.routers.vaultwarden-job.tls.certresolver=cloudflare",
      ]
    }
  }
}
