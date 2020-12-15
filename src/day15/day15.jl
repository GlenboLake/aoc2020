module Day15

using AoC2020
using Test

input = [1, 17, 0, 10, 18, 11, 6]

function playGame(startingNumbers::Array{Int}, n::Int)
    history = ones(Int, n) .* -1
    history[1:length(startingNumbers)] = startingNumbers
    # @show history
    for i ∈ length(startingNumbers)+1:n
        if i%10000 == 0
            @show i
        end
        lastSpoken = history[i-1]
        prev = findlast(x->x==lastSpoken, history[begin:i-2])
        if prev ≡ nothing
            history[i] = 0
        else
            history[i] = i-1-prev
        end
    end
    history[n]
end

expected = [0,3,6,0,3,3,1,0,4,0]
for i ∈ 4:length(expected)
    @test playGame([0,3,6], i) == expected[i]
end
@test playGame([0,3,6], 2020) == 436

@show playGame(input, 2020)

end  # module Day15
