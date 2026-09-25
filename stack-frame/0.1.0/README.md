# Stack Layout

A Typst package for drawing computer science stack diagrams, memory layouts, and stack frames.

## Features

Flexible Layout: Automatically adjusts width or uses fixed constraints.

Components: Slots, Frames, and Stack Breaks (gaps).

Styling: Customizable fonts, colors, and borders.

Annotations: Support for Pointers (ESP, EBP), Addresses, Variable Names, and Side Notes.

Positioning: Place labels, notes, addresses, and the legend wherever you want.

## Usage

```typst
#import "@preview/stack-layout:0.3.0": stack-view, frame, slot, stack-break
#stack-view( title: [Stack Frame], show-addr-bounds: true, legend: "right",

frame(label: "main", color: blue.lighten(90%), ( slot(value: [0x00], name: "var"), slot(value: [0x00], ptr: "ESP"), )) )
```

## Functions

`stack-view`

The main container.

`width`: Total width (default auto).

`slot-width`: Width of the central stack boxes (default 80pt).

`legend`: Position of the legend ("top", "bottom", "left", "right", "none").

ptr-pos, addr-pos, note-pos: Position of element columns.

frame

Groups slots together visually.

label: Text label for the frame.

color: Background color.

slot

A single memory row.

addr: Memory address string.

value: Content of the memory cell.

ptr: One or more pointers (e.g., "ESP").

note: Side note/comment.

```

```
