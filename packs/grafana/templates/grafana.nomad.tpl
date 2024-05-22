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

    task "grafana" {
      driver = "docker"

      config {
        image   = "grafana/grafana-oss:10.1.10"
        ports   = [[ list $service.port | toStringList ]]
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_TASK_DIR}/config/grafana.ini"
      }

      env {
        GF_SERVER_HTTP_PORT = "${NOMAD_PORT_[[ $service.port ]]}"
        GF_PATHS_CONFIG     = "${NOMAD_TASK_DIR}/config/grafana.ini"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
