[[ define "job_name" -]]
[[ coalesce ( var "job_name" . ) ( meta "pack.name" . ) | quote ]]
[[- end -]]

[[ define "ui_description" -]]
[[ coalesce ( var "ui_description" .) ( meta "pack.description" . ) | quote ]]
[[- end -]]

[[ define "job_type" -]]
  type = [[ var "job_type" . | quote ]]
[[- end -]]

[[ define "region" -]]
  region = [[ var "region" . | quote ]]
[[- end -]]

[[ define "namespace" -]]
  namespace = [[ var "namespace" . | quote ]]
[[- end -]]

[[ define "datacenters" -]]
  datacenters = [[ var "datacenters" . | toStringList ]]
[[- end -]]

[[ define "port" -]]
[[- $port := . -]]
      port [[ $port.name | quote ]] {
        [[ if $port.to -]]
        to           = [[ $port.to ]]
        [[ end -]]
        [[ if $port.static -]]
        static       = [[ $port.static ]]
        [[ end -]]
        [[ if $port.host_network -]]
        host_network = [[ $port.host_network | quote ]]
        [[ end -]]
      }
[[- end -]]

[[ define "service" -]]
[[- $service := . -]]
    service {
      name = [[ $service.name | quote ]]
      port = [[ $service.port | quote ]]
      tags = [[ $service.tags | toStringList ]]
      [[ if $service.connect -]]
      connect {
        [[ if $service.connect.native -]]
        native = [[ $service.connect.native ]]
        [[ end -]]
        [[ if $service.connect.sidecar -]]
        [[ if $service.connect.sidecar.resources -]]
        sidecar_task {
          [[ template "resources" $service.connect.sidecar.resources ]]
        }
        [[ end -]]
        sidecar_service {
          [[ if $service.connect.sidecar.upstreams -]]
          proxy {
            [[- range $idx, $upstream := $service.connect.sidecar.upstreams ]]
            upstreams {
              destination_name = [[ $upstream.name | quote ]]
              local_bind_port  = [[ $upstream.port ]]
            }
            [[- end ]]
          }
          [[ end -]]
        }
        [[ end -]]
      }
      [[ end -]]
    }
[[- end -]]

[[ define "resources" -]]
[[- $resources := . -]]
      resources {
        cpu    = [[ $resources.cpu ]]
        memory = [[ $resources.memory ]]
      }
[[- end -]]

[[ define "constraint" -]]
[[- $constraint := . -]]
  constraint {
    attribute = [[ $constraint.attribute | quote ]]
    [[ if $constraint.operator -]]
    operator  = [[ $constraint.operator | quote ]]
    [[ end -]]
    value     = [[ $constraint.value | quote ]]
  }
[[- end -]]

[[ define "vault" -]]
[[- $vault := . -]]
    vault {
      [[ if $vault.role -]]
      role = [[ $vault.role | quote ]]
      [[ end -]]
    }
[[- end -]]

[[ define "template" -]]
[[- $template := . -]]
      template {
        data = <<EOH
[[ $template.data ]]
        EOH
        destination = [[ $template.destination | quote ]]
        [[ if $template.change_mode -]]
        change_mode = [[ $template.change_mode | quote ]]
        [[ end -]]
      }
[[- end -]]

[[ define "volume" -]]
[[- $volume := . -]]
    volume [[ $volume.name | quote ]] {
      type      = [[ $volume.type | quote ]]
      source    = [[ $volume.source | quote ]]
      read_only = [[ $volume.read_only ]]
      [[ if eq $volume.type "csi" -]]
      access_mode     = [[ $volume.access_mode | quote ]]
      attachment_mode = [[ $volume.attachment_mode | quote ]]
      [[ end -]]
    }
[[- end -]]

[[ define "volume_mount" -]]
[[- $volume_mount := . -]]
      volume_mount {
        volume        = [[ $volume_mount.volume | quote ]]
        destination   = [[ $volume_mount.destination | quote ]]
        read_only     = [[ $volume_mount.read_only ]]
        [[ if $volume_mount.selinux_label -]]
        selinux_label = [[ $volume_mount.selinux_label | quote ]]
        [[ end -]]
      }
[[- end -]]

[[ define "env" -]]
        [[- range $key, $var := . ]]
        [[ $key ]] = "[[ $var ]]"
        [[- end ]]
[[- end ]]

[[ define "artifact" -]]
[[- $artifact := . -]]
      artifact {
        mode          = [[ $artifact.mode | quote ]]
        source        = [[ $artifact.source | quote ]]
        destination   = [[ $artifact.destination | quote ]]
      }
[[- end -]]

[[ define "docker_config" -]]
[[- $docker_config := . -]]
      config {
        image       = [[ $docker_config.image | quote ]]
        [[ if ne $docker_config.entrypoint nil -]]
        entrypoint  = [[ $docker_config.entrypoint | toStringList ]]
        [[ end -]]
        [[ if ne $docker_config.args nil -]]
        args        = [[ $docker_config.args | toStringList ]]
        [[ end -]]
        [[ if $docker_config.volumes -]]
        volumes     = [[ $docker_config.volumes | toStringList ]]
        [[ end -]]
      }
[[- end -]]
