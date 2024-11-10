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

    task "memos" {
      driver = "docker"

      config {
        image   = [[ var "docker_image" . | quote ]]
        ports   = [[ list $service.port | toStringList ]]

        entrypoint = ["/bin/sh", "-c"]
        args       = ["set -a && source ${NOMAD_SECRETS_DIR}/.env && set +a && /usr/local/memos/memos"]
      }

      env {
        MEMOS_ADDR = "0.0.0.0"
        MEMOS_PORT = "${NOMAD_PORT_[[ $service.port ]]}"
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
