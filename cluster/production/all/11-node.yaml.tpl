apiVersion: v1alpha1
kind: KubeNodeConfig
nodeIP:
  validSubnets:
    - "{{ .Data.nodeCidr }}"
