#!/usr/bin/perl/ -w

my $tweets = "puretweets.txt";

open TWEET, "< $tweets";

my $negative = "negative.txt";
my $positive = "positive.txt";

open NEGATIVE, "< $negative";
open POSITIVE, "< $positive";

my %neg = ();
my %pos = ();

my $negnum = 0;
my $posnum = 0;
my $total = 0;

while (my $line = <NEGATIVE>) {
	chomp($line);
	$neg{$line} = "1";
}

while (my $line = <POSITIVE>) {
	chomp($line);
	$pos{$line} = 1;
}

while (my $line = <TWEET>){
	$line = lc($line);
	$total = $total + 1;
	@words = split(' ', $line);
	foreach $word (@words){
		if (exists($neg{$word})){
			$negnum = $negnum + 1;
		}
		if (exists($pos{$word})){
			$posnum = $posnum + 1;
		}
	}
}
print "Negative is $negnum \n";
print "Positive is $posnum \n";
print "Tweets is $total \n";
	
