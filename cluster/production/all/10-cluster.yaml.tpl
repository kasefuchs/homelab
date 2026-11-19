machine:
  certSANs:
    - "127.0.0.1"
    - "{{ .Node.IP }}"
    - "{{ (urlParse .ClusterEndpoint).hostname }}"
---
apiVersion: v1alpha1
kind: KubeNetworkConfig
podSubnets: ["{{ .Data.podCidr }}"]
serviceSubnets: ["{{ .Data.serviceCidr }}"]
