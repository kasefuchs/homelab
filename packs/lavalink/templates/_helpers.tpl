// allow nomad-pack to set the job name

[[- define "job_name" -]]
[[ coalesce ( var "job_name" .) (meta "pack.name" .) | quote ]]
[[- end -]]

// additional job constraints

[[ define "constraints" -]]
[[ range $idx, $constraint := . ]]
  constraint {
    attribute = [[ $constraint.attribute | quote ]]
    [[ if $constraint.operator -]]
    operator  = [[ $constraint.operator | quote ]]
    [[ end -]]
    value     = [[ $constraint.value | quote ]]
  }
[[ end -]]
[[- end -]]

// task env vars

[[ define "env_vars" -]]
      env {
        [[- range $key, $value := . ]]
        [[ $key ]] = [[ $value | quote ]]
        [[- end ]]
      }
[[- end ]]
