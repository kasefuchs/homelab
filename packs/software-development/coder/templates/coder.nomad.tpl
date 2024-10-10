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

    task "coder" {
      driver = "docker"

      config {
        image   = [[ var "docker_image" . | quote ]]
        ports   = [[ list $service.port | toStringList ]]
        volumes = [[ var "volumes" . | toStringList ]]

        entrypoint = ["/bin/sh", "-c"]
        args       = ["set -a && source ${NOMAD_SECRETS_DIR}/config/coder.env && set +a && /opt/coder server"]
      }

      env {
        CODER_HTTP_ADDRESS = "0.0.0.0:${NOMAD_PORT_[[ $service.port ]]}"
        TF_CLI_CONFIG_FILE = "${NOMAD_SECRETS_DIR}/config/terraform.rc"
        [[ template "env" var "environment" . ]]
      }

      template {
        data = <<EOH
[[ var "dotenv" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/coder.env"
      }

      template {
        data = <<EOH
[[ var "terraformrc" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/terraform.rc"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
