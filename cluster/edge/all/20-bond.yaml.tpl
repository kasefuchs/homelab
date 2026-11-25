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
{{- range .Node.Data.addresses }}
  - address: "{{ . }}"
{{- end }}
routes: {{ .Data.routes | toRawJson }}
