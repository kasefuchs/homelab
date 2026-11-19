apiVersion: v1alpha1
kind: KubeAPIServerConfig
extraArgs:
  enable-aggregator-routing: "true"
certExtraSANs:
  - "127.0.0.1"
  - "{{ .Node.IP }}"
  - "{{ (urlParse .ClusterEndpoint).hostname }}"
