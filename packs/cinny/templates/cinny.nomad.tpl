job [[ template "job_name" . ]] {
  type = "service"

  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]
  
  group "application" {
    count = [[ var "count" . ]]
    [[ $service := var "service" . ]]
    network {
      port "[[ $service.port ]]" {
        [[ template "host_network" var "host_network" . ]]
      }
    }

    [[ template "service" $service ]]

    task "application" {
      driver = "docker"

      config {
        image   = "busybox:1"
        command = "httpd"
        args    = [
          "-v", "-f", 
          "-p", "${NOMAD_PORT_[[ $service.port ]]}", 
          "-h", [[ var "home_path" . | quote ]]
        ]
        ports   = [ [[ $service.port | quote]] ]
      }

      artifact {
        source = [[ var "artifact" . | quote ]]
        destination = "local"
      }

      template {
        data = <<EOH
[[ template "config" var "config" . ]]
        EOH

        destination = [[ var "config_path" . | quote ]]
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
