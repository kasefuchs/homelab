module Provider
  def self.configure(config, options)
    config.vm.provider :libvirt do |domain|
      domain.cpus   = options.dig("domain", "cores")
      domain.memory = options.dig("domain", "memory")

      domain.forward_ssh_port = true
    end
  end
end
