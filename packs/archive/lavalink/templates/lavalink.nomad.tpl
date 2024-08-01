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

    task "lavalink" {
      driver = "java"

      config {
        jar_path = "${NOMAD_TASK_DIR}/application.jar"
      }

      artifact {
        source      = [[ var "artifact_source" . | quote ]]
        destination = "${NOMAD_TASK_DIR}/application.jar"
        mode        = "file"
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "application.yml"
      }

      env {
        SERVER_ADDRESS = "0.0.0.0"
        SERVER_PORT    = "${NOMAD_HOST_PORT_[[ $service.port ]]}"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
