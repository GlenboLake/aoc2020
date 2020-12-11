module Day10

using AoC2020
using Memoize

function day10(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    nums = sort(parse.(Int, splitLines(input)))
    nums = vcat([0], nums, [nums[end]+3])

    diffs = [b-a for (a,b) in zip(nums, nums[2:end])]
    part1 = sum(diffs.==1) * sum(diffs.==3)

    # Build a mapping of which adapters can plug into which
    branches = Dict([
        i => intersect(nums, i.+[1,2,3])
        for i ∈ nums[begin:end-1]
    ])

    @memoize function countPaths(n::Int)
        n ∈ keys(branches) || return 1
        sum(map(x -> countPaths(x), branches[n]))
    end
    part2 = countPaths(0)

    part1, part2
end

flush(stdout)
part1, part2 = day10()

println("Part 1: $part1")
println("Part 2: $part2")

end # module Day10
