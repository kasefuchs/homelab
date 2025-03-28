job [[ template "job_name" . ]] {
  type        = [[ var "job_type" . | quote ]]
  region      = [[ var "region" . | quote ]]
  namespace   = [[ var "namespace" . | quote ]]
  datacenters = [[ var "datacenters" . | toStringList ]]

  [[- $ui := var "ui" . -]]
  [[- if ne $ui nil ]]

  [[ template "ui" $ui ]]
  [[- end ]]

  [[- range $constraint := var "constraints" . ]]

  [[ template "constraint" $constraint ]]
  [[- end ]]

  group "servers" {
    [[ template "network" var "network" . ]]

    [[- range $service := var "services" . ]]

    [[ template "service" $service ]]
    [[- end ]]

    [[- range $volume := var "volumes" . ]]

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

      [[- range $identity := var "identities" . ]]

      [[ template "identity" $identity ]]
      [[- end ]]

      [[- range $artifact := var "artifacts" . ]]

      [[ template "artifact" $artifact ]]
      [[- end ]]

      [[- range $template := var "templates" . ]]

      [[ template "template" $template ]]
      [[- end ]]

      [[- range $volume_mount := var "volume_mounts" . ]]

      [[ template "volume_mount" $volume_mount ]]
      [[- end ]]

      [[ template "resources" var "resources" . ]]
    }
  }
}
