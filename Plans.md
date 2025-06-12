Future work
- Make text centered by default
- Better select tool? Maybe eyen with the square with the scale and move handles around it? 
- Double click things to edit them (texts, Polylines)
- Double click empty place on page to draw polyline (or other tool)
- Overhaul the line editing tool, auto close & more stuff
- Is it possible (to some extend) to see an error log if an ipelet fails to load, instead of just the window closing directly
- Tab and Shift+Tab for next / prev selection
- Is there an option to stretch with shift mouse that just needs to be enabled?
  - https://github.com/Marian-Braendle/ipe-lassotool/tree/main?tab=readme-ov-file#usage <- should work!
- How easy would it be to make P close if start node is clicked or so? And remove doubles and so
- ctrl+tab and ctrl+shift+tab for cycling through views AND pages? <- this is just a different key assignment
- Make the 2nd call of F1, F2 and F3 hide the axis (better solution than just removing the shortcuts)

Stuff that would require work in C++
- Multiple shortcuts possible (on OSX)
- Drag drop for layers in the gui
- Shift-clicking un-ticks everything but the current 
- Apply the color when clicking it; only shift+click opens color chooser dialog
- Make layers highlight contained objects on hover (rest gets 50% opacity or so, maybe?)