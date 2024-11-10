job [[ template "job_name" . ]] {
  type = [[ var "type" . | quote ]]

  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]
  
  group "servers" {
    task "diun" {
      driver = "docker"

      config {
        image   = [[ var "docker_image" . | quote ]]
  
        entrypoint = ["/bin/sh", "-c"]
        args       = ["set -a && source ${NOMAD_SECRETS_DIR}/.env && set +a && /usr/local/bin/diun serve"]
  
        volumes = [[ var "volumes" . | toStringList ]]
      }
  
      action "notification-test" {
        command = "/usr/local/bin/diun"
        args    = ["notif", "test"]
      }
  
      identity {
        env = true
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/diun.yml"
      }
  
      template {
        data = <<EOH
[[ var "dotenv" . ]]
        EOH
        
        destination = "${NOMAD_SECRETS_DIR}/.env"
      }

      env {
        CONFIG = "${NOMAD_SECRETS_DIR}/diun.yml"
        [[ template "env" var "environment" . ]]
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
