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
    }

    task "gitea-container"{
      driver = "docker"

      resources {
        cpu    = 500
        memory = 1024
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
      }

      config{
        image = "docker.gitea.com/gitea:1.26.0"

        ports = ["http","ssh"]
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
