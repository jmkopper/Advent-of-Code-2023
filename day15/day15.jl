struct Lens
    label::String
    focalLength::Int
end

function hash(xs::AbstractString)::Int
    cur = 0
    for c in xs
        cur += Int(c)
        cur *= 17
        cur %= 256
    end
    return cur
end

function part2(steps)
    boxes::Vector{Vector{Lens}} = [[] for _ in 1:256]

    for step in steps
        typeIdx = findfirst(x -> x == '-' || x == '=', step)
        label = step[1:typeIdx-1]
        boxNum = hash(label) + 1 # smh
        labels = [lens.label for lens in boxes[boxNum]]
        labelIdx = findfirst(==(label), labels)

        if step[typeIdx] == '-'
            labelIdx !== nothing && deleteat!(boxes[boxNum], labelIdx)
        else
            newLens = Lens(label, parse(Int, step[typeIdx+1:end]))
            if labelIdx === nothing
                push!(boxes[boxNum], newLens)
            else
                boxes[boxNum][labelIdx] = newLens
            end
        end
        
    end

    return sum(i * scoreBox(box) for (i, box) in enumerate(boxes))
end

function scoreBox(box::Vector{Lens})
    length(box) == 0 && return 0
    sum(i * lens.focalLength for (i, lens) in enumerate(box))
end

function main()
    input = read("day15/input.txt", String) |> filter(!=('\n'))
    steps = split(input, ",")
    println("Part 1: ", sum(hash(x) for x in steps))
    println("Part 2: ", part2(steps))
end

main()
