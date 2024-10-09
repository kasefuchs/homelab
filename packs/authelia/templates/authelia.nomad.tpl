job [[ template "job_name" . ]] {
  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "servers" {
    [[ $service := var "service" . -]]

    [[ template "service" $service ]]

    network {
      [[ template "port" $service ]]
    }

    task "authelia" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]

        entrypoint = ["/bin/sh", "-c"]
        args       = ["set -a && source ${NOMAD_SECRETS_DIR}/authelia.env && set +a && /app/authelia --config ${NOMAD_SECRETS_DIR}/config.yaml"]
      }

      env {
        AUTHELIA_AUTHENTICATION_BACKEND_FILE_PATH = "${NOMAD_SECRETS_DIR}/users.yaml"
        AUTHELIA_SERVER_ADDRESS                   = "tcp://0.0.0.0:${NOMAD_PORT_[[ $service.port ]]}"
        [[ template "env" var "environment" . ]]
      }

      template {
        data = <<EOH
[[ var "dotenv" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/authelia.env"
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config.yaml"
      }

      template {
        data = <<EOH
[[ var "users" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/users.yaml"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
