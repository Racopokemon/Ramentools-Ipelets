------------------------------------------------------------
-- Ramentools - some quality-of-life improvements for ipe --
------------------------------------------------------------
-- Toggle select all / nothing with the A key
-- Cycle pathmode with X
-- Cycle arrows with W
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
    --pls implement (as you see below, it worked nicely). You'll need this: 
    --selection is an array of indices, access object property with p[index]:get("pathmode"). Note that not every element in the selection supports pathmode, so you need to check for it as seen in the if check above :)
    --model:selector("pathmode","filled") <- this magical command already applies the property to the entire selection (if the property exists) and handles the undo/redo registration. 
    --_G.indexOf(model.snap.gridsize, gridsizes) is the general indexof implementation
    
    local allSame = true
    for _, index in ipairs(selection) do
      local pm = p[index]:get("pathmode")
      if pm and pm ~= "undefined" and pm ~= pathmode then
        allSame = false
        break
      end
    end

    if allSame then -- Cycle
      local modes = {"stroked","strokedfilled","filled"}
      local index = _G.indexOf(pathmode, modes)
      if methods[num].back then
        index = (index + 1) % 3 + 1
      else
        index = index%3 + 1
      end
      model:selector("pathmode", modes[index])
      model.ui:explain("Cycle pathmode")
    else -- Unify
      model:selector("pathmode", pathmode)
      model.ui:explain("Unify pathmode to primary selection")
    end

  end
end

-- Cycles between the four possible combinations of front and rear arrow enabled, in the order none <-> front <-> rear <-> both <-> ...
-- multi-selection: Applies the combination of primary selection the to rest of the selection, if some of them differ. If they all match already, cycles
function cycleArrow(model, num)
  local p = model:page()
  if not p:hasSelection() then
    model.ui:explain("No selection")
    return
  end

  local prim = p:primarySelection()
  local primObj = p[prim]
  local farrow = primObj:get("farrow")
  local rarrow = primObj:get("rarrow")

  if primObj:type() == "path" and farrow ~= nil and rarrow ~= nil then
    local selection = model:selection()
    local allSame = true

    for _, index in ipairs(selection) do
      local obj = p[index]
      if obj:type() == "path" then
        local objFarrow = obj:get("farrow")
        local objRarrow = obj:get("rarrow")
        if objFarrow ~= nil and objRarrow ~= nil and (objFarrow ~= farrow or objRarrow ~= rarrow) then
          allSame = false
          break
        end
      end
    end

    if allSame then
      local states = {
        { false, false },
        { true, false },
        { false, true },
        { true, true }
      }
      local stateIndex = 1
      for i, state in ipairs(states) do
        if state[1] == farrow and state[2] == rarrow then
          stateIndex = i
          break
        end
      end

      if methods[num].back then
        stateIndex = (stateIndex + 2) % 4 + 1
      else
        stateIndex = stateIndex % 4 + 1
      end

      model:selector("farrow", tostring(states[stateIndex][1]))
      model:selector("rarrow", tostring(states[stateIndex][2]))
      model.ui:explain("Cycle arrows")
    else
      model:selector("farrow", tostring(farrow))
      model:selector("rarrow", tostring(rarrow))
      model.ui:explain("Unify arrows to primary selection")
    end
  end
end

function edit_mode(model, num)
  model:action("edit")
end

methods = {
  { label = "Toggle select all / none", run = toggle_select_all },
  { label = "Cycle fill/stroke/both", run = cycle, back=false },
  { label = "Cycle fill/stroke/both (backwards)", run = cycle, back=true },
  { label = "Cycle front/back arrows", run = cycleArrow, back=false },
  { label = "Cycle front/back arrows (backwards)", run = cycleArrow, back=true },
  { label = "Enter edit mode (copy)", run = edit_mode }
}

shortcuts.mode_arc1 = nil --every 2nd time the shortcut is not overwritten without this fix
shortcuts.pan_here = nil

-- Shortcut: press A to toggle selection
shortcuts.ipelet_1_ramenselectiontools = "A"
shortcuts.ipelet_2_ramenselectiontools = "X"
shortcuts.ipelet_3_ramenselectiontools = "Shift+X"
shortcuts.ipelet_4_ramenselectiontools = "W"
shortcuts.ipelet_5_ramenselectiontools = "Shift+W"
shortcuts.ipelet_6_ramenselectiontools = " "
