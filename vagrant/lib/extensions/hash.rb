class ::Hash
  # Provides deep merging capability for nested Hashes.
  # @see https://stackoverflow.com/a/9381776
  def deep_merge(second)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    self.merge(second, &merger)
  end

  # Provides deep copy capability for nested Hashes.
  # @see https://stackoverflow.com/a/8206537
  def deep_dup
    Marshal.load(Marshal.dump(self))
  end
end
