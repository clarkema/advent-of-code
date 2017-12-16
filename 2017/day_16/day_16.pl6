#! /usr/bin/env perl6

grammar Dance {
    token TOP      { <move>* % \, }
    token move     { <spin> | <exchange> | <partner> }
    token spin     { 's' <num> }
    token exchange { 'x' <num> '/' <num> }
    token partner  { 'p' <id> '/' <id> }

    token num { \d+ }
    token id { <[a..z]> }
}

class DanceActions {
    has @.programs = ['a'..'p'];

    multi method spin(Int $i) {
        @!programs = [|@!programs[*-$i..Inf], |@!programs[0 .. *-($i + 1)]];
    }
    multi method spin(Dance $/) { self.spin: $/<num>.Int; }

    multi method exchange(Int $a, Int $b) {
        @!programs[$a,$b] .= reverse;
    };
    multi method exchange(Dance $/) {
        my Int @p = $/<num>[0,1].map: *.Int;
        self.exchange: |@p;
    };

    multi method partner(Str $a, Str $b)  {
        @!programs[
            @!programs.grep($a, :k).first,
            @!programs.grep($b, :k).first
        ] .= reverse;
    };
    multi method partner(Dance $/)  {
        my Str @p = $/<id>[0,1].map: *.Str;
        self.partner: |@p;
    };
}


my $actions = DanceActions.new;
Dance.parse('day_16.input'.IO.slurp.chomp, :$actions);

say "Part 1: ", $actions.programs.join('');
