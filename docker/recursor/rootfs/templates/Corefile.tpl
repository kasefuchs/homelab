{{ .Env.ZONE_NAME }} {
  forward . dns:53
  log
  errors
}

. {
  log
  errors
  hosts /etc/hosts {
    ttl 60
    reload 15s
    fallthrough
  }
  cache 30
  forward . /etc/resolv.conf
}
