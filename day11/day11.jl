function dist(p, q, emptyRows, emptyCols, scale)
    r1, r2 = max(p[1], q[1]), min(p[1], q[1])
    c1, c2 = max(p[2], q[2]), min(p[2], q[2])
    crossCols = count(c -> c > c2 && c < c1, emptyCols)
    crossRows = count(r -> r > r2 && r < r1, emptyRows)
    return (r1 - r2) + (c1 - c2) + crossCols * (scale - 1) + crossRows * (scale - 1)
end

function addDists(grid, scale)
    gxs = [(r, c) for r = 1:size(grid, 1), c = 1:size(grid, 2)]
    gxs = filter(x -> grid[x[1], x[2]] == '#', gxs)
    erows = filter(r -> all(grid[r, :] .== '.'), 1:size(grid, 1))
    ecols = filter(c -> all(grid[:, c] .== '.'), 1:size(grid, 2))
    return sum(sum(dist(p, q, erows, ecols, scale) for q in gxs[i+1:end]) for (i, p) in enumerate(gxs[1:end-1]))
end

function main()
    grid = stack(collect.(readlines("day11/input.txt")), dims = 1)
    println("Part 1: ", addDists(grid, 2))
    println("Part 2: ", addDists(grid, 1000000))
end

main()
