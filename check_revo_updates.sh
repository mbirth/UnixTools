#!/bin/sh
#echo -n "dump1090: "
#cd /opt/flightradar24/dump1090.git
#git pull
#cd - >/dev/null
echo -n "fr24feed: "
FR24_INST=`apt-cache policy fr24feed | grep "Installed" | cut -d" " -f4`
FR24_LIVE=`wget -q -O - "http://feed.flightradar24.com/linux/" | grep -o "fr24feed_.*_i386.deb" | sed 's/^.*fr24feed_\(.*\)_i386.deb.*$/\1/'`
if [ "$FR24_INST" != "$FR24_LIVE" ]; then
    echo "new version: $FR24_LIVE (currently installed: $FR24_INST)"
else
    echo "up-to-date ($FR24_INST)."
fi
echo -n "newznab: "
cd /opt/newznab
svn up
cd - >/dev/null
echo -n "spotweb: "
cd /opt/spotweb
git pull
cd - >/dev/null
#echo -n "Plex: "
#PLEX_INST=`apt-cache policy plexmediaserver | grep "Installed" | cut -d" " -f4`
#PLEX_LIVE=`wget -q -O - --header='Cookie: remember_user_token=BAhbB1sGaQNpZTFJIhkzOHFLRHE5d3Z1VFJaSlpwR2JhdAY6BkVG--c367af27eec0fdc46ada94a77af6d06059f204cb' "https://plex.tv/downloads?channel=plexpass" | grep -o "plexmediaserver_.*_amd64.deb" | sed 's/plexmediaserver_\(.*\)_amd64.deb$/\1/'`
#if [ "$PLEX_INST" != "$PLEX_LIVE" ]; then
#    echo "new version: $PLEX_LIVE (currently installed: $PLEX_INST)"
#else
#    echo "up-to-date ($PLEX_INST)."
#fi
echo -n "Dash: "
cd /mnt/storage/WWW/.admin/dash
git pull
cd - >/dev/null
echo -n "Tiny-Tiny-RSS: "
cd /opt/ttRSS
git pull
cd - >/dev/null
