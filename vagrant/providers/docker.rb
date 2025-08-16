module Provider
  def self.configure(node, name, options)
    node.vm.provider :docker do |domain|
      name_format = options.dig("domain", "name_format")

      domain.name        = format(name_format, name)
      domain.image       = options.fetch("image")
      domain.create_args = options.dig("domain", "create_arguments")
    end
  end
end
