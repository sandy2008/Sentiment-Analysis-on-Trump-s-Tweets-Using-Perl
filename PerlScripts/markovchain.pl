#!/usr/bin/env perl
use strict;
use warnings;
use File::Open qw(fopen);
use Data::Munge;

my $k = 9;                  # k-gram length
my $n = 2000000;                  # number of iterations
my $file = "puretweets.txt";
my $long_string = slurp fopen $file;

# loop through each k-gram; if no entry exists in %markov_chain,
# initialize it to an empty array. In either case, push the next
# k-gram into the array.

my %markov_chain;               # hash of arrays

for my $i (0 .. (length $long_string) - 1) {
  my $curr = substr $long_string, $i, $k;
  my $next = substr $long_string, $i + 1, $k;
  $markov_chain{$curr} //= [];
  push $markov_chain{$curr}, $next;
}

# Take the first k-gram from the original document. Draw a random
# k-gram from this k-gram's entry in %markov_chain. This will be the
# k-gram for the next iteration. Print the last character of the
# k-gram.

sub rand_elem { $_[rand @_] }

my $seed = substr $long_string, 0, $k;
print $seed;
for my $i (0 .. $n) {
  $seed = rand_elem @{$markov_chain{$seed}};
  print substr $seed, -1;
}
