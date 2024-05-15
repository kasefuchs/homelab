job [[ template "job_name" . ]] {
  type = "service"

  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "servers" {
    [[ $service := var "service" . -]]
    count = [[ var "count" . ]]

    network {
      port "[[ $service.port ]]" {
        [[ template "host_network" var "host_network" . ]]
      }
    }

    [[ template "service" $service ]]

    task "imgproxy" {
      driver = "docker"

      config {
        image = "darthsim/imgproxy:v3.24.1"

        ports   = [ [[ $service.port | quote ]] ]
      }

      [[ template "env" . ]]

      [[ template "resources" var "resources" . ]]
    }
  }
}