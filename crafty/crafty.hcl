job "crafty-job" {
  datacenters = ["bedroom"]
  type        = "service"

  group "crafty-group" {
    count = 1

    volume "crafty-backup" {
      type      = "host"
      read_only = false
      source    = "crafty-backup"
    }
    volume "crafty-servers" {
      type      = "host"
      read_only = false
      source    = "crafty-servers"
    }
    volume "crafty-logs" {
      type      = "host"
      read_only = false
      source    = "crafty-logs"
    }
    volume "crafty-config" {
      type      = "host"
      read_only = false
      source    = "crafty-config"
    }
    volume "crafty-import" {
      type      = "host"
      read_only = false
      source    = "crafty-import"
    }

    network {
      mode = "bridge"

      port "https" {
        static = 8443
        to = 8443
      }
      port "dynmap" {
        static = 8123
        to = 8123
      }
      port "server1" {
        static = 25500
        to = 25500
      }
      port "server2" {
        static = 25501
        to = 25501
      }
      port "server3" {
        static = 25502
        to = 25502
      }
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "crafty-container" {
      driver = "docker"

      volume_mount {
        volume      = "crafty-backup"
        destination = "/crafty/backup"
        read_only   = false
      }
      volume_mount {
        volume      = "crafty-logs"
        destination = "/crafty/logs"
        read_only   = false
      }
      volume_mount {
        volume      = "crafty-servers"
        destination = "/crafty/servers"
        read_only   = false
      }
      volume_mount {
        volume      = "crafty-config"
        destination = "/crafty/app/config"
        read_only   = false
      }
      volume_mount {
        volume      = "crafty-import"
        destination = "/crafty/app/import"
        read_only   = false
      }

      env {
        TZ = "Etc/UTC"
      }

      config {
        image = "registry.gitlab.com/crafty-controller/crafty-4:latest"

        ports = ["https", "dynmap", "server1", "server2", "server3" ]
      }

      resources {
        cpu    = 1000
        memory = 1024
      }

      service {
        name = "crafty-service"
        port = "https"
        provider = "nomad"

        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
