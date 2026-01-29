------------------------------------------------------------
-- Ramentools - some quality-of-life improvements for ipe --
------------------------------------------------------------
-- Ctrl+R opens a context menu at the cursor to open 
-- recent files & flip and rotate if theres a selection
-- Shift+5, Ctrl+Shift+5, Ctrl+Shift+T, Ctrl+Shift+W, 
-- Ctrl+Shift+D to set opacity, stroke opacity, tiling, pen 
-- width, dashing
------------------------------------------------------------

-- Place this file in ...
-- ~/.ipe/ipelets/ (on Mac)
-- %userprofile%/ipelets/ (on Windows)

label = "Ramen quick menues"
about = "Open recent files & do rotations and flips with Ctrl+R, quick menus for opacities, line & tiling properties"

function is_empty_doc(model)
    return #model:page() == 0 and #model.doc == 1 --0 elements and one page
end

function quick_menu(model, num)
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

    mouse = model.ui:globalPos() -- global mouse pos 
    -- (but updated only after the first click. On Windows after bootup, its some e-300 float OR some e+300 float OR some random 8.07... float, so we work around that
    -- (actually almost feels like not initialized at all, its entirely random)
    local x, y = mouse.x, mouse.y
    if x < 1 or x > 100000 then x = 0 end
    if y < 1 or y > 100000 then y = 0 end
    item, no, subitem = m:execute(math.floor(x), math.floor(y))

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

function attribute_menu(model, num)
    attr = methods[num].attr
    -- secret feature: if none of the selected shapes currently has a fill (or strokefilled), set the line opacity instead. Equally, when setting the line opacity where nothing in the selection is stroked (or strokefilled), set the opaticy instead: 
    local use_attr = attr

    if attr == "opacity" or attr == "strokeopacity" then
        local p = model:page()
        local selection = model:selection()
        local has_fill = false
        local has_stroke = false
        for _, index in ipairs(selection) do
            local pm = p[index]:get("pathmode")
            if pm and pm ~= "undefined" then
                if pm == "filled" then
                    has_fill = true
                elseif pm == "stroked" then
                    has_stroke = true
                elseif pm == "strokedfilled" then
                    has_fill = true
                    has_stroke = true
                end
            end
        end

        if attr == "opacity" and not has_fill and has_stroke then
            use_attr = "strokeopacity"
        elseif attr == "strokeopacity" and not has_stroke and has_fill then
            use_attr = "opacity"
        end
    end

    name_in_sheet = use_attr
    if use_attr == "strokeopacity" then name_in_sheet = "opacity" end

    -- Get the current attributes and available values from the style sheets
    local sheet = model.doc:sheets()
    local values = sheet:allNames(name_in_sheet)
    if #values == 0 then return end

    if name_in_sheet == "opacity" or name_in_sheet == "pen" then
        table.sort(values, function(a, b)
            local aval = sheet:find(name_in_sheet, a)
            local bval = sheet:find(name_in_sheet, b)
            return aval < bval
        end)
    end

    local m = ipeui.Menu(model.ui:win())

    local prim = model:page():primarySelection()
    if not prim then
        return
    end

    local current_value = model:page()[prim]:get(use_attr)

    if attr == "tiling" then
        table.insert(values, 1, "normal")
    end

    for _, value in ipairs(values) do
        if value == current_value then
            m:add(value, "> " .. value)
        else
            m:add(value, value)
        end
    end

    -- Get mouse position for menu popup
    local mouse = model.ui:globalPos()
    local x, y = mouse.x, mouse.y
    if x < 1 or x > 100000 then x = 0 end
    if y < 1 or y > 100000 then y = 0 end

    local item = m:execute(math.floor(x), math.floor(y))
    if item and item ~= nil then
        -- Set the attribute for the selection
        model:selector(use_attr, item)
    end
end

methods = {
    { label = "Quick menu", run = quick_menu},
    { label = "Opacity menu", run = attribute_menu, attr="opacity"},
    { label = "Stroke opacity menu", run = attribute_menu, attr="strokeopacity"},
    { label = "Tiling menu", run = attribute_menu, attr="tiling"},
    { label = "Pen width menu", run = attribute_menu, attr="pen"},
    { label = "Pen dash menu", run = attribute_menu, attr="dashstyle"}
}


shortcuts.ipelet_1_ramenquickmenu = "Ctrl+R"
shortcuts.ipelet_2_ramenquickmenu = "Shift+5" -- opacity
shortcuts.ipelet_3_ramenquickmenu = "Ctrl+Shift+5" -- stroke opacity
shortcuts.ipelet_4_ramenquickmenu = "Ctrl+Shift+T" -- tiling
shortcuts.ipelet_5_ramenquickmenu = "Ctrl+Shift+W" -- pen width
shortcuts.ipelet_6_ramenquickmenu = "Ctrl+Shift+D" -- pen dash
shortcuts.ipelet_8_goodies = nil -- Precise rotate (was Ctrl+R before)
--shortcuts.ipelet_8_goodies = "Ctrl+Shift+R" Precise rotate
--shortcuts.rename_active_layer = "F2"