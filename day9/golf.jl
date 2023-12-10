dtz(rows) = iszero(rows[end]) ? rows : dtz([rows; [diff(rows[end])]])
p(i) = sum(sum(d[end] for d in dtz([x])) for x in i)
i = readlines("day9/input.txt") .|> x -> parse.(Int,split(x))
println("Part 1: ", p(i), "\nPart 2: ", p(reverse.(i)))
