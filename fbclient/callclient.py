#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import telnetlib
import os
import sys

HOST = "172.16.254.254" # "fritz.box"
PORT = 1012
ESPEAK_BINARY = "/usr/bin/espeak -v german+f2"

print( "Started in %s" % sys.path[0] )
f = open( sys.path[0] + "/callclient.list", "rt" )

pb = {}
for line in f:
    line = line.strip(" \n")
    ( number, sep, name ) = line.partition(' ')
    name = name.strip()
    pb[number] = name
print( "Loaded %s entries from local phonebook." % len( pb ) )
print( pb )

tn = telnetlib.Telnet( HOST, PORT )
try:
    while True:
        event = tn.read_until( b"\n" ).decode( "utf-8" )
        edata = event.split( ';' )
        print( edata )
        if edata[1] == "RING":
            caller = edata[3]
            print( "Incoming call from %s" % caller )
            if caller in pb:
                caller = pb[caller]
                print( "Caller found in phonebook: %s" % caller )
#            os.system( "/usr/bin/play /usr/share/sounds/ubuntu/stereo/message-new-instant.ogg" )
            os.system( ESPEAK_BINARY + " \"Anruf von " + caller + ".\"" )

except EOFError as eof:
    print( "Connection closed by remote host." )

print( "All done." )
