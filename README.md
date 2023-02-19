# smsjigger

Pipeline: fetch.sh --> process.sh --> exec.sh --> push.sh

Fetching folder: /var/spool/sms/incoming

Pushing folder: /var/spool/sms/outgoing

Put to crontab

_* * * * * ( ~/sms/run-sms.sh 2>&1 >> ~/sms/log/run-sms.sh-cron.log )_

