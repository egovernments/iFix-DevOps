{{- define "redis.name" -}}
{{- $envOverrides := index .Values (tpl (default .Chart.Name .Values.name) .) -}} 
{{- $baseValues := .Values | deepCopy -}}
{{- $values := dict "Values" (mustMergeOverwrite $baseValues $envOverrides) -}}
{{- with mustMergeOverwrite . $values -}}
{{- default .Chart.Name .Values.name -}}    
{{- end }}
{{- end }}


{{- define "redis.labels" -}}
app: {{ template "redis.name" . }}
{{- if .Values.labels.group }}      
group: {{ .Values.labels.group }}  
{{- end }}  
{{- range $key, $val := .Values.additionalLabels }}
{{ $key }}: {{ $val | quote }}
{{- end }}
{{- end }}