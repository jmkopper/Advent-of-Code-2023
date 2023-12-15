hash(xs) = reduce((x, c) -> (x + Int(c)) * 17 % 256, xs, init=0)
scoreBox(box) = length(box) == 0 ? 0 : sum(i * lens[2] for (i, lens) in enumerate(box))

function part2(steps)
    boxes = [[] for _ in 1:256]

    for step in steps
        typeIdx = findfirst(x -> x == '-' || x == '=', step)
        label = step[1:typeIdx-1]
        boxNum = hash(label) + 1 # smh
        labels = [lens[1] for lens in boxes[boxNum]]
        labelIdx = findfirst(==(label), labels)

        if step[typeIdx] == '-'
            labelIdx !== nothing && deleteat!(boxes[boxNum], labelIdx)
        else
            newLens = (label, parse(Int, step[typeIdx+1:end]))
            if labelIdx === nothing
                push!(boxes[boxNum], newLens)
            else
                boxes[boxNum][labelIdx] = newLens
            end
        end
        
    end

    return sum(i * scoreBox(box) for (i, box) in enumerate(boxes))
end

function main()
    input = read("day15/input.txt", String) |> filter(!=('\n'))
    steps = split(input, ",")
    println("Part 1: ", sum(hash(x) for x in steps))
    println("Part 2: ", part2(steps))
end

main()
