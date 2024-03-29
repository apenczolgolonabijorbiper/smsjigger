# smsjigger

**This is a shell-based utensil for processing incoming SMSes, executing actions for defined recipients and sending out replies via SMS to senders.**

## General information

Default working folder: ~/sms

Pipeline of commands: fetch.sh --> process.sh --> exec.sh --> push.sh

Fetching folder: /var/spool/sms/incoming

Pushing folder: /var/spool/sms/outgoing

Pipeline of files: incoming (after SMS received) --> got (after fetch) --> new (after process) --> old (after exec) --> outgoing (before SMS sent out)

## Execution (daemon)

Put to crontab

_* * * * * ( ~/sms/run-sms.sh 2>&1 >> ~/sms/log/run-sms.sh-cron.log )_

## Prerequisites

1. smstools installed (Ubuntu: `sudo apt install smstools` or source code http://smstools3.kekekasvi.com/index.php?p=packages)
2. mobile phone connected to the server via USB cable
3. git repository cloned to local ~/sms folder
4. local user added to smsd group
5. sticky bit removed from /var/spool/sms/incoming

## Use by SMS:

Users will be sending SMSes to a known mobile phone number in the following format

> `<@recipient> [#command] [parameters]`

------

## Scripts

### fetch.sh
It looks for new files in /var/spool/sms/incoming older than 2 seconds (assumed time enough to write down all content by smstools deamon.

Once anything new found they are moved to ~/sms/got folder with the original naming convention (GSM?.<random> or USB?.<random>)


### process.sh

It looks for new GSM* or USB* (referred further commonly as GSM) files in ~/sms/got and once found it starts processing them, in a sense of parsing and creating content
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

> Format of the new file: `<sender>.<command>.<timestamp>`.

The raw GSM file is moved to ~/sms/old/gsm folder.

### exec.sh

Further processing is assumed to be done by dedicated shell script related to the command indicated in SMS.
If there was no command than it is assumed to be #generic and if related script of @recipient is not found than an error message is send back to the sender.
If sender is not a valid mobile number there will be an SMS sent to owner of this tool (configured as ~/sms/cfg/unknown/owner.cfg).

The script to be executed is expected to be found in ~/sms/cmd/@recipient (or ~/sms/cmd/unknown). 

The script is called in a subshell with two parameters: `<actionscript.sh> <sender> <smsfile>`. The `<smsfile>` contains full path and filename to the content of SMS with file format as idicated above (output of process.sh).

Result (standard output) of execution of the script is stored in a interim file (/tmp/`<sender>`.outinfo.`<timestamp>`) and moved to ~/sms/out/@recipient.

The input file is archived to ~/sms/old/@recipient folder.

### push.sh

The script looks for out files in ~/sms/out subfolders and once found it moves them to /var/spool/sms/outgoing for further processing by smstools. Then they are archived to ~/sms/old/@recipient folder.

### run-sms.sh

Inifinite loop with 3s sleep to run processing pipeline.

## Folders

### got

Incoming SMSes are stored here temporarily after pulling from smstools for further processing.
Used by fetch.sh script.

### new

Received SMSes are stored here for further execution.
Used by process.sh script.

### out

Outgoing SMSes are stored here for further sending out.
Used by push.sh script.

### cmd

Repository of shell scripts for executing commands.
Used by execute.sh script.

### log

Logs are stored here.
Used by all scripts.

### old

Old SMSes files are stored here.
Used by process.sh, execute.sh and push.sh scripts.

### cfg

Configurations are kept here. 
Used by execute.sh and possibly by individual action scripts.

### www

Web interface files are kept here.
Not in use as of now.

### api

API interace is kept here.
Not in use as of now.

### app

Application data are kept here.
Used by individual action scripts.

-------

## Test use

Send a new SMS "ok" to the mobile phone you have connected to the server.

Within 30 seconds you should get a reply "hello, you didn't provide any @recipient"

Send a new SMS "@test ok" to the same mobile phone.

Within 30 seconds you should get a reply "ready to accept #command".

Send a new SMS "@test #shell w".

Within 30 second you should get a reply with result of executing "w" shell command.

## Setup use

Send a new SMS "@setup #create `<recipient>`" to the mobile phone you have connected to the server.

Within 30 seconds you should get a reply "recipient `<recipient>` created for `<yournumber>`"

Send a new SMS "@setup #blacklist `<recipient>` `<blocknumber>`" to the same mobile phone.

Within 30 seconds you should get a reply "number `<blocknumber>` blacklisted for recipient @`<recipient>`".

Send a new SMS "@setup #delete `<recipient>`".

Within 30 second you should get a reply "recipient @`<recipient>` deleted for `<yournumber>`".

Available @setup #commands:
* create `<recipient>`
* delete `<recipient>`
* blacklist `<recipient>` `<blocknumber>`
* install `<recipient>` `<command>`
* notify `<recipient>` `<number>`
* notifystop `<recipient>` `<number>`

Avilable #commands for any @`<recipient>`:
* generic (no #command provided)
* help <-- returns available commands
* addme `<list>` <-- adds sender to specified list
* info `<content_to_send_back>` <-- returns provided content 

-------

# ToDo

01. ~~add blacklisting - generic one and by a recipient~~
02. add www interface (browsing own lists from apps)
03. add API interface (REST/SOAP)
04. add general command for subscribing and unsubscribing
05. add general mechanism for broadcasting (pushing to subcribers)
06. add general command for getting content of a list
07. add time-based list (with expiration)
08. add multi-language support (with setting up own/preferred language)
09. add delayed/scheduled send out
10. add support for own/configurable root folder
11. add archiving mechanism
12. add shortcodes (alias for @+#)
13. improve error-handling
14. add tracker & logger
15. implement forwarder app
16. add statistics
17. implement shopping-list app
18. implement reminder app
19. add ignoring (self-blacklisting for any send-out)
20. add whitelist for @setup
21. ~~add notificantiona~~
22. ?
