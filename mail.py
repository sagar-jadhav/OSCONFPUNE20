# the first step is always the same: import all necessary components:
import smtplib
import sys
from socket import gaierror

port = sys.argv[1]
smtp_server = sys.argv[2]
login = sys.argv[3]  # paste your login generated by Mailtrap
password = sys.argv[4]  # paste your password generated by Mailtrap
mysql_password = sys.argv[5]

sender = "sagar@email.com"
receiver = "sagar@gmail.com"

# type your message: use two newlines (\n) to separate the subject from the message body, and use 'f' to  automatically insert variables in the text
message = f"""\
Subject: Hi Mailtrap
To: {receiver}
From: {sender}

Application deployed successfully, Root user password is {mysql_password}"""

try:
    # send your message with credentials specified above
    with smtplib.SMTP(smtp_server, port) as server:
        server.login(login, password)
        server.sendmail(sender, receiver, message)

    # tell the script to report if your message was sent or which errors need to be fixed
    print('Sent')
except (gaierror, ConnectionRefusedError):
    print('Failed to connect to the server. Bad connection settings?')
except smtplib.SMTPServerDisconnected:
    print('Failed to connect to the server. Wrong user/password?')
except smtplib.SMTPException as e:
    print('SMTP error occurred: ' + str(e))
