job "qbittorrent-job" {
  datacenters = ["bedroom"]
  type        = "service"

  group "qbittorrent-group" {
    count = 1

    constraint{
      attribute = "{meta.name}"
      value = "dell-xps"
    }

    volume "qbittorrent-config" {
      type      = "host"
      read_only = false
      source    = "qbittorrent-config"
    }
    volume "qbittorrent-downloads" {
      type      = "host"
      read_only = false
      source    = "qbittorrent-downloads"
    }

    network {
      port "http" {
        static = 8081
        to = 8080
      }
      port "torrent" {
        static = 6881
      }
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "qbittorrent-container" {
      driver = "docker"

      volume_mount {
        volume      = "qbittorrent-config"
        destination = "/config"
        read_only   = false
      }
      volume_mount {
        volume      = "qbittorrent-downloads"
        destination = "/downloads"
        read_only   = false
      }

      env{
        PUID=1000
        PGID=1000
        TZ="Etc/UTC"
        WEBUI_PORT=8080
        TORRENTING_PORT=6881
      }

      config {
        image = "lscr.io/linuxserver/qbittorrent:latest"

        ports = ["http", "torrent"]
      }

      resources {
        cpu    = 500
        memory = 1024
      }
    }
  }
}
