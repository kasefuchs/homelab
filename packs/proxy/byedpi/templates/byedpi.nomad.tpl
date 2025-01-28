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
      [[- if var "port" . ]]
      [[ template "port" var "port" . ]]
      [[- end ]]
    }

    [[ template "service" var "service" . ]]

    task "byedpi" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        args  = [[ var "arguments" . | toStringList ]]
      }

      env {
        [[- template "env" var "environment" . ]]
      }

      [[- range $idx, $artifact := var "artifacts" . ]]

      [[ template "artifact" $artifact ]]
      [[- end ]]

      [[ template "resources" var "resources" . ]]
    }
  }
}
