#!/bin/sh

# Initializing connection details
echo 'Initializing connection details ...'
source ../dev.rc

# Install Helm Chart
echo 'Installing application on k8s ...'
helm install dependentapps ./frontend_deps

# Send Email
echo 'Sending email ...'
python3 mail.py $MAIL_PORT $MAIL_SMTP_SERVER $MAIL_LOGIN $MAIL_PASSWORD $MYSQL_PASSWORD