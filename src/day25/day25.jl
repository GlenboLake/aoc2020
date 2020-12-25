module Day25

using Test

function loopSize(key::Int)
    value = 1
    loops = 0
    while value ≠ key
        value = mod(value*7, 20201227)
        loops += 1
    end
    loops
end

function solve(cardKey::Int, doorKey::Int)
    cardLoop = loopSize(cardKey)
    doorLoop = loopSize(doorKey)
    value1 = 1
    for _ ∈ 1:doorLoop
        value1 = mod(value1*cardKey, 20201227)
    end
    value2 = 1
    for _ ∈ 1:cardLoop
        value2 = mod(value2*doorKey, 20201227)
    end
    @assert value1 == value2
    value1
end

@test loopSize(5764801) == 8
@test loopSize(17807724) == 11

@test solve(5764801, 17807724) == 14897079

input = [19241437, 17346587]

@show solve(input...)

end  # module Day25
