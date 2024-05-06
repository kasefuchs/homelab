job [[ template "job_name" . ]] {
  type = "system"

  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "agents" {
    network {
      port "engine" {
        [[ template "host_network" var "host_network" . ]]
      }
    }

    task "woodpecker" {
      driver = "docker"

      config {
        image = "woodpeckerci/woodpecker-agent:v2.4.1"
      }

      [[ template "env" var "environment" . ]]

      [[ template "resources" var "agent_resources" . ]]
    }

    task "engine" {
      driver = "docker"

      config {
        image = "docker:26-dind"

        command = "dockerd"
        args    = ["-H", "tcp://0.0.0.0:${NOMAD_PORT_engine}", "--tls=false"]

        privileged = true
        ports      = ["engine"]
      }

      lifecycle {
        hook    = "prestart"
        sidecar = true
      }

      [[ template "resources" var "engine_resources" . ]]
    }
  }
}