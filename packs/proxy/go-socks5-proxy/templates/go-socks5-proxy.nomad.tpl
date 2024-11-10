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

    task "go-socks5-proxy" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]
        
        entrypoint = ["/bin/sh", "-c"]
        args       = ["set -a && source ${NOMAD_SECRETS_DIR}/.env && set +a && /usr/bin/socks5"]
      }
    
      env {
        PROXY_PORT = "${NOMAD_PORT_[[ $service.port ]]}"
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
