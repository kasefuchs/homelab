machine:
  certSANs:
    - "127.0.0.1"
{{- range .Node.Data.addresses }}
    - "{{ splitList "/" . | first }}"
{{- end }}
    - "{{ (urlParse .ClusterEndpoint).hostname }}"
---
apiVersion: v1alpha1
kind: KubeNetworkConfig
podSubnets: {{ .Data.podCidrs | toRawJson }}
serviceSubnets: {{ .Data.serviceCidrs | toRawJson }}
