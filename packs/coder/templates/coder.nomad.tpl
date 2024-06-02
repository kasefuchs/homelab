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
        image   = "ghcr.io/coder/coder:latest"
        ports   = [[ list $service.port | toStringList ]]
      }

      env {
        CODER_HTTP_ADDRESS = "0.0.0.0:${NOMAD_PORT_[[ $service.port ]]}"
        TF_CLI_CONFIG_FILE = "${NOMAD_SECRETS_DIR}/config/coder.tfrc"
        [[ template "env" var "environment" . ]]
      }

      template {
        data = <<EOH
[[ var "terraform_config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/coder.tfrc"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
