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

variable "mail_port" {
  type = string
}

variable "mail_smtp_server" {
  type = string
}

variable "mail_login" {
  type = string
}

variable "mail_password" {
  type = string
}

resource "null_resource" "example1" {
  provisioner "local-exec" {
    command = "python3 mail.py $MAIL_PORT $SMTP_SERVER $USERNAME $PASSWORD"

    environment = {
      MAIL_PORT = "${var.mail_port}"
      SMTP_SERVER = "${var.mail_smtp_server}"
      USERNAME = "${var.mail_login}"
      PASSWORD = "${var.mail_password}"
    }
  }
}