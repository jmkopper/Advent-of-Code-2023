D(row) = [row[i] - row[i-1] for i in eachindex(row)[2:end]]

function dtz(rows)
    all(rows[end] .== 0) && return rows
    return dtz([rows; [D(rows[end])]])
end

part1(history) = (sum(d[end] for d in dtz([row])) for row in history) |> sum
part2(history) = (foldr(-, d[1] for d in dtz([row])) for row in history) |> sum

function main()
    input = readlines("day9/input.txt")
    history = [split(line, " ") .|> x -> parse(Int, x) for line in input]
    println("Part 1: ", part1(history))
    println("Part 2: ", part2(history))
end

main()
