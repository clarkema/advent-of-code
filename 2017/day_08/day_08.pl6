#! /usr/bin/env perl6

#use Grammar::Tracer;

grammar Instruction {
    rule TOP { <target> <action> <change> 'if' <testreg> <testop> <testval> }
    token target  { <.register> }
    token action  { 'inc' | 'dec' }
    token change  { <.int> }
    token testreg { <.register> }
    token testop  { '>' | '<' | '>=' | '<=' | '==' | '!=' }
    token testval { <.int> }

    token int { \-?\d+ }
    token register { <[a..z]>+ }
}

my %regs = Hash.new;
my $highest_ever = 0;

for 'day_08.input'.IO.lines -> $line {
    if my $m = Instruction.parse($line) {
        my $target = $m<target>.Str;
        my $testreg = $m<testreg>.Str;

        %regs{$target} //= 0;

        my &op = do given $m<testop>.Str {
            when ">"  { &infix:«>»  }
            when "<"  { &infix:«<»  }
            when "<=" { &infix:«<=» }
            when ">=" { &infix:«>=» }
            when "==" { &infix:«==» }
            when "!=" { &infix:«!=» }
        }

        if &op( %regs{$testreg} //= 0, $m<testval>.Int ) {
            %regs{$target} += $m<change>.Int if $m<action> eq 'inc';
            %regs{$target} -= $m<change>.Int if $m<action> eq 'dec';
        }

        $highest_ever max= %regs.values.max;
    }
    else {
        die "Failed to parse $line";
    }
}

say "Largest: ", %regs.values.max;
say "Highest ever: ", $highest_ever;
