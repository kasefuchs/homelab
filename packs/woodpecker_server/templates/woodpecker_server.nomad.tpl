job [[ template "job_name" . ]] {
  type = "service"

  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "servers" {
    [[ $http_service := var "http_service" . -]]
    [[ $grpc_service := var "grpc_service" . -]]

    network {
      port "[[ $http_service.port ]]" {
        [[ template "host_network" var "host_network" . ]]
      }

      port "[[ $grpc_service.port ]]" {
        [[ template "host_network" var "host_network" . ]]
      }
    }

    [[ template "service" $http_service ]]

    [[ template "service" $grpc_service ]]

    task "woodpecker" {
      driver = "docker"

      config {
        image = "woodpeckerci/woodpecker-server:v2.4.1"

        ports   = [[ list $http_service.port $grpc_service.port | toStringList ]]
      }

      [[ template "env" . ]]

      [[ template "resources" var "resources" . ]]
    }
  }
}