job [[ template "job_name" . ]] {
  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "servers" {
    [[ $service := var "service" . -]]

    count = [[ var "count" . ]]

    [[ template "service" $service ]]

    network {
      [[ template "port" $service ]]
    }

    task "matrix-media-repo" {
      driver = "docker"

      config {
        image = [[ var "docker_image" . | quote ]]
        ports = [[ list $service.port | toStringList ]]
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/repo.yml"
      }

      env {
        REPO_CONFIG    = "${NOMAD_SECRETS_DIR}/config/repo.yml"
        REPO_BIND_PORT = "${NOMAD_PORT_[[ $service.port ]]}"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
