#!/usr/bin/perl/ -w
#convert raw data to txt
my $trumptweets = "TrumpTweets.xml";
open TRUMP, "< $trumptweets";

$out = "wensdaytweets.txt";
open(OUT, '>', $out);

while (my $line = <TRUMP>) {
	if ($line =~  /Wed/){
		@a = split("\"text\":\"", $line);
		@b = split("\",\"created_at\":", $a[1]);
		print OUT ($b[0]);
		print OUT ("\n");
	}
}

