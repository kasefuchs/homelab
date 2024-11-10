job [[ template "job_name" . ]] {
  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "servers" {
    [[ $service := var "service" . -]]
    [[ $data_volume := var "data_volume" . -]]  
    [[ $level_volume := var "level_volume" . -]]

    [[ template "service" $service ]]
    [[ template "volume" $data_volume ]]
    [[ template "volume" $level_volume ]]

    network {
      [[ template "port" $service ]]
    }

    task "minecraft-server" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]

        entrypoint = ["/bin/bash", "-c"]
        args       = ["set -a && source ${NOMAD_SECRETS_DIR}/.env && set +a && /start"]
      }
  
      volume_mount {
        volume      = [[ $data_volume.name | quote ]]
        destination = "/data"
      }

      volume_mount {
        volume      = [[ $level_volume.name | quote ]]
        destination = "${NOMAD_TASK_DIR}/level"
      }

      env {
        LEVEL       = "${NOMAD_TASK_DIR}/level/world"
        SERVER_PORT = "${NOMAD_PORT_[[ $service.port ]]}"
        [[ template "env" var "environment" . ]]
      }

      template {
        data = <<EOH
[[ var "dotenv" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/.env"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
