#!/usr/bin/env perl
# @(#) convert .m3u playlists to .pls
# Copyright (c) 2006 Dirk Jagdmann <doj@cubic.org>
#
# This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
#     1. The origin of this software must not be misrepresented; you
#        must not claim that you wrote the original software. If you use
#        this software in a product, an acknowledgment in the product
#        documentation would be appreciated but is not required.
#
#     2. Altered source versions must be plainly marked as such, and
#        must not be misrepresented as being the original software.
#
#     3. This notice may not be removed or altered from any source
#        distribution.
#
# http://llg.cubic.org/tools/#m3upls

use strict;

my $i=0;
my $title='';
my $length=-1;

print "[playlist]\n";
while(<>)
{
    chomp;
    next if /^\#EXTM3U/;
    if(/^\#EXTINF:(\d+),(.*)/)
    {
    $title=$2;
    $length=$1;
    next;
    }
    print "File$i=$_\n";
    print "Title$i=$title\n";
    print "Length$i=$length\n";
    $title='';
    $length=-1;
    $i++;
}

print "NumberOfEntries=$i\nVersion=2\n";