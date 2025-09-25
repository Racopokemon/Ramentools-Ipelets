# Ramentools
Small ipelets that make various quality of life-improvements to the drawing editor [Ipe](https://github.com/otfried/ipe):

**arrowkeymove**
- Move the selection using arrow keys based on the gridsize (`Shift` for 1/4 steps)
- Change gridsize with `Ctrl+Up / Down`
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

**quickmenu**
- `Ctrl+R` opens quick menu for recent files and after that rotate and mirror basics
- `Shift+5` (= the `%` button) to opens opacity menu
- `Ctrl+Shift+5` opens stroke opacity menu
- `Ctrl+Shift+T` opens tiling menu
- `Ctrl+Shift+W` opens pen width menu
- `Ctrl+Shift+D` opens pen dash menu

**prefs**
- `Ctrl+Shift+C / V` for picking up and applying styles (replacing `Q` and `Ctrl+Q`)
- `Ctrl+Click` stretches
- `Ctrl+Shift+S` is save as, `Ctrl+Shift+Y` is style sheets
- Disable `F1`, `F2` and `F3`
- `Ctrl+Tab` and `Ctrl+Shift+Tab` to move between views (`Control` on Mac)
- `Ctrl+N` creates a new window
- Grid size 8 by start, instead of 16
- Forth and back mouse buttons delete objects
- More snap initially activated
- Text centered by default
- Auto-Latex disabled. Compile by saving or pressing `Ctrl+L` (or turn it back on in the file menu)

**main.lua**
- On startup, ipe shows an error message when an ipelet was NOT successfully loaded, instead of just silently crashing
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