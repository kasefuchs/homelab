[[ define "job_name" -]]
[[ coalesce ( var "job_name" . ) ( meta "pack.name" . ) | quote ]]
[[- end -]]

[[ define "ui" -]]
[[- $ui := . -]]
  ui {
    [[ if $ui.description -]]
    description = [[ $ui.description | quote ]]
    [[ end -]]
    [[- range $idx, $link := $ui.links ]]
    link {
      label = [[ $link.label | quote ]]
      url   = [[ $link.url | quote ]]
    }
    [[- end ]]
  }
[[- end -]]

[[ define "port" -]]
[[- $port := . -]]
      port [[ $port.name | quote ]] {
        [[ if $port.to -]]
        to           = [[ $port.to ]]
        [[ end -]]
        [[ if $port.static -]]
        static       = [[ $port.static ]]
        [[ end -]]
        [[ if $port.host_network -]]
        host_network = [[ $port.host_network | quote ]]
        [[ end -]]
      }
[[- end -]]

[[ define "dns" -]]
[[- $dns := . -]]
      dns {
        [[ if ne $dns.servers nil -]]
        servers  = [[ $dns.servers | toStringList ]]
        [[ end -]]
        [[ if ne $dns.searches nil -]]
        searches = [[ $dns.searches | toStringList ]]
        [[ end -]]
        [[ if ne $dns.options nil -]]
        options  = [[ $dns.options | toStringList ]]
        [[ end -]]
      }
[[- end -]]

[[ define "network" -]]
[[- $network := . -]]
    network {
      mode = [[ $network.mode | quote ]]
      [[- range $idx, $port := $network.ports ]]
      [[ template "port" $port ]]
      [[- end ]]
      [[ if $network.dns -]]
      [[ template "dns" $network.dns ]]
      [[ end -]]
    }
[[- end -]]

[[ define "sidecar_task" -]]
[[- $sidecar_task := . -]]
        sidecar_task {
          [[ if $sidecar_task.resources -]]
          [[ template "resources" $sidecar_task.resources ]]
          [[ end -]]
        }
[[- end -]]

[[ define "sidecar_service" -]]
[[- $sidecar_service := . -]]
        sidecar_service {
          [[ if $sidecar_service.port -]]
          port = [[ $sidecar_service.port | quote ]]
          [[ end -]]
          [[ template "proxy" $sidecar_service.proxy ]]
        }
[[- end -]]

[[ define "proxy" -]]
[[- $proxy := . -]]
          proxy {
            [[ if $proxy.expose -]]
            [[ template "expose" $proxy.expose ]]
            [[ end -]]
            [[- range $upstream := $proxy.upstreams ]]
            [[ template "upstream" $upstream ]]
            [[- end ]]
          }
[[- end -]]

[[ define "expose" -]]
[[- $expose := . -]]
            expose {
              [[- range $path := $expose ]]
              path {
                path            = [[ $path.path | quote ]]
                protocol        = [[ $path.protocol | quote ]]
                listener_port   = [[ $path.listener_port | quote ]]
                local_path_port = [[ $path.local_port ]]
              }
              [[- end ]]
            }
[[- end -]]

[[ define "upstream" -]]
[[- $upstream := . -]]
            upstreams {
              local_bind_port  = [[ $upstream.port ]]
              destination_name = [[ $upstream.name | quote ]]
            }
[[- end -]]

[[ define "connect" -]]
[[- $connect := . -]]
      connect {
        native = [[ $connect.native ]]
        [[ if $connect.sidecar -]]
        [[ if $connect.sidecar.task -]]
        [[ template "sidecar_task" $connect.sidecar.task ]]
        [[ end -]]
        [[ template "sidecar_service" $connect.sidecar.service ]]
        [[ end -]]
      }
[[- end -]]

[[ define "service" -]]
[[- $service := . -]]
    service {
      name     = [[ $service.name | quote ]]
      port     = [[ $service.port | quote ]]
      tags     = [[ $service.tags | toStringList ]]
      provider = [[ $service.provider | quote ]]
      [[ if $service.connect -]]
      [[ template "connect" $service.connect ]]
      [[ end -]]
      [[ if $service.checks -]]
      [[- range $idx, $check := $service.checks ]]
      [[ template "check" $check ]]
      [[- end ]]
      [[- end ]]
    }
[[- end -]]

[[ define "check" -]]
[[- $check := . -]]
      check {
        [[ if $check.address_mode -]]
        address_mode = [[ $check.address_mode | quote ]]
        [[ end -]]
        [[ if $check.args -]]
        args = [[ $check.args | toStringList ]]
        [[ end -]]
        [[ if ne $check.check_restart nil -]]
        [[ template "check_restart" $check.check_restart ]]
        [[ end -]]
        [[ if $check.command -]]
        command = [[ $check.command | quote ]]
        [[ end -]]
        interval = [[ $check.interval | quote ]]
        [[ if $check.method -]]
        method = [[ $check.method | quote ]]
        [[ end -]]
        [[ if $check.body -]]
        body = [[ $check.body | quote ]]
        [[ end -]]
        [[ if $check.name -]]
        name = [[ $check.name | quote ]]
        [[ end -]]
        [[ if $check.path -]]
        path = [[ $check.path | quote ]]
        [[ end -]]
        [[ if $check.expose -]]
        expose = [[ $check.expose ]]
        [[ end -]]
        [[ if $check.port -]]
        port = [[ $check.port | quote ]]
        [[ end -]]
        [[ if $check.protocol -]]
        protocol = [[ $check.protocol | quote ]]
        [[ end -]]
        [[ if $check.task -]]
        task = [[ $check.task | quote ]]
        [[ end -]]
        timeout = [[ $check.timeout | quote ]]
        type = [[ $check.type | quote ]]
      }
[[- end -]]

[[ define "check_restart" -]]
[[- $check_restart := . -]]
        check_restart {
          [[ if $check_restart.limit -]]
          limit = [[ $check_restart.limit | quote ]]
          [[ end -]]
          [[ if $check_restart.grace -]]
          grace = [[ $check_restart.grace | quote ]]
          [[ end -]]
          ignore_warnings = [[ $check_restart.ignore_warnings ]]
        }
[[- end -]]

[[ define "resources" -]]
[[- $resources := . -]]
      resources {
        cpu    = [[ $resources.cpu ]]
        memory = [[ $resources.memory ]]
        [[ if $resources.memory_max -]]
        memory_max = [[ $resources.memory_max ]]
        [[ end -]]
      }
[[- end -]]

[[ define "constraint" -]]
[[- $constraint := . -]]
  constraint {
    attribute = [[ $constraint.attribute | quote ]]
    [[ if $constraint.operator -]]
    operator  = [[ $constraint.operator | quote ]]
    [[ end -]]
    value     = [[ $constraint.value | quote ]]
  }
[[- end -]]

[[ define "vault" -]]
[[- $vault := . -]]
    vault {
      env           = [[ $vault.env ]]
      [[ if $vault.role -]]
      role          = [[ $vault.role | quote ]]
      [[ end -]]
      [[ if $vault.change_mode -]]
      change_mode   = [[ $vault.change_mode | quote ]]
      [[ end -]]
      [[ if $vault.change_signal -]]
      change_signal = [[ $vault.change_signal | quote ]]
      [[ end -]]
    }
[[- end -]]

[[ define "identity" -]]
[[- $identity := . -]]
      identity {
        env  = [[ $identity.env ]]
        file = [[ $identity.file ]]
        [[ if $identity.name -]]
        name = [[ $identity.name | quote ]]
        [[ end -]]
        [[ if ne $identity.audience nil -]]
        aud = [[ $identity.audience | toStringList ]]
        [[ end -]]
        [[ if $identity.change_mode -]]
        change_mode   = [[ $identity.change_mode | quote ]]
        [[ end -]]
        [[ if $identity.change_signal -]]
        change_signal = [[ $identity.change_signal | quote ]]
        [[ end -]]
      }
[[- end -]]

[[ define "consul" -]]
[[- $consul := . -]]
    consul {
    }
[[- end -]]

[[ define "template" -]]
[[- $template := . -]]
      template {
        data          = [[ $template.data | quote ]]
        destination   = [[ $template.destination | quote ]]
        [[ if $template.change_mode -]]
        change_mode   = [[ $template.change_mode | quote ]]
        [[ end -]]
        [[ if $template.change_signal -]]
        change_signal = [[ $template.change_signal | quote ]]
        [[ end -]]
        [[ if $template.env -]]
        env = [[ $template.env ]]
        [[ end -]]
      }
[[- end -]]

[[ define "volume" -]]
[[- $volume := . -]]
    volume [[ $volume.name | quote ]] {
      type      = [[ $volume.type | quote ]]
      source    = [[ $volume.source | quote ]]
      read_only = [[ $volume.read_only ]]
      [[ if eq $volume.type "csi" -]]
      access_mode     = [[ $volume.access_mode | quote ]]
      attachment_mode = [[ $volume.attachment_mode | quote ]]
      [[ end -]]
    }
[[- end -]]

[[ define "volume_mount" -]]
[[- $volume_mount := . -]]
      volume_mount {
        volume        = [[ $volume_mount.volume | quote ]]
        destination   = [[ $volume_mount.destination | quote ]]
        read_only     = [[ $volume_mount.read_only ]]
        [[ if $volume_mount.selinux_label -]]
        selinux_label = [[ $volume_mount.selinux_label | quote ]]
        [[ end -]]
      }
[[- end -]]

[[ define "environment" -]]
      env {
        [[- range $key, $var := . ]]
        [[ $key ]] = "[[ $var ]]"
        [[- end ]]
      }
[[- end ]]

[[ define "artifact" -]]
[[- $artifact := . -]]
      artifact {
        mode          = [[ $artifact.mode | quote ]]
        source        = [[ $artifact.source | quote ]]
        destination   = [[ $artifact.destination | quote ]]
      }
[[- end -]]

[[ define "docker_config" -]]
[[- $docker_config := . -]]
      config {
        image       = [[ $docker_config.image | quote ]]
        [[ if ne $docker_config.entrypoint nil -]]
        entrypoint  = [[ $docker_config.entrypoint | toStringList ]]
        [[ end -]]
        [[ if ne $docker_config.args nil -]]
        args        = [[ $docker_config.args | toStringList ]]
        [[ end -]]
        volumes     = [[ $docker_config.volumes | toStringList ]]
        privileged  = [[ $docker_config.privileged ]]
      }
[[- end -]]

[[ define "restart" -]]
[[- $restart := . -]]
    restart {
      mode     = [[ $restart.mode | quote ]]
      delay    = [[ $restart.delay | quote ]]
      interval = [[ $restart.interval | quote ]]
      attempts = [[ $restart.attempts ]]
    }
[[- end -]]
