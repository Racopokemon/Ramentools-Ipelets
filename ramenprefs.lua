------------------------------------------------------------
-- Ramentools - some quality-of-life improvements for ipe --
------------------------------------------------------------
-- Some changes in shortcuts and minimal pref changes
------------------------------------------------------------

-- Place this file in ...
-- ~/.ipe/ipelets/ (on Mac)
-- %userprofile%/ipelets/ (on Windows)

-- copying and pasting styles
if config.platform == "apple" then
    --for some reason, multi-shortcuts are not supported on mac
    shortcuts.pick_properties = "Ctrl+Shift+C"
    shortcuts.apply_properties = "Ctrl+Shift+V"
else
    shortcuts.pick_properties = {"Q", "Ctrl+Shift+C"}
    shortcuts.apply_properties = {"Ctrl+Q", "Ctrl+Shift+V"}
end
shortcuts.copy_page = nil --used to be ctrl+shift+c and v
shortcuts.paste_page = nil

shortcuts.ungroup = "Ctrl+Shift+G"
shortcuts.new_window = "Ctrl+N"
shortcuts.edit_notes = nil --old ctrl-N command

--hardly use it & rather annoying, so disabling these hotkeys
shortcuts.set_origin = nil    --F1
shortcuts.set_direction = nil --F2
shortcuts.set_line = nil      --F3

shortcuts.style_sheets = "Ctrl+Shift+Y"
shortcuts.save_as = "Ctrl+Shift+S"

shortcuts.duplicate = nil --super weird if you don't know it and randomly theres stuff twice

-- backspace, tab, enter etc. are introduced in the modified main.lua, without it they will not work on Windows. However, you can look up the keycodes here: https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
-- backspace e.g. can be acessed using \b
if config.platform ~= "apple" then
    shortcuts.delete = {"delete", "backspace"}
end

if config.platform == "apple" then
    shortcuts.next_view = "Control+\t"
    shortcuts.previous_view = "Control+Shift+\t"
else
    shortcuts.next_view = {"Ctrl+tab", "PgDown"}
    shortcuts.previous_view = {"Ctrl+Shift+tab", "PgUp"}
end


----

-- ppl will probably hate all four of these options, maybe delete em
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
mouse.left_control = "stretch"