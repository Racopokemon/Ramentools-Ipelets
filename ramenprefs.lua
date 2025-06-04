----------------------------------------------------------
-- Ramentools - some quality-of-life features by Ramin K --
----------------------------------------------------------
-- Some changes in shortcuts and minimal pref changes
----------------------------------------------------------

-- license or so --


-- Place this file in Ipe’s configuration folder
-- (you’ll find the exact location listed on the ipelet path (check Show configuration again).

-- On MacOS, it is ~/.ipe/ipelets/, 
-- on Windows, the file has to be in the top level of the Ipe directory 
-- (the same place that contains the readme.txt and gpl.txt files).


--  copying and pasting styles
shortcuts.pick_properties = "Ctrl+Shift+C"
shortcuts.apply_properties = "Ctrl+Shift+V"
shortcuts.copy_page = nil --used to be ctrl+shift+c and v
shortcuts.paste_page = nil

shortcuts.ungroup = "Ctrl+Shift+G"
shortcuts.new_window = "Ctrl+N"

----

prefs.initial.grid_size = 8
prefs.auto_run_latex = false

-- Attributes set when Ipe starts (crashes maybe bc no stylesheet is loaded yet)
--prefs.initial_attributes.farrowsize = "small"
--prefs.initial_attributes.rarrowsize = "small"
--prefs.initial_attributes.horizontalalignment = "center"
--prefs.initial_attributes.verticalalignment = "center"
