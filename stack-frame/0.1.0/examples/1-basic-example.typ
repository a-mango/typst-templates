#import "../lib.typ": frame, slot, stack-break, stack-view

#set page(width: auto, height: auto, margin: 1cm)

#text(size: 14pt, weight: "bold")[Example 1: Getting Started]
#v(0.5cm)

// A basic stack view consists of frames and slots.
// - stack-view: The main container.
// - frame: A logical grouping (like a function stack frame).
// - slot: A single memory row.

#stack-view(
  title: [Simple Function Call],

  // 1. Define the main frame
  frame(label: "main()", color: rgb("#E3F2FD"), (
    // Slots can have a value, a variable name, and a memory address.
    slot(
      value: [0x00000005],
      name: "local_var",
      addr: "0x7FFF0004",
    ),
    // You can add notes to explain specific values.
    slot(
      value: [0x00401000],
      name: "ret_addr",
      note: "Returns to OS",
    ),
  )),

  // 2. Define the callee frame
  frame(label: "calculate()", color: rgb("#FFF9C4"), (
    // Pointers like EBP/ESP can be attached to slots.
    slot(
      value: [0x7FFF0000],
      name: "saved ebp",
      ptr: "EBP",
      addr: "0x7FFF0000",
    ),
    slot(
      value: [0x00000000],
      name: "result",
      ptr: "ESP",
      addr: "0x7FFEFFF4",
    ),
  )),
)
