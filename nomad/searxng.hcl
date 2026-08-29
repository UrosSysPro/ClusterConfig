job "searxng-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "searxng-group"{
    count = 1

    volume "searxng-core-config"{
      type = "host"
      read_only = false
      source = "searxng-core-config"
    }
    volume "searxng-core-data"{
      type = "host"
      read_only = false
      source = "searxng-core-data"
    }
    volume "searxng-valkey"{
      type = "host"
      read_only = false
      source = "searxng-valkey"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    network {
      port "search"{
        to = 8080
      }
    }

    task "core"{
      driver = "docker"

      volume_mount {
        volume      = "searxng-core-config"
        destination = "/etc/searxng"
        read_only   = false
      }
      volume_mount {
        volume      = "searxng-core-data"
        destination = "/var/cache/searxng"
        read_only   = false
      }

      resources {
        cpu    = 100
        memory = 256
      }

      config{
        image = "docker.io/searxng/searxng:latest"

        ports = [
          "search"
        ]
        cap_add = [
          "CHOWN",
          "SETUID",
          "SETGID"
        ]
      }
    }

    task "valkey"{
      driver = "docker"

      volume_mount {
        volume      = "searxng-valkey"
        destination = "/data"
        read_only   = false
      }

      resources {
        cpu    = 100
        memory = 256
      }

      config{
        image = "docker.io/valkey/valkey:9-alpine"

        entrypoint = ["valkey-server"]

        args = [
          "--save",
          "30",
          "1",
          "--loglevel",
          "warning"
        ]
      }
    }

    service {
      name = "searxng-job"
      port = "search"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.searxng-job.rule=Host(`searxng.karaleic.com`)",
        "traefik.http.routers.searxng-job.entrypoints=websecure",
        "traefik.http.routers.searxng-job.tls.certresolver=cloudflare",
      ]
    }
  }
}
