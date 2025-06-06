#!/bin/sh

myuser="$1"
mypass="$2"

/usr/bin/expect <<EOF
spawn /usr/bin/vncpasswd $myuser
expect "Password:"
send "$mypass\r"
expect "Verify:"
send "$mypass\r"
#expect "Would you like to enter a view-only password (y/n)?"
#send "n\r"
#expect "Password too long - only the first 8 characters will be used"
expect eof
exit
EOF
