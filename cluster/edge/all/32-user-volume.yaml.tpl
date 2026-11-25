{{- range .Node.Data.userVolumes }}
---
apiVersion: v1alpha1
kind: UserVolumeConfig
name: {{ . }}
volumeType: directory
{{- end }}
