# Immich v2.7.5 as a Nomad job.
#
# Mirrors docker/docker-compose.yml of Immich v2.7.5 with the same pinned
# images, so the postgres data directory from the current TrueNAS app can be
# restored as-is. Upgrade the image tags only after the data is in place.
#
# Before running: set DB_PASSWORD in BOTH tasks to the password used by the
# current Immich database (only A-Za-z0-9, no special characters). It has to
# match the pgdata you copy to /mnt/containers/immich/pgdata.

job "immich-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "immich-job"{
    count = 1

    # The photo library and database datasets live on the NAS.
    constraint{
      attribute = "${node.unique.name}"
      value     = "lil-nas"
    }

    volume "immich-data" {
      type      = "host"
      read_only = false
      source    = "immich-data"
    }
    volume "immich-pgdata" {
      type      = "host"
      read_only = false
      source    = "immich-pgdata"
    }
    volume "immich-model-cache" {
      type      = "host"
      read_only = false
      source    = "immich-model-cache"
    }
    volume "immich-localtime" {
      type      = "host"
      read_only = true
      source    = "immich-localtime"
    }

    network {
      mode = "host"

      port "http" {
        static = 2283
        to = 2283
      }
    }

    task "immich-server"{
      driver = "docker"

      resources {
        cpu    = 1000
        memory = 2048
      }

      volume_mount {
        volume      = "immich-data"
        destination = "/data"
        read_only   = false
      }
      volume_mount {
        volume      = "immich-localtime"
        destination = "/etc/localtime"
        read_only   = true
      }

      env{
        DB_HOSTNAME                 = "127.0.0.1"
        DB_USERNAME                 = "postgres"
        DB_PASSWORD                 = "CHANGE_ME"
        DB_DATABASE_NAME            = "immich"
        REDIS_HOSTNAME              = "127.0.0.1"
        IMMICH_MACHINE_LEARNING_URL = "http://127.0.0.1:3003"
      }

      config{
        image = "ghcr.io/immich-app/immich-server:v2.7.5"

        ports = ["http"]
      }
    }

    task "immich-machine-learning"{
      driver = "docker"

      resources {
        cpu    = 1000
        memory = 2048
      }

      volume_mount {
        volume      = "immich-model-cache"
        destination = "/cache"
        read_only   = false
      }

      config{
        image = "ghcr.io/immich-app/immich-machine-learning:v2.7.5"
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
        cpu    = 1000
        memory = 1024
      }

      volume_mount {
        volume      = "immich-pgdata"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }

      env{
        POSTGRES_PASSWORD    = "CHANGE_ME"
        POSTGRES_USER        = "postgres"
        POSTGRES_DB          = "immich"
        POSTGRES_INITDB_ARGS = "--data-checksums"
      }

      config{
        image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23"
      }
    }

    service {
      name = "immich-job"
      port = "http"

      check {
        type     = "http"
        path     = "/api/server/ping"
        interval = "30s"
        timeout  = "5s"
      }

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.immich-job.rule=Host(`immich.karaleic.com`)",
        "traefik.http.routers.immich-job.entrypoints=websecure",
        "traefik.http.routers.immich-job.tls.certresolver=cloudflare",
      ]
    }
  }
}
