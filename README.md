# ImGuiGML

A GameMaker demo project for the **GMRT ImGUI compatibility module** — a binding of [Dear ImGui](https://github.com/ocornut/imgui) exposed to GML as a single global static class, `ImGui`.

The project is a live playground: one object, one room, and a Step event that exercises most of the API surface — windows, docking, tables, plots, drag & drop, draw lists, multi-select, custom TTF fonts and Unicode glyph ranges. It also ships a full API reference and the GML enum definitions you need to call the module.

> Everything in this module is experimental and may change in future GMRT releases.

---

## Requirements

- GameMaker with the **GMRT** runtime (project built against IDE `2026.0.0.16`).
- The ImGUI compatibility module available to the runtime. This repo contains **no extension** — `ImGui` is resolved by GMRT itself, not by an asset in the project tree.

## Running it

1. Open `ImGuiGML.yyp` in the GameMaker IDE.
2. Select a GMRT target and run.
3. `Room1` spawns a single `Object1`, which draws the whole demo from its Step event.

There is nothing to configure. The window is 1366×768 with docking enabled by default (`global.enable_docking` in `Object1`'s Create event).

## Project layout

| Path | What it is |
| --- | --- |
| `objects/Object1/Create_0.gml` | Demo state, font loading, glyph ranges, and **all `ImGui*` enum definitions** |
| `objects/Object1/Step_0.gml` | The demo UI itself — every widget call lives here |
| `scripts/Script1/Script1.gml` | GM-side helper constructors: `ImColor`, `ImGuiWindowClass`, `ImGuiSelectionBasicStorage` |
| `notes/ImGui_API.md/ImGui_API.md.txt` | Full API reference — ~2400 lines of signatures, per-argument notes, and the enums |
| `datafiles/fonts/` | Noto Sans (Main + Hiragana Bold) and Roboto, plus their Apache-2.0 licence |
| `sprites/` | `spr_example`, `spr_example2` — used for `Image`, `ImageButton`, and draw-list image calls |

## Quick start

Every function is static on the `ImGui` class, so you call it directly. UI is built imperatively each frame from a Step event:

```gml
/// Step Event
if (ImGui.Begin("Hello", { open: true })) {
    ImGui.Text("ImGui version: " + ImGui.GetVersion());

    if (ImGui.Button("Click me")) {
        show_message_async("clicked");
    }

    my_slider = ImGui.SliderInt("Amount", my_slider, 0, 10);
}
ImGui.End();
```

Two conventions are worth knowing up front:

- **State structs.** Widgets that need to write state back to you take a struct, e.g. `ImGui.Begin("Name", { open: true })` — ImGui flips `open` to `false` when the user clicks the close button.
- **Value returns.** Sliders and inputs return their new value rather than mutating in place: `val = ImGui.SliderFloat("x", val, 0, 1)`. Array variants (`SliderInt4`, `InputFloat4`, …) write into the array you pass.

British and American spellings (`Colour` / `Color`) are aliases for the same native function.

## Enums

The GML enum definitions live in the `#region Enums` block at the bottom of `Object1`'s Create event, and again at the end of the API reference. Copy that block into your own project — `ImGuiWindowFlags`, `ImGuiTableFlags`, `ImGuiCol`, `ImGuiStyleVar`, `ImDrawFlags`, and the rest are plain GML enums, not something the module provides.

## Helper constructors

`scripts/Script1/Script1.gml` supplies the GM-side structs the module expects:

```gml
// Colours for the *4 colour editors and pickers
var c = new ImColor(c_aqua, 0.5);      // GM colour + alpha
var d = new ImColor(128, 255, 255);    // r, g, b
ImGui.ColorPicker4s("Pick", c);
c.Color();  // BGR int, for GM drawing functions
c.Alpha();

// Multi-select storage — remember to Destroy() it
var sel = new ImGuiSelectionBasicStorage();
sel.ApplyRequests(ImGui.BeginMultiSelect(flags, sel.GetSize(), count));
sel.Contains(index);
sel.Destroy();
```

`ImGuiWindowClass` is also defined here for the window-class/viewport calls.

## What the demo covers

Text and layout · buttons (regular, small, invisible, arrow, colour) · images, image buttons and **GameMaker surfaces** rendered into ImGui · tree nodes and collapsing headers · sliders and drag widgets · text/int/float inputs, multiline and hint variants · colour pickers and editors · tables with per-cell background colours · tab bars · line and histogram plots · dock spaces and the **DockBuilder** API (programmatic split layout) · drag & drop with copy/move/swap modes · TTF font loading with Cyrillic and Japanese glyph ranges · draw lists (text, circles, béziers, rounded images, n-gons) · the multi-select system with box-select and keyboard navigation · the built-in `ShowDemoWindow`.

## Notes and caveats

- **Fonts** are included files under `datafiles/fonts/` and are loaded at runtime from `assets/fonts/…`. Only `NotoSans-Main.ttf` is loaded by the demo; Roboto and the Hiragana Bold face are there for you to experiment with.
- **Arabic text** renders, but BIDI ordering and letter joining are not handled — see `str_marhaba` in the Create event.
- **`static_get(ImGui)`** is used to peek at module internals and is guarded in a `try`/`catch`; older runtimes without it show a disabled field and a warning tooltip instead.
- `*.resource_order` and the GMRT `Build` directory are gitignored; `.yy` files are marked `linguist-generated` and forced to LF.

## Credits

- [Dear ImGui](https://github.com/ocornut/imgui) by Omar Cornut.
- The demo layout is adapted from [knno/ImGM](https://github.com/knno/ImGM); the DockBuilder setup follows [this gist by Aidan Sun](https://gist.github.com/AidanSun05/953f1048ffe5699800d2c92b88c36d9f).
- Red panda artwork by @Snoozercreation.
- Bundled fonts (Noto Sans, Roboto) are licensed under Apache-2.0 — see `datafiles/fonts/LICENSE.txt`.
