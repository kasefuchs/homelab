job [[ template "job_name" . ]] {
  type = "service"

  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]
  
  group "servers" {
    [[- $service := var "service" . ]]
    network {
      port "[[ $service.port ]]" {
        [[ template "host_network" var "host_network" . ]]
      }
    }

    [[ template "service" $service ]]

    task "lavalink" {
      driver = "java"

      config {
        jar_path = "local/application.jar"
      }

      artifact {
        source      = [[ var "artifact_source" . | quote ]]
        destination = "local/application.jar"
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
