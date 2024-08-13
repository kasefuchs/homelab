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

    task "miniflux" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]

        entrypoint = ["/usr/bin/miniflux"]
        args       = ["-config-file=${NOMAD_SECRETS_DIR}/config/miniflux.ini"]
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/miniflux.ini"
      }

      env {
        PORT           = "${NOMAD_PORT_[[ $service.port ]]}"
        RUN_MIGRATIONS = "1"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
