module Day19

using AoC2020
using Test

function part1(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    ruleLines, messages = collect.(splitLines.(split(input, "\n\n")))
    patterns = Dict{AbstractString,AbstractString}()
    while !isempty(ruleLines)
        check = popfirst!(ruleLines)
        key, rule = split(check, ": ")
        dependencies = Set(map(m->rule[m], findall(r"\d+", rule)))
        if !all(d->d ∈ keys(patterns), dependencies)
            push!(ruleLines, check)
            continue
        end
        if '"' ∈ rule
            # This is a raw string, so it has one possibility
            s = pop!(match(r"\"(.)\"", rule).captures)
            patterns[key] = s
        else
            sequences = split.(strip.(split(rule, '|')))
            regex = join(join.(map.(x->patterns[x], sequences)), '|')
            patterns[key] = "(?:" * regex * ")"
        end
    end
    pattern = Regex('^' * patterns["0"] * '$')
    length(filter(msg -> occursin(pattern, msg), messages))
end

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

@test part1(sample1) == 2
@test part1(sample2) == 2
@show part1()

end  # module Day19
