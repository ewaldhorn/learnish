const std = @import("std");

export fn calculate_pi(n: usize) f64 {
    const seed: u64 = undefined;
    var randGen = std.rand.DefaultPrng.init(seed);
    var rand = randGen.random();

    var counter: f64 = 0.0;
    var iter: i32 = 0;

    while (iter < n) : (iter += 1) {
        const x = rand.float(f64);
        const y = rand.float(f64);

        if (x * x + y * y < 1.0) {
            counter += 1.0;
        }
    }

    return 4.0 * counter / @as(f64, @floatFromInt(n));
}
