#! julia

drifts = Int32[]

function part_2()
    acc = 0
    seen = Set()
    while true
        for drift in drifts
            acc += drift
            if in(acc, seen)
                return acc
            else
                push!(seen, acc)
            end
        end
    end
end

open("day_01.input") do fh
    for ln in eachline(fh)
        push!(drifts, parse(Int32, ln))
    end
end


println("Part 1: ", sum(drifts))
println("Part 2: ", part_2())

