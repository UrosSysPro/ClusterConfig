datacenter = "bedroom"
data_dir = "/opt/nomad"

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


  # cloudflared
  host_volume "cloudflared" {
    path      = "/mnt/containers/cloudflared"
    read_only = false
  }


  # traefik
  host_volume "traefik" {
    path      = "/mnt/containers/traefik"
    read_only = false
  }


  # wireguard
  host_volume "wireguard-etc" {
    path      = "/mnt/containers/wireguard"
    read_only = false
  }
  host_volume "wireguard-modules" {
    path      = "/lib/modules"
    read_only = true
  }


  # vaultwarden
  host_volume "vaultwarden" {
    path      = "/mnt/containers/vaultwarden"
    read_only = false
  }


  # adguard
  host_volume "adguard-conf" {
    path      = "/mnt/containers/adguard/conf"
    read_only = false
  }
  host_volume "adguard-work" {
    path      = "/mnt/containers/adguard/work"
    read_only = false
  }


  # home assistand
  host_volume "home-assistant-config" {
    path      = "/mnt/containers/home-assistant/config"
    read_only = false
  }
  host_volume "home-assistant-localtime" {
    path      = "/etc/localtime"
    read_only = true
  }
  host_volume "home-assistant-dbus" {
    path      = "/run/dbus"
    read_only = true
  }


  # esp home
  host_volume "esphome-config" {
    path      = "/mnt/containers/esp-home/config"
    read_only = false
  }
  host_volume "esphome-localtime" {
    path      = "/etc/localtime"
    read_only = true
  }


  # searxng
  host_volume "searxng-core-config" {
    path      = "/mnt/containers/searxng/core-config"
    read_only = false
  }
  host_volume "searxng-core-data" {
    path      = "/mnt/containers/searxng/core-data"
    read_only = false
  }
  host_volume "searxng-valkey" {
    path      = "/mnt/containers/searxng/valkey"
    read_only = false
  }




  # open web ui
  host_volume "open-web-ui" {
    path      = "/mnt/containers/open-web-ui"
    read_only = false
  }
}
