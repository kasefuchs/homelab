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

    task "navidrome" {
      driver = "docker"

      config {
        image   = "deluan/navidrome:0.52.5"
        ports   = [[ list $service.port | toStringList ]]
      }

      volume_mount {
        volume      = [[ $volume.name | quote ]]
        destination = "${NOMAD_TASK_DIR}/data"
      }

      env {
        ND_PORT        = "${NOMAD_PORT_[[ $service.port ]]}"
        ND_MUSICFOLDER = "${NOMAD_TASK_DIR}/data/music"
        ND_DATAFOLDER  = "${NOMAD_TASK_DIR}/data/database"
        ND_CACHEFOLDER = "${NOMAD_TASK_DIR}/data/cache"
        [[ template "env" var "environment" . ]]
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
