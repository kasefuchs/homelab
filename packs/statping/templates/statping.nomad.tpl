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

    task "statping" {
      driver = "docker"

      config {
        image   = [[ var "docker_image" . | quote ]]
        ports   = [[ list $service.port | toStringList ]]

        entrypoint = ["/usr/local/bin/statping"]
        args       = [
          "--config=${NOMAD_SECRETS_DIR}/config/statping.yaml",
          "--port=${NOMAD_PORT_[[ $service.port ]]}"
        ]
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/statping.yaml"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
