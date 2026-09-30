# typst-templates

Typst packages and templates for HEIG-VD and HES-SO/MSE coursework.

| Package           | Content                                        |
| ----------------- | ---------------------------------------------- |
| `common`          | Shared utility functions                       |
| `heig-vd-handout` | Practical work handout, with a solutions build |
| `heig-vd-notes`   | Personal course notes                          |
| `heig-vd-report`  | Course report, HEIG-VD branding                |
| `heig-vd-slides`  | Presentation deck (Touying)                    |
| `heig-vd-summary` | Lesson summary                                 |
| `hes-so-notes`    | Personal course notes, HES-SO branding         |
| `hes-so-report`   | Course report, HES-SO branding                 |
| `hes-so-slides`   | Presentation deck (Touying), HES-SO            |
| `hes-so-summary`  | Lesson summary, HES-SO branding                |
| `mse-notes`       | Personal course notes, HES-SO MSE branding     |
| `mse-report`      | Course report, HES-SO MSE branding             |
| `mse-slides`      | Presentation deck (Touying), HES-SO MSE        |
| `mse-summary`     | Lesson summary, HES-SO MSE branding            |
| `stack-frame`     | Stack frame, heap and pointer diagrams         |

## Install

To install the packages into Typst's local namespace, run:

```bash
just
```

That symlinks every package into Typst's local package directory, so edits in
this checkout take effect immediately. Every version is installed since older
documents pin the version they were written against.

Other recipes: `just status` shows what the namespace holds, `just verify`
compiles a probe against each package to prove Typst resolves it, `just
uninstall` removes them again, and `just list` and `just check` inspect the
manifests. Override the destination with `just dest_root=/some/path link`.

## Use

Every template package (`*-handout`, `*-notes`, `*-report`, `*-slides` and
`*-summary`, and across all three brandings) ships `typst init` scaffolding
with their latest version:

```bash
typst init @local/heig-vd-slides:1.0.0 my-deck
cd my-deck && just
```

`heig-vd-handout` and the three slide decks scaffold a `justfile` for their build
variants. The report, notes and summary templates scaffold their entrypoint
file (`report.typ`, `notes.typ`, `summary.typ`) and an empty `assets/` folder,
compiled directly with `typst compile`.

`common` and `stack-frame` are not documents to scaffold use by direct
import:

```typst
#import "@local/stack-frame:0.1.0": *
```

## License

MIT
