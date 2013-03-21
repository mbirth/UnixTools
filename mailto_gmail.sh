#!/bin/sh
# found at: http://www.google.com/support/forum/p/Chrome/thread?tid=0c3beab0fef1bf34&hl=en
# Opens a compose with the input mailto. Strip the protocol and convert the subject to google's format.
gnome-open "https://mail.google.com/mail?view=cm&tf=0&to=`echo $1 | sed 's/mailto://' | sed 's/?subject=/\&su=/g' `"
