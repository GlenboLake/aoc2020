module Day01

using AoC2020

function part1(nums::Array{Int, 1})
    for (i, a) in enumerate(nums)
        for b in nums[i+1:end]
            if a + b == 2020
                return a*b
            end
        end
    end
end

function part2(nums::Array{Int, 1})
    for (i, a) in enumerate(nums)
        for (j, b) in enumerate(nums[i+1:end])
            for c in nums[i+j+1:end]
                if a+b+c==2020
                    return a*b*c
                end
            end
        end
    end
end

function day01(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    nums = parse.(Int, split(input))
    part1(nums), part2(nums)
end

# println(day01("1721 979 366 299 675 1456"))
println(day01())

end # module
