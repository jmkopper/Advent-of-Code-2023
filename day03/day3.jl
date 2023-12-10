function readFile(filename)
    return open(filename) do f
        lines = read(f, String) |> x -> split(x, "\n")
        g = [split(line, "") for line in lines[1:end-1]]
        return g
    end
end

isNum(x)::Bool = tryparse(Int64, x) !== nothing

function findNumberIndices(row)::Vector{UnitRange{Int}}
    indices::Vector{UnitRange{Int}} = []
    inNumber = false
    left, right = 1, 1
    for (i, char) in enumerate(row)
        if isNum(char)
            if !inNumber
                left = i
            end
            right = i
            inNumber = true
        else
            if inNumber
                push!(indices, left:right)
            end
            inNumber = false
        end
    end
    if inNumber
        push!(indices, left:right)
    end
    return indices
end

function hasAdjacentSymbol(input, row, range::UnitRange{Int})::Bool
    dirs = [x for x in -1:1 if x + row > 0 && x + row <= length(input)]
    effectiveRange = max(range.start-1, 1):min(range.stop+1, length(input[1]))
    for d in dirs
        if any(x != "." && !isNum(x) for x in input[d + row][effectiveRange])
            return true
        end
    end
    return false
end

function part1(input)
    total = 0
    for (rowIndex, row) in enumerate(input)
        rs = findNumberIndices(row)
        ns = [parse(Int, join(row[r])) for r in rs]
        m = [hasAdjacentSymbol(input, rowIndex, r) for r in rs]
        total += sum(ns[m])
    end
    return total
end

function findStars(input)
    coords = [(i, j) for i in eachindex(input), j in eachindex(input[1])]
    return (filter(((r, c),) -> input[r][c] == "*", coords))
end

function getRangeFromIndex(row, idx)
    left, right = idx, idx
    while left > 1 && isNum(row[left-1])
        left -= 1
    end
    while right < length(row) && isNum(row[right+1])
        right += 1
    end
    return left:right
end

function findGears(symbCoords, input)::Int64
    nrows, ncols = length(input), length(input[1])
    r, c = symbCoords
    dirs = [
        (r - 1, c),
        (r - 1, c - 1),
        (r - 1, c + 1),
        (r, c - 1),
        (r, c + 1),
        (r + 1, c),
        (r + 1, c - 1),
        (r + 1, c + 1),
    ]
    filter!(
        ((r, c),) -> r > 0 && r <= nrows && c > 0 && c <= ncols && isNum(input[r][c]),
        dirs,
    )
    indices = unique([(r, getRangeFromIndex(input[r], c)) for (r, c) in dirs])
    vals = [parse(Int, join(input[r][range])) for (r, range) in indices]

    return length(vals) == 2 ? vals[1] * vals[2] : 0
end

function main()
    input = readFile("day3/input.txt")
    stars = findStars(input)
    gears = [findGears(star, input) for star in stars]
    println("Part 1: ", part1(input))
    println("Part 2: ", sum(gears))
end

main()
