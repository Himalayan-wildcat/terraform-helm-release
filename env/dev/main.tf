# resource "helm_release" "sealed_secrets" {
#   name       = "sealed-secrets"
#   repository = "https://bitnami-labs.github.io/sealed-secrets/"
#   chart      = "sealed-secrets"
#   version    = "~> 2.7.0"
#   namespace  = "kube-system"
# }

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "~> 5.20.0"
  create_namespace = true
  namespace        = "argocd"

  set {
    name  = "global.logging.level"
    value = "info"
  }

  set {
    name  = "applicationSet.enabled"
    value = "false"
  }

  set {
    name  = "configs.params.server.insecure"
    value = "true"
  }

  # set {
  #   name = "server.service.type"
  #   value = "NodePort"
  # }

  # values = [
  #   "${file("values.yaml")}"
  # ]
}

resource "helm_release" "argocdapp_nginx" {
  name       = "argocdapp-nginx"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "0.0.8"
  namespace  = "argocd"

  values = [
    templatefile("../../argoproj/ojt.yaml.tpl", {})
  ]
}

resource "helm_release" "ojt" {
  name  = "wordpress"
  chart = "../../ojt"

  values = [
    templatefile("../../ojt/values.yaml.tpl", {
      replicas = 1
      tag      = "latest"
    })
  ]
}
