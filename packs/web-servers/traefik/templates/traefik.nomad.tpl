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

    service {
      name = [[ ( var "service" . ).name | quote ]]
      port = [[ ( var "service" . ).port | quote ]]
      tags = [[ ( var "service" . ).tags | toStringList ]]
      [[ if ( var "service" . ).connect -]]
      connect {
        native = true
      }
      [[- end ]]
    }

    [[- if var "vault" . ]]

    vault {
      role = [[ ( var "vault" . ).role | quote ]]
    }
    [[- end ]]

    task "traefik" {
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
