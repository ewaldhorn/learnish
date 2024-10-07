const std = @import("std");

// ----------------------------------------------------------------------------
pub const BankAccount = struct {
    personID: u32,
    balance: f32,

    pub fn Report(account: BankAccount) void {
        std.debug.print("Bank balance: {d}\n", .{account.balance});
    }

    pub fn HasAvailable(account: BankAccount, amount: f32) bool {
        return account.balance >= amount;
    }
};

// ====================================================================== TESTS
const expect = std.testing.expect;

// ----------------------------------------------------------------------------
test "Account knows it has sufficient money available or not" {
    var testAccount = BankAccount{ .balance = 100.00 };
    var result = testAccount.HasAvailable(100.00);

    try expect(result == true);

    result = testAccount.HasAvailable(100.01);
    try expect(result == false);
}
