using Base.Iterators

function readFile(filename)
    return open(filename) do f
        lines = read(f, String) |> x -> split(x, "\n")
        g = [split(line, "") for line in lines[1:end-1]]
        return g
    end
end

isNum(x)::Bool = tryparse(Int64, x) !== nothing

function findSymbols(input)
    coords = [(i, j) for i in eachindex(input), j in eachindex(input[1])]
    return(filter(((r,c),) -> input[r][c] != "." && !isNum(input[r][c]), coords))
end

function findStars(input)
    coords = [(i, j) for i in eachindex(input), j in eachindex(input[1])]
    return(filter(((r,c),) -> input[r][c] == "*", coords))
end

function getNumFromIndex(input, r, c)::Int64
    rightDigits = takewhile(isNum, input[r][c:end]) |> join
    leftDigits = takewhile(isNum, reverse(input[r][1:c-1])) |> join |> reverse
    return tryparse(Int64, leftDigits*rightDigits)
end

function findNums(symbCoords, input)::Vector{Int64}
    nrows, ncols = length(input), length(input[1])
    r, c = symbCoords
    dirs = [(r-1, c), (r-1, c-1), (r-1, c+1), (r, c-1), (r, c+1), (r+1, c), (r+1, c-1), (r+1, c+1)]
    filter!(((r,c),) -> r > 0 && r <= nrows && c > 0 && c <= ncols && isNum(input[r][c]), dirs)
    vals = [getNumFromIndex(input, x, y) for (x, y) in dirs]
    return unique(vals)
end

function findGears(symbCoords, input)::Int64
    nrows, ncols = length(input), length(input[1])
    r, c = symbCoords
    dirs = [(r-1, c), (r-1, c-1), (r-1, c+1), (r, c-1), (r, c+1), (r+1, c), (r+1, c-1), (r+1, c+1)]
    filter!(((r,c),) -> r > 0 && r <= nrows && c > 0 && c <= ncols && isNum(input[r][c]), dirs)
    vals = unique([getNumFromIndex(input, x, y) for (x, y) in dirs])
    if length(vals) == 2
        return vals[1] * vals[2]
    end
    return 0
end

function main()
    input = readFile("day3/input.txt")
    symbols = findSymbols(input)
    stars = findStars(input)
    nums = vcat([findNums(symbol, input) for symbol in symbols]...)
    gears = [findGears(star, input) for star in stars]
    println("Part 1: ", sum(nums))
    println("Part 2: ", sum(gears))
end

main()
