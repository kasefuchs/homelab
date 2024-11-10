job [[ template "job_name" . ]] {
  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]
  
  group "servers" {
    [[ $services := var "services" . -]]

    [[ range $idx, $service := $services ]]
    [[ template "service" $service -]]
    [[ end ]]

    network {
      [[ range $idx, $service := $services ]]
      [[ template "port" $service -]]
      [[ end ]]
    }

    task "xray" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [ [[ range $idx, $service := $services ]][[if $idx]],[[end]][[ $service.port | quote ]][[ end ]] ]

        entrypoint = ["/usr/bin/xray"]
        args       = ["-config=${NOMAD_SECRETS_DIR}/config/xray.json"]
      }

      template {
        data = <<EOH
[[ var "config" . -]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/xray.json"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
