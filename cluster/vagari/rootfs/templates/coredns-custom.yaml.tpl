apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns-custom
  namespace: kube-system
data:
  docker.server: |
    docker:53 {
      errors
      cache 30
      hosts {
        ${HOST_IP} docker
        fallthrough
      }
    }
