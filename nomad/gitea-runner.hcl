job "gitea-runner-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "gitea-runner-group"{
    count = 1

    volume "gitea-runner-config"{
      type = "host"
      read_only = false
      source = "gitea-runner-config"
    }
    volume "gitea-runner-data"{
      type = "host"
      read_only = false
      source = "gitea-runner-data"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "gitea-runner-container"{
      driver = "docker"

      volume_mount {
        volume      = "gitea-runner-config"
        destination = "/config.yaml"
        read_only   = false
      }
      volume_mount {
        volume      = "gitea-runner-data"
        destination = "/data"
        read_only   = false
      }

      resources {
        cpu    = 500
        memory = 512
      }

      env{
        GITEA_INSTANCE_URL="${GITEA_INSTANCE_URL}"
        GITEA_RUNNER_REGISTRATION_TOKEN="${GITEA_RUNNER_REGISTRATION_TOKEN}"
        GITEA_RUNNER_NAME="${GITEA_RUNNER_NAME}"
        GITEA_RUNNER_LABELS="${GITEA_RUNNER_LABELS}"
      }

      config{
        image = "docker.io/gitea/runner:3-dind"

        privileged = true
      }
    }
  }
}
