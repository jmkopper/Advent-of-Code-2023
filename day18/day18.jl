const DIRS = Dict('U' => (1, 0), 'R' => (0, 1), 'D' => (-1, 0), 'L' => (0, -1))
const DIG_TO_DIR = Dict('0' => 'R', '1' => 'D', '2' => 'L', '3' => 'U')

function find_vertices(instructions, init = (0, 0))
    vertices = [init]
    (x, y) = init
    steps = 0
    for (dir, num) in instructions
        dx, dy = DIRS[dir]
        push!(vertices, (x + num * dx, y + num * dy))
        x, y = x + num * dx, y + num * dy
        steps += num
    end
    return vertices, steps
end

function walk(instructions)
    vertices, steps = find_vertices(instructions)
    area = sum((
        v1[2] * v2[1] - v2[2] * v1[1] for
        (v1, v2) in zip(vertices[1:end-1], vertices[2:end])
    ))
    area = div(abs(area), 2)
    return area + div(steps, 2) + 1
end

function fixinstructions(input)
    hs = [line[3] for line in input]
    dirs = []
    for h in hs
        lastdig = h[end-1]
        dir = DIG_TO_DIR[lastdig]
        num = parse(Int, h[3:end-2]; base = 16)
        push!(dirs, (dir, num))
    end
    return dirs
end

function part2(input)
    instructions = [
        (DIG_TO_DIR[line[3][end-1]], parse(Int, line[3][3:end-2]; base = 16)) for
        line in input
    ]
    return walk(instructions)
end
part1(input) = walk([(line[1][1], parse(Int, line[2])) for line in input])

function main()
    input = readlines("day18/input.txt") .|> split
    println(part1(input))
    println(part2(input))
end

main()
