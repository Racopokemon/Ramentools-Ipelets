# Ramentools
Small ipelets that make various quality of life-improvements to the drawing editor [Ipe](https://github.com/otfried/ipe):

**arrowkeymove**
- Move the selection using arrow keys based on the gridsize (`Shift` for 1/4 steps)
- Change gridsize with `+ / -` or `Ctrl+Up / Down`
- Cycle between elements with `Tab` and `Shift+Tab` (Windows only) and `N` and `Shift+N` (all platforms)

**linestool**
- Small optimizations in polygons, polylines and splines tool
  - Auto-closes shape if returning to start vertex
  - Automatically creates a closed polygon in this case
  - Right-click removes last vertex
  - Avoids stacked vertices & single-vertex shapes in various cases
  - Creating a non-closed shape will not fill it
  - Finish by pressing space

**duplicatetool**
- `Ctrl+D` to duplicate selection and paste at the cursor (hold `Shift` to stamp), all while keeping the *original layers*!

**layertool**
- Cycle active layer with `Ctrl+Shift+Up / Down`
- Toggle only active visible / all layers visible with `Ctrl+Shift+Right`
- Toggle active layer visibility with `Ctrl+Shift+Left`
- Activate layer of selection with `Ctrl+Space`
- Activate layer of selection & pick properties with `Ctrl+Shift+Space`

**silentactions**
- Silently deleting layers: If the layer was active in some views, it is silently changed to a different view before deleting (instead of showing an error message)
- Silently locking layers: Analogously, change active views before locking a layer
- Silently creating shapes: If created on a hidden layer, make the layer visible before creating the shape there

**quickmenu**
- `Ctrl+R` opens quick menu for recent files and after that rotate and mirror basics
- `Shift+5` (= the `%` button) to opens opacity menu
- `Ctrl+Shift+5` opens stroke opacity menu
- `Ctrl+Shift+T` opens tiling menu
- `Ctrl+Shift+W` opens pen width menu
- `Ctrl+Shift+D` opens pen dash menu

**selectiontools**
- Hitting `A` toggles (un)selecting everything, Blender style
- `X` cycles between pathmodes (stroked, filled, both)

**prefs**
*Probably the most controversal changes, feel free to not include / adapt it to your own preferences*
- `Ctrl+Shift+C / V` for picking up and applying styles (replacing `Q` and `Ctrl+Q`)
- `Ctrl+Click` stretches
- `Ctrl+Shift+S` is save as, `Ctrl+Shift+Y` is style sheets
- `Space` enters edit mode
- Disable `F1`, `F2` and `F3`
- `Ctrl+Tab` and `Ctrl+Shift+Tab` to move between views (`Control` on Mac)
- `Ctrl+N` opens a new window
- `Ctrl+Shift+I` now just creates a new view, no new layer
- Grid size 8 by start, instead of 16
- 'Forward' and 'backward' mouse buttons delete objects
- More snap initially activated
- Text centered by default
- Auto-Latex disabled. Compile by saving or pressing `Ctrl+L` or turn it back on in the 'file' menu

**main.lua**
- On startup, ipe shows a detailled error message when an ipelet was NOT successfully loaded, instead of just silently crashing
- Recognize 'backspace', 'tab', 'enter' as windows shortcuts

## Installation
Just copy the `.lua` files that you're interested in into the proper directory: 

- On Windows, create the directory `~/ipelets/`
- On MacOS, create the directory `~/.ipe/ipelets/`

The lua files in `replace in lua-directory` need to be placed instead of the same-named files in the `lua` directory. 
You'll find them 

- usually in `C:/Program Files/ipe .../bin/lua/` on Windows
- somewhere in `Library/ipe/...bin/lua/` on MacOS

Please backup / rename the original files. 