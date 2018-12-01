#! gawk -f

{ sum += $1 }
END { print sum }
