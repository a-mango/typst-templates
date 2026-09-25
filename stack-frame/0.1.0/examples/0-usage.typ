#import "@preview/stack-layout:0.1.0": frame, slot, stack-break, stack-view

#stack-view(
  title: [Memory Layout],
  show-addr-bounds: true,
  high-addr: "0xFFFF",
  low-addr: "0x0000",
  legend: "bottom",

  frame(
    label: "Main",
    color: blue.lighten(90%),
    start-addr: "0x1000",
    (
      slot(value: [0x05], name: "var_a", size: "4B"),
      slot(value: [0xFF], name: "ret_addr", ptr: "ESP"),
    ),
  ),

  stack-break(label: " ... ", note: "Unused Space"),
)
