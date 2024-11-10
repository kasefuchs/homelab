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

    task "hoodik" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]

        entrypoint = ["/bin/bash", "-c"]
        args       = ["set -a && source ${NOMAD_SECRETS_DIR}/config/hoodik.env && set +a && /usr/local/bin/hoodik"]
      }

      volume_mount {
        volume      = [[ $volume.name | quote ]]
        destination = "${NOMAD_TASK_DIR}/data"
      }

      env {
        SSL_DISABLED = "true"
        HTTP_ADDRESS = "0.0.0.0"
        HTTP_PORT    = "${NOMAD_PORT_[[ $service.port ]]}"
        DATA_DIR     = "${NOMAD_TASK_DIR}/data"
        [[ template "env" var "environment" . ]]
      }

      template {
        data = <<EOH
[[ var "dotenv" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/hoodik.env"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
