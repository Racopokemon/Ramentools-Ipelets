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




-- if polyline: NO fill
-- no doubles!
-- how does it work for the other tools? - SPLINES are ugly and replaced with verts; circles crash lol. 
    -- Not tested for Splines tool etc yet
-- make right click and backspace remove (and show info)
-- close if no grid? Tolerance distance?
-- Auto close?
-- write markdown dox

local VERTEX = 1
local SPLINE = 2
local ARC = 3

-- Injecting a modded version of the original mouseButton call
function _G.LINESTOOL:mouseButton(button, modifiers, press)
  if not press then return end
  local v = self.model.ui:pos()
  self.v[#self.v] = v
  if button == 0x81 then
    -- double click
    -- the first click already added a vertex, do not use second one
    if #self.v == 2 then return end -- single vertex, lets maybe dont create something
    table.remove(self.v)
    table.remove(self.t)
    button = 2
  elseif #self.v > 1 and v == self.v[#self.v - 1] then
    -- "remove doubles", clicking the same pos twice in a row does not create a second vertex
    table.remove(self.v)
    table.remove(self.t)  
  end
  if modifiers.control and button == 1 then button = 2 end
  if button == 2 then
    if self:last() == SPLINE then self.t[#self.t] = VERTEX end
    -- Close the shape if the last vertex coincides with the first
    if #self.v > 2 and self.v[1] == self.v[#self.v] then
      table.remove(self.v)
      table.remove(self.t)
      self.mode = "polygons"
    end
    self:compute()
    self.model.ui:finishTool()
    local obj = ipe.Path(self.model.attributes, { self.shape }, true)
    -- if it is just a point, force line cap to round
    if #self.shape == 1 and self.shape[1].type == "segment" and
      self.shape[1][1] == self.shape[1][2] then
      obj:set("linecap", "round")
    end
    self.model:creation("create path", obj)
    return
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