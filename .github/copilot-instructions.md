# Copilot Instructions for this Repo

## Context: What this repo is
- This repository contains **Ipelets**: Lua extensions for the vector editor **Ipe** (C++ backend with large Lua surface).
- We **extend Ipe via ipelets**, not by modifying Ipe’s core code. Keep changes in this repo as loadable ipelets unless there is an explicit need to patch Ipe’s internal Lua scripts.
- Internal Ipe Lua scripts are installed with the app (macOS typically under `/Applications/Ipe.app/Contents/Resources/lua/`). They are the best reference for what is possible and for understanding Ipe’s sometimes cryptic APIs.
- Official Lua bindings documentation: https://ipe.otfried.org/ipelib/lua.html (the five sub‑pages are key).

## Repo structure & main files
- Each `*.lua` file in the repo root is an ipelet that can be copied into `~/.ipe/ipelets/` (macOS) or `~/ipelets/` (Windows).
- Folder `replace in lua-directory/` contains replacements for Ipe’s internal Lua scripts. **Avoid using these unless necessary**; prefer ipelets.
- `README.md` documents the tools and shortcuts; keep it updated when behavior changes.
- `Plans.md` captures future ideas; don’t implement items silently—use it as guidance and update when completed.

## Key Ipe concepts you must respect
- **Pages** are independent; each page can have multiple **views** with different layer visibility.
- Each page has an **active layer** per view.
- **Layers are not z‑order**. Z‑order is separate; every object belongs to a layer, which controls visibility only.
- **Undo/redo** is central: most operations should be wrapped in a `model:register(t)` with `t.undo/t.redo`.
- **Selection changes are not undoable** (do not expect selection-only actions to be in the undo stack).
- Shapes are either stroked, filled, or both (strokefilled)

## How ipelets work (patterns in this repo)
- Most ipelets define `label`, `about`, `methods`, and register shortcuts (see `ramenlayertools.lua`).
- Many tools extend Ipe by **overriding globals** in `_G`, e.g.:
  - `_G.MODEL:layeraction_delete()` in `ramensilentactions.lua`
  - `_G.LINESTOOL:mouseButton()` in `ramenlinestool.lua`
- This is intentional and sometimes necessary. Be careful:
  - Always preserve behavior where possible; only adjust the intended part.
  - When overriding, copy the original pattern from Ipe’s internal Lua and adapt.

## Where to look before coding
- **First**: Find similar behavior in existing ipelets in this repo.
- **Second**: Look at Ipe’s internal Lua scripts (the installed `.../lua/` directory). This is often the only reliable way to see how the API behaves in practice.
- **Third**: Read the Ipe Lua docs (link above).
- Generally, it might happen that things are simply not possible, bc they are not part of the lua implementation etc. This is acceptable! Please report this to the user/programmer and they will decide how to continue instead. 

## Platform nuances
- macOS has quirks: multi‑shortcut bindings are limited (see `ramenprefs.lua`).
- Special keys like backspace/enter/tab may require platform‑specific codes; the repo references Windows virtual key codes as needed.

## Shortcuts & actions
- Use Ipe’s `shortcuts.*` and `shortcuts.ipelet_*` bindings consistently.
- Prefer descriptive labels in `methods` to populate the Ipelets menu.
- Keep shortcuts aligned with the README to avoid drift.

## Undo/redo pattern (necessary for most changes (except changing selections))
- When changing document state, wrap in:
  ```lua
  local t = { label = "...", pno = model.pno, vno = model.vno, ... }
  t.undo = function (t, doc) ... end
  t.redo = function (t, doc) ... end
  model:register(t)
  ```
- After state changes, call `model:deselectNotInView()` if visibility changes can invalidate selection.

## Model access notes
- The `model` object is only provided when tools/actions are invoked, **but** you can still access it at load time via `_G.MODEL` in some cases. This repo already uses that to override behavior.
- `_G` also exposes convenience functions; inspect Ipe’s internal Lua to see what is available.

## Guardrails (what not to do)
- Do **not** modify Ipe’s C++ code; this repo is only for ipelets.
- Avoid editing internal Ipe Lua scripts unless absolutely required (use `replace in lua-directory/` only if there is no ipelet solution, talk back to the programmer before you do that).
- Keep changes consistent with existing behavior; don’t refactor unrelated code. 

## When you add or change features
- Update `README.md` so that also the new features are documented/mentioned properly. 
- Consider adding notes to `Plans.md` if the change impacts future ideas.

## Quick reference: install paths
- macOS: `~/.ipe/ipelets/`
- Windows: `~/ipelets/` (or the program folder’s `ipelets/` subfolder for some ipelets)

## Testing
- Manual testing in Ipe is the only reliable check.
- Test on at least one page with multiple views/layers.
- Confirm undo/redo behavior and that selection is unaffected unless explicitly intended.
