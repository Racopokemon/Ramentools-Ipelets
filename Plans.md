## Future work
- Make poly-tool remove not needed verts, if theres multiple in a row. On finish, so also between start and end
    - Maybe also: Make `esc` finish instead of removing. 
- Edittool - how hard is it to modify it?
    - Better way to create verts. Best would be to click anywhere on the line using snap. But, well. 
    - Make the shortcut for cycling between grid-sizes also work in edittool (but this might be problematic)
- Tab and Shift+Tab for next / prev selection
- Shift+5 (for %) to have a context menu to select the opacity
- Silent layer removal etc. - right now we get warnings, but we could also just select the next layer when removing the active layer. 
- Make the 2nd call of F1, F2 and F3 hide the axis (better solution than just removing the shortcuts)
- Having boolean and and offset tools would make the software even more powerful ... but welllll xD

## Work that requires modifying the internal .lua scripts
*Nothing, currently*

## Stuff that would require work in C++
- Look for ipelets also in subfolders (the lua interface does not provide a way to identify dirs / iterate through them, so this is required first)
- Multiple shortcuts possible for MacOS like the other platforms, I need that
- Make 'tab' and 'shift+tab' input recognized on MacOS
- Double click things to edit them (texts, Polylines)
- Double click empty place on page to draw polyline (or other tool)
- Better select tool! To be comprehensible for unfamiliar users, the default AABB with knobs for scaling all around would be a game-changer
- In the same way, the fill- and stroke buttons with a dropdown option would help new users - also putting the no fill / stroke options there. 
- Move the opacity settings visually closer to the fill and stroke color
- Make icons next to the "normal" "normal" dropdows so that its clear that this is thickness and dashes
- Drag drop for layer order in the gui
- Shift-clicking un-ticks everything but the current 
- Make layers highlight contained objects on hover (rest gets 50% opacity or so, maybe?)
- If there is a selection, somehow also show an arrow or do some other highlighting of in which layer the selection is rn