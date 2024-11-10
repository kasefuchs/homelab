job [[ template "job_name" . ]] {
  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "servers" {
    [[ $volume := var "volume" . -]]
    [[ $service := var "service" . -]]

    [[ template "volume" $volume ]]
    [[ template "service" $service ]]

    network {
      [[ template "port" $service ]]
    }

    task "shiori" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]

        entrypoint = ["/bin/sh", "-c"]
        args       = ["set -a && source ${NOMAD_SECRETS_DIR}/config/shiori.env && set +a && /usr/bin/shiori server"]
      }

      volume_mount {
        volume      = [[ $volume.name | quote ]]
        destination = "${NOMAD_TASK_DIR}/data"
      }

      env {
        SHIORI_DIR       = "${NOMAD_TASK_DIR}/data"
        SHIORI_HTTP_PORT = "${NOMAD_PORT_[[ $service.port ]]}"
        [[ template "env" var "environment" . ]]
      }

      template {
        data = <<EOH
[[ var "dotenv" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/shiori.env"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
