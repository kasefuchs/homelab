apiVersion: v1alpha1
kind: LinkAliasConfig
name: net0
selector:
  match: true
---
apiVersion: v1alpha1
kind: BondConfig
name: bond0
links:
  - net0
bondMode: active-backup
addresses:
  - address: "{{ .Node.IP }}/{{ splitList "/" .Data.nodeCidr | last }}"
routes: {{ .Data.routes | toRawJson }}
