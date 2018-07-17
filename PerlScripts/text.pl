#!/usr/bin/perl/ -w
#convert raw data to txt
my $trumptweets = "TrumpTweets.xml";
open TRUMP, "< $trumptweets";

$out = "puretweets.xml";
open(OUT, '>', $out);

while (my $line = <TRUMP>) {
	@a = split("\"text\":\"", $line);
	@b = split("\",\"created_at\":", $a[1]);
	print OUT ($b[0]);
	print OUT ("\n");
}

