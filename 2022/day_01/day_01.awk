#! gawk -f

function sort_desc(i1, v1, i2, v2) {
    if (v1 < v2)
        return 1
    else if (v1 == v2)
        return 0
    else
        return -1
}

function sum(array, from, to) {
    acc = 0
    for (i = from; i <= to; i++) {
        acc += array[i]
    }
    return acc
}

BEGIN {
    RS=""
    FS="\n"
}

{
    elf_calories[NR] = 0
    for (i = 1; i <= NF; i++) {
        elf_calories[NR] += $i
    }
}

END {
    asort(elf_calories, sorted, "sort_desc")
    print "Part 1:", sorted[1]
    print "Part 2:", sum(sorted, 1, 3)
}
