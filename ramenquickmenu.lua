------------------------------------------------------------
-- Ramentools - some quality-of-life improvements for ipe --
------------------------------------------------------------
-- Ctrl+R opens a context menu at the cursor to open 
-- recent files & flip and rotate if theres a selection
------------------------------------------------------------

-- Place this file in Ipe’s configuration folder
-- (you’ll find the exact location listed on the ipelet path (check Show configuration again).

-- On MacOS, it is ~/.ipe/ipelets/, 
-- on Windows, the file must be placed in the program folder, there already exists a sub-folder named ipelets. 

label = "Quick menu"
about = "Open recent files & do rotations and flips with Ctrl+R"

function is_empty_doc(model)
    return #model:page() == 0 and #model.doc == 1 --0 elements and one page
end

function run(model)
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

shortcuts.ipelet_1_ramenquickmenu = "Ctrl+R"
shortcuts.ipelet_8_goodies = nil -- Precise rotate
--shortcuts.ipelet_8_goodies = "Ctrl+Shift+R" Precise rotate
--shortcuts.rename_active_layer = "F2"