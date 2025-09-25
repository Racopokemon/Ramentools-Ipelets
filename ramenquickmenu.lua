------------------------------------------------------------
-- Ramentools - some quality-of-life improvements for ipe --
------------------------------------------------------------
-- Ctrl+R opens a context menu at the cursor to open 
-- recent files & flip and rotate if theres a selection
-- Shift+5 to select opacities
------------------------------------------------------------

-- Place this file in ...
-- ~/.ipe/ipelets/ (on Mac)
-- %userprofile%/ipelets/ (on Windows)

label = "Ramen quick menues"
about = "Open recent files & do rotations and flips with Ctrl+R, change opacities with Shift+5"

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
    name_in_sheet = methods[num].name_in_sheet

    -- Get the current attributes and available opacities from the style sheets
    local sheet = model.doc:sheets()
    local opacities = sheet:allNames(name_in_sheet)
    if #opacities == 0 then return end

    if methods[num].sort then
        table.sort(opacities)
    end

    local m = ipeui.Menu(model.ui:win())
    for _, opacity in ipairs(opacities) do
        m:add(opacity, opacity)
    end

    -- Get mouse position for menu popup
    local mouse = model.ui:globalPos()
    local x, y = mouse.x, mouse.y
    if x < 1 or x > 100000 then x = 0 end
    if y < 1 or y > 100000 then y = 0 end

    local item = m:execute(math.floor(x), math.floor(y))
    if item then
        -- Set the opacity attribute for the selection
        model:selector(attr, item)
    end
end

methods = {
    { label = "Quick menu", run = quick_menu},
    { label = "Opacity menu", run = attribute_menu, attr="opacity", name_in_sheet="opacity", sort=true},
    { label = "Stroke opacity menu", run = attribute_menu, attr="strokeopacity", name_in_sheet="opacity", sort=true},
    { label = "Tiling menu", run = attribute_menu, attr="tiling", name_in_sheet="tiling", sort=false},
    { label = "Pen width menu", run = attribute_menu, attr="pen", name_in_sheet="pen", sort=false},
    { label = "Pen dash menu", run = attribute_menu, attr="dashstyle", name_in_sheet="dashstyle", sort=false}
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