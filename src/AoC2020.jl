module AoC2020

using Printf

const solvedDays = []

for day in solvedDays
    ds = @sprintf("%02d", day)
    modulePath = joinpath(@__DIR__, "day$ds", "day$ds.jl")
    println("Including $modulePath")
    include(modulePath)
end

export readInput
function readInput(path::String)
    s = open(path, "r") do file
        read(file, String)
    end
    return s
end

export splitLines
function splitLines(text::AbstractString)
    eachline(IOBuffer(chomp(text)))
end

export stringAsGrid
function stringAsGrid(string::String)
    reduce(vcat, permutedims.(collect.(splitLines(string))))
end

end # module
