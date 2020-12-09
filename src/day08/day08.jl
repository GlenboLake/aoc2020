module Day08

using AoC2020

struct Instruction
    op::AbstractString
    arg::Int
end

function loadProgram(input::String)
    function parseLine(line::AbstractString)
        op, arg = split(line)
        Instruction(op, parse(Int, arg))
    end
    parseLine.(splitLines(input))
end

function debugProgram(prog::Array{Instruction})
    acc = 0
    iPtr = 1
    seen = Set{Int}()
    while iPtr ∈ 1:length(prog)
        if iPtr ∈ seen
            return false, acc
        else
            push!(seen, iPtr)
        end
        instruction = prog[iPtr]
        if instruction.op == "nop"
            iPtr += 1
        elseif instruction.op == "acc"
            acc += instruction.arg
            iPtr += 1
        elseif instruction.op == "jmp"
            iPtr += instruction.arg
        else
            println("Invalid instruction: $instruction")
        end
    end
    true, acc
end

function day08(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    prog = loadProgram(input)
    _, part1 = debugProgram(prog)
    part2 = nothing
    for i ∈ eachindex(prog)
        if prog[i].op ∈ ("nop", "jmp")
            otherOp = prog[i].op == "nop" ? "jmp" : "nop"
            progCopy = copy(prog)
            progCopy[i] = Instruction(otherOp, prog[i].arg)
            success, result = debugProgram(progCopy)
            if success
                part2 = result
                break
            end
        end
    end
    part1, part2
end

flush(stdout)
println()

println(day08())

end # module Day08
