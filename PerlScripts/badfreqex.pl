#!/usr/bin/perl/ -w

my $tweets = "puretweets.txt";

open TWEET, "< $tweets";

my $negative = "racism.txt";
my $positive = "swearWords.txt";

open NEGATIVE, "< $negative";
open POSITIVE, "< $positive";

$out = "posout.txt";
open(OUT, '>', $out);

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
			print OUT "$word ";
		}
		if (exists($pos{$word})){
			$posnum = $posnum + 1;
		}
	}
}
print "Racism is $negnum \n";
print "Swear Words is $posnum \n";
print "Tweets is $total \n";
	
