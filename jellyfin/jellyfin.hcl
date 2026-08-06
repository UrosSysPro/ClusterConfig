job "jellyfin-job" {
  datacenters = ["bedroom"]
  type        = "service"

  group "jellyfin-group" {
    count = 1

    constraint{
      attribute = "${meta.name}"
      value = "dell-xps"
    }

    volume "jellyfin" {
      type      = "host"
      read_only = false
      source    = "jellyfin"
    }

    network {
      port "http" {
        static = 8096
      }
      port "https" {
        static = 8920
      }
      port "discovery" {
        static = 7359
      }
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "jellyfin-container" {
      driver = "docker"

      volume_mount {
        volume      = "jellyfin"
        destination = "/media"
        read_only   = false
      }

      env {
        JELLYFIN_CONFIG_DIR = "/media/config"
        JELLYFIN_CACHE_DIR  = "/media/cache"
      }

      config {
        image = "jellyfin/jellyfin:latest"

        ports = ["http", "https", "discovery"]
      }

      resources {
        cpu    = 1000
        memory = 1536
      }

      service {
        name = "jellyfin"
        port = "http"
        provider = "nomad"

        check {
          type     = "http"
          path     = "/health"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
