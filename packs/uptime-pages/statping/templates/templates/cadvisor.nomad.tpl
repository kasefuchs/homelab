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

    task "cadvisor" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]
        args  = ["--port=${NOMAD_PORT_[[ $service.port ]]}"]

        mount {
          type = "bind"
          source = "/"
          target = "/rootfs"
          readonly = true
        }

        mount {
          type = "bind"
          source = "/var/run"
          target = "/var/run"
          readonly = false
        }

        mount {
          type = "bind"
          source = "/sys"
          target = "/sys"
          readonly = true
        }

        mount {
          type = "bind"
          source = "/var/lib/docker"
          target = "/var/lib/docker"
          readonly = true
        }
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
