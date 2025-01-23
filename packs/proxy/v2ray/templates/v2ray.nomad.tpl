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

    [[- $vault := var "vault" . -]]
    [[- if $vault ]]

    [[ template "vault" $vault ]]
    [[- end ]]

    task "v2ray" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        args  = [[ var "arguments" . | toStringList ]]
      }

      [[- range $idx, $template := var "templates" . ]]

      template {
        data = <<EOH
[[ $template.data ]]
        EOH
        destination = [[ $template.destination | quote ]]
        change_mode = [[ $template.change_mode | quote ]]
      }
      [[- end ]]

      [[ template "resources" var "resources" . ]]
    }
  }
}
