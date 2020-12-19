module Day18

using AoC2020
using Test

DEBUG = false

DIGITS = "123456789"

add(x,y) = x+y
mul(x,y) = x*y
OPS = Dict([
    '+' => add,
    '*' => mul
])

function solveWithRegex(expr::String)
    println("Solving $expr")
    while '(' ∈ expr
        println("parens found in $expr")
        parens = findfirst(r"\([\d +*]+\)", expr)
        innerValue = string(solve(expr[parens][begin+1:end-1]))
        print("$expr -> ")
        expr = expr[begin:parens.start-1] * innerValue * expr[parens.stop+1:end]
        println(expr)
    end
    # At this point, we should just have numbers.
    # We know from looking at the input that everything is 1 digit, and we should never start with a space
    @assert expr[begin] ∈ DIGITS
    value = parse(Int, expr[begin])
    op = nothing
    opch = nothing
    for ch ∈ expr[2:end]
        if ch in "+*"
            opch = ch
            op = OPS[ch]
        elseif ch ∈ DIGITS
            nextValue = parse(Int, ch)
            println("Evaluating $value $opch $nextValue = $(op(value, nextValue))")
            value = op(value, nextValue)
        end
    end
    @show value
end

function solve(expr::String)
    tokens = collect(filter(!isspace, expr))
    stack = []
    for token ∈ tokens
        if token ∈ DIGITS
            push!(stack, parse(Int, token))
        elseif token == ')'
            openPos = findlast(x->x=='(', stack)
            # After reducing, the open parentheses should have a single number after it.
            # We can just pop the open parenthesis from the stack.
            @assert openPos == length(stack)-1
            popat!(stack, openPos)
        elseif token == '('
            push!(stack, token)
        elseif token ∈ keys(OPS)
            push!(stack, OPS[token])
        end
        if length(stack) ≥ 3 && stack[end-2] isa Number && stack[end-1] isa Function && stack[end] isa Number
            b = pop!(stack)
            op = pop!(stack)
            a = pop!(stack)
            push!(stack, op(a,b))
        end
    end
    pop!(stack)
end

part1(input::String = readInput(joinpath(@__DIR__, "input.txt"))) = sum(solve.(splitLines(input)))

@test solve("1 + 2 * 3 + 4 * 5 + 6") == 71
@test solve("1 + (2 * 3) + (4 * (5 + 6))") == 51
@test solve("2 * 3 + (4 * 5)") == 26
@test solve("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 437
@test solve("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 12240
@test solve("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 13632

@show part1()

function solve2(expr::String)
    # Screw it, we'll reduce with regex this time
    # They're still well-formatted so we can remove spaces
    expr = filter(!isspace, expr)
    ADD = r"(\d+)\+(\d+)"
    MUL = r"(?<!\+)\b(\d+)\*(\d+)\b(?!\+)"
    EMPTY_PARENS = r"\((\d+)\)"
    FINISHED = r"^\d+$"
    while !occursin(FINISHED, expr)
        # First reduce adds
        while occursin(ADD, expr)
            m = match(ADD, expr)
            value = sum(parse.(Int, m.captures))
            expr = replace(expr, ADD => string(value), count=1)
        end
        # Next reduce muls
        while occursin(MUL, expr)
            m = match(MUL, expr)
            value = prod(parse.(Int, m.captures))
            expr = replace(expr, MUL => string(value), count=1)
        end
        # Remove unnecessary parentheses before continuing
        expr = replace(expr, EMPTY_PARENS => s"\1")
    end
    parse(Int, expr)
end

part2(input::String = readInput(joinpath(@__DIR__, "input.txt"))) = sum(solve2.(splitLines(input)))

@test solve2("1 + 2 * 3 + 4 * 5 + 6") == 231
@test solve2("1 + (2 * 3) + (4 * (5 + 6))") == 51
@test solve2("2 * 3 + (4 * 5)") == 46
@test solve2("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 1445
@test solve2("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 669060
@test solve2("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 23340
# Line from my input that caused problems at first
@test solve2("3 * (9 * 7) + 4 + 6 * 4") == 876

@show part2()

end  # module Day18
