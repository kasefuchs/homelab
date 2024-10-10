job [[ template "job_name" . ]] {
  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "servers" {
    [[ $volume := var "volume" . -]]
    [[ $service := var "service" . -]]

    [[ template "service" $service ]]
    [[ template "volume" $volume ]]

    network {
      port "[[ $service.port ]]" {
        to = 8123
        [[ template "host_network" $service.host_network ]]
      }
    }

    task "home-assistant" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]

        entrypoint = ["/bin/bash", "-c"]
        args       = ["set -a && source ${NOMAD_SECRETS_DIR}/config/home-assistant.env && set +a && /usr/local/bin/python3 -m homeassistant --config ${NOMAD_TASK_DIR}/config"]
      }

      volume_mount {
        volume      = [[ $volume.name | quote ]]
        destination = "${NOMAD_TASK_DIR}/config"
      }

      env {
        [[ template "env" var "environment" . ]]
      }

      template {
        data = <<EOH
[[ var "dotenv" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/home-assistant.env"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
