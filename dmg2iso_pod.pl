#!/usr/bin/perl
#
# Downloaded from http://blinkenlights.ch/gnupod/dmg2iso.pl
#
# dmg2iso.pl was written by vu1tur, license ?!?
#
# Note: This doesn't look like the Version 0.2a provided at
#       http://vu1tur.eu.org/tools/ . But this version works with Apples iPod-Firmware dmg images..
# ...
#
#
use MIME::Base64;
use strict ;
local ($^W) = 1; #use warnings ;
use Compress::Zlib ;
my $x = inflateInit()
   or die "ERROR: Cannot create inflation stream. Is Compress::zlib installed?\n" ;
my $zfblock="\x00"; for (0..8) { $zfblock.=$zfblock; }
my $indxbeg=0;
my $indxend=0;
my @plist;
print "dmg2iso v0.2a by vu1tur (vu1tur\@gmx.de)\n\n";
if (@ARGV."" != 2) { die "Syntax: dmg2iso.pl filename.dmg filename.iso\n"; }
my $zeroblock = "\x00";
for (0..8) { $zeroblock.=$zeroblock; }
my $tmp;
my ($output,$status);
my $buffer;
open(FINPUT,$ARGV[0]) or die "ERROR: Can't open input file\n";

binmode FINPUT;
sysseek(FINPUT,-0x200000,2);
print "reading property list...";
my $fpos = sysseek(FINPUT,0,1);
while(my $ar = sysread(FINPUT,$buffer,0x10000))
{
	my $fpos = sysseek(FINPUT,0,1)-$ar;
	if ($buffer =~ /(.*)<plist version=\"1.0\">/s)
	{
		$indxbeg = $fpos+length($1);
	}
	if ($buffer =~ /(.*)<\/plist>/s)
	{
		$indxend = $fpos+length($1)+8;
	}
}
open(FOUTPUT,">".$ARGV[1]) or die "ERROR: Can't open output file\n";
binmode FOUTPUT;
my $indxcur = $indxbeg + 0x28;
sysseek(FINPUT,$indxbeg,0);
sysread(FINPUT,$tmp,$indxend-$indxbeg);

if ($tmp =~ s/.*<key>blkx<\/key>.*?\s*<array>(.*?)<\/array>.*/$1/s)
{
	while ($tmp =~ s/.*?<data>(.*?)<\/data>//s)
	{
		my $t = $1;
		$t =~ s/\t//g;
		$t =~ s/^\n//g;
		push @plist,decode_base64($t);
	}
} else {
die "PropertyList is corrupted\n";
}
print "found ".@plist." partitions\n";
print "decompressing:\n";

my $t=0;
my $zoffs = 0;
my $tempzoffs = 0;
foreach (@plist)
{
	print "partition ".$t++."\n";
	s/^.{204}//s;
	while (s/^(.{8})(.{8})(.{8})(.{8})(.{8})//s)
	{
		$x = inflateInit();
		my $block_type = unpack("H*",$1);
		my $out_offs = 0x200*hex(unpack("H*",$2));
		my $out_size = 0x200*hex(unpack("H*",$3));
		my $in_offs = hex(unpack("H*",$4));
		my $in_size = hex(unpack("H*",$5));
		# $1 - block type, $2 - output offs $3 - output size $4 input offset $5 - input size
		sysseek(FINPUT,$in_offs+$zoffs,0);
		sysread(FINPUT,$tmp,$in_size);
		
		if ($block_type =~ /^80000005/)
		{
			($output,$status) = $x->inflate($tmp);
			if ($status == Z_OK or $status == Z_STREAM_END)
			{
				syswrite(FOUTPUT,$output,$out_size);
			} else { die "\nConversion failed. File may be corrupted.\n"; }
		}
		if  ($block_type =~ /^00000001/)
		{
			sysseek(FINPUT,$in_offs+$zoffs,0);
			sysread(FINPUT,$tmp,$in_size);
			syswrite(FOUTPUT,$tmp,$out_size);
		}
		if ($block_type =~ /^00000002/)
		{
			for(1..$out_size/0x200) 
			{
				syswrite(FOUTPUT,$zeroblock,0x200);
			}
		}
		if ($block_type =~ /^FFFFFFFF/i)
		{
			$zoffs += $tempzoffs;
		}
		$tempzoffs = $in_offs+$in_size;
	}
}

print "\nconversion successful\n";

