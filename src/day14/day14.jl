module Day14

using AoC2020
using Combinatorics
using Test

REGISTER_SIZE = 36

function bitmaskValue(bitmask::AbstractString, value::Int)
    n = 0
    for bit ∈ 0:35
        if bitmask[end-bit] == 'X'
            n += value & 1<<bit
        else
            n += parse(Int, bitmask[end-bit])<<bit
        end
    end
    n
end

@test bitmaskValue("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", 11) == 73
@test bitmaskValue("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", 101) == 101
@test bitmaskValue("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X", 0) == 64

function bitmaskRegister(bitmask::AbstractString, value::Int)
    baseMask = parse(Int, replace(bitmask, 'X'=>'0'), base=2)
    clearXMask = parse(Int, replace(replace(bitmask, '0'=>'1'), 'X'=>'0'), base=2)
    baseValue = value & clearXMask | baseMask
    floatingBits = map(x->2^(x[1]-1), Iterators.filter(x->x[2]=='X', enumerate(reverse(bitmask))))

    map(floats ->
        baseValue | sum(floats),
    vcat([[0]], collect(combinations(floatingBits))))
end

@test Set(bitmaskRegister("000000000000000000000000000000X1001X", 42)) == Set([26, 27, 58, 59])
@test Set(bitmaskRegister("00000000000000000000000000000000X0XX", 26)) == Set([16,17,18,19,24,25,26,27])

function part1(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    regs = Dict()
    mask = nothing
    for line ∈ splitLines(input)
        if startswith(line, "mask")
            mask = split(line)[end]
        else
            reg, value = parse.(Int, map(m->line[m], findall(r"\d+", line)))
            regs[reg] = bitmaskValue(mask, value)
        end
    end
    Int(sum(values(regs)))
end

function part2(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    regs = Dict()
    mask = ""
    for line ∈ splitLines(input)
        if startswith(line, "mask")
            mask = split(line)[end]
        else
            address, value = parse.(Int, map(m->line[m], findall(r"\d+", line)))
            for addr ∈ bitmaskRegister(mask, address)
                regs[addr] = value
            end
        end
    end
    Int(sum(values(regs)))
end

sample1 = string(lstrip("""
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0"""))

@test part1(sample1) == 165

@show part1()

sample2 = string(lstrip("""
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
"""))

@test part2(sample2) == 208
@show part2()

end # module Day14
