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
        sidecar_service {
          proxy {
            [[- range $idx, $upstream := $service.proxy_upstreams ]]
            upstreams {
              destination_name = [[ $upstream.name | quote ]]
              local_bind_port  = [[ $upstream.port ]]
            }
            [[- end ]]
          }
        }
        [[ if $service.sidecar_resources -]]
        sidecar_task {
          [[ template "resources" $service.sidecar_resources ]]
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
