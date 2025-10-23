------------------------------------------------------------
-- Ramentools - some quality-of-life improvements for ipe --
------------------------------------------------------------
-- Move objects with arrow keys (copied from existing 
-- ipelet) and change grid size 
------------------------------------------------------------

-- Place this file in ...
-- ~/.ipe/ipelets/ (on Mac)
-- %userprofile%/ipelets/ (on Windows)

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

function match_layer_and_pick_properties(model, num)
  if not model:page():primarySelection() then
    model.ui:explain("no primary selection")
    return
  end
  match_layer(model, num)
  model:saction_pick_properties()
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

function toggle_layer_vis(model, num)
  local p = model:page()
  local vno = model.vno
  local active = p:active(vno)
  local visible = p:visible(vno, active)
  model:layeraction_select(active, not visible)
end

-- if active layer is solo'ed already, make all visible. Otherwise make exactly active layer visible
function toggle_layer_solo(model, num)
  -- layer, arg
  local p = model:page() 
  local layer = p:active(model.vno)
  local layers = p:layers()
  local layer_visibilities = {}
  local already_solo = true
  for _, l in ipairs(layers) do
    local vis = p:visible(model.vno, l)
    layer_visibilities[l] = vis
    if l ~= layer and vis then
      already_solo = false
    end
    if l == layer and not vis then
      already_solo = false
    end
  end

  local t = { label = "solo visibility for layer " .. layer,
              pno = model.pno,
              vno = model.vno,
              layer = layer,
              original = layer_visibilities,
            }

  t.undo = function (t, doc)
    local p = doc[t.pno]
    for _, l in ipairs(p:layers()) do
      p:setVisible(t.vno, l, t.original[l])
    end
  end

  if already_solo then
    -- show all layers
    t.redo = function (t, doc)
      local p = doc[t.pno]
      for _, l in ipairs(p:layers()) do
        p:setVisible(t.vno, l, true)
      end
    end
  else
    -- hide all except the given layer
    t.redo = function (t, doc)
      local p = doc[t.pno]
      for _, l in ipairs(p:layers()) do
        p:setVisible(t.vno, l, l == t.layer)
      end
    end
  end
  
  model:register(t)
  model:deselectNotInView() -- actions.lua always calls here -- but shouldnt it come in the redo function?
end

methods = {
    { label = "Activate Layer of Selection", run = match_layer},
    { label = "Activate Next Layer", run = cycle_layers, back = false},
    { label = "Activate Prev Layer", run = cycle_layers, back = true},
    { label = "Toggle Layer Visibility", run = toggle_layer_vis},
    { label = "Toggle Layer Solo", run = toggle_layer_solo},
    { label = "Activate Layer & Pick Properties", run = match_layer_and_pick_properties}
}

shortcuts.ipelet_1_ramenlayertools = "Ctrl+ "
shortcuts.ipelet_2_ramenlayertools = "Ctrl+Shift+Down"
shortcuts.ipelet_3_ramenlayertools = "Ctrl+Shift+Up"
shortcuts.ipelet_4_ramenlayertools = "Ctrl+Shift+Left" 
shortcuts.ipelet_5_ramenlayertools = "Ctrl+Shift+Right"
if config.platform == "win" then
  shortcuts.ipelet_6_ramenlayertools = "Ctrl+Shift+space" --for weird reasons, "Ctrl+ " works on windows but "Ctrl+Shift+ " doesnt work. ("Shift+ " works...)
else
  shortcuts.ipelet_6_ramenlayertools = "Ctrl+Shift+ "
end