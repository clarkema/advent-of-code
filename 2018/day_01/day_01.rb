#! ruby

require 'set'

def part_2(drifts)
    seen = Set.new
    freq = 0
    drifts.cycle do |delta|
        freq += delta
        break freq unless seen.add?(freq)
    end
end

drifts = File.new("day_01.input").each_line.map(&:to_i)

puts "Part 1: #{drifts.sum}"
puts "Part 2: #{part_2(drifts)}"
