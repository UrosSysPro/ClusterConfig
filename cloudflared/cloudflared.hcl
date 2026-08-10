variable "cloudflare_api_token"{
  type = string
}

job "cloudflared-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "cloudflared-group"{
    count = 1

    volume "cloudflared"{
      type = "host"
      read_only = true
      source = "cloudflared"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "cloudflared-container"{
      driver = "docker"

      volume_mount {
        volume      = "cloudflared"
        destination = "/config"
        read_only   = true
      }

      resources {
        cpu    = 100
        memory = 128
      }

      env {
        API_TOKEN = var.cloudflare_api_token
      }

      config{
        image = "cloudflare/cloudflared"

        args = [
          "tunnel",
          "--no-autoupdate",
          "run",
          "--token",
          "$API_TOKEN",
        ]
      }
    }
  }
}
