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

    task "imgproxy" {
      driver = "docker"

      config {
        image = "darthsim/imgproxy:v3.24.1"

        ports   = [[ list $service.port | toStringList ]]
      }

      [[ template "env" . ]]

      [[ template "resources" var "resources" . ]]
    }
  }
}