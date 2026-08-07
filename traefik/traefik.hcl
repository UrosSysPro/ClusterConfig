job "traefik-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "traefik-job"{
    count = 1

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
      port "dashboard" {
        static = 8080
        to = 8080
      }
    }

    task "traefik-container"{
      dirver = "docker"

      config{
        image = "traefik:v3.7"

        ports = ["http", "dashboard"]

        args = [
          "--api.insecure=true",
          "--providers.docker=true",
          "--entrypoints.web.address=:80",
        ]
      }

      resources {
        cpu    = 500
        memory = 1024
      }

      service {
        name = "traefik-dashboard"
        port = "http"
      }
    }
  }
}
