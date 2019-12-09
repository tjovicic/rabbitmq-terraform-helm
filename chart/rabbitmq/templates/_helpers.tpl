{{/*
Defines a JSON file containing definitions of all broker objects (queues, exchanges, bindings, 
users, virtual hosts, permissions and parameters) to load by the management plugin.
*/}}
{{- define "rabbitmq.definitions" -}}
{
  "users": [
    {
      "name": {{ .Values.rabbitmq.username | quote }},
      "password": {{ .Values.rabbitmq.password | quote }},
      "tags": "administrator"
    }
  ],
  "vhosts": [
    {
      "name":"/"
    }
  ],
  "permissions": [
    {
      "user": {{ .Values.rabbitmq.username | quote }},
      "vhost":"/",
      "configure":".*",
      "write":".*",
      "read":".*"
    }
  ],

  "topic_permissions": [],

  "parameters": [],
  
  "global_parameters": [
{{ .Values.definitions.globalParameters | indent 4 }}
  ],

  "policies": [
{{ .Values.definitions.policies | indent 4 }}
  ],
  
  "queues": [
{{ .Values.definitions.queues | indent 4 }}
  ],

  "exchanges": [
{{ .Values.definitions.exchanges | indent 4 }}
  ],
  
  "bindings": [
{{ .Values.definitions.bindings | indent 4 }}
  ]
}
{{- end -}}
