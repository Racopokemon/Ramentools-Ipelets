------------------------------------------------------------
-- Ramentools - some quality-of-life improvements for ipe --
------------------------------------------------------------
-- Toggle select all / nothing with the A key
-- Cycle pathmode with X
------------------------------------------------------------

-- Place this file in ...
-- ~/.ipe/ipelets/ (on Mac)
-- %userprofile%/ipelets/ (on Windows)

label = "Selection"
about = "Toggle select all / deselect all with the A key"

function toggle_select_all(model, num)
  local p = model:page()
  if p:hasSelection() then
    p:deselectAll()
    model.ui:explain("Deselected all")
  else
    model:action_select_all()
    if p:hasSelection() then
        model.ui:explain("Selected all")
    end
  end
  -- model.ui:update(false)
end

-- Cycles between the three possible pathmode types "stroked", "strokedfilled", "filled".
-- multi-selection: Applies pathmode of primary the to rest if they differ. If they already have the same pathmode, cycles all. 
function cycle(model, num)
  local p = model:page()
  if not p:hasSelection() then
    model.ui:explain("No selection")
    return
  end
  local prim = p:primarySelection()
  local pathmode = p[prim]:get("pathmode")
  if pathmode and pathmode ~= "undefined" then
    local selection = model:selection()
    --pls implement. You'll need this: 
    --selection is an array of indices, access object property with p[index]:get("pathmode"). Note that not every element in the selection supports pathmode, so you need to check for it as seen in the if check above :)
    --model:selector("pathmode","filled") <- this magical command already applies the property to the entire selection (if the property exists) and handles the undo/redo registration. 
    --_G.indexOf(model.snap.gridsize, gridsizes) is the general indexof implementation
    
    local allSame = true
    for _, index in ipairs(selection) do
      local pm = p[index]:get("pathmode")
      if pm and pm ~= pathmode then
        allSame = false
        break
      end
    end

    if allSame then -- Cycle
      local modes = {"stroked","strokedfilled","filled"}
      local index = _G.indexOf(pathmode, modes)
      if methods[num].back then
        index = index%3 + 1
      else
        index = (index + 1) % 3 + 1
      end
      model:selector("pathmode", modes[index])
      model.ui:explain("Cycle pathmode")
    else -- Unify
      model:selector("pathmode", pathmode)
      model.ui:explain("Unify pathmode to primary selection")
    end

  end
end

methods = {
  { label = "Toggle select all / none", run = toggle_select_all },
  { label = "Cycle fill/stroke/both", run = cycle, back=false },
  { label = "Cycle fill/stroke/both (backwards)", run = cycle, back=true }
}

shortcuts.mode_arc1 = nil --every 2nd time the shortcut is not overwritten without this fix
shortcuts.pan_here = nil

-- Shortcut: press A to toggle selection
shortcuts.ipelet_1_ramenselectiontools = "A"
shortcuts.ipelet_2_ramenselectiontools = "X"
shortcuts.ipelet_3_ramenselectiontools = "Shift+X"
