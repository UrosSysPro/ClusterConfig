job "immich-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "immich-job"{
    count = 1

    network {
      mode = "host"

      port "http" {
        static = 2283
        to = 2283
      }
    }

    task "immich-webapp"{
      driver = "docker"

      resources {
        cpu    = 200
        memory = 256
      }

      config{
        image = "ghcr.io/immich-app/immich-server:IMMICH_VERSION:-release"

        ports = ["http"]
      }
    }

    task "immich-machine-learning"{
      driver = "docker"

      resources {
        cpu    = 200
        memory = 256
      }

      config{
        image = "ghcr.io/immich-app/immich-machine-learning:IMMICH_VERSION:-release"
      }
    }

    task "immich-redis"{
      driver = "docker"

      resources {
        cpu    = 200
        memory = 256
      }

      config{
        image = "docker.io/valkey/valkey:9@sha256:3b55fbaa0cd93cf0d9d961f405e4dfcc70efe325e2d84da207a0a8e6d8fde4f9"
      }
    }

    task "immich-database"{
      driver = "docker"

      resources {
        cpu    = 200
        memory = 256
      }

      config{
        image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23"
      }
    }

    service {
      name = "immich-job"
      port = "http"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.immich-job.rule=Host(`immich.karaleic.com`)",
        "traefik.http.routers.immich-job.entrypoints=websecure",
        "traefik.http.routers.immich-job.tls.certresolver=cloudflare",
      ]
    }
  }
}
