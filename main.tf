provider "helm" {
  version = "~> 1.0.0"
}

resource "helm_release" "backend" {
  name  = "backend"
  chart = "./backend"
}

resource "helm_release" "frontend" {
  name  = "frontend"
  chart = "./frontend"

  depends_on = [helm_release.backend]
}

