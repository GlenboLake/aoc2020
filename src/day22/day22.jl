module Day22

using AoC2020
using Test

function parseInput(input::String)
    p1, p2 = strip.(split(input, "\n\n"))
    p1deck = parse.(Int, collect(splitLines(p1))[begin+1:end])
    p2deck = parse.(Int, collect(splitLines(p2))[begin+1:end])
    p1deck, p2deck
end

SHOW_GAME = false

log(s::Any) = SHOW_GAME && println(s)
log() = log("")

scoreDeck(deck::Array{Int}) = sum(prod.(enumerate(reverse(deck))))

playGame(input::String = readInput(joinpath(@__DIR__, "input.txt"))) = playGame(parseInput(input))
function playGame(decks::Tuple{Array{Int},Array{Int}})
    round = 1
    while !any(isempty, decks)
        log("-- Round $round --")
        log("Player 1's deck: $(join(decks[1], ", "))")
        log("Player 2's deck: $(join(decks[2], ", "))")
        plays = popfirst!.(decks)
        log("Player 1 plays: $(plays[1])")
        log("Player 2 plays: $(plays[2])")
        winner = plays[1] > plays[2] ? 1 : 2
        log("Player $winner wins the round!")
        log()
        append!(decks[winner], sort(collect(plays), rev=true))
        round += 1
        # sleep(1)
    end
    log()
    log("== Post-game results ==")
    log("Player 1's deck: $(join(decks[1], ", "))")
    log("Player 2's deck: $(join(decks[2], ", "))")
    cards = pop!(filter(!isempty, collect(decks)))
    scoreDeck(cards)
end

sample = """Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10"""

@test parseInput(sample) == ([9,2,6,3,1], [5,8,4,7,10])

@test playGame(sample) == 306
println("Part 1: $(playGame())")

GameState = Tuple{Array{Int},Array{Int}}
gamesPlayed = 0

playRecursive(input::String = readInput(joinpath(@__DIR__, "input.txt"))) = playRecursive(parseInput(input))
function playRecursive(decks::Tuple{Array{Int},Array{Int}})
    global gamesPlayed
    gamesPlayed += 1
    gameNumber = gamesPlayed
    history = Set{GameState}()
    round = 1
    log("=== Game $gameNumber ===")
    while !any(isempty, decks)
        currentState = deepcopy(decks)
        if currentState ∈ history
            log("Immediate win for player 1")
            return 1, scoreDeck(decks[1])
        end
        push!(history, currentState)
        log()
        log("-- Round $round (Game $gameNumber) --")
        log("Player 1's deck: $(join(decks[1], ", "))")
        log("Player 2's deck: $(join(decks[2], ", "))")
        plays = popfirst!.(decks)
        log("Player 1 plays: $(plays[1])")
        log("Player 2 plays: $(plays[2])")
        if length(decks[1]) ≥ plays[1] && length(decks[2]) ≥ plays[2]
            log("Playing a sub-game to determine the winner...\n")
            # @show plays, decks
            winner, _ = playRecursive(Tuple([d[1:p] for (p,d) ∈ zip(plays, decks)]))
            log("...anyway, back to game $gameNumber.")
            log("Player $winner wins round $round of game $(gameNumber)!")
        else
            winner = plays[1] > plays[2] ? 1 : 2
            log("Player $winner wins round $round of game $(gameNumber)!")
        end
        if winner == 2
            plays = reverse(collect(plays))
        end
        append!(decks[winner], plays)
        round += 1
    end
    winner = isempty(decks[1]) ? 2 : 1
    log("The winner of game $gameNumber is player $(winner)!")
    log()
    score = scoreDeck(pop!(filter(!isempty, collect(decks))))
    if gameNumber == 1
        log()
        log("== Post-game results ==")
        log("Player 1's deck: $(join(decks[1], ", "))")
        log("Player 2's deck: $(join(decks[2], ", "))")
        score
    else
        winner, score
    end
end

@test playRecursive(sample) == 291
println("Part 2: $(playRecursive())")

end  # module Day22
