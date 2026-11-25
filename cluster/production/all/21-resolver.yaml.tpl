apiVersion: v1alpha1
kind: ResolverConfig
nameservers: {{ .Data.dnsServers | toRawJson }}
searchDomains:
  disableDefault: true
