job [[ template "job_name" . ]] {
  type = "service"

  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]
  
  group "servers" {
    count = [[ var "count" . ]]
    [[ $service := var "service" . ]]
    network {
      port "[[ $service.port ]]" {
        [[ template "host_network" var "host_network" . ]]
      }
    }

    [[ template "service" $service ]]

    task "cinny" {
      driver = "docker"

      config {
        image   = "busybox:stable"
        command = "httpd"
        args    = [
          "-v", "-f", 
          "-p", "${NOMAD_PORT_[[ $service.port ]]}", 
          "-c", "local/httpd/httpd.conf"
        ]
        ports   = [ [[ $service.port | quote ]] ]
      }

      artifact {
        source = [[ var "artifact" . | quote ]]
        destination = "local/cinny"
      }

      template {
        data = <<EOH
[[ template "cinny_config" . ]]
        EOH

        destination = [[ var "config_path" . | quote ]]
      }

      template {
        data = <<EOH
[[ template "httpd_config" . ]]
        EOH

        destination = "local/httpd/httpd.conf"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
