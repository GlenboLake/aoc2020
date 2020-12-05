module Day04

using AoC2020

function validateHeight(height::AbstractString)
    value = parse(Int, height[1:end-2])
    unit = height[end-1:end]
    if unit == "cm"
        return value ∈ 150:193
    elseif unit == "in"
        return value ∈ 59:76
    end
    false
end

rules = Dict(
    "byr" => x -> parse(Int, x) in 1920:2020,
    "iyr" => x -> parse(Int, x) in 2010:2020,
    "eyr" => x -> parse(Int, x) in 2020:2030,
    "hgt" => validateHeight,
    "hcl" => x -> occursin(r"^#[0-9a-f]{6}$", x),
    "ecl" => x -> x ∈ ["amb" "blu" "brn" "gry" "grn" "hzl" "oth"],
    "pid" => x -> occursin(r"^\d{9}$", x),
    "cid" => x -> true
)

function day04(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    requiredFields = Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])
    passports = map(p -> Dict(split.(p, ":")), split.(split(input, "\n\n")))
    allFieldsPresent = filter(
        passport -> isempty(setdiff(requiredFields, keys(passport))),
        passports
    )
    part1 = length(allFieldsPresent)
    check(passport) = all(rules[field](value) for (field, value) ∈ passport)
    part2 = length(filter(check, allFieldsPresent))
    (part1, part2)
end

part1, part2 = day04()

println("Part 1: $part1")
println("Part 2: $part2")

end # module Day04
