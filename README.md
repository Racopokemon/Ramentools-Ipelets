# Ramentools
Small ipelets that make various quality of life-improvements to the drawing editor Ipe:

**arrowkeymove**
- Move the selection using arrow keys based on the gridsize (`Shift` for 1/4 steps)
- Change gridsize with `Ctrl+Up / Down`

**duplicatetool**
- `Ctrl+D` to duplicate selection and paste at the cursor (hold `Shift` to stamp), all while keeping the *original layers*!

**quickmenu**
- `Ctrl+R` opens quick menu for recent files and after that rotate and mirror basics

**layertool**
- Cycle active layer with `Ctrl+Shift+Up / Down`
- Toggle only active visible / all layers visible with `Ctrl+Shift+Right`
- Toggle active layer visibility with `Ctrl+Shift+Left`
- Activate layer of selection with `Ctrl+Space`

**linestool**
- Small optimizations in polygons, polylines and splines tool
  - Auto-closes shape if returning to start vertex
  - Automatically creates a closed polygon in this case
  - Right-click removes last vertex
  - Avoids stacked vertices & single-vertex shapes in various cases
  - Creating a non-closed shape will not fill it
  - Finish by pressing space

**prefs**
- `Ctrl+Shift+C / V` for picking up and applying styles (replacing `Q` and `Ctrl+Q`)
- `Ctrl+Click` stretches
- `Ctrl+Shift+S` is save as, `Ctrl+Shift+Y` is style sheets
- Disable `F1`, `F2` and `F3`
- Grid size 8 by start, instead of 16
- Forth and back mouse buttons delete objects
- More snap initially activated
- Text centered by default
- Auto-Latex disabled. Compile by saving or pressing `Ctrl+L` (or turn it back on in the file menu)

## Installation
Just copy the `.lua` files that you're interested in into the proper directory: 

- On Windows, the file must be placed in the program folder, there already exists a sub-folder named `ipelets`. 
- On MacOS, you can also create the directory `~/.ipe/ipelets/`