// A library for visualizing computer memory stack frames, heaps, and pointers.
// It provides flexible layout options, automatic address management, and
// customizable styling for educational and technical diagrams.

// Default styling configuration for the stack visualization.
// These values can be overridden via the settings parameter in stack-view.
#let default-config = (
  addr-color: gray,
  addr-font: "DejaVu Sans Mono",
  val-font: "DejaVu Sans Mono",
  label-font: "Libertinus Serif",
  note-font: "Libertinus Serif",
  ptr-color: rgb("#d32f2f"),
  border-color: black,
  gap-color: luma(200),
  size-font: "DejaVu Sans Mono",
  bound-font: "DejaVu Sans Mono",
)

// Renders a label with a directional arrow.
// Used for pointers like ESP or EBP pointing to stack slots.
#let dir-arrow(label, direction, cfg) = {
  set text(fill: cfg.ptr-color, weight: "bold", font: cfg.val-font, size: 0.9em)
  if direction == "left" {
    stack(dir: ltr, spacing: 4pt, label, sym.arrow.r)
  } else {
    stack(dir: ltr, spacing: 4pt, sym.arrow.l, label)
  }
}

// Represents a single memory slot or row.
// Can contain a value, an address, variable name, and notes.
#let slot(
  value,
  addr: none,
  name: none,
  note: none,
  ptr: none,
  size: none,
  fill: white,
  center-align: true,
) = {
  (
    type: "slot",
    addr: addr,
    value: value,
    name: name,
    note: note,
    ptr: ptr,
    size: size,
    fill: fill,
    center-align: center-align,
  )
}

// Represents a break or gap in the stack memory.
// Automatically renders a dashed separator line if multiple breaks are adjacent.
#let stack-break(label, fill: luma(245), note: none) = {
  (
    label: label,
    type: "break",
    fill: fill,
    note: note,
  )
}

// Groups multiple slots into a logical frame (e.g., a function stack frame).
// Can display start and end addresses for the entire block.
#let frame(
  label: none,
  color: rgb("#f5f5f5"),
  start-addr: none,
  end-addr: none,
  content,
) = {
  (
    type: "frame",
    label: label,
    color: color,
    start-addr: start-addr,
    end-addr: end-addr,
    children: content,
  )
}

// Internal helper to render the address column cell.
// Handles deduplication so frame bounds are hidden if they match the slot address.
#let _addr-cell(addr, size, top-bound, bottom-bound, cfg) = {
  let content = none

  // Render Frame Top Bound
  // Aligns the bound with the very top of the row (frame boundary) using absolute placement.
  if top-bound != none and top-bound != addr {
    content += place(top + center, text(
      font: cfg.bound-font,
      size: 0.6em,
      fill: gray,
      top-bound,
    ))
  }

  // Render Frame Bottom Bound
  // Aligns the bound with the very bottom of the row using absolute placement.
  if bottom-bound != none and bottom-bound != addr {
    content += place(bottom + center, text(
      font: cfg.bound-font,
      size: 0.6em,
      fill: gray,
      bottom-bound,
    ))
  }

  // Render the specific slot address and optional size.
  // Combines address and size into a single text block for consistent styling.
  if addr != none {
    let addr-text = addr
    if size != none {
      addr-text += " [" + size + "]"
    }
    content += text(
      font: cfg.addr-font,
      fill: cfg.addr-color,
      size: 0.8em,
      addr-text,
    )
  }

  content
}

// Internal helper to generate the content for a single row in the grid.
// Processes pointers, addresses, central values, and notes.
#let _get-row-content(
  item,
  cfg,
  ptr-pos: "left",
  note-pos: "right",
  slot-width: 80pt,
  extra-addr-top: none,
  extra-addr-bottom: none,
  show-separator: false,
  is-last: false,
) = {
  // Generate pointer arrows (left or right side)
  let ptr-content = if item.at("ptr", default: none) != none {
    let p = item.ptr
    let dir = if ptr-pos == "right" { "right" } else { "left" }
    if type(p) == array {
      stack(dir: ttb, spacing: 2pt, ..p.map(x => dir-arrow(x, dir, cfg)))
    } else {
      dir-arrow(p, dir, cfg)
    }
  } else { none }

  // Generate address block with bounds
  let addr-val = item.at("addr", default: none)
  let size-val = item.at("size", default: none)
  let addr-content = _addr-cell(
    addr-val,
    size-val,
    extra-addr-top,
    extra-addr-bottom,
    cfg,
  )

  // Generate the central box (slot value or break)
  let cell-content = if item.type == "break" {
    // Base style: vertical dotted lines on the sides
    let base-stroke = (
      left: (thickness: 1pt, paint: cfg.border-color, dash: "dotted"),
      right: (thickness: 1pt, paint: cfg.border-color, dash: "dotted"),
    )

    // Determine if a bottom border is needed
    let stroke-style = if show-separator {
      // Add a separator line if followed by another break
      (
        base-stroke
          + (
            bottom: (thickness: 0.5pt, paint: cfg.border-color, dash: "dashed"),
          )
      )
    } else if is-last {
      // Close the box with a dotted line if it is the last item in the frame/list
      (
        base-stroke
          + (bottom: (thickness: 1pt, paint: cfg.border-color, dash: "dotted"))
      )
    } else {
      // Default: Open bottom (flows into next item)
      base-stroke
    }

    box(
      width: slot-width,
      inset: 8pt,
      fill: item.fill,
      stroke: stroke-style,
      align(center, text(fill: gray, item.label)),
    )
  } else {
    box(
      width: slot-width,
      inset: 8pt,
      fill: item.fill,
      stroke: (
        top: 0.5pt + cfg.border-color,
        bottom: 0.5pt + cfg.border-color,
        left: 1pt + cfg.border-color,
        right: 1pt + cfg.border-color,
      ),
      align(if item.center-align { center + horizon } else { left + horizon })[
        #set text(font: cfg.val-font, size: 0.8em)
        #item.value
      ],
    )
  }

  // Generate variable name
  let name-content = if item.at("name", default: none) != none {
    text(font: cfg.label-font, weight: "bold", size: 0.9em, item.name)
  } else { none }

  // Generate side note with connecting arrow
  let note-content = if item.at("note", default: none) != none {
    let note-text = text(style: "italic", item.note)
    let arrow = if note-pos == "left" { sym.arrow.r } else { sym.arrow.l }

    let content = if note-pos == "left" {
      note-text + " " + arrow
    } else {
      arrow + " " + note-text
    }

    text(font: cfg.note-font, fill: gray, size: 0.8em, content)
  } else { none }

  (
    ptr: ptr-content,
    addr: addr-content,
    value: cell-content,
    name: name-content,
    note: note-content,
  )
}

// The main container function for rendering the stack layout.
#let stack-view(
  width: auto,
  slot-width: 80pt,
  title: none,
  settings: (:),
  show-addr-bounds: false,
  high-addr: none,
  low-addr: none,
  legend: "none",
  ptr-pos: "left",
  addr-pos: "left",
  note-pos: "right",
  label-pos: "header",
  name-pos: "right",
  col-aligns: (:),
  ..items,
) = {
  let cfg = default-config + settings

  // When width is auto, constrain the value column to the slot-width
  let value-col-size = if width == auto { slot-width } else { auto }

  // Normalize legend position (supports boolean for backward compatibility)
  let legend-pos = if type(legend) == bool {
    if legend { "bottom" } else { "none" }
  } else {
    legend
  }

  // Build the list of columns to render based on position arguments
  let cols = ()

  if label-pos == "left" { cols.push("label") }
  if note-pos == "left" { cols.push("note") }
  if ptr-pos == "left" { cols.push("ptr") }
  if addr-pos == "left" { cols.push("addr") }

  cols.push("value")

  if name-pos == "right" { cols.push("name") }
  if addr-pos == "right" { cols.push("addr") }
  if ptr-pos == "right" { cols.push("ptr") }
  if note-pos == "right" { cols.push("note") }
  if label-pos == "right" { cols.push("label") }

  // Helper to determine alignment for a specific column
  let get-col-align(col-name) = {
    if col-name in col-aligns { col-aligns.at(col-name) } else if (
      col-name == "value"
    ) { center } // Label column defaults to center alignment
    else if col-name == "label" { center } else if col-name == "note" {
      if note-pos == "left" { right } else { left }
    } else if col-name == "ptr" {
      if ptr-pos == "left" { right } else { left }
    } else if col-name == "addr" { center } else { left }
  }
  let grid-aligns = cols.map(c => get-col-align(c) + horizon)

  // Accumulate rows and frame definitions
  let rows = ()
  let collected-frames = ()

  // Filter input items to ensure we only process valid dictionaries (slots/frames/breaks)
  // This removes 'none' values and other non-dictionary content, ensuring accurate 'is-last' calculation.
  let item-list = items
    .pos()
    .filter(it => it != none and type(it) == dictionary)

  // Add the "High" address marker row if enabled
  if show-addr-bounds and addr-pos != "none" {
    let header-row = cols.map(c => {
      if c == "addr" {
        let txt = [High]
        if high-addr != none { txt += [ #high-addr] }
        txt += [ #sym.arrow.t]
        align(center + bottom, text(
          font: cfg.label-font,
          size: 0.7em,
          fill: gray,
          txt,
        ))
      } else { none }
    })
    rows.push(header-row)
  }

  // Iterate through all items (frames or individual slots)
  for (i, item) in item-list.enumerate() {
    if item.type == "frame" {
      // Register frame for the legend
      if item.label != none {
        collected-frames.push((label: item.label, color: item.color))
      }

      // Optional header label above the frame
      if label-pos == "header" and item.label != none {
        let val-idx = cols.position(x => x == "value")
        let label-row = range(cols.len()).map(i => {
          if i == val-idx {
            // Explicitly force center alignment for the header label to override column alignment
            grid.cell(
              align: center + horizon,
              box(inset: (y: 6pt), text(weight: "bold", item.label)),
            )
          } else { none }
        })
        rows.push(label-row)
      }

      let children = item.children
      // Ensure children is always an array for consistent processing
      if type(children) != array { children = (children,) }
      // Filter children to remove none values
      children = children.filter(c => c != none and type(c) == dictionary)

      let row-span-count = children.len()

      for (j, child) in children.enumerate() {
        let child-fill = if child.type == "slot" and child.fill == white {
          item.color
        } else { child.fill }
        let processed-child = child
        processed-child.fill = child-fill

        // Pass frame bounds only to the first and last child of the frame
        let extra-top = if j == 0 { item.start-addr } else { none }
        let extra-bottom = if j == row-span-count - 1 { item.end-addr } else {
          none
        }

        // Check if a separator line is needed between stack breaks
        let is-break = child.type == "break"
        let next-is-break = if j + 1 < children.len() {
          children.at(j + 1).type == "break"
        } else { false }

        // Check if this is the last item in the current frame
        // Modified to ensure breaks at the end of frames are closed
        let is-last = (j == children.len() - 1)

        let parts = _get-row-content(
          processed-child,
          cfg,
          ptr-pos: ptr-pos,
          note-pos: note-pos,
          slot-width: slot-width,
          extra-addr-top: extra-top,
          extra-addr-bottom: extra-bottom,
          show-separator: is-break and next-is-break,
          is-last: is-last,
        )

        // Construct the grid row
        let grid-row = ()
        for col-type in cols {
          if col-type == "label" {
            if j == 0 {
              grid-row.push(grid.cell(
                rowspan: row-span-count,
                // Frame label side-column is centered vertically and horizontally
                align: center + horizon,
                inset: (x: 8pt),
                text(
                  weight: "bold",
                  font: cfg.label-font,
                  fill: black.lighten(20%),
                  item.label,
                ),
              ))
            }
          } else if col-type == "value" { grid-row.push(parts.value) } else if (
            col-type == "ptr"
          ) { grid-row.push(parts.ptr) } else if col-type == "addr" {
            grid-row.push(parts.addr)
          } else if col-type == "name" { grid-row.push(parts.name) } else if (
            col-type == "note"
          ) { grid-row.push(parts.note) }
        }
        rows.push(grid-row)
      }
    } else {
      // Handle loose items (slots/breaks not in a frame)
      let is-break = item.type == "break"
      let next-is-break = if i + 1 < item-list.len() {
        item-list.at(i + 1).type == "break"
      } else { false }
      let is-last = (i == item-list.len() - 1)

      let parts = _get-row-content(
        item,
        cfg,
        ptr-pos: ptr-pos,
        note-pos: note-pos,
        slot-width: slot-width,
        show-separator: is-break and next-is-break,
        is-last: is-last,
      )

      let grid-row = ()
      for col-type in cols {
        if col-type == "label" { grid-row.push(none) } else if (
          col-type == "value"
        ) { grid-row.push(parts.value) } else if col-type == "ptr" {
          grid-row.push(parts.ptr)
        } else if col-type == "addr" { grid-row.push(parts.addr) } else if (
          col-type == "name"
        ) { grid-row.push(parts.name) } else if col-type == "note" {
          grid-row.push(parts.note)
        }
      }
      rows.push(grid-row)
    }
  }

  // Add the "Low" address marker row if enabled
  if show-addr-bounds and addr-pos != "none" {
    let footer-row = cols.map(c => {
      if c == "addr" {
        let txt = [Low]
        if low-addr != none { txt += [ #low-addr] }
        txt += [ #sym.arrow.b]
        align(center + top, text(
          font: cfg.label-font,
          size: 0.7em,
          fill: gray,
          txt,
        ))
      } else { none }
    })
    rows.push(footer-row)
  }

  // Render the legend if required
  let legend-content = if collected-frames.len() > 0 and legend-pos != "none" {
    let is-horizontal = legend-pos in ("top", "bottom")
    let legend-dir = if is-horizontal { ltr } else { ttb }
    let item-spacing = if is-horizontal { 12pt } else { 8pt }

    // Align legend items to left for vertical legends, center for horizontal
    let content-align = if is-horizontal { center } else { left }

    align(content-align)[
      #set text(size: 0.9em, font: cfg.label-font)
      #box(stroke: 0.5pt + gray, inset: 8pt, radius: 1pt)[
        #stack(dir: legend-dir, spacing: item-spacing, ..collected-frames
          .dedup()
          .map(f => {
            // Use a small grid for precise vertical alignment of the box and label
            grid(
              columns: 2,
              column-gutter: 4pt,
              align: horizon,
              box(
                height: 1em,
                width: 1em,
                fill: f.color,
                stroke: 0.5pt + black,
              ),
              f.label,
            )
          }))
      ]
    ]
  } else { none }

  // Render the title and stack grid
  let main-content = {
    if title != none {
      align(center, text(weight: "bold", size: 1.2em, title))
      v(0.5em)
    }
    align(center, grid(
      columns: cols.map(c => if c == "value" { value-col-size } else { auto }),
      column-gutter: 8pt,
      row-gutter: 0pt,
      align: grid-aligns,
      ..rows.flatten()
    ))
  }

  // Final assembly based on legend position
  box(width: width)[
    #if legend-pos == "top" and legend-content != none {
      legend-content
      v(1em)
      main-content
    } else if legend-pos == "bottom" and legend-content != none {
      main-content
      v(1em)
      legend-content
    } else if legend-pos == "left" and legend-content != none {
      stack(
        dir: ltr,
        spacing: 12pt,
        align(center + horizon, legend-content),
        main-content,
      )
    } else if legend-pos == "right" and legend-content != none {
      stack(dir: ltr, spacing: 12pt, main-content, align(
        center + horizon,
        legend-content,
      ))
    } else {
      main-content
    }
  ]
}
