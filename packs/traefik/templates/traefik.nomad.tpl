job [[ template "job_name" . ]] {
  type = "service"

  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "servers" {
    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik:v3.0.0"
        network_mode = "host"
      }

      [[ template "env" var "environment" . ]]

      [[ template "resources" var "resources" . ]]
    }
  }
}