# Ramentools
Small ipelets that make various quality of life-improvements to the drawing tool Ipe

Currently contains the following files: 

**arrowkeymove**
- Move the selection using arrow keys based on the gridsize (`Shift` for 1/4 steps)
- Change gridsize with `Ctrl+Up / Down`

**duplicatetool**
- `Ctrl+D` to duplicate selection (hold `Shift` to stamp) while keeping the *original layers*!

**quickmenu**
- `Ctrl+R` opens quick menu for recent files and after that rotate and mirror basics

**prefs**
- `Ctrl+Shift+C / V` for picking up and applying styles (replacing `Q` and `Ctrl+Q`)
- Grid size 8 by start, instead of 16
- Auto-Latex disabled. Compile by saving or pressing `Ctrl+L` (or turn it back on in the file menu)

## Installation
Just copy the `.lua` files that you want to install into the right directory: 

- On Windows, the file must be placed in the program folder, there already exists a sub-folder named `ipelets`. 
- On MacOS, you can also create the directory `~/.ipe/ipelets/`