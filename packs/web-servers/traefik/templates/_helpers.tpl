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
        to           = [[ $port.to ]]
        static       = [[ $port.static ]]
        [[ if $port.host_network -]]
        host_network = [[ $port.host_network | quote ]]
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
