function parseRow(row)
    vals = split(split(row, ":")[2], [',', ';']) .|> strip
    rgb = Dict("red" => 0, "blue" => 0, "green" => 0)
    for v in vals
        count, color = split(v)
        rgb[color] = max(parse(Int, count), rgb[color])
    end
    return rgb
end

validRow(rgb) = rgb["red"] <= 12 && rgb["green"] <= 13 && rgb["blue"] <= 14

function main()
    input = readlines("day2/input.txt")
    m = [parseRow(row) for row in input]
    println("Part 1: ", (1:length(input))[validRow.(m)] |> sum)
    println("Part 2: ", sum(x["red"] * x["green"] * x["blue"] for x in m))
end

main()
