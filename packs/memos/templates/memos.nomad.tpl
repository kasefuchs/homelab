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

    task "memos" {
      driver = "docker"

      config {
        image   = "ghcr.io/usememos/memos:0.22.3"
        ports   = [[ list $service.port | toStringList ]]
      }

      env {
        MEMOS_ADDR = "0.0.0.0"
        MEMOS_PORT = "${NOMAD_PORT_[[ $service.port ]]}"

        [[ template "env" var "environment" . ]]
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
