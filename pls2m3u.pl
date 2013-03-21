#!/usr/bin/env perl
# @(#) convert .pls playlists to .m3u
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

$_=<>;
chomp;
die "not a valid .pls file" unless $_ eq "[playlist]";

my $total=0;
my @a;
while(<>)
{
    chomp;
    next if /^\s*$/;

    if(/NumberOfEntries=(\d+)/)
    {
    $total=$1;
    next;
    }
    if(/Version=(\d+)/)
    {
    warn "unknown pls version : $1" unless $1 == 2;
    next;
    }

    next unless /^(File|Title|Length)(\d+)=(.*)/;
    my $tag=$1;
    my $num=$2;
    my $str=$3;
    unless($a[$num])
    {
    $a[$num]={  };
    }
    $a[$num]->{$tag}=$str;
}

warn "NumberOfEntries does not match number of entries: $#a != $total" if $total != $#a;

print "#EXTM3U\n";
foreach my $r (@a)
{
    $r->{Length}=-1 unless $r->{Length};
    $r->{Title}='' unless $r->{Title};
    if($r->{File})
    {
    print "#EXTINF:$r->{Length},$r->{Title}\n";
    print "$r->{File}\n";
    }
}