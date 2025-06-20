Vagrant.configure("2") do |config|
  config.vm.box         = "{{.SourceBox}}"
  config.ssh.insert_key = {{.InsertKey}}

  config.vm.define "source", autostart: false do |source|
    source.vm.provider "libvirt" do |domain|
      domain.cpus   = 2
      domain.memory = 2048
    end
  end

  config.vm.define "output" do |output|
    output.vm.box_url = "file://package.box"
  end

  {{ if ne .SyncedFolder "" -}}
    config.vm.synced_folder "{{ .SyncedFolder }}", "/vagrant"
  {{- else -}}
    config.vm.synced_folder ".", "/vagrant", disabled: true
  {{- end }}
end
