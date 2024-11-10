job [[ template "job_name" . ]] {
  type = "system"

  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "servers" {
    [[ $service := var "service" . -]]

    [[ template "service" $service ]]

    network {
      [[ template "port" $service ]]
    }

    task "node-exporter" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]
        args  = ["--path.rootfs=/host",  "--web.listen-address=0.0.0.0:${NOMAD_PORT_[[ $service.port ]]}"]

        mount {
          type = "bind"

          source = "/"
          target = "/host"

          readonly = true
          bind_options {
            propagation = "rslave"
          }
        }
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
