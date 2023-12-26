using LinearAlgebra

function parse_hail(line)
    p, v = split(line, "@")
    pos = parse.(Int, split(p, ", "))
    vel = parse.(Int, split(v, ", "))
    return pos, vel
end

function intersection_pt(a, b)
    xa, ya = a[1]
    xb, yb = b[1]
    ma = a[2][2]/a[2][1]
    mb = b[2][2]/b[2][1]
    ma == mb && return [0, 0] # This is outside the square, so idc
    A = [-ma 1; -mb 1]
    c = [ya - ma*xa, yb - mb*xb]
    return A\c
end

inside_square(pt, xmin, xmax, ymin, ymax) = pt[1] >= xmin && pt[1] <= xmax && pt[2] >= ymin && pt[2] <= ymax

function in_future(pt, hail)
    hail[2][1] < 0 && return pt[1] < hail[1][1]
    return pt[1] > hail[1][1]
end

function part1(hail)
    crossings = 0
    lo, hi = 200000000000000, 400000000000000
    for i in eachindex(hail), j in i+1:length(hail)
        pt = intersection_pt(hail[i], hail[j])
        if inside_square(pt, lo, hi, lo, hi) && in_future(pt, hail[i]) && in_future(pt, hail[j])
            crossings += 1
        end
    end
    return crossings
end

cross_coeffs(a) = [0 -a[3] a[2]; a[3] 0 -a[1]; -a[2] a[1] 0]

function part2(hail)
    p1, v1 = hail[1][1], hail[1][2]
    p2, v2 = hail[2][1], hail[2][2]
    p3, v3 = hail[3][1], hail[3][2]
    A, B, C, D = cross_coeffs.([p2 .- p1, v2 .- v1, p3 .- p2, v3 .- v2])
    M = vcat(hcat(A, B), hcat(C, D))
    rhs = [cross(p1, v1) - cross(p2, v2); cross(p2, v2) - cross(p3, v3)]
    sol = M\rhs
    return sum(sol[4:end])
end

function main()
    input = readlines("day24/input.txt")
    hail = [parse_hail(line) for line in input]
    println("Part 1: ", part1(hail))
    println("Part 2: ", (Int ∘ round)(part2(hail))) # may be off by ±1
end

main()
