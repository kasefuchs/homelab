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
        image   = "ghcr.io/minekube/gate:latest"
        ports   = [[ list $service.port | toStringList ]]
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/gate.yml"
      }

      env {
        GATE_CONFIG      = "${NOMAD_SECRETS_DIR}/config/gate.yml"
        GATE_CONFIG_BIND = "0.0.0.0:${NOMAD_PORT_[[ $service.port ]]}"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
