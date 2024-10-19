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

    task "v2ray-exporter" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]

        entrypoint = ["/bin/sh", "-c"]
        args       = ["/usr/bin/v2ray-exporter --listen=0.0.0.0:${NOMAD_PORT_[[ $service.port ]]} $(cat ${NOMAD_SECRETS_DIR}/.argv)"]
      }

      template {
        data        = [[ var "arguments" . | quote ]]
        destination = "${NOMAD_SECRETS_DIR}/.argv"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
