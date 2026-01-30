------------------------------------------------------------
-- Ramentools - some quality-of-life improvements for ipe --
------------------------------------------------------------
-- Move objects with arrow keys (copied from existing 
-- ipelet) and change grid size 
-- Cycle between elements with (Shift)+Tab and (Shift)+N
------------------------------------------------------------

-- Place this file in ...
-- ~/.ipe/ipelets/ (on Mac)
-- %userprofile%/ipelets/ (on Windows)

label = "Move with arrow keys"
about = "And change grid size with ctrl+shift+up / down"

function change_gridsize(model, num)
    model.ui:explain("changed gridsize")
    
    local gridsizes = allValues(model, model.doc:sheets(), "gridsize")
    --table.sort(gridsizes)
    local currentIndex = _G.indexOf(model.snap.gridsize, gridsizes)
    if methods[num].back then
        if currentIndex and currentIndex < #gridsizes then
            model.snap.gridsize = gridsizes[currentIndex + 1]
        else
            model.snap.gridsize = gridsizes[1] -- Wrap around to the smallest size
        end
    else
        if currentIndex and currentIndex > 1 then
            model.snap.gridsize = gridsizes[currentIndex - 1]
        else
            model.snap.gridsize = gridsizes[#gridsizes] -- Wrap around to the largest size
        end
    end
    model.ui:setGridAngleSize(model.snap.gridsize, model.snap.anglesize)
    model:setSnap()
end


-- good style: as i have no idea how to access this, just a copypasta from main.lua
function allValues(model, sheets, kind)
    local syms = sheets:allNames(kind)
    local values = {}
    for _,sym in ipairs(syms) do
        values[#values + 1] = sheets:find(kind, sym)
    end
    return values
end
-- end copypasta
    
-- copypasta from ipelet move.lua, but better grid size
-- and with movement merging to reduce undo steps
revertOriginal = _G.revertOriginal
function mov(model, num)
  local p = model:page()
  if not p:hasSelection() then
    model.ui:explain("no selection")
    return
  end
  local dx = methods[num].dx
  if not dx then dx = 0 end
  local dy = methods[num].dy
  if not dy then dy = 0 end
  dx = dx * model.snap.gridsize
  dy = dy * model.snap.gridsize

  local pin = {}
  for i, obj, sel, lay in p:objects() do
    if sel then pin[obj:get("pinned")] = true end
  end

  if pin.fixed or pin.horizontal and dx ~= 0 or pin.vertical and dy ~= 0 then
    model:warning("Cannot move objects",
		  "Some object is pinned and cannot be moved")
    return
  end

  local selection = model:selection()
  local matrix = ipe.Matrix(1, 0, 0, 1, dx, dy)
  
  -- Check if we can merge with the last undo action
  local last_undo = #model.undo > 0 and model.undo[#model.undo] or nil
  local can_merge = false
  
  if last_undo and last_undo._is_movement and 
     last_undo.pno == model.pno and 
     last_undo.vno == model.vno then
    -- Check if selection is the same
    local same_selection = #last_undo.selection == #selection
    if same_selection then
      for i, idx in ipairs(selection) do
        if last_undo.selection[i] ~= idx then
          same_selection = false
          break
        end
      end
    end
    can_merge = same_selection
  end

  if can_merge then
    -- Merge with last movement: multiply the matrices
    local new_matrix = last_undo.matrix * matrix
    -- Update redo to move from start to accumulated pos
    last_undo.matrix = new_matrix
    -- Manually apply the new transform w/o registering undo or calling redo
    for _,i in ipairs(selection) do p:transform(i, matrix) end
    model.ui:explain("move by (" .. dx .. ", " .. dy .. ")")
  else
    -- Create new undo action
    local t = { label = "move by (" .. dx .. ", " .. dy .. ")",
        pno = model.pno,
        vno = model.vno,
        selection = selection,
        original = model:page():clone(),
        matrix = matrix,
        undo = revertOriginal,
        _is_movement = true,  -- marker for movement actions
      }
    t.redo = function (t, doc)
       local p = doc[t.pno]
       for _,i in ipairs(t.selection) do p:transform(i, t.matrix) end
    end
    model:register(t)
  end
end


function test(model, num)
    model.ui:explain("test run!")
end

function select_next(model, num)
    next = methods[num].next

    local p = model:page()
    local vno = model.vno

    if #p == 0 then
        return
    end

    if p:hasSelection() then
        p:ensurePrimarySelection()
        idx = p:primarySelection()
    else
        if next then
            idx = 1
        else 
            idx = #p
        end
    end
    --model.ui:explain(idx) --used for debug

    local start_index = idx    
    repeat 
        if next then
            idx=idx-1
            if idx < 1 then
                idx = #p
            end
        else
            idx=idx+1
            if idx > #p then
                idx = 1
            end
        end

        local layer = p:layerOf(idx)
        if layer and p:visible(vno, layer) and not p:isLocked(layer) then
            p:deselectAll()
            p:setSelect(idx, 1) -- primary selection
            model.ui:update(false)
            return
        end
    until start_index == idx
    -- only one accessible element, do nothing
end

methods = {
    { label = "Next Grid Size", run = change_gridsize, back = false},
    { label = "Prev Grid Size", run = change_gridsize, back = true},
    { label = "Move up", run = mov, dy = 1},
    { label = "Move down", run = mov, dy = -1},
    { label = "Move left", run = mov, dx = -1},
    { label = "Move right", run = mov, dx = 1},
    { label = "Move up 1/4", run = mov, dy = 0.25},
    { label = "Move down 1/4", run = mov, dy = -0.25},
    { label = "Move left 1/4", run = mov, dx = -0.25},
    { label = "Move right 1/4", run = mov, dx = 0.25},
    {label = "Select next element", run = select_next, next=true},
    {label = "Select next element (copy)", run = select_next, next=true},
    {label = "Select previous element", run = select_next, next=false},
    {label = "Select previous element (copy)", run = select_next, next=false},
    { label = "Next Grid Size (copy)", run = change_gridsize, back = false},
    { label = "Prev Grid Size (copy)", run = change_gridsize, back = true},
--    { label = "Test command", run = test},
}

shortcuts.ipelet_1_ramenarrowkeymove = "Ctrl+Up"
shortcuts.ipelet_2_ramenarrowkeymove = "Ctrl+Down"

shortcuts.ipelet_3_ramenarrowkeymove = "Up"
shortcuts.ipelet_4_ramenarrowkeymove = "Down"
shortcuts.ipelet_5_ramenarrowkeymove = "Left"
shortcuts.ipelet_6_ramenarrowkeymove = "Right"
shortcuts.ipelet_7_ramenarrowkeymove = "Shift+Up"
shortcuts.ipelet_8_ramenarrowkeymove = "Shift+Down"
shortcuts.ipelet_9_ramenarrowkeymove = "Shift+Left"
shortcuts.ipelet_10_ramenarrowkeymove = "Shift+Right"

if config.platform == "win" then
    shortcuts.ipelet_11_ramenarrowkeymove = "tab"
    shortcuts.ipelet_13_ramenarrowkeymove = "Shift+tab"
else
    shortcuts.ipelet_11_ramenarrowkeymove = "\t"
    shortcuts.ipelet_13_ramenarrowkeymove = "Shift+\t"
end
shortcuts.ipelet_12_ramenarrowkeymove = "N"
shortcuts.ipelet_14_ramenarrowkeymove = "Shift+N"

shortcuts.ipelet_15_ramenarrowkeymove = "+"
shortcuts.ipelet_16_ramenarrowkeymove = "-"
shortcuts.fit_width = nil; --was "-"

--shortcuts.ipelet_11_ramenarrowkeymove = "Ctrl+Shift+K" --that test one only
