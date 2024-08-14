job [[ template "job_name" . ]] {
  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "servers" {
    [[ $volume := var "volume" . -]]
    [[ $service := var "service" . -]]

    [[ template "volume" $volume ]]
    [[ template "service" $service ]]

    network {
      [[ template "port" $service ]]
    }

    task "vaultwarden" {
      driver = "docker"

      config {
        image   = [[ var "docker_image" . | quote ]]
        ports   = [[ list $service.port | toStringList ]]
      }

      volume_mount {
        volume      = [[ $volume.name | quote ]]
        destination = "${NOMAD_TASK_DIR}/data"
      }

      env {
        ROCKET_PORT = "${NOMAD_PORT_[[ $service.port ]]}"
        DATA_FOLDER = "${NOMAD_TASK_DIR}/data"
        [[ template "env" var "environment" . ]]
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
