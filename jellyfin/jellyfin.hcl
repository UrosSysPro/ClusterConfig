job "jellyfin" {
  datacenters = ["bedroom"]
  type        = "service"
  provider = "nomad"

  group "jellyfin" {
    count = 1

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

    task "jellyfin" {
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
        cpu    = 500
        memory = 1024
      }

      service {
        name = "jellyfin"
        port = "http"

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
