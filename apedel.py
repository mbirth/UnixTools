#!/usr/bin/env python
import sys
import mutagen.apev2
for p in sys.argv:
    try:
        mutagen.apev2.delete(p)
    except Exception, e:
        print e
