variable "gitea_instance_url"{
  type = string
}
variable "gitea_runner_registration_token"{
  type = string
}
variable "gitea_runner_name"{
  type = string
}
variable "gitea_runner_labels"{
  type = string
}

job "gitea-runner-job"{
  datacenters = ["bedroom"]
  type        = "service"

  group "gitea-runner-group"{
    count = 1

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
        volume      = "gitea-runner-data"
        destination = "/data"
        read_only   = false
      }

      resources {
        cpu    = 500
        memory = 512
      }

      env{
        GITEA_INSTANCE_URL                = "${var.gitea_instance_url}"
        GITEA_RUNNER_REGISTRATION_TOKEN   = "${var.gitea_runner_registration_token}"
        GITEA_RUNNER_NAME                 = "${var.gitea_runner_name}"
        GITEA_RUNNER_LABELS               = "${var.gitea_runner_labels}"
        DOCKER_HOST                       = "unix:///var/run/user/1000/docker.sock"
        DOCKERD_ROOTLESS_ROOTLESSKIT_NET  = "slirp4netns"
        DOCKERD_ROOTLESS_ROOTLESSKIT_MTU  = 65520
        CONFIG_FILE                       = "/data/config.yaml"
      }

      config{
        image = "docker.io/gitea/runner:3-dind-rootless"

        privileged = true

        security_opt = [
          "apparmor=rootlesskit"
        ]
      }
    }
  }
}
