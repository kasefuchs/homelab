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

    task "nats" {
      driver = "docker"

      config {
        image   = "nats:2.10.16-alpine"
        args    = [
          "-a", "0.0.0.0",
          "-n", "${NOMAD_ALLOC_ID}",
          "-p", "${NOMAD_PORT_[[ $service.port ]]}",
          "-js", "-sd", "${NOMAD_TASK_DIR}/storage"
        ]
        ports   = [[ list $service.port | toStringList ]]
      }

      volume_mount {
        volume      = [[ $volume.name | quote ]]
        destination = "${NOMAD_TASK_DIR}/storage"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
