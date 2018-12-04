use v6.c;
use Test;

use lib 'lib';
use Day04;

plan 4;

my $test-file-name = "test";

my %test-sleep-log := {
    10 => {
        '1518-11-01' => Array.new(".....####################.....#########################.....".comb),
        '1518-11-03' => Array.new("........................#####...............................".comb)
    },
    99 => {
        '1518-11-02' => Array.new("........................................##########..........".comb),
        '1518-11-04' => Array.new("....................................##########..............".comb),
        '1518-11-05' => Array.new(".............................................##########.....".comb)
    }
};

my %sleep-log = read-sleep-log($test-file-name);
is-deeply(%test-sleep-log, %sleep-log);

is sleepiest-guard(%sleep-log), 10;
is sleepiest-minute(%sleep-log{10}), 24;

is sleepiest-guard-minute(%sleep-log), (99, 45);
