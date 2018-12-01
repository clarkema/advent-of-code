import strutils
import sequtils
import math
import intsets

proc part_2(drifts: seq): int =
  var seen = initIntSet()
  var acc = 0
  while true:
    for i in drifts:
      acc = acc + i
      if seen.contains(acc):
        return acc
      else:
        seen.incl(acc)

let drifts = readFile("../day_01.input").strip.splitlines.map(parseInt)

echo "Part 1: ", drifts.sum()
echo "Part 2: ", part_2(drifts)
