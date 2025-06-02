# IpeMods
Small ipelet that make various improvements to the drawing tool Ipe

Currently contains: 

- `Ctrl+Shift+C / V` for picking up and applying styles (replacing `Q` and `Ctrl+Q`)
- Duplicate with `Ctrl+D`
- Movement along gridsize using arrow keys (`Shift` for 1/4 speed)
- Change gridsize with `Ctrl+Up / Down`

- Grid size 8 by start, instead of 16
- Auto-Latex disabled. Compile by saving or pressing `Ctrl+L`

Future work
- Make F2 rename the layer
- Make text centered by default
- `Ctrl+D` Duplicates at cursor (like paste at cursor) AND keeps the original layers
- Multiple shortcuts possible
- Open menu for recent files?
- Better select tool? Maybe eyen with the square with the scale and move handles around it? 
- Double click things to edit them (texts, Polylines)
- Double click empty place on page to draw polyline (or other tool)
- Overhaul the line editing tool, auto close & more stuff
- Is it possible (to some extend) to see an error log if an ipelet fails to load, instead of just the window closing directly
- Tab and Shift+Tab for next / prev selection

Stuff that would require work in C++
- Drag drop for layers in the gui
- Shift-clicking un-ticks everything but the current 
- Apply the color when clicking it; only shift+click opens color chooser dialog