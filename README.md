# smsjigger

Default working folder: ~/sms

Pipeline of commands: fetch.sh --> process.sh --> exec.sh --> push.sh

Fetching folder: /var/spool/sms/incoming

Pushing folder: /var/spool/sms/outgoing

Pipeline of files: incoming (after SMS received) --> got (after fetch) --> new (after process) --> old (after exec) --> outgoing (before SMS sent out)

Put to crontab

_* * * * * ( ~/sms/run-sms.sh 2>&1 >> ~/sms/log/run-sms.sh-cron.log )_

------

## fetch.sh
It looks for new files in /var/spool/sms/incoming older than 2 seconds (assumed time enough to write down all content by smstools deamon.

Once anything new found they are moved to ~/sms/got folder with the original naming convention (GSM1.<random>)


## process.sh

It looks for new GSM* files in ~/sms/got and once found it starts processing them, in a sense of parsing and creating content
for further execution.

At first it goes through file and reads every line. There are specific keywords expected:
* From - sender of SMS
* Sent - original date when SMS was sent by sender
* Length - indication the content of SMS will start after one empty line

In the next step the script looks at the extracted content and checks for recipient (indicated by @) and command (indicated by #).
Recipient is expected as a first word in the given sms, command can follow as second one (#command is optional).

A new file is created in ~/sms/new depending on the recipient found. If @recipient was not specified in SMS than
the new file is created in ~/sms/new/unknown otherwise in ~/sms/new/@recipient. If a command is not found than it
is assumed to be #generic command (or #received for unknown recipients).

> Format of the new file: <sender>.<command>.<timestamp>.
The raw GSM file is moved to ~/sms/old/gsm folder.

## exec.sh


## push.sh
