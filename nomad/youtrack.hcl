job "youtrack-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "youtrack-job"{
    count = 1

    volume "youtrack-data" {
      type      = "host"
      read_only = false
      source    = "youtrack-data"
    }
    volume "youtrack-conf" {
      type      = "host"
      read_only = false
      source    = "youtrack-conf"
    }
    volume "youtrack-logs" {
      type      = "host"
      read_only = false
      source    = "youtrack-logs"
    }
    volume "youtrack-backups" {
      type      = "host"
      read_only = false
      source    = "youtrack-backups"
    }

    constraint{
      attribute = "${meta.name}"
      value = "dell-xps"
    }

    network {
      mode = "host"

      port "http" {
        to = 8080
      }
    }

    task "youtrack-container"{
      driver = "docker"

      resources {
        cpu    = 200
        memory = 256
      }

      volume_mount {
        volume      = "youtrack-data"
        destination = "/opt/youtrack/data"
        read_only   = false
      }
      volume_mount {
        volume      = "youtrack-conf"
        destination = "/opt/youtrack/conf"
        read_only   = false
      }
      volume_mount {
        volume      = "youtrack-logs"
        destination = "/opt/youtrack/logs"
        read_only   = false
      }
      volume_mount {
        volume      = "youtrack-backups"
        destination = "/opt/youtrack/backups"
        read_only   = false
      }

      config{
        image = "jetbrains/youtrack:2025.1.76253"

        ports = ["http"]
      }
    }

    service {
      name = "youtrack-job"
      port = "http"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.youtrack-job.rule=Host(`youtrack.karaleic.com`)",
        "traefik.http.routers.youtrack-job.entrypoints=websecure",
        "traefik.http.routers.youtrack-job.tls.certresolver=cloudflare",
      ]
    }
  }
}
