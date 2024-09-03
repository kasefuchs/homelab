job [[ template "job_name" . ]] {
  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]
  
  group "servers" {
    [[ $service := var "service" . -]]

    [[ template "service" $service ]]

    network {
      [[ template "port" $service ]]
    }

    task "wakapi" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]

        entrypoint = ["/wakapi"]
        args       = ["-config=${NOMAD_SECRETS_DIR}/config/wakapi.yaml"]
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/wakapi.yaml"
      }

      env {
        WAKAPI_PORT             = "${NOMAD_PORT_[[ $service.port ]]}"
        WAKAPI_LISTEN_IPV4      = "0.0.0.0"
        WAKAPI_LISTEN_IPV6      = "-"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
