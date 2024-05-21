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

    task "cinny" {
      driver = "docker"

      config {
        image   = "busybox:stable"
        command = "httpd"
        args    = [
          "-v", "-f", 
          "-p", "${NOMAD_PORT_[[ $service.port ]]}", 
          "-c", "${NOMAD_TASK_DIR}/httpd/httpd.conf"
        ]
        ports   = [[ list $service.port | toStringList ]]
      }

      artifact {
        source      = [[ var "artifact_source" . | quote ]]
        destination = "${NOMAD_TASK_DIR}/cinny"
      }

      template {
        data = <<EOH
[[ var "config" . ]]
        EOH

        destination = [[ var "config_path" . | quote ]]
      }

      template {
        data = <<EOH
H:[[ var "home_path" . ]]
I:index.html
E404:index.html
        EOH

        destination = "${NOMAD_TASK_DIR}/httpd/httpd.conf"
      }

      [[ template "resources" var "resources" . ]]
    }
  }
}
