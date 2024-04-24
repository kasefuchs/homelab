job [[ template "job_name" . ]] {
  type = "service"

  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]
  
  group "application" {
    [[- $service := var "service" . ]]
    network {
      port "[[ $service.port ]]" {
        [[ template "host_network" var "host_network" . ]]
      }
    }

    [[ template "service" $service ]]

    task "application" {
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
[[ template "config" . ]]
        EOH

        destination = "application.yml"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
