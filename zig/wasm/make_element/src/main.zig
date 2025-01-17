const std = @import("std");
const wasm = @import("wasm");

export fn create_element() void {
    // Get the document object
    const document = wasm.get_document().?;

    // Create a new paragraph element
    const paragraph = document.create_element("p").?;

    // Set the text content of the paragraph
    paragraph.set_text_content("Hello, world!").?;

    // Append the paragraph to the body of the document
    const body = document.get_element_by_id("body").?;
    body.append_child(paragraph).?;
}
