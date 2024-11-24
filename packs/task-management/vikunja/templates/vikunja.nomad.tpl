job [[ template "job_name" . ]] {
  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "servers" {
    [[ $service := var "service" . -]]
    [[ $files_volume := var "files_volume" . -]]

    [[ template "service" $service ]]
    [[ template "volume" $files_volume ]]

    network {
      [[ template "port" $service ]]
    }

    task "vikunja" {
      driver = "docker"

      config {
        image   = [[ var "docker_image" . | quote ]]
        ports   = [[ list $service.port | toStringList ]]

        entrypoint = ["/bin/sh", "-c"]
        args       = ["set -a && source ${NOMAD_SECRETS_DIR}/.env && set +a && /app/vikunja/vikunja"]
      }

      volume_mount {
        volume      = [[ $files_volume.name | quote ]]
        destination = "${NOMAD_TASK_DIR}/files"
      }

      env {
        VIKUNJA_FILES_BASEPATH    = "${NOMAD_TASK_DIR}/files"
        VIKUNJA_SERVICE_ROOTPATH  = "${NOMAD_SECRETS_DIR}"
        VIKUNJA_SERVICE_INTERFACE = ":${NOMAD_PORT_[[ $service.port ]]}"
        [[ template "env" var "environment" . ]]
      }

      template {
        data = <<EOH
[[ var "dotenv" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/.env"
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config.yml"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
