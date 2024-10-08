job [[ template "job_name" . ]] {
  type = "system"

  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]
  
  group "servers" {
    task "diun" {
      driver = "docker"

      config {
        image = "crazymax/diun:latest"

        hostname = "${attr.unique.hostname}"

        entrypoint = ["/usr/local/bin/diun", "serve"]
        args       = ["--config", "${NOMAD_TASK_DIR}/config/diun.yml"]

        mount {
          type = "bind"
          target = "/var/run/docker.sock"
          source = "/var/run/docker.sock"
        }
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_TASK_DIR}/config/diun.yml"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
