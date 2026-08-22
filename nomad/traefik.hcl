job "traefik-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "traefik-job"{
    count = 1

    volume "traefik" {
      type      = "host"
      read_only = false
      source    = "traefik"
    }

    constraint{
      attribute = "${meta.name}"
      value = "dell-xps"
    }

    network {
      mode = "host"

      port "http" {
        static = 80
        to = 80
      }

      port "https" {
        static = 443
        to = 443
      }

      port "dashboard" {
        static = 8080
        to = 8080
      }
    }

    task "traefik-container"{
      driver = "docker"

      resources {
        cpu    = 500
        memory = 1024
      }

      volume_mount {
        volume      = "traefik"
        destination = "/etc/traefik"
        read_only   = false
      }

      config{
        image = "traefik:v3.7"

        ports = ["http", "https", "dashboard"]
      }

      env {
        CF_API_EMAIL = "karaleicu@gmail.com"
      }

      template {
        data = <<EOH
      {{- with nomadVar "nomad/jobs/traefik" -}}
        {{- range .Tuples -}}
      {{ .K }}={{ .V }}
        {{- end -}}
      {{- end -}}
      EOH
        destination = "secrets/cloudflare.env"
        env         = true
      }
    }
  }
}
