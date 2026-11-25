apiVersion: v1alpha1
kind: KubeNodeConfig
nodeIP:
  validSubnets: {{ .Node.Data.addresses | toRawJson }}
