------------------------------------------------------------
-- Ramentools - some quality-of-life improvements for ipe --
------------------------------------------------------------
-- Toggle select all / nothing with the A key
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

methods = {
  { label = "Toggle select all / none", run = toggle_select_all }
}

shortcuts.mode_arc1 = nil --every 2nd time the shortcut is not overwritten without this fix

-- Shortcut: press A to toggle selection
shortcuts.ipelet_1_ramenselectiontools = "A"
