module Day21

using AoC2020
using Test

struct Food
    ingredients::Vector{AbstractString}
    allergens::Vector{AbstractString}
end

using Base
function Base.show(io::IO, food::Food)
    print(io, "Food(")
    print(io, join(food.ingredients, ", "))
    print(io, ". Contains: ")
    print(io, join(food.allergens, ", "))
    print(io, ')')
end

function parseFood(line::AbstractString)
    ingredientList, allergenList = split(line, " (contains ")
    ingredients = split(ingredientList)
    allergens = split(rstrip(allergenList, ')'), ", ")
    Food(ingredients, allergens)
end

function mapAllergens(input::String = readInput(joinpath(@__DIR__, "input.txt")))
    foods = parseFood.(splitLines(input))
    allIngredients = union(map(f->f.ingredients, foods)...)
    allAllergens = union(map(f->f.allergens, foods)...)
    allergenOptions = Dict{AbstractString,Set{AbstractString}}()
    for a ∈ allAllergens
        foodsWith = filter(f->a ∈ f.allergens, foods)
        commonIngredients = intersect(map(f->f.ingredients, foodsWith)...)
        allergenOptions[a] = Set(commonIngredients)
    end
    notAllergens = setdiff(allIngredients, union(values(allergenOptions)...))
    part1 = length(filter(i->i ∈ notAllergens, vcat(map(f->f.ingredients, foods)...)))
    dangerous = Dict{AbstractString,AbstractString}()
    while !isempty(allergenOptions)
        knownAllergens = filter(pair->length(pair.second)==1, allergenOptions)
        for (allergen, source) ∈ knownAllergens
            ingredient = pop!(source)
            pop!(allergenOptions, allergen)
            dangerous[allergen] = ingredient
            for v ∈ values(allergenOptions)
                setdiff!(v, [ingredient])
            end
        end
    end
    part2 = join(map(p->p.second, sort(collect(dangerous))), ',')
    part1, part2
end

sample = """mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)"""

@test mapAllergens(sample) == (5, "mxmxvkd,sqjhc,fvjkl")
@show mapAllergens()

end # module Day21
