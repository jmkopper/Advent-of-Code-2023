abstract type Node end

mutable struct Conjunction <: Node
    name::String
    memory::Dict{String,Int}
    outputs::Vector{String}
end

mutable struct FlipFlop <: Node
    name::String
    state::Int
    outputs::Vector{String}
end

struct Broadcaster <: Node
    name::String
    outputs::Vector{String}
end

struct Pulse
    source::Union{String,Nothing}
    destination::String
    value::Int
end

mutable struct Output <: Node
    name::String
end

function process_pulse!(node::FlipFlop, pulse::Pulse)
    pulse.value == 1 && return []
    node.state = 1 - node.state
    return [Pulse(node.name, output, node.state) for output in node.outputs]
end

function process_pulse!(node::Conjunction, pulse::Pulse)
    node.memory[pulse.source] = pulse.value
    if sum(values(node.memory)) == length(node.memory)
        return [Pulse(node.name, output, 0) for output in node.outputs]
    end
    return [Pulse(node.name, output, 1) for output in node.outputs]
end

process_pulse!(node::Output, pulse::Pulse) = []

function process_pulse!(node::Broadcaster, pulse::Pulse)
    return [Pulse(node.name, output, pulse.value) for output in node.outputs]
end

function init_nodes(lines)
    nodes = Dict{String,Node}()
    cnjs = Set{String}()
    for line in lines
        s = split(line, " -> ")
        outputs = split(s[2], ", ")
        if line[1] != '&' && line[1] != '%'
            nodes["broadcaster"] = Broadcaster("broadcaster", outputs)
        elseif line[1] == '&'
            n = s[1][2:end]
            newcnj = Conjunction(n, Dict(), outputs)
            nodes[n] = newcnj
            push!(cnjs, n)
        elseif line[1] == '%'
            n = s[1][2:end]
            nodes[n] = FlipFlop(n, 0, outputs)
        end
    end

    # Initialize the conjunctions
    # and output modules
    for (name, node) in nodes
        for output in node.outputs
            if output in cnjs
                nodes[output].memory[name] = 0
            end
            if !haskey(nodes, output)
                nodes[output] = Output(output)
            end
        end
    end
    return nodes
end

function press_button!(nodes; pt2 = false, cnjs = Set())
    q = [Pulse(nothing, "broadcaster", 0)]
    low_high = [0, 0]
    fires = []
    while length(q) > 0
        p = popfirst!(q)
        low_high .+= p.value == 0 ? [1, 0] : [0, 1]
        n = nodes[p.destination]
        outputs = process_pulse!(n, p)
        if pt2 && n.name in cnjs && outputs[1].value == 1
            push!(fires, n.name)
        end
        push!(q, outputs...)
    end
    return pt2 ? fires : low_high
end

function part1!(nodes)
    low_high = [0, 0]
    for _ = 1:1000
        low_high .+= press_button!(nodes)
    end
    return prod(low_high)
end

function part2!(nodes; relevant_node = "xm")
    connected_nodes = Set(keys(nodes[relevant_node].memory))
    vals = Dict()
    i = 0
    while length(connected_nodes) > length(vals)
        fires = press_button!(nodes, pt2 = true, cnjs = connected_nodes)
        i += 1
        map(x -> get!(vals, x, i), fires)
    end
    return lcm(collect(values(vals))...)
end

function main()
    input = (readlines ∘ strip)("day20/input.txt")
    nodes = init_nodes(input)
    println("Part 1: ", part1!(nodes))
    nodes = init_nodes(input) # reset nodes
    println("Part 2: ", part2!(nodes))
end

main()
