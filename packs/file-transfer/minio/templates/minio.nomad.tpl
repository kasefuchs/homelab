job [[ template "job_name" . ]] {
  [[ template "job_type" . ]]
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
    [[- if ne $vault nil ]]

    [[ template "vault" $vault ]]
    [[- end ]]

    [[- $consul := var "consul" . -]]
    [[- if ne $consul nil ]]

    [[ template "consul" $consul ]]
    [[- end ]]

    task [[ template "job_name" . ]] {
      driver = "docker"

      [[ template "docker_config" var "docker_config" . ]]

      [[- $environment := var "environment" . -]]
      [[- if $environment ]]

      [[ template "environment" $environment ]]
      [[- end ]]

      [[- range $idx, $artifact := var "artifacts" . ]]

      [[ template "artifact" $artifact ]]
      [[- end ]]

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
