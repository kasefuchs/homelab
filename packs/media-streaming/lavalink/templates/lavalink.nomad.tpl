job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  [[ template "datacenters" . ]]

  [[- range $idx, $constraint := var "constraints" . ]]

  [[ template "constraint" $constraint ]]
  [[- end ]]

  ui {
    description = [[ template "ui_description" . ]]
  }

  group "servers" {
    network {
      mode = "bridge"
    }

    service {
      name = [[ ( var "service" . ).name | quote ]]
      tags = [[ ( var "service" . ).tags | toStringList ]]
      port = "2333"
      connect {
        sidecar_task {
          [[ template "resources" var "sidecar_resources" . ]]
        }
        sidecar_service {}
      }
    }

    [[- if var "vault" . ]]

    vault {
      role = [[ ( var "vault" . ).role | quote ]]
    }
    [[- end ]]

    task "lavalink" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        args  = ["--spring.config.location=${NOMAD_TASK_DIR}/lavalink.yml"]
      }

      env {
        SERVER_PORT    = "2333"
        SERVER_ADDRESS = "0.0.0.0"
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH
        destination = "${NOMAD_TASK_DIR}/lavalink.yml"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
