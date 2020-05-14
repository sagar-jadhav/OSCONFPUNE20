provider "helm" {
  version = "~> 1.0.0"
}

resource "random_password" "password" {
  length = 4
}

resource "helm_release" "backend" {
  name  = "backend"
  chart = "./backend"

  set {
    name  = "mysql_password"
    value = random_password.password.result
  }

  depends_on = [helm_release.backend]
}

resource "helm_release" "frontend" {
  name  = "frontend"
  chart = "./frontend"

  set {
    name  = "mysql_password"
    value = random_password.password.result
  }

  depends_on = [helm_release.backend]
}

resource "null_resource" "example1" {
  provisioner "local-exec" {
    command = "python3 mail.py $MAIL_PORT $SMTP_SERVER $USERNAME $PASSWORD $MYSQL_PASSWORD"

    environment = {
      MAIL_PORT = var.mail_port
      SMTP_SERVER = var.mail_smtp_server
      USERNAME = var.mail_login
      PASSWORD = var.mail_password
      MYSQL_PASSWORD = random_password.password.result
    }
  }

  depends_on = [helm_release.frontend]
}