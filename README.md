# Ramentools
Small ipelets that make various quality of life-improvements to the drawing editor Ipe:

**arrowkeymove**
- Move the selection using arrow keys based on the gridsize (`Shift` for 1/4 steps)
- Change gridsize with `Ctrl+Shift+Left / Right`

**duplicatetool**
- `Ctrl+D` to duplicate selection and paste at the cursor (hold `Shift` to stamp) while keeping the *original layers*!

**quickmenu**
- `Ctrl+R` opens quick menu for recent files and after that rotate and mirror basics

**layertool**
- Cycle active layer with `Ctrl+Shift+Up / Down`
- Activate layer of selection with `Ctrl+Space`

**prefs**
- `Ctrl+Shift+C / V` for picking up and applying styles (replacing `Q` and `Ctrl+Q`)
- Grid size 8 by start, instead of 16
- Auto-Latex disabled. Compile by saving or pressing `Ctrl+L` (or turn it back on in the file menu)
- Disable `F1`, `F2` and `F3`

## Installation
Just copy the `.lua` files that you want to install into the right directory: 

- On Windows, the file must be placed in the program folder, there already exists a sub-folder named `ipelets`. 
- On MacOS, you can also create the directory `~/.ipe/ipelets/`