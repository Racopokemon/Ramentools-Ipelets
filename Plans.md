Future work
- Tab and Shift+Tab for next / prev selection
- How easy would it be to make P close if start node is clicked or so? And remove doubles and so
- ctrl+tab and ctrl+shift+tab for cycling through views AND pages? <- this is just a different key assignment
- Silent layer removal etc. - right now we get warnings, but we could also just select the next layer when removing the active layer. 
- Make the 2nd call of F1, F2 and F3 hide the axis (better solution than just removing the shortcuts)
- Having boolean and and offset tools would make the software even more powerful ... but welllll xD

Work that requires modifying the internal .lua scripts
- Is it possible (to some extend) to see an error log if an ipelet fails to load, instead of just the window closing directly?
- Look for ipelets also in subfolders

Stuff that would require work in C++
- Multiple shortcuts possible, I need that xD (on OSX)
- Double click things to edit them (texts, Polylines)
- Double click empty place on page to draw polyline (or other tool)
- Better select tool! To be comprehensible for unfamiliar users, the default AABB with knobs for scaling all around should really be there
- In the same way, the fill- and stroke buttons with a dropdown option would help new users - also putting the no fill / stroke options there. 
- Move the opacity settings visually closer to the fill and stroke color
- Make icons next to the "normal" "normal" dropdows so that its clear that this is thickness and dashes
- Drag drop for layer order in the gui
- Shift-clicking un-ticks everything but the current 
- Make layers highlight contained objects on hover (rest gets 50% opacity or so, maybe?)
- If there is a selection, somehow also show an arrow or do some other highlighting of in which layer the selection is rn