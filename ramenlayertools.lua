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
-- on Windows, the file must be placed in the program folder, there already exists a sub-folder named ipelets. 


label = "Layer-related shortcuts"
about = "Some stuff that might come in handy"

function match_layer(model, num)
  local p = model:page()
  local prim = p:primarySelection()
  if not prim then
    model.ui:explain("no primary selection")
    return
  end
  local layer = p:layerOf(prim)
  if not layer then
    model.ui:explain("could not determine layer of primary selection")
    return
  end
  model:layeraction_active(layer)
end

function cycle_layers(model, num)
    local p = model:page()
    local active = p:active(model.vno)
    local layers = p:layers()
    local index = _G.indexOf(active, layers)

    if #layers <= 1 then return end

    if methods[num].back then
        if index == 1 then
            model:layeraction_active(layers[#layers])
        else
            model:layeraction_active(layers[index-1])
        end
    else
        if index == #layers then
            model:layeraction_active(layers[1])
        else
            model:layeraction_active(layers[index+1])
        end
    end
end

function cycle_layer_vis(model, num)
    model.ui:explain("test run!")
end

methods = {
    { label = "Select Layer of Selection", run = match_layer},
    { label = "Select Next Layer", run = cycle_layers, back = false},
    { label = "Select Prev Layer", run = cycle_layers, back = true},
    { label = "Cycle Layer Visibilities", run = cycle_layer_vis}
}

shortcuts.ipelet_1_ramenlayertools = "Ctrl+ "
shortcuts.ipelet_2_ramenlayertools = "Ctrl+Shift+Down"
shortcuts.ipelet_3_ramenlayertools = "Ctrl+Shift+Up"
shortcuts.ipelet_4_ramenlayertools = "Ctrl+Shift+H"