provider "helm" {
  version = "~> 1.0.0"
}

resource "random_password" "password" {
  length = 4
}

resource "random_string" "backend_release_name" {
  length  = 10
  special = false
  number  = false
}

resource "random_string" "frontend_release_name" {
  length  = 10
  special = false
  number  = false
}

resource "helm_release" "backend" {
  name  = random_string.backend_release_name.result
  chart = "./backend"

  set {
    name  = "mysql_password"
    value = random_password.password.result
  }

  depends_on = [random_password.password, random_string.backend_release_name]
}

resource "helm_release" "frontend" {
  name  = random_string.frontend_release_name
  chart = "./frontend"

  set {
    name  = "mysql_password"
    value = random_password.password.result
  }

  depends_on = [helm_release.backend, random_password.password, random_string.frontend_release_name]
}

resource "null_resource" "example1" {
  provisioner "local-exec" {
    command = "python3 mail.py $MAIL_PORT $SMTP_SERVER $USERNAME $PASSWORD $MYSQL_PASSWORD"

    environment = {
      MAIL_PORT      = var.mail_port
      SMTP_SERVER    = var.mail_smtp_server
      USERNAME       = var.mail_login
      PASSWORD       = var.mail_password
      MYSQL_PASSWORD = random_password.password.result
    }
  }

  depends_on = [helm_release.frontend]
}
