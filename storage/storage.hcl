client {
  # Jellyfin
  host_volume "jellyfin" {
    path      = "/mnt/containers/jellyfin"
    read_only = false
  }



  #  Crafty
  host_volume "crafty-backup" {
    path      = "/mnt/containers/crafty/backup"
    read_only = false
  }
  host_volume "crafty-logs" {
    path      = "/mnt/containers/crafty/logs"
    read_only = false
  }
  host_volume "crafty-servers" {
    path      = "/mnt/containers/crafty/servers"
    read_only = false
  }
  host_volume "crafty-config" {
    path      = "/mnt/containers/crafty/config"
    read_only = false
  }
  host_volume "crafty-import" {
    path      = "/mnt/containers/crafty/import"
    read_only = false
  }



  # qbittorrent
  host_volume "qbittorrent-config" {
    path      = "/mnt/containers/qbittorrent/config"
    read_only = false
  }
  host_volume "qbittorrent-downloads" {
    path      = "/mnt/containers/qbittorrent/downloads"
    read_only = false
  }
}
