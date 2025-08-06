module Provider
  def self.configure(config, options)
    config.vm.provider :docker do |domain|
      domain.image       = options.fetch("image")
      domain.create_args = options.dig("domain", "create_arguments")
    end
  end
end
