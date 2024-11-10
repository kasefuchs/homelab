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

    task "miniflux" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]
  
        entrypoint = ["/bin/sh", "-c"]
        args       = ["set -a && source ${NOMAD_SECRETS_DIR}/.env && set +a && /usr/bin/miniflux -config-file=${NOMAD_SECRETS_DIR}/miniflux.ini"]
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/miniflux.ini"
      }
  
      template {
        data = <<EOH
[[ var "dotenv" . ]]
        EOH
        
        destination = "${NOMAD_SECRETS_DIR}/.env"
      }

      env {
        PORT           = "${NOMAD_PORT_[[ $service.port ]]}"
        RUN_MIGRATIONS = "1"
        [[ template "env" var "environment" . ]]
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
