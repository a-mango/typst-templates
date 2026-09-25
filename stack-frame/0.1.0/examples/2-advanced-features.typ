#import "../lib.typ": frame, slot, stack-break, stack-view

#set page(width: auto, height: auto, margin: 1cm)

#text(size: 14pt, weight: "bold")[Example 2: Advanced Features]
#v(0.5cm)

#stack-view(
  title: [Advanced Stack Visualization],

  // Feature 1: Show global High/Low markers with specific addresses
  show-addr-bounds: true,
  high-addr: "0xFFFF",
  low-addr: "0x0000",

  // Feature 2: Customize Column Alignment
  // Here we force the 'note' column to be centered and 'value' to the right.
  col-aligns: (
    note: center,
    value: right,
  ),

  // Feature 3: Frame Address Bounds
  // Define start-addr and end-addr for the frame to show range in the address column.
  frame(
    label: "kernel_space",
    color: rgb("#FFEBEE"),
    start-addr: "0xFFFF",
    end-addr: "0x8000",
    (
      // Feature 4: Slot Sizes
      // Display the size of the data type next to the address (e.g., [4B])
      slot(
        value: [Syscall Table],
        addr: "0xF000",
        size: "4KB",
        center-align: true,
      ),
      // Feature 5: Stack Breaks with Notes
      stack-break(label: " ... ", note: "Restricted Access"),
      // Feature 6: Automatic Separators
      // Placing multiple stack-breaks sequentially automatically adds
      // a dashed visual separator between them.
      stack-break(label: " Guard Page ", fill: luma(230), note: "No R/W"),
      stack-break(
        label: " MMIO Region ",
        fill: luma(240),
        note: "Hardware Mapped",
      ),
    ),
  ),

  frame(
    label: "user_space",
    color: rgb("#E8F5E9"),
    start-addr: "0x7FFF",
    (
      slot(value: [Stack Top], ptr: "ESP", addr: "0x7FFF", size: "8B"),
      slot(value: [Heap Data], addr: "0x4000", size: "Dynamic"),
    ),
  ),
)
