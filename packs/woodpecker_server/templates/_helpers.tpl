[[ define "job_name" -]]
[[ coalesce ( var "job_name" . ) ( meta "pack.name" . ) | quote ]]
[[- end -]]

[[ define "region" -]]
[[- if var "region" . -]]
  region = "[[ var "region" . ]]"
[[- end -]]
[[- end -]]

[[ define "host_network" -]]
[[- if . -]]
  host_network = "[[ . ]]"
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
[[- $http_service := var "http_service" . -]]
[[- $grpc_service := var "grpc_service" . -]]
[[- $environment := var "environment" . -]]
      env {
        WOODPECKER_SERVER_ADDR = ":${NOMAD_PORT_[[ $http_service.port ]]}"
        WOODPECKER_GRPC_ADDR = ":${NOMAD_PORT_[[ $grpc_service.port ]]}"
        [[- range $key, $var := $environment ]]
        [[ $key ]] = "[[ $var ]]"
        [[- end ]]
      }
[[- end ]]
