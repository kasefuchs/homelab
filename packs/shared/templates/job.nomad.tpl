job [[ template "job_name" . ]] {
  type        = [[ var "job_type" . | quote ]]
  region      = [[ var "region" . | quote ]]
  namespace   = [[ var "namespace" . | quote ]]
  datacenters = [[ var "datacenters" . | toStringList ]]

  [[- $ui := var "ui" . -]]
  [[- if ne $ui nil ]]

  [[ template "ui" $ui ]]
  [[- end ]]

  [[- range $idx, $constraint := var "constraints" . ]]

  [[ template "constraint" $constraint ]]
  [[- end ]]

  group "servers" {
    [[ template "network" var "network" . ]]

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

    [[- $restart := var "restart" . -]]
    [[- if ne $restart nil ]]

    [[ template "restart" $restart ]]
    [[- end ]]

    task [[ template "job_name" . ]] {
      driver = "docker"

      [[ template "docker_config" var "docker_config" . ]]

      [[- $environment := var "environment" . -]]
      [[- if $environment ]]

      [[ template "environment" $environment ]]
      [[- end ]]

      [[- range $idx, $identity := var "identities" . ]]

      [[ template "identity" $identity ]]
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
