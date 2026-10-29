variable "cf_api_token"{
  type = string
}

job "traefik-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "traefik-job"{
    count = 1

    volume "traefik" {
      type      = "host"
      read_only = false
      source    = "traefik"
    }

    constraint{
      attribute = "${meta.name}"
      value = "dell-xps"
    }

    network {
      mode = "host"

      port "http" {
        static = 80
        to = 80
      }

      port "https" {
        static = 443
        to = 443
      }

      port "dashboard" {
        static = 8080
        to = 8080
      }
    }

    task "traefik-container"{
      driver = "docker"

      resources {
        cpu    = 500
        memory = 1024
      }

      volume_mount {
        volume      = "traefik"
        destination = "/etc/traefik"
        read_only   = false
      }

      config{
        image = "traefik:v3.7"

        ports = ["http", "https", "dashboard"]
      }

      env {
        CF_API_EMAIL     = "karaleicu@gmail.com"
        CF_DNS_API_TOKEN = "${var.cf_api_token}"
      }
    }

    service {
      name = "traefik-job"
      port = "dashboard"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.traefik-job.rule=Host(`traefik.karaleic.com`)",
        "traefik.http.routers.traefik-job.entrypoints=websecure",
        # "traefik.http.services.vaultwarden-job.loadbalancer.server.port=51821",
        "traefik.http.routers.traefik-job.tls.certresolver=cloudflare",
      ]
    }
  }
}
