#!/bin/sh
svn status | egrep '^A.*$' | sed -e 's/^. *//' > /tmp/svn_ci.txt
svn ci --targets /tmp/svn_ci.txt
