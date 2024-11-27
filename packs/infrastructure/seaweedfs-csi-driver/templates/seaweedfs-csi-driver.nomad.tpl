job [[ template "job_name" . ]] {
  type = [[ var "type" . | quote ]]

  [[ template "datacenters" . ]]
  [[ template "region" . ]]
  [[ template "constraints" var "constraints" . ]]

  group "drivers" {
    task "seaweedfs-csi" {
      driver = "docker"

      config {
        image  = [[ var "docker_image" . | quote ]]

        entrypoint = ["/seaweedfs-csi-driver"]
        args       = ["-options=${NOMAD_SECRETS_DIR}/.cli"]

        volumes    = ["/etc/seaweedfs:/etc/seaweedfs:ro"]
        privileged = true
      }

      env {
        WEED_ENDPOINT = "unix://csi/csi.sock"
        WEED_NODEID   = "${node.unique.name}"
        WEED_LOGDIR   = "${NOMAD_ALLOC_DIR}/logs"
        WEED_CACHEDIR = "${NOMAD_TASK_DIR}/tmp"
        [[- template "env" var "environment" . ]]
      }

      template {
        data = <<EOH
[[ var "options" . ]]
        EOH

        change_mode = "noop"
        destination = "${NOMAD_SECRETS_DIR}/.cli"
      }

      [[ template "csi_plugin" var "csi_plugin" . ]]

      [[ template "resources" var "resources" . ]]
    }
  }
}
