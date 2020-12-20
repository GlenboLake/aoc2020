module Day19

using AoC2020
using Test

sample1 = string(chomp("""
0: 1 2
1: "a"
2: 1 3 | 3 1
3: "b"

aaa
aab
aba
abb
baa
bab
bba
bbb
"""))

sample2 = string(chomp("""
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
"""))

function validate(msg::AbstractString, rules::Dict{Int,Union{AbstractString,Vector{Vector{Int}}}}, seq = [0])
    if isempty(msg) || isempty(seq)
        return isempty(msg) && isempty(seq)
    end
    firstRule = rules[seq[begin]]
    if firstRule isa AbstractString
        firstRule == msg[begin:begin] || return false
        validate(msg[2:end], rules, seq[2:end])
    else
        any(validate(msg, rules, vcat(t, seq[2:end])) for t ∈ firstRule)
    end
end

function parseInput(input::String)
    ruleInput, msgInput = split(input, "\n\n")
    messages = collect(splitLines(msgInput))
    rules = Dict{Int,Union{AbstractString,Vector{Vector{Int}}}}()
    for line ∈ splitLines(ruleInput)
        key, value = split(line, ": ")
        key = parse(Int, key)
        if '"' ∈ value
            rules[key] = value[begin+1:end-1]
        else
            patterns = map(s -> parse.(Int, split(s)), strip.(split(value, '|')))
            rules[key] = patterns
        end
    end
    rules, messages
end

function part1(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    rules, messages = parseInput(input)
    length(filter(msg->validate(msg, rules), messages))
end

function part2(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    rules, messages = parseInput(input)
    rules[8] = [[42], [42, 8]]
    rules[11] = [[42, 31], [42, 11, 31]]
    length(filter(msg->validate(msg, rules), messages))
end


@test part1(sample1) == 2
@test part1(sample2) == 2
@show part1()
@show part2()

end  # module Day19
