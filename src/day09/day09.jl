module Day09

using AoC2020
using Combinatorics

function inSums(n::Int, nums::Array{Int})
    for combo ∈ combinations(nums, 2)
        if sum(combo) == n
            return true
        end
    end
    false
end

function solve(input::String = readInput(joinpath(@__DIR__, "input.txt")), len=25)
    part1 = part2 = nothing
    nums = parse.(Int, splitLines(input))
    prev = nums[begin:len]
    remaining = nums[len+1:end]
    part1 = nothing
    while !isempty(remaining)
        n = popfirst!(remaining)
        if !inSums(n, prev)
            part1 = n
            break
        end
        popfirst!(prev)
        push!(prev, n)
    end

    a, b = 1, 2
    while b < length(nums)
        range = nums[a:b]
        if sum(range) == part1
            part2 = minimum(range) + maximum(range)
            break
        elseif sum(range) < part1
            b += 1
        else
            a += 1
        end
    end

    part1, part2
end

sample = """35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576"""

# println(solve(sample, 5))
println(solve())

end  # module Day09
