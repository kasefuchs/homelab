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

    task "gate" {
      driver = "docker"

      config {
        image   = [[ var "docker_image" . | quote ]]
        ports   = [[ list $service.port | toStringList ]]
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/gate.yml"
      }

      template {
        data = <<EOH
{
  "token": "[[ var "connect_token" . ]]"
}
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/token.json"
      }

      env {
        GATE_CONFIG             = "${NOMAD_SECRETS_DIR}/config/gate.yml"
        GATE_CONFIG_BIND        = "0.0.0.0:${NOMAD_PORT_[[ $service.port ]]}"
        GATE_CONNECT_TOKEN_FILE = "${NOMAD_SECRETS_DIR}/config/token.json"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
