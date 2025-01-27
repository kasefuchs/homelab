job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  [[ template "namespace" . ]]
  [[ template "datacenters" . ]]

  [[- range $idx, $constraint := var "constraints" . ]]

  [[ template "constraint" $constraint ]]
  [[- end ]]

  ui {v
    description = [[ template "ui_description" . ]]
  }

  group "servers" {
    network {
      mode = "bridge"
      [[- if var "port" . ]]
      [[ template "port" var "port" . ]]
      [[- end ]]
    }

    [[ template "service" var "service" . ]]

    [[- $vault := var "vault" . -]]
    [[- if $vault ]]

    [[ template "vault" $vault ]]
    [[- end ]]

    task [[ template "job_name" . ]] {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        args  = ["--spring.config.location=${NOMAD_TASK_DIR}/lavalink.yml"]
      }

      env {
        [[- template "env" var "environment" . ]]
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
