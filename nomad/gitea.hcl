job "gitea-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "gitea-job"{
    count = 1

    constraint{
      attribute = "${meta.name}"
      value = "dell-xps"
    }

    volume "gitea-data" {
      type      = "host"
      read_only = false
      source    = "gitea-data"
    }
    volume "gitea-postgres" {
      type      = "host"
      read_only = false
      source    = "gitea-postgres"
    }
    volume "gitea-timezone" {
      type      = "host"
      read_only = true
      source    = "gitea-timezone"
    }
    volume "gitea-localtime" {
      type      = "host"
      read_only = true
      source    = "gitea-localtime"
    }

    network {
      mode = "host"

      port "http" {
        to = 3000
      }
      port "ssh" {
        static = 8022
        to = 22
      }
      port "postgres" {
        static = 5432
        to = 5432
      }
    }

    task "gitea-container"{
      driver = "docker"

      resources {
        cpu    = 200
        memory = 256
      }

      volume_mount {
        volume      = "gitea-data"
        destination = "/data"
        read_only   = false
      }
      volume_mount {
        volume      = "gitea-timezone"
        destination = "/etc/timezone"
        read_only   = true
      }
      volume_mount {
        volume      = "gitea-localtime"
        destination = "/etc/localtime"
        read_only   = true
      }

      env{
        USER_UID = 1000
        USER_GID = 1000
        GITEA__database__DB_TYPE = "postgres"
        GITEA__database__HOST = "192.168.31.15:5432"
        GITEA__database__NAME = "gitea"
        GITEA__database__USER = "gitea"
        GITEA__database__PASSWD = "gitea"
      }

      config{
        image = "docker.gitea.com/gitea:1.26.0-rootless"

        ports = ["http", "ssh"]
      }
    }

    task "gitea-postgres"{
      driver = "docker"
      user   = "1000:1000"

      resources {
        cpu    = 200
        memory = 256
      }

      volume_mount {
        volume      = "gitea-postgres"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }

      env{
        POSTGRES_USER     = "gitea"
        POSTGRES_PASSWORD = "gitea"
        POSTGRES_DB       = "gitea"
      }

      config{
        image = "docker.io/library/postgres:14"

        ports = ["postgres"]
      }
    }

    service {
      name = "gitea-job"
      port = "http"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.gitea-job.rule=Host(`gitea.karaleic.com`)",
        "traefik.http.routers.gitea-job.entrypoints=websecure",
        "traefik.http.routers.gitea-job.tls.certresolver=cloudflare",
      ]
    }
  }
}
