module IPUtils
  def self.int_to_ip(num)
    [
      (num >> 24) & 0xFF,
      (num >> 16) & 0xFF,
      (num >> 8) & 0xFF,
      num & 0xFF
    ].join(".")
  end

  def self.ip_to_int(ip)
    octets = ip.split(".").map(&:to_i)
    (octets[0] << 24) | (octets[1] << 16) | (octets[2] << 8) | octets[3]
  end

  def self.increment_ip(base_ip, increment)
    base_int = ip_to_int(base_ip)
    new_int = base_int + increment
    int_to_ip(new_int)
  end
end
