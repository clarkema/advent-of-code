#! perl6

my $record-re = rx {
    ^'[' $<date>=(\d ** 4 \- \d\d \- \d\d) <.ws>
    \d\d\: $<min>=(\d\d)']' <.ws>
    $<action>=(.*)$
};

sub read-sleep-log(Str:D $file --> Map) is export {
    my %shifts;
    my $current-guard;
    my $asleep-at;

    for $file.IO.lines.sort -> $line {
        if my $record = $line ~~ $record-re {
            given $record<action> {
                when m:s/^Guard '#'(\d+) begins shift/ { $current-guard = $0; }
                when "falls asleep" { $asleep-at = $record<min>; }
                when "wakes up" {
                    unless defined %shifts{$current-guard}{$record<date>} {
                        %shifts{$current-guard}{$record<date>} := Array.new('.' xx 60);
                    }
                    %shifts{$current-guard}{$record<date>}[$_] = '#' for $asleep-at ..^ $record<min>;
                }
            }
        }
    }

    return %shifts;
}

sub sleepiest-guard(Hash $sleep-log --> Str) is export {
    my $max-mins = 0;
    my $guard-id;

    for $sleep-log.kv -> $guard, %shifts {
        my $total-mins = %shifts.values>>.grep('#').map(*.elems).sum;
        if $total-mins > $max-mins {
            $guard-id = $guard;
            $max-mins = $total-mins;
        }
    }

    return $guard-id;
}

sub sleepiest-minute(Hash $guard-shifts --> Int) is export {
    guard-sleep-map($guard-shifts).maxpairs.first.key;
}

sub guard-sleep-map(Hash $guard-shifts) {
    my @combined := Array[Int].new(0 xx 60);
    for $guard-shifts.values -> @shift {
        for ^60 -> $min {
            @combined[$min]++ if @shift[$min] eq '#';
        }
    }

    return @combined;
}

sub sleepiest-guard-minute(Hash $sleep-log) is export {
    my $max-asleep = 0;
    my $worst-guard;
    my $worst-min;

    for $sleep-log.kv -> $guard, %s {
        my @sleep-map := guard-sleep-map(%s);

        for ^60 -> $min {
            if @sleep-map[$min] > $max-asleep {
                $max-asleep = @sleep-map[$min];
                $worst-guard = $guard;
                $worst-min = $min;
            }
        }

    }

    return $worst-guard, $worst-min;
}
