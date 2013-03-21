#!/bin/bash
SEARCH=/usr
join -t '' -v1 <(find $SEARCH | sort) \
               <(grep -h $SEARCH /var/lib/dpkg/info/*.list | sort -u) \
               | grep -v ".pyc\$"
