job [[ template "job_name" . ]] {
  datacenters = [[ var "datacenters" . | toStringList ]]

  [[ template "constraints" var "constraints" . ]]

  group "server" {
    network {
      port "lavalink" {
        host_network = "tailscale"
      }
    }

    service {
      provider = "nomad"
      port     = "lavalink"
      name     = [[ var "service_name" . | quote ]]
      tags     = [[ var "service_tags" . | toStringList ]]
    }

    task "lavalink" {
      driver = "java"

      config {
        jar_path = "local/Lavalink.jar"
      }

      artifact {
        source      = [[ var "artifact_source" . | quote ]]
        destination = "local/Lavalink.jar"
        mode        = "file"
      }

      template {
        data = <<EOH
[[ $config := var "lavalink_config_file" . ]][[ fileContents $config ]]
        EOH

        destination = "application.yml"
      }

      [[ template "env_vars" var "env" . ]]

      resources {
        cpu    = [[ var "resources.cpu" . ]]
        memory = [[ var "resources.memory" . ]]
      }
    }
  }
}
