terraform {
  required_version = ">= 0.13"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
provider "helm" {
    kubernetes {
        config_path = "~/.kube/config"
    }
}
resource "kubernetes_namespace" "demoplantillasterraform" {
  metadata {
    name = "mi-namespace-postgresql"
  }
}

resource "helm_release" "postgressql" {
    name = "postgresql"
    namespace = kubernetes_namespace.demoplantillasterraform.metadata[0].name
    repository = "https://charts.bitnami.com/bitnami"
    chart = "postgresql"
    version = "14.3.3"
    set {
        name = "postgresqlPassword"
        value = "my-secret-password"
    }
}

