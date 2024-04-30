job [[ template "job_name" . ]] {
  type = "system"

  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]
  
  group "servers" {
    task "diun" {
      driver = "docker"

      config {
        image = "crazymax/diun:latest"
        args  = ["serve"] 

        mount {
          type = "bind"
          target = "/var/run/docker.sock"
          source = "/var/run/docker.sock"
        }
      }

      [[ template "env" var "environment" . ]]

      [[ template "resources" var "resources" . ]]
    }
  }
}
