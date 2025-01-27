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
      [[- range $idx, $port := var "ports" . ]]

      [[ template "port" $port ]]
      [[- end ]]
    }

    [[- range $idx, $service := var "services" . ]]

    [[ template "service" $service ]]
    [[- end ]]

    [[- range $idx, $volume := var "volumes" . ]]

    [[ template "volume" $volume ]]
    [[- end ]]

    [[- $vault := var "vault" . -]]
    [[- if $vault ]]

    [[ template "vault" $vault ]]
    [[- end ]]

    task [[ template "job_name" . ]] {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
      }

      env {
        [[- template "env" var "environment" . ]]
      }

      [[- range $idx, $template := var "templates" . ]]

      [[ template "template" $template ]]
      [[- end ]]

      [[- range $idx, $volume_mount := var "volume_mounts" . ]]

      [[ template "volume_mount" $volume_mount ]]
      [[- end ]]

      [[ template "resources" var "resources" . ]]
    }
  }
}
