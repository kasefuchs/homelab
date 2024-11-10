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

    task "clash-exporter" {
      driver = "docker"
  
      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]
        
        entrypoint = ["/bin/sh", "-c"]
        args       = ["set -a && source ${NOMAD_SECRETS_DIR}/.env && set +a && /usr/bin/clash-exporter --port ${NOMAD_PORT_[[ $service.port ]]}[[ var "arguments" . | join " " | indent 1 | trimSuffix " " ]]"]
      }
  
      env {
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
