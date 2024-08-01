constraints = [
  {
    attribute = "$${node.unique.name}"
    operator  = "="
    value     = "firefly"
  }
]

config = <<EOH
---
api:
  dashboard: true
  disableDashboardAd: true

entryPoints:
  http:
    address: ":80"
    asDefault: true

  minecraft:
    address: ":25565"

metrics:
  addInternals: true
  prometheus:
    manualRouting: true
    headerLabels:
      useragent: User-Agent

providers:
  consul:
    endpoints:
      - http://consul.service.consul:8500

  consulCatalog:
    exposedByDefault: false
    watch: true
    endpoint:
      address: http://consul.service.consul:8500

EOH