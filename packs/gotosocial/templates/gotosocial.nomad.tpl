job [[ template "job_name" . ]] {
  type = "service"

  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "servers" {
    [[ $service := var "service" . -]]

    [[ template "service" $service ]]

    network {
      [[ template "port" $service ]]
    }

    task "gotosocial" {
      driver = "docker"

      config {
        image   = [[ var "docker_image" . | quote ]]
        args    = [
          "--config-path", "${NOMAD_SECRETS_DIR}/config.yaml",
          "--port", "${NOMAD_PORT_[[ $service.port ]]}",
          "--bind-address", "0.0.0.0",
        ]
        ports   = [[ list $service.port | toStringList ]]
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config.yaml"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
