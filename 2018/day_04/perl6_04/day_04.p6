#! perl6

use lib 'lib';
use Day04;

my %log = read-sleep-log("../day_04.input");

my $sleepiest-guard = sleepiest-guard(%log);
my $sleepiest-minute = sleepiest-minute(%log{$sleepiest-guard});

say "Part 1: ", $sleepiest-guard * $sleepiest-minute;

my @sleepiest-combo = sleepiest-guard-minute(%log);

say "Part 2: ", [*] @sleepiest-combo;
