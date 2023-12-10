struct SDMap
    sources::Vector{Int}
    destinations::Vector{Int}
    lengths::Vector{Int}
end

function lookup(map::SDMap, source::Int)::Int
    for (s, d, len) in zip(map.sources, map.destinations, map.lengths)
        if s <= source && source <= s + len
            return d + source - s
        end
    end
    return source
end

function parseMap(rows::AbstractString)::SDMap
    rows = split(rows, "\n")[2:end]
    sources, destinations, lengths = [], [], []
    for row in rows
        sep = split(row)
        push!(sources, parse(Int, sep[2]))
        push!(destinations, parse(Int, sep[1]))
        push!(lengths, parse(Int, sep[3]))
    end
    return SDMap(sources, destinations, lengths)
end

getLocation(seed, maps) = foldl((x, y) -> lookup(y, x), maps, init = seed)

function makeIntervals(pair::Tuple{Int,Int}, map::SDMap)::Vector{Tuple{Int,Int}}
    intervals = Tuple{Int,Int}[]
    leftmost = minimum(map.sources)
    if pair[1] < leftmost
        push!(intervals, (pair[1], min(pair[1] + pair[2], leftmost - pair[1])))
    end
    for (s, d, len) in zip(map.sources, map.destinations, map.lengths)
        if pair[1] + pair[2] >= s && pair[1] <= s + len
            left = d + max(pair[1], s) - s
            right = d + min(pair[1] + pair[2], s + len) - s
            push!(intervals, (left, right - left))
        end
    end
    return intervals
end

function part2(pairs::Vector{Tuple{Int,Int}}, maps::Vector{SDMap})::Int
    best = typemax(Int)
    for pair in pairs
        intervals = [pair]
        for map in maps
            newIntervals = [makeIntervals(p, map) for p in intervals]
            intervals = vcat(newIntervals...)
        end
        best = min(best, minimum(x for (x, _) in intervals))
    end
    return best
end

function main()
    input = read("day5/input.txt", String) |> strip
    chunks = split(input, "\n\n")

    seeds = split(split(chunks[1], ": ")[2]) .|> x -> tryparse(Int, x)
    maps = [parseMap(chunk) for chunk in chunks[2:end]]
    locs = [getLocation(seed, maps) for seed in seeds]

    println("Part 1: ", minimum(locs))

    pairs = [(seeds[i], seeds[i+1]) for i = 1:2:length(seeds)]
    println("Part 2: ", part2(pairs, maps))
end

main()
