## Future work
- (Could we include in a way that A also saves/restores the last selection? If there was nothing else in between? - maybe you can grab that from the last undo step that saves the last selection? Or does it feel wrong like this? At least it cant crash like this. -> Maybe make it Shift+S for now.)
- Later: See if it makes sense that pressing S always unselects everything, and a 2nd hit restores the last selection, if there was any. 
- When pasting stuff, I did not understand at all why I couldnt stamp. Fix this together with duplicate, that also arraying works etc? Same function etc?
- Mid click should not duplicate in tool. (Probably same with other tools. With any tool? Can we do that?)
- One could group multiple consecutive arrow movements in the undo history, would actually be very clever
- Make poly-tool remove not needed verts, if theres multiple in a row. On finish, so also between start and end
- Edittool - how hard is it to modify it?
    - Better way to create verts. Best would be to click anywhere on the line using snap. But, well. 
    - Make the shortcut for cycling between grid-sizes also work in edittool (but this might be problematic)
- Make the 2nd call of F1, F2 and F3 hide the axis (better solution than just removing the shortcuts)
- (Maybe) have arrow keys in duplicate tool also work along the size grid (including shift? I think shift is not supported in tools)
- One could think to make Ctrl+Shift+A first switch to the layer of the current selection (if there is one). Similarily, Ctrl+Shift+C should also pick the layer? Or, Ctrl+Space should also pick properties. 
- Make ctrl-shift-N already select the new layer!
- One could slightly modify the "flip", "rotate" and "scale" goodie scripts to not only work with selections. Instead, if nothing is selected, it is applied to everything / everything is selected before the dialog opens or the action is applied
- Context menu: Shift 5 should display (if only shape selected that has no fill but line) menu for outline transparency. Similarily for Ctrl Shift 5 if only fill. 
- Right now I am missing a "pick all with same properties" that might be placed at Shift+Alt+A - but this is not that easy. Should we compare all properties? Also filled and unfilled? Texts, Paragraphs and Marks are separate classes, probably. Maybe go several stages, if there is no other mark exactly the same, select all marks? If there are no other texts of same color, select all texts? ...
    - There is a preinstalled ipelet that selects all of same kind? Check it out first!
- The quickmenu sorts entries by values and indicates (with a >) the current value. Turns out you CAN edit the context menu in the properties.lua <- apply these fixes also there! 
- Ctrl+Shift+Left / Right are still unintuitive. I want to select less going to the left, and select more going to the right. 
- One could rework Polyfillet ...
    - Replace shape instead of adding new shape
    - Use old properties instead of the currently selected ones
    - Keep in the same layer
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
- In the context menu, sort opacitiy entries (and probably stroke sizes etc) by values
- In the context menu, indicate which option is active for the selection rn