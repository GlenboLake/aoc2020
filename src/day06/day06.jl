module Day06

using AoC2020

function day06(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    groups = split(input, "\n\n")

    part1 = sum(map(group -> length(union(split(group)...)), groups))
    part2 = sum(map(group -> length(intersect(split(group)...)), groups))
    part1, part2
end

flush(stdout)
part1, part2 = day06()

println("Part 1: $part1")
println("Part 2: $part2")

end  # module Day06
