module Day23

using Test

SHOW_GAME = false

log(s::Any) = SHOW_GAME && println(s)
log() = log("")

function playGameOld(cups::Vector{Int}, numMoves::Int)
    current = cups[begin]
    for move ∈ 1:numMoves
        println("-- move $move --")
        log("cups: $(join([cup==current ? "($cup)" : " $cup " for cup ∈ cups]))")
        # Shift the current one to the beginning to make things easier
        currentIndex = findfirst(.==(current), cups)
        cups = circshift(cups, -currentIndex)
        pickedUp = [popfirst!(cups) for _ ∈ 1:3]
        log("pick up: $(join(pickedUp, ", "))")
        destination = current - 1
        while destination ∉ cups
            if destination == 0
                destination = 10
            end
            destination -= 1
        end
        offset = 6-findfirst(.==(destination), cups)
        log("destination: $destination")
        # Shift the destination to the end so we can use append and not bother with modular arithmetic
        cups = circshift(cups, offset)
        for n ∈ pickedUp
            append!(cups, n)
        end
        # Update current
        updatedIndex = findfirst(.==(current), cups)
        cups = circshift(cups, currentIndex-updatedIndex)
        newCurrentIndex = (findfirst(.==(current), cups)) % 9 + 1
        # Restore for matching printout
        current = cups[newCurrentIndex]
        log()
    end
    log("-- final --")
    log("cups: $(join([cup==current ? "($cup)" : " $cup " for cup ∈ cups]))")
    cups
end

function playGame(cups::Vector{Int}, numTurns::Int)
    nexts = zeros(Int, length(cups))
    for (cup, next) ∈ zip(cups, vcat(cups[2:end], cups[begin:1]))
        nexts[cup] = next
    end
    current = cups[begin]

    function getSeq(cup::Int=current)
        res = Vector{Int}()
        for _ ∈ 1:length(cups)
            append!(res, cup)
            cup = nexts[cup]
        end
        res
    end

    for move ∈ 1:numTurns
        # println("-- move $move --")
        a = nexts[current]
        b = nexts[a]
        c = nexts[b]
        newNext = nexts[c]
        dest = current-1
        while dest==0 || dest==a || dest==b || dest==c
            if dest == 0
                dest = length(cups) + 1
            end
            dest -= 1
        end
        destNext = nexts[dest]
        # println("cups: $(getSeq())")
        # println("pick up: $a, $b, $c")
        # println("destination: $dest")
        # println()
        #=
        Update pointers
        Before: current -> a -> b -> c -> newNext
                dest -> destNext
        After: current -> newNext
               dest -> a -> b -> c -> destNext
        =#
        nexts[current] = newNext
        nexts[dest] = a
        nexts[c] = destNext
        current = newNext
    end
    getSeq(1)
end

sample = [3, 8, 9, 1, 2, 5, 4, 6, 7]
input = [9, 2, 5, 1, 7, 6, 8, 3, 4]

function part1(cups::Vector{Int})
    resultSeq = playGame(cups, 100)
    parse(Int, join(resultSeq[2:end]))
end

function part2(cups::Vector{Int})
    resultSeq = playGame(vcat(cups, length(cups)+1:1000000), 10000000)
    resultSeq[2] * resultSeq[3]
end

@test part1(sample) == 67384529
@show part1(input)

@test part2(sample) == 149245887792
@show part2(input)

end  # module Day23
