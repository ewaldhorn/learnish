// As per https://en.wikipedia.org/wiki/Zig_(programming_language)
pub fn main() void {
    var node = LinkedList(i32).Node{
        .prev = null,
        .next = null,
        .data = 1234,
    };

    var list = LinkedList(i32){
        .first = &node,
        .last = &node,
        .len = 1,
    };
    _ = list;
}

fn LinkedList(comptime T: type) type {
    return struct {
        pub const Node = struct {
            prev: ?*Node,
            next: ?*Node,
            data: T,
        };

        first: ?*Node,
        last: ?*Node,
        len: usize,
    };
}
