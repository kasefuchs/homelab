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

    task "byedpi" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]

        entrypoint = ["/opt/byedpi/ciadpi", "--ip=0.0.0.0", "--port=${NOMAD_PORT_[[ $service.port ]]}"]
        args       = [[ var "arguments" . | toStringList ]]
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
