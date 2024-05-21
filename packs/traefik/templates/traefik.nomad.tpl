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
        args         = ["--configFile", "${NOMAD_TASK_DIR}/config/traefik.yml"]
        network_mode = "host"
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_TASK_DIR}/config/traefik.yml"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}