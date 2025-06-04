---- ramenmods ----

-- Place this file in Ipe’s configuration folder
-- (you’ll find the exact location listed on the ipelet path (check Show configuration again).

-- On MacOS, it is ~/.ipe/ipelets/ramenmods.lua, 
-- on Windows, the file has to be in the top level of the Ipe directory 
-- (the same place that contains the readme.txt and gpl.txt files).

label = "Ramen Mods"

about = "Quality of life stuff by ramen"

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

function is_empty_doc(model)
    return #model:page() == 0 and #model.doc == 1 --0 elements and one page
end

function recent(model, num)
    m = ipeui.Menu(model.ui:win())
    for i, j in pairs(model.recent_files) do
        m:add("o" .. j, j)
    end

    if model:page():hasSelection() then
        m:add("nothing", "---")
        m:add("ipelet_8_goodies", "rotate by ...")
        m:add("ipelet_7_goodies", "90° right")
        m:add("ipelet_5_goodies", "90° left")
        m:add("ipelet_6_goodies", "180°")
        m:add("ipelet_1_goodies", "mirror hrz")
        m:add("ipelet_2_goodies", "mirror vrt")
    else 
        if #model.recent_files == 0 then return end
    end

    mouse = model.ui:globalPos() -- global mouse pos (but updated only after a click? At least on OSX)
    item, no, subitem = m:execute(mouse.x, mouse.y)

    if item then
        if item:sub(1,1) == "o" then
            if not is_empty_doc(model) then --and model:checkModified()
                mod = model.new(nil, item:sub(2)) --new window
                mod:runLatex()
            else
                model:loadDocument(item:sub(2)) --silently delete all changes and open new doc
                model:runLatex()
            end
            return
        end
        if item:sub(1,6) == "ipelet" then
            model:action(item)
        end
    end
end

---------------------
-- What were offering in the menu
---------------------
methods = {
    { label = "Next Grid Size", run = change_gridsize, back = false},
    { label = "Prev Grid Size", run = change_gridsize, back = true },
    { label = "Move up", run = mov, dy = 1 },
    { label = "Move down", run = mov, dy = -1 },
    { label = "Move left", run = mov, dx = -1 },
    { label = "Move right", run = mov, dx = 1 },
    { label = "Move up 1/4", run = mov, dy = 0.25 },
    { label = "Move down 1/4", run = mov, dy = -0.25 },
    { label = "Move left 1/4", run = mov, dx = -0.25 },
    { label = "Move right 1/4", run = mov, dx = 0.25 },
    { label = "Test command", run = test},
    { label = "Recent Files Quick Menu", run = recent}
}

-- assigning shortcuts for us:
shortcuts.ipelet_1_ramenmods = "Ctrl+Shift+Down"
shortcuts.ipelet_2_ramenmods = "Ctrl+Shift+Up"

shortcuts.ipelet_3_ramenmods = "Up"
shortcuts.ipelet_4_ramenmods = "Down"
shortcuts.ipelet_5_ramenmods = "Left"
shortcuts.ipelet_6_ramenmods = "Right"
shortcuts.ipelet_7_ramenmods = "Shift+Up"
shortcuts.ipelet_8_ramenmods = "Shift+Down"
shortcuts.ipelet_9_ramenmods = "Shift+Left"
shortcuts.ipelet_10_ramenmods = "Shift+Right"
shortcuts.ipelet_11_ramenmods = "Ctrl+Shift+K" --that test one only
shortcuts.ipelet_12_ramenmods = "Ctrl+R"
shortcuts.ipelet_8_goodies = "Ctrl+Shift+R" -- Precise rotate
shortcuts.rename_active_layer = "F2"

--  copying and pasting styles
shortcuts.pick_properties = "Ctrl+Shift+C"
shortcuts.apply_properties = "Ctrl+Shift+V"

shortcuts.duplicate = "Ctrl+D"
shortcuts.ungroup = "Ctrl+Shift+G"
shortcuts.copy_page = nil --used to be ctrl+shift+c and v
shortcuts.paste_page = nil
shortcuts.new_window = "Ctrl+N"


----

prefs.initial.grid_size = 8
prefs.auto_run_latex = false

-- Attributes set when Ipe starts
--prefs.initial_attributes.farrowsize = "small"
--prefs.initial_attributes.rarrowsize = "small"
--prefs.initial_attributes.horizontalalignment = "center"
--prefs.initial_attributes.verticalalignment = "center"
