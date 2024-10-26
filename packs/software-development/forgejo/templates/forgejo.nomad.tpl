job [[ template "job_name" . ]] {
  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "servers" {
    [[ $service := var "service" . -]]
    [[ $data_volume := var "data_volume" . -]]
    [[ $custom_volume := var "custom_volume" . -]]
    [[ $repository_volume := var "repository_volume" . -]]
    
    [[ template "service" $service ]]
    [[ template "volume" $data_volume ]]
    [[ template "volume" $custom_volume ]]
    [[ template "volume" $repository_volume ]]

    network {
      [[ template "port" $service ]]
    }

    task "forgejo" {
      driver = "docker"

      config {
        image   = [[ var "docker_image" . | quote ]]
        ports   = [[ list $service.port | toStringList ]]

        entrypoint = ["/bin/sh", "-c"]
        args       = ["set -a && source ${NOMAD_SECRETS_DIR}/.env && set +a && /usr/bin/entrypoint"]
      }
  
      volume_mount {
        volume      = [[ $data_volume.name | quote ]]
        destination = "${NOMAD_TASK_DIR}/data"
      }
  
      volume_mount {
        volume      = [[ $custom_volume.name | quote ]]
        destination = "${NOMAD_TASK_DIR}/custom"
      }
  
      volume_mount {
        volume      = [[ $repository_volume.name | quote ]]
        destination = "${NOMAD_TASK_DIR}/repository"
      }

      env {
        GITEA_CUSTOM     = "${NOMAD_TASK_DIR}/custom"
        FORGEJO_CUSTOM   = "${NOMAD_TASK_DIR}/custom"
        FORGEJO_WORK_DIR = "${NOMAD_TASK_DIR}/data"
  
        FORGEJO__LOG__ROOT_PATH        = "${NOMAD_ALLOC_DIR}/logs"
        FORGEJO__REPOSITORY__ROOT      = "${NOMAD_TASK_DIR}/repository"
        FORGEJO__SERVER__HTTP_ADDR     = "0.0.0.0"
        FORGEJO__SERVER__HTTP_PORT     = "${NOMAD_PORT_[[ $service.port ]]}"
        FORGEJO__SERVER__DISABLE_SSH   = "true"
        [[ template "env" var "environment" . ]]
      }

      template {
        data = <<EOH
[[ var "dotenv" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/.env"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
