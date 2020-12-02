module Day01

using AoC2020
using Combinatorics

function day01(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    nums = parse.(Int, split(input))

    function check(nums::Array{Int, 1}, n)
        combos = collect(combinations(nums, n))
        idx = findfirst(x -> sum(x)==2020, combos)
        prod(combos[idx])
    end
    check(nums, 2), check(nums, 3)
end

(part1, part2) = day01()

println("Part 1: $part1")
println("Part 2: $part2")

end # module
