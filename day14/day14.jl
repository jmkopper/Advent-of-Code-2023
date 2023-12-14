function tilt(row)
    rocks = 0
    newRow = ['.' for _ in eachindex(row)]
    for i in eachindex(row)
        if row[i] == 'O'
            rocks += 1
        elseif row[i] == '#'
            newRow[i] = '#'
            newRow[i-rocks:i-1] .= 'O'
            rocks = 0
        end
    end
    if rocks > 0
        newRow[end-rocks+1:end] .= 'O'
    end
    return newRow
end

weight(row) = findall(==('O'), row) |> sum

@inline rollNorth(grid) = mapslices(reverse ∘ tilt ∘ reverse, grid; dims = 1)
@inline rollWest(grid) = mapslices(reverse ∘ tilt ∘ reverse, grid; dims = 2)
@inline rollSouth(grid) = mapslices(tilt, grid; dims = 1)
@inline rollEast(grid) = mapslices(tilt, grid; dims = 2)
@inline cycle(grid) = (rollEast ∘ rollSouth ∘ rollWest ∘ rollNorth)(grid)

part1(grid) = mapslices(weight ∘ reverse ∘ rollNorth, grid; dims = 1) |> sum

function part2(grid)
    cycleLength = 11
    g1 = copy(grid)
    for _ = 1:1010
        g1 = cycle(g1)
    end
    for _ = 1:((1000000000-1010)%cycleLength)
        g1 = cycle(g1)
    end
    weights = mapslices(weight ∘ reverse, g1; dims = 1)
    return sum(weights)
end

function main()
    grid = stack(collect.(readlines("day14/input.txt")), dims = 1)
    println("Part 1: ", part1(grid))
    println("Part 2: ", part2(grid))
end

main()
