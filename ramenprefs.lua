------------------------------------------------------------
-- Ramentools - some quality-of-life improvements for ipe --
------------------------------------------------------------
-- Some changes in shortcuts and minimal pref changes
------------------------------------------------------------

-- Place this file in Ipe’s configuration folder
-- (you’ll find the exact location listed on the ipelet path (check Show configuration again).

-- On MacOS, it is ~/.ipe/ipelets/, 
-- on Windows, the file must be placed in the program folder, there already exists a sub-folder named ipelets. 


--  copying and pasting styles
shortcuts.pick_properties = "Ctrl+Shift+C"
shortcuts.apply_properties = "Ctrl+Shift+V"
shortcuts.copy_page = nil --used to be ctrl+shift+c and v
shortcuts.paste_page = nil

shortcuts.ungroup = "Ctrl+Shift+G"
shortcuts.new_window = "Ctrl+N"

--hardly use it & rather annoying, so disabling these hotkeys
shortcuts.set_origin = nil    --F1
shortcuts.set_direction = nil --F2
shortcuts.set_line = nil      --F3

shortcuts.style_sheets = "Ctrl+Shift+Y"
shortcuts.save_as = "Ctrl+Shift+S"
----

prefs.initial.grid_size = 8
prefs.auto_run_latex = false

prefs.snap.intersection = true
prefs.snap.vertex = true

-- Attributes set when Ipe starts (crashes maybe bc no stylesheet is loaded yet)
prefs.initial_attributes.farrowsize = "small"
prefs.initial_attributes.rarrowsize = "small"
prefs.initial_attributes.horizontalalignment = "hcenter"
prefs.initial_attributes.verticalalignment = "vcenter"

mouse.button9 = "shredder"
mouse.left_command = "stretch"
