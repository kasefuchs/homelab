job [[ template "job_name" . ]] {
  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "servers" {
    [[ $service := var "service" . -]]

    count = [[ var "count" . ]]

    [[ template "service" $service ]]

    network {
      [[ template "port" $service ]]
    }

    task "dendrite" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]
        args  = [
          "-config=${NOMAD_SECRETS_DIR}/config/dendrite.yml",
          "-http-bind-address=0.0.0.0:${NOMAD_PORT_[[ $service.port ]]}",
        ]
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/dendrite.yml"
      }

      template {
        data = <<EOH
[[ var "matrix_key" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/keys/matrix.pem"
      }

      env {
        MATRIX_PRIVATE_KEY = "${NOMAD_SECRETS_DIR}/keys/matrix.pem"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
