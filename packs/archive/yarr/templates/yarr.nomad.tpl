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

    task "yarr" {
      driver = "docker"

      config {
        image = "jgkawell/yarr:v3.1.3"
        ports = [[ list $service.port | toStringList ]]
      }

      env {
        YARR_ADDR = ":${NOMAD_PORT_[[ $service.port ]]}"
        [[ template "env" var "environment" . ]]
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
