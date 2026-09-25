#import "../lib.typ": frame, slot, stack-break, stack-view

#set page(width: auto, height: auto, margin: 1cm)

#text(size: 14pt, weight: "bold")[Example 3: Process Memory Layout]
#v(0.5cm)

#stack-view(
  title: [Virtual Address Space (32-bit)],
  width: auto, // Wider layout for system map
  slot-width: 140pt,

  show-addr-bounds: true,
  high-addr: "0xFFFFFFFF",
  low-addr: "0x00000000",

  // Legend to explain colors
  legend: "bottom",

  // Clean look: Labels on the right, Pointers on the left
  label-pos: "right",
  ptr-pos: "left",
  note-pos: "right",

  // --- Kernel Space ---
  frame(
    label: "Kernel Space",
    color: rgb("#ffcdd2"),
    start-addr: "0xC0000000",
    (
      slot(value: [Kernel Code & Data], addr: "0xC0000000", size: "1GB"),
    ),
  ),

  // --- Gap ---
  // Automatic separator handles the transition logic
  stack-break(label: " ... ", note: "Context Switch Barrier"),

  // --- User Stack ---
  frame(label: "Stack", color: rgb("#bbdefb"), start-addr: "0xBFFFFFFF", (
    slot(value: [Environment Vars], name: "env"),
    slot(value: [Command Line Args], name: "argv"),
    slot(value: [Main Stack Frame], ptr: "ESP"),
  )),

  stack-break(label: " ↓ Grows Down ", fill: white),

  // --- Shared Libraries ---
  frame(label: "Memory Mapping", color: rgb("#d1c4e9"), (
    slot(value: [libc.so], addr: "0x40000000", size: "Shared Libs"),
  )),

  stack-break(label: " ↑ Grows Up ", fill: white),

  // --- Heap ---
  frame(label: "Heap", color: rgb("#c8e6c9"), (
    slot(value: [Dynamic Allocations], ptr: "brk", addr: "0x08049000"),
  )),

  // --- BSS & Data ---
  frame(label: "Data Segments", color: rgb("#fff9c4"), (
    slot(value: [Uninitialized (BSS)], name: ".bss"),
    slot(value: [Initialized Data], name: ".data"),
  )),

  // --- Text ---
  frame(
    label: "Text Segment",
    color: rgb("#f5f5f5"),
    start-addr: "0x08048000",
    (
      slot(value: [Binary Code], name: ".text", ptr: "EIP", note: "Read-only"),
    ),
  ),

  stack-break(
    label: " Restricted ",
    fill: luma(220),
    note: "Null Pointer Zone",
  ),
)
