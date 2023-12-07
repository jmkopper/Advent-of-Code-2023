import Base.isless

struct Hand
    cards::Vector{String}
end

struct OptimizedHand
    old::Hand
    new::Hand
end

@enum HandType begin
    high
    pair
    twopair
    three
    full
    four
    five
end

const VALS = Dict(string(i) => i for i in 2:9)
VALS["T"] = 10
VALS["J"] = 1
VALS["Q"] = 12
VALS["K"] = 13
VALS["A"] = 14

function handType(h::Hand)::HandType
    counts = Dict(i => length(h.cards[h.cards .== i]) for i in h.cards)
    if length(counts) == 1
        return five
    elseif length(counts) == 2
        return maximum(values(counts)) == 4 ? four : full
    elseif length(counts) == 3
        return maximum(values(counts)) == 3 ? three : twopair
    elseif length(counts) == 4
        return pair
    else
        return high
    end
end

function cmpCards(a::Vector{String}, b::Vector{String})::Bool
    x, y = [VALS[c] for c in a], [VALS[c] for c in b]
    m = x .!= y
    return any(m) ? x[m][1] < y[m][1] : false
end

function Base.isless(a::Hand, b::Hand)::Bool
    return handType(a) == handType(b) ? cmpCards(a.cards, b.cards) : handType(a) < handType(b)
end

function Base.isless(a::OptimizedHand, b::OptimizedHand)::Bool
    return handType(a.new) == handType(b.new) ? cmpCards(a.old.cards, b.old.cards) : handType(a.new) < handType(b.new)
end

function optimizeHand(h::Hand)::OptimizedHand
    if !("J" in h.cards)
        return OptimizedHand(h, h)
    end

    best = Hand(copy(h.cards))
    best.cards[best.cards .== "J"] .= "A"
    jndices = findall(==("J"), h.cards)
    cards = Set(h.cards[h.cards .!= "J"])
    for comb in Iterators.product((cards for _ in 1:length(jndices))...)
        newhand = Hand(copy(h.cards))
        newhand.cards[jndices] .= [x for x in comb]
        best = max(best, newhand)
    end

    return OptimizedHand(h, best)
end

function main()
    lines = readlines("day7/input.txt")
    hands = [Hand(split(line, " ")[1] |> x -> split(x, "")) for line in lines]
    bids = [split(line, " ")[2] for line in lines] .|>  x-> parse(Int, x)
    besthands = [optimizeHand(h) for h in hands]
    order = sortperm(besthands)
    p2 = sum(x * y for (x, y) in enumerate(bids[order]))
    println("Part 2: ", p2)
end

main()
