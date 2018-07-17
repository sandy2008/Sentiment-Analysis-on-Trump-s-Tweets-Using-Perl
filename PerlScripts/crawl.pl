#!/usr/bin/perl/ -w

use warnings ;
use strict ;
use Getopt::Long ;
use Math::BigInt ;
use Net::Twitter::Lite ;
use HTTP::Date ; 
use Encode ;

my $since_id = '' ;  #Default is empty
my $max_id = '' ;  # Default is empty
GetOptions(
	'since=s' => \$since_id,
	'max=s' => \$max_id,
) ;

$since_id and not $since_id =~ /^\d+$/ and die "since_id must be number.\n" ;
$max_id and not $max_id =~ /^\d+$/ and die "max_id must be number.\n" ;

# OAuth Auth
my $twit ;
twitter_oauth() ;

# Get Timeline
while (my @timeline = get_home_timeline($since_id,$max_id,'')){
	my $last_id = (split /\t/, $timeline[-1])[0] ;
	$max_id = Math::BigInt->new($last_id) - 1 ;  # BigInt
	$max_id = "$max_id" ;  # int to string
	$" = "\n" ;  #"
	print "@timeline\n" ;
	print STDERR "Fetched: since_id=$since_id,max_id=$max_id,tweets=", scalar @timeline, "\n" ;
}

exit ;

# ====================
sub twitter_oauth {  # get it https://dev.twitter.com/apps
$twit = Net::Twitter::Lite->new(
	consumer_key => 'xxxxxxxxxxxxxxxxxxxx',
	consumer_secret => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
	access_token => 'xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
	access_token_secret =>'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
) ;
} ;
# ====================
sub get_home_timeline {  # Usage: @timeline = get_home_timeline($since_id,$max_id,$count) ;
my %arg ;
$_[0] and $arg{'since_id'} = $_[0] ;  
$_[1] and $arg{'max_id'} = $_[1] ;  
$arg{'count'} = $_[2] || 200 ;  
my @tweet_tsv ;

my $timeline_ref = $twit->home_timeline({%arg}) ;
foreach (@$timeline_ref){
	my $tweet_time = $_->{'created_at'} || '' ;
	my $tweet_id = $_->{'id'} || '' ;
	my $tweet_text = $_->{'text'} || '' ;
	my $tweet_source = $_->{'source'} || '' ;
	my $tweet_replyto = $_->{'in_reply_to_status_id'} || '' ;
	my $user_screenname = $_->{'user'}{'screen_name'} || '' ;
	
	$tweet_time =~ s/\+0000/UTC/ ;
	$tweet_time = HTTP::Date::str2time($tweet_time) ;
	$tweet_time = HTTP::Date::time2iso($tweet_time) ;

	$tweet_text =~ s/[\n\r\t]/ /g ;


	$tweet_source =~ s/<.*?>//g ;

	my $tweet = "$tweet_id	$tweet_time	$user_screenname	$tweet_text	$tweet_replyto	$tweet_source" ;
	Encode::is_utf8($tweet) and $tweet = Encode::encode('utf-8',$tweet) ;
	push @tweet_tsv, $tweet ;
}
return @tweet_tsv ;
} ;
