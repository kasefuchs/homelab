[[ define "job_name" -]]
[[ coalesce ( var "job_name" . ) ( meta "pack.name" . ) | quote ]]
[[- end -]]

[[ define "region" -]]
[[- if var "region" . -]]
  region = "[[ var "region" . ]]"
[[- end -]]
[[- end -]]

[[ define "datacenters" -]]
  datacenters =  [ [[ range $idx, $dc := (var "datacenters" .) ]][[if $idx]],[[end]][[ $dc | quote ]][[ end ]] ]
[[- end -]]

[[ define "resources" -]]
[[- $resources := . -]]
      resources {
        cpu    = [[ $resources.cpu ]]
        memory = [[ $resources.memory ]]
      }
[[- end -]]

[[ define "service" -]]
[[- $service := . -]]
    service {
      name     = [[ $service.name | quote ]]
      port     = [[ $service.port | quote ]]
      tags     = [[ $service.tags | toStringList ]]
      provider = [[ coalesce $service.provider "nomad" | quote ]]
    }
[[- end -]]

[[ define "host_network" -]]
[[- if . -]]
  host_network = "[[ . ]]"
[[- end -]]
[[- end -]]

[[ define "port" -]]
[[- $service := . -]]
      port "[[ $service.port ]]" {
        [[ template "host_network" $service.host_network ]]
      }
[[- end -]]

[[ define "constraints" -]]
[[- range $idx, $constraint := . -]]
  constraint {
    attribute = [[ $constraint.attribute | quote ]]
    [[ if $constraint.operator -]]
    operator  = [[ $constraint.operator | quote ]]
    [[ end -]]
    value     = [[ $constraint.value | quote ]]
  }
[[- end -]]
[[- end -]]

[[ define "env" -]]
        [[- range $key, $var := . ]]
        [[ $key ]] = "[[ $var ]]"
        [[- end ]]
[[- end ]]

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

[[ define "artifact" -]]
[[- $artifact := . -]]
      artifact {
        source      = [[ $artifact.source | quote ]]
        destination = [[ coalesce $artifact.destination "${NOMAD_TASK_DIR}/artifacts" | quote ]]
      }
[[- end -]]

[[ define "csi_plugin" -]]
[[- $csi_plugin := . -]]
      csi_plugin {
        id        = [[ $csi_plugin.id | quote ]]
        type      = [[ $csi_plugin.type | quote ]]
        mount_dir = "/csi"
      }
[[- end -]]
