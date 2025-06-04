----------------------------------------------------------
-- Ramentools - some quality-of-life features by Ramin K --
----------------------------------------------------------
-- Move objects with arrow keys (copied from existing 
-- ipelet) and change grid size 
----------------------------------------------------------

-- license or so --


-- Place this file in Ipe’s configuration folder
-- (you’ll find the exact location listed on the ipelet path (check Show configuration again).

-- On MacOS, it is ~/.ipe/ipelets/, 
-- on Windows, the file has to be in the top level of the Ipe directory 
-- (the same place that contains the readme.txt and gpl.txt files).

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

  local t = { label = "move by (" .. dx .. ", " .. dy .. ")",
	      pno = model.pno,
	      vno = model.vno,
	      selection = model:selection(),
	      original = model:page():clone(),
	      matrix = ipe.Matrix(1, 0, 0, 1, dx, dy),
	      undo = revertOriginal,
	    }
  t.redo = function (t, doc)
	     local p = doc[t.pno]
	     for _,i in ipairs(t.selection) do p:transform(i, t.matrix) end
	   end
  model:register(t)
end
----

function test(model, num)
    model.ui:explain("test run!")
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
    { label = "Move right 1/4", run = mov, dx = 0.25}
--    { label = "Test command", run = test},
}

shortcuts.ipelet_1_ramenarrowkeymove = "Ctrl+Shift+Down"
shortcuts.ipelet_2_ramenarrowkeymove = "Ctrl+Shift+Up"

shortcuts.ipelet_3_ramenarrowkeymove = "Up"
shortcuts.ipelet_4_ramenarrowkeymove = "Down"
shortcuts.ipelet_5_ramenarrowkeymove = "Left"
shortcuts.ipelet_6_ramenarrowkeymove = "Right"
shortcuts.ipelet_7_ramenarrowkeymove = "Shift+Up"
shortcuts.ipelet_8_ramenarrowkeymove = "Shift+Down"
shortcuts.ipelet_9_ramenarrowkeymove = "Shift+Left"
shortcuts.ipelet_10_ramenarrowkeymove = "Shift+Right"

--shortcuts.ipelet_11_ramenarrowkeymove = "Ctrl+Shift+K" --that test one only
