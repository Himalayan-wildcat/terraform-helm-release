replicaCount: ${replicas}

image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: ${tag}

serviceAccount:
  create: true
  annotations: {}
podAnnotations: {}
podSecurityContext: {}
securityContext: {}

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false

resources: {}

nodeSelector: {}

tolerations: []

affinity: {}
