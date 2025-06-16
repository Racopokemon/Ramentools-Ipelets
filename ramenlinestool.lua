----------------------------------------------------------
-- Ramentools - some quality-of-life features by Ramin K --
----------------------------------------------------------
-- Some changes to details in the LINESTOOL
----------------------------------------------------------

-- license or so --


-- Place this file in Ipe’s configuration folder
-- (you’ll find the exact location listed on the ipelet path (check Show configuration again).

-- On MacOS, it is ~/.ipe/ipelets/, 
-- on Windows, the file must be placed in the program folder, there already exists a sub-folder named ipelets. 

-- Auto close?
-- write markdown dox
-- better explain
-- fix backspace and enter not working

local VERTEX = 1
local SPLINE = 2
local ARC = 3

-- Injecting a modded version of the original calls
function _G.LINESTOOL:mouseButton(button, modifiers, press)
  if not press then return end
  local v = self.model.ui:pos()
  self.v[#self.v] = v
  if button == 0x81 then 
    -- double click
    -- the first click already added a vertex, do not use second one
    self:finish(true)
    return
  end
  if (modifiers.control or modifiers.command) and button == 1 then
    self:finish(false)
    return
  end
  if button == 2 then -- right click deletes last one now
    self:delete()
    return
  end
  
  -- no finish, no delete: Normal creation now
  if #self.v > 1 and v == self.v[#self.v - 1] and self:last() == VERTEX then
    -- "remove doubles", clicking the same pos twice in a row does not create a second vertex (for arc and verts)
    table.remove(self.v)
    table.remove(self.t)  
  elseif #self.v > 2 and self.t[#self.t-1] == ARC and self.v[#self.v - 2] == self.v[#self.v] then
    -- remove degen arcs
    table.remove(self.v)
    table.remove(self.t)  
    table.remove(self.v)
    table.remove(self.t)
  end
  self.v[#self.v + 1] = v
  self.model.ui:setAutoOrigin(v)
  if self:last() == SPLINE then
    local typ = modifiers.shift and VERTEX or SPLINE
    self.t[#self.t] = typ
    self.t[#self.t + 1] = typ
  else
    self.t[#self.t + 1] = VERTEX
  end
  self:compute()
  self.model.ui:update(false) -- update tool
  self:explain()
end

function _G.LINESTOOL:explain()
  if true then return end
  local s
  if self:last() == SPLINE then
    s = ("Left: add ctrl point | Shift+Left: switch to line mode" ..
	 " | Del: delete ctrl point")
  else
    s = "Left: add vtx | Del: delete vtx"
  end
  s = s .. " | Right, Ctrl-Left, or Double-Left: final vtx"
  if self:has_segs(2) then
    s = s .. " | " .. _G.shortcuts_linestool.spline .. ": spline mode"
  end
  if self:has_segs(3) then
    s = s .. " | " .. _G.shortcuts_linestool.arc .. ": circle arc"
  end
  if #self.v > 2 and self.t[#self.t - 1] == VERTEX then
    s = s .. " | " .. _G.shortcuts_linestool.set_axis ..": set axis"
  end
  self.model.ui:explain(s, 0)
end

function _G.LINESTOOL:delete()
    if #self.v > 2 then
      table.remove(self.v)
      table.remove(self.t)
      if self:last() == ARC then
	    self.t[#self.t] = VERTEX
      end
      self.v[#self.v] = self.model.ui:pos()
      self:compute()
      self.model.ui:update(false)
      self:explain()
    end
end

function _G.LINESTOOL:key(text, modifiers)
  if text == "backspace" or text == "delete" then
    self:delete()
    return true
  elseif text == "\027" then
    self.model.ui:finishTool()
    return true
  elseif text == " " or text == "enter" then
    if self:last() == SPLINE then self:finish(false)
    elseif self:last() == VERTEX and #self.t > 2 and self.t[#self.t-1] == ARC then self:finish(false)
    else self:finish(true) end
    return true
  elseif self:has_segs(2) and text == _G.shortcuts_linestool.spline then
    self.t[#self.t] = SPLINE
    self:compute()
    self.model.ui:update(false)
    self:explain()
    return true
  elseif self:has_segs(3) and text == _G.shortcuts_linestool.arc then
    self.t[#self.t - 1] = ARC
    self:compute()
    self.model.ui:update(false)
    self:explain()
    return true
  elseif #self.v > 2 and self.t[#self.t - 1] == VERTEX and
    text == _G.shortcuts_linestool.set_axis then
    -- set axis
    self.model.snap.with_axes = true
    self.model.ui:setActionState("show_axes", self.model.snap.with_axes)
    self.model.snap.snapangle = true
    self.model.snap.origin = self.v[#self.v - 1]
    self.model.snap.orientation = self:compute_orientation()
    self.model:setSnap()
    self.model.ui:setActionState("snapangle", true)
    self.model.ui:update(true)   -- redraw coordinate system
    self:explain()
    return true
  else
    return false
  end
end

function _G.LINESTOOL:finish(deleteLast)
    if #self.v <= 1 then 
        self.model.ui:finishTool()
        return
    end
    if deleteLast then
        table.remove(self.v)
        table.remove(self.t)
        if self:last() == ARC then
            self.t[#self.t] = VERTEX
        end
    end

    -- degen cases, 1, 2 at the same, or closed 3er. lets not do that
    if #self.v == 1 or (#self.v <= 3 and self.v[1] == self.v[#self.v]) then 
        self.model.ui:finishTool()
        return
    end

    -- Close the shape if the last vertex coincides with the first
    if #self.v > 2 and self.v[1] == self.v[#self.v] then
        if self:last() == SPLINE and self.t[#self.t-1] == VERTEX then
            self.t[#self.t] = VERTEX -- single step spline is just a line segment
        end
        if self:last() == VERTEX and self.t[#self.t-1] ~= ARC then
            table.remove(self.v)
            table.remove(self.t)
            -- this creates two overlapping verts, but it cant be helped easily - the last segment is always a line but not represented in a shape, so you cant modify it. You also cant delete it in edit mode...
        end
        self.mode = "polygons"
    else
        if self:last() == SPLINE then self.t[#self.t] = VERTEX end
    end

    self:compute()
    self.model.ui:finishTool()

    local obj = ipe.Path(self.model.attributes, { self.shape }, true)
    if not self.shape.closed then
        obj:set("pathmode", "stroked")
    end
    self.model:creation("create path", obj)
end