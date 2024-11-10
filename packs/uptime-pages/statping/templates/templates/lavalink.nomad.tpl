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

    task "lavalink" {
      driver = "docker"

      config {
        image   = [[ var "docker_image" . | quote ]]
        ports   = [[ list $service.port | toStringList ]]

        entrypoint = ["java", "-jar", "/opt/Lavalink/Lavalink.jar"]
        args       = ["--spring.config.location=${NOMAD_SECRETS_DIR}/config/lavalink.yaml"]
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = "${NOMAD_SECRETS_DIR}/config/lavalink.yaml"
      }

      env {
        SERVER_PORT    = "${NOMAD_PORT_[[ $service.port ]]}"
        SERVER_ADDRESS = "0.0.0.0"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
