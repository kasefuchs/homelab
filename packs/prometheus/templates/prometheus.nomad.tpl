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

    task "prometheus" {
      driver = "docker"

      config {
        image   = "prom/prometheus:v2.53.1"
        args    = [
          "--config.file=${NOMAD_SECRETS_DIR}/config/prometheus.yml",
          "--web.listen-address=0.0.0.0:${NOMAD_PORT_[[ $service.port ]]}"
        ]
        ports   = [[ list $service.port | toStringList ]]
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/prometheus.yml"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
