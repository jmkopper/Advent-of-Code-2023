import Base.isless

struct Hand
    cards::Vector{String}
end

struct OptimizedHand
    old::Hand
    new::Hand
end

const VALS1 = Dict(zip([[string(i) for i in 2:9]; ["T", "J", "Q", "K", "A"]], 2:14))
const VALS2 = Dict(zip([[string(i) for i in 2:9]; ["T", "J", "Q", "K", "A"]], [2:9; [10, 1, 12, 13, 14]]))

function handType(h::Hand)::Int
    counts = Dict(i => length(h.cards[h.cards .== i]) for i in h.cards)
    length(counts) == 1 && return 6
    length(counts) == 2 && return maximum(values(counts)) == 4 ? 5 : 4
    length(counts) == 3 && return maximum(values(counts)) == 3 ? 3 : 2
    length(counts) == 4 && return 1
    return 0
end

function cmpCards(a::Vector{String}, b::Vector{String}, vals)::Bool
    x, y = [vals[c] for c in a], [vals[c] for c in b]
    m = x .!= y
    return any(m) ? x[m][1] < y[m][1] : false
end

function Base.isless(a::Hand, b::Hand)::Bool
    return handType(a) == handType(b) ? cmpCards(a.cards, b.cards, VALS1) : handType(a) < handType(b)
end

function Base.isless(a::OptimizedHand, b::OptimizedHand)::Bool
    return handType(a.new) == handType(b.new) ? cmpCards(a.old.cards, b.old.cards, VALS2) : handType(a.new) < handType(b.new)
end

function optimizeHand(h::Hand)::OptimizedHand
    all(h.cards .== "J") && return OptimizedHand(h, Hand(["A" for _ in 1:5]))

    counts = Dict(i => length(h.cards[h.cards .== i]) for i in h.cards)
    delete!(counts, "J")

    top = collect(keys(counts))[argmax(collect(values(counts)))]
    new = Hand(copy(h.cards))
    new.cards[new.cards .== "J"] .= top

    return OptimizedHand(h, new)
end

function main()
    lines = readlines("day7/input.txt")
    hands = [Hand(split(line, " ")[1] |> x -> split(x, "")) for line in lines]
    bids = [split(line, " ")[2] for line in lines] .|>  x-> parse(Int, x)
    besthands = [optimizeHand(h) for h in hands]
    p1 = sum(x * y for (x, y) in enumerate(bids[sortperm(hands)]))
    println("Part 1: ", p1)
    p2 = sum(x * y for (x, y) in enumerate(bids[sortperm(besthands)]))
    println("Part 2: ", p2)
end

main()
