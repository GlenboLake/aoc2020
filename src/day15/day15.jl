module Day15

using AoC2020
using Test

input = [1, 17, 0, 10, 18, 11, 6]

function playGame(startingNumbers::Array{Int}, n::Int)
    history = Dict{Int,Int}([
        num => i
        for (i, num) ∈ enumerate(startingNumbers[begin:end-1])
    ])
    lastSpoken = startingNumbers[end]
    for i ∈ length(startingNumbers)+1:n
        newNum = lastSpoken ∈ keys(history) ? i - 1 - history[lastSpoken] : 0
        history[lastSpoken] = i - 1
        lastSpoken = newNum
    end
    lastSpoken
end

expected = [0,3,6,0,3,3,1,0,4,0]
for i ∈ 4:length(expected)
    @test playGame([0,3,6], i) == expected[i]
end
@test playGame([0,3,6], 2020) == 436

println("Part 1: $(playGame(input, 2020))")
println("Part 2: $(playGame(input, 30000000))")

end  # module Day15
