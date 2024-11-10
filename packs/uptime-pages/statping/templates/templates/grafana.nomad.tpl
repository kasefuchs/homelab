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
        image   = [[ var "docker_image" . | quote ]]
        ports   = [[ list $service.port | toStringList ]]
  
        entrypoint = ["/bin/sh", "-c"]
        args       = ["set -a && source ${NOMAD_SECRETS_DIR}/.env && set +a && /run.sh"]
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/grafana.ini"
      }

[[ range $idx, $entry := var "provisioning" . ]]
      template {
        data = <<EOH
[[ $entry.config ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/provisioning/[[ $entry.type ]]/[[ $idx ]].yaml"
      }
[[ end ]]

      env {
        GF_SERVER_HTTP_PORT   = "${NOMAD_PORT_[[ $service.port ]]}"
        GF_PATHS_CONFIG       = "${NOMAD_SECRETS_DIR}/grafana.ini"
        GF_PATHS_PROVISIONING = "${NOMAD_SECRETS_DIR}/provisioning"
        [[ template "env" var "environment" . ]]
      }
  
      template {
        data = <<EOH
[[ var "dotenv" . ]]
        EOH
        
        destination = "${NOMAD_SECRETS_DIR}/.env"
      }
  
      [[ template "resources" var "resources" . ]]
    }
  }
}
