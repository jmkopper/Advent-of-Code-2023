const std = @import("std");

fn is_digit(x: u8) bool {
    return (x >= 48 and x <= 57);
}

fn get_digit(x: u8) u64 {
    return x - 48;
}

fn first_digit(xs: []const u8) u64 {
    for (xs) |x| {
        if (x >= 48 and x <= 57) {
            return x - 48;
        }
    }
    return 0;
}

fn word_to_digit(xs: []const u8) u64 {
    if (std.mem.eql(u8, xs, "one")) {
        return 1;
    } else if (std.mem.eql(u8, xs, "two")) {
        return 2;
    } else if (std.mem.eql(u8, xs, "three")) {
        return 3;
    } else if (std.mem.eql(u8, xs, "four")) {
        return 4;
    } else if (std.mem.eql(u8, xs, "five")) {
        return 5;
    } else if (std.mem.eql(u8, xs, "six")) {
        return 6;
    } else if (std.mem.eql(u8, xs, "seven")) {
        return 7;
    } else if (std.mem.eql(u8, xs, "eight")) {
        return 8;
    } else if (std.mem.eql(u8, xs, "nine")) {
        return 9;
    }
    return 0;
}

fn first_digit_or_word(xs: []const u8) u64 {
    var words = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
    var i: usize = 0;
    while (i < xs.len) : (i += 1) {
        if (is_digit(xs[i])) {
            return get_digit(xs[i]);
        }

        for (words) |word| {
            const word_len = word.len;
            if (i + word_len < xs.len) {
                if (std.mem.eql(u8, word, xs[i .. i + word_len])) {
                    return word_to_digit(word);
                }
            }
        }
    }

    return 0;
}

fn last_digit_or_word(xs: []const u8) u64 {
    var words = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
    var i: usize = 0;
    while (i < xs.len) : (i += 1) {
        var idx = xs.len - i;
        for (words) |word| {
            const word_len = word.len;
            if (idx >= word_len) {
                if (std.mem.eql(u8, word, xs[idx - word_len .. idx])) {
                    return word_to_digit(word);
                }
            }
        }

        if (is_digit(xs[idx - 1])) {
            return get_digit(xs[idx - 1]);
        }
    }

    return 0;
}

fn last_digit(xs: []const u8) u64 {
    var i: usize = 0;
    while (i < xs.len) : (i += 1) {
        const val = xs[xs.len - i - 1];
        if (is_digit(val)) {
            return get_digit(val);
        }
    }

    return 0;
}

fn part1(input: []const u8) u64 {
    var lines = std.mem.split(u8, input, "\n");
    var sum: u64 = 0;

    while (lines.next()) |line| {
        const first = first_digit(line);
        const last = last_digit(line);
        sum += first * 10 + last;
    }

    return sum;
}

fn part2(input: []const u8) u64 {
    var lines = std.mem.split(u8, input, "\n");
    var sum: u64 = 0;

    while (lines.next()) |line| {
        const first = first_digit_or_word(line);
        const last = last_digit_or_word(line);
        sum += first * 10 + last;
    }

    return sum;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const p1 = part1(input);
    const p2 = part2(input);
    std.debug.print("Part 1: {d}\n", .{p1});
    std.debug.print("Part 2: {d}\n", .{p2});
}
