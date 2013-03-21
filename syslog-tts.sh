#!/bin/bash
# found: http://dailypackage.fedorabook.com/index.php?/archives/42-Productive-Monday-Festival-Speech-synthesis.html
tail -0f /var/log/messages | sed "s/^[^:]*:[^:]*:[^:]*: //" | while read LINE
#tail -0f /var/log/syslog | sed "s/^[^:]*:[^:]*:[^:]*: //" | while read LINE
#tail -0f /var/log/auth.log | sed "s/^[^:]*:[^:]*:[^:]*: //" | while read LINE
#tail -0f /var/log/user.log | sed "s/^[^:]*:[^:]*:[^:]*: //" | while read LINE
do
    echo $LINE
    echo $LINE | festival --tts
    sleep 0.75
done