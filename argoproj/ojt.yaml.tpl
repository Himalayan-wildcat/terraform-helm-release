applications:
- name: ojt
  namespace: argocd
  project: default
  sources:
   - repoURL: https://github.com/Himalayan-wildcat/terraform-helm-release.git
     path: ojt
     targetRevision: HEAD
     helm:
       valueFiles:
         - ${value_file}
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
      allowEmpty: false
    retry:
      limit: 5
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
    syncOptions:
    - ServerSideApply=true
    - Validate=true
    - CreateNamespace=false
    - ApplyOutOfSyncOnly=true
    - PrunePropagationPolicy=foreground
    - PruneLast=true
  revisionHistoryLimit: 1
  # ignoreDifferences:
  # - group: apps
  #   kind: Deployment
  #   jsonPointers:
  #   - /spec/replicas
  # info:
  # - name: url
  #   value: https://argoproj.github.io/
