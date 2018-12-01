#! gawk -f

{
    sum += $1
    drifts[NR] = $1
}
END {
    print "Part 1: " sum

    acc = 0
    while (1) {
        for (i in drifts) {
            acc += drifts[i]
            if (acc in seen) {
                print "Part 2: " acc
                exit 1
            }
            else {
                seen[acc]++
            }
        }
    }
}
