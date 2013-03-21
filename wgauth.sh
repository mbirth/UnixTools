#!/bin/sh
HERE=`dirname $0`

. $HERE/CONFIG

read -p "Enter username: " USER
echo -n "Enter password: "
/bin/stty -echo
read PASS
/bin/stty echo
echo ""
DOMAIN=Firebox-DB
#DOMAIN=RADIUS

# POST with multipart/form-data (form name: user_auth_form)
TMP=`tempfile -p WG`
POST="fw_username=${USER}&fw_password=${PASS}&fw_domain=${DOMAIN}&submit=Login&action=fw_logon&style=fw_logon_progress.xsl&fw_logon_type=logon"
echo "Sending login data..."
wget --quiet -S -O "$TMP" --no-check-certificate --post-data="$POST" "$WATCHGUARD_URL/?action=fw_logon&style=fw_logon.xsl&fw_logon_type=status"

REQID=`cat "$TMP" | egrep -o "<reqId>(.*)</reqId>" | sed 's/<reqId>\(.*\)<\/reqId>/\1/g'`
rm "$TMP"
echo "Got Request ID: $REQID"

sleep 2
URI="/?action=fw_logon&style=fw_logon_progress.xsl&fw_logon_type=progress&fw_reqId=${REQID}"
echo "Requesting login status..."
wget --quiet -S -O "$TMP" --no-check-certificate "${WATCHGUARD_URL}${URI}"

STATUS=`cat "$TMP" | egrep -o "<logon_status>(.*)</logon_status>" | sed 's/<logon_status>\(.*\)<\/logon_status>/\1/g'`
echo "Status: $STATUS"
rm "$TMP"
if [ $STATUS = "1" ]; then
    echo "Logged in successfully."
else
    echo "Login failed for some reason. Please try again."
fi