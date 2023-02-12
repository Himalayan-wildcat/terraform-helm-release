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

# resource "helm_release" "ojt" {
#   name  = "ojt-app"
#   chart = "../../ojt"

#   values = [
#     file("${path.module}/ojt_values.yaml")
#   ]
# }

# output "ojt" {
#   value = helm_release.ojt.manifest
# }

resource "helm_release" "argoproj_ojt" {
  name       = "ojt-argoproj"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "0.0.8"
  namespace  = "argocd"

  values = [
    templatefile("../../argoproj/ojt.yaml.tpl", {
      # path = "env/ojt/generated"
      value_file = "ojt_values.yaml"
    })
  ]

  // depends_on = [helm_release.ojt]
}
