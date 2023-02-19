# smsjigger

Default working folder: ~/sms

Pipeline of commands: fetch.sh --> process.sh --> exec.sh --> push.sh

Fetching folder: /var/spool/sms/incoming

Pushing folder: /var/spool/sms/outgoing

Pipeline of files: incoming (after SMS received) --> got (after fetch) --> new (after process) --> old (after exec) --> outgoing (before SMS sent out)

Put to crontab

_* * * * * ( ~/sms/run-sms.sh 2>&1 >> ~/sms/log/run-sms.sh-cron.log )_

----
