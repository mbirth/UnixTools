#!/usr/bin/env python
#-*- coding:utf-8 -*-

# Text editor to use (uncomment only one, if more the last one will be used):
# editor = "gedit"
# editor = "kate"
# editor = "kwrite"
# editor = "mousepad"
editor = "mcedit"



### STOP HERE ###

import sys, os

def checkDeb(s):
    if s.find(".deb") != -1:
        try:
            f = open(s)
            f.close()
        except IOError:
            return False
        return True
    return False

if len(sys.argv) != 2 or not checkDeb(sys.argv[1]):
    print "__DEB Dependencies Hacker__ by RickDesantis"
    print "Give me the name of the existing deb file:"
    print "\t%s %s" % (sys.argv[0][sys.argv[0].rfind("/")+1:], "<file.deb>")
    exit(-1)

deb = sys.argv[1]
ftmp = "tmpdir"
hdeb = "%s.modified.deb" % deb[0:deb.find(".deb")]

os.system("dpkg-deb -x %s %s" % (deb, ftmp))
os.system("dpkg-deb --control %s %s/DEBIAN" % (deb, ftmp))
os.system("%s %s/DEBIAN/control" % (editor, ftmp))
os.system("dpkg -b %s %s" % (ftmp, hdeb))
