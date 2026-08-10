variable "cf_api_token" {
  type        = string
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

    volume "traefik-certs" {
      type      = "host"
      read_only = false
      source    = "traefik-certs"
    }

    constraint{
      attribute = "${meta.name}"
      value = "dell-xps"
    }

    network {
      mode = "bridge"

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
        volume      = "traefik-certs"
        destination = "/letsencrypt"
        read_only   = false
      }

      volume_mount {
        volume      = "traefik"
        destination = "/etc/traefik"
        read_only   = false
      }

      config{
        image = "traefik:v3.7"

        ports = ["http", "dashboard"]

        args = [
          "--configFile=/etc/traefik/traefik.yml",
        ]
      }
      template {
        data        = file("traefik.yml")
        destination = "local/traefik.yml"
      }

      template {
        data        = file("dynamic.yml")
        destination = "local/dynamic.yml"
      }

      env {
        CF_DNS_API_TOKEN = var.cf_api_token
      }
  # service {
  #   name = "traefik-dashboard"
  #   port = "http"
  # }
    }
  }
}
