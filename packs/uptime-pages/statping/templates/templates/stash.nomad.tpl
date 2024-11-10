job [[ template "job_name" . ]] {
  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "servers" {
    [[ $service := var "service" . -]]
    [[ $blobs_volume := var "blobs_volume" . -]]
    [[ $media_volume := var "media_volume" . -]]
    [[ $database_volume := var "database_volume" . -]]
    [[ $generated_volume := var "generated_volume" . -]]

    [[ template "service" $service ]]
    [[ template "volume" $blobs_volume ]]
    [[ template "volume" $media_volume ]]
    [[ template "volume" $database_volume  ]]
    [[ template "volume" $generated_volume ]]

    network {
      [[ template "port" $service ]]
    }

    task "stash" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]

        entrypoint = ["/bin/sh", "-c"]
        args       = ["set -a && source ${NOMAD_SECRETS_DIR}/stash.env && set +a && /usr/bin/stash"]
      }

      volume_mount {
        volume      = [[ $blobs_volume.name | quote ]]
        destination = "${NOMAD_TASK_DIR}/mnt/blobs"
      }

      volume_mount {
        volume      = [[ $media_volume.name | quote ]]
        destination = "${NOMAD_TASK_DIR}/mnt/media"
      }

      volume_mount {
        volume      = [[ $database_volume.name | quote ]]
        destination = "${NOMAD_TASK_DIR}/mnt/database"
      }

      volume_mount {
        volume      = [[ $generated_volume.name | quote ]]
        destination = "${NOMAD_TASK_DIR}/mnt/generated"
      }

      env {
        STASH_HOST          = "0.0.0.0"
        STASH_PORT          = "${NOMAD_PORT_[[ $service.port ]]}"
        STASH_BLOBS_DIR     = "${NOMAD_TASK_DIR}/mnt/blobs"
        STASH_CACHE_DIR     = "${NOMAD_TASK_DIR}/tmp/cache"
        STASH_MEDIA_DIR     = "${NOMAD_TASK_DIR}/mnt/media"
        STASH_CONFIG_FILE   = "${NOMAD_SECRETS_DIR}/stash.yml"
        STASH_DATABASE_DIR  = "${NOMAD_TASK_DIR}/mnt/database"
        STASH_GENERATED_DIR = "${NOMAD_TASK_DIR}/mnt/generated"
        [[ template "env" var "environment" . ]]
      }

      template {
        data = <<EOH
[[ var "dotenv" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/stash.env"
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/stash.yml"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
