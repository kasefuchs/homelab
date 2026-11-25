apiVersion: v1alpha1
kind: KubeAPIServerConfig
extraArgs:
  enable-aggregator-routing: "true"
certExtraSANs:
  - "127.0.0.1"
{{- range .Node.Data.addresses }}
  - "{{ splitList "/" . | first }}"
{{- end }}
  - "{{ (urlParse .ClusterEndpoint).hostname }}"
