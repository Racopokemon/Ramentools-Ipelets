------------------------------------------------------------
-- Ramentools - some quality-of-life improvements for ipe --
------------------------------------------------------------
-- Smart Toggles for F1, F2 and F3
------------------------------------------------------------

label = "Ramen Origin"
about = "Makes F1, F2, F3 toggle the axes if pressed again at the same location."

-- Toggle for F1 / setOrigin
local orig_setOrigin = _G.MODEL.setOrigin
function _G.MODEL:setOrigin(snapping)
  local pos = self.ui:simpleSnapPos()
  
  -- Check if axes are visible and position didn't change
  if self.snap.with_axes and self.snap.origin and (self.snap.origin - pos):sqLen() < 1e-6 then
    self.snap.with_axes = false
    self.ui:setActionState("show_axes", false)
    self.snap.snapangle = false
    self.ui:setActionState("snapangle", false)
    self:setSnap()
    self.ui:update()
  else
    orig_setOrigin(self, snapping)
  end
end

-- Toggle for F2 / action_set_direction
local orig_set_direction = _G.MODEL.action_set_direction
function _G.MODEL:action_set_direction()
  if not self.snap.origin then 
    orig_set_direction(self)
    return
  end
  
  local dir = (self.ui:simpleSnapPos() - self.snap.origin):angle()
  
  local diff = math.abs(self.snap.orientation - dir)
  if diff > math.pi then diff = math.abs(diff - 2*math.pi) end
  
  -- Check if axes are visible and angle didn't change
  if self.snap.with_axes and diff < 1e-4 then
    self.snap.with_axes = false
    self.ui:setActionState("show_axes", false)
    self.snap.snapangle = false
    self.ui:setActionState("snapangle", false)
    self:setSnap()
    self.ui:update()
  else
    orig_set_direction(self)
  end
end

-- Toggle for F3 / setLine
local orig_setLine = _G.MODEL.setLine
function _G.MODEL:setLine(snapping)
  local origin, dir = self:page():findEdge(self.vno, self.ui:unsnappedPos())
  
  if origin then
    local diff = math.abs(self.snap.orientation - dir)
    if diff > math.pi then diff = math.abs(diff - 2*math.pi) end
    
    -- Check if axes are visible and both position and angle didn't change
    if self.snap.with_axes and self.snap.origin and (self.snap.origin - origin):sqLen() < 1e-6 and diff < 1e-4 then
      self.snap.with_axes = false
      self.ui:setActionState("show_axes", false)
      self.snap.snapangle = false
      self.ui:setActionState("snapangle", false)
      self:setSnap()
      self.ui:update()
      return
    end
  end
  orig_setLine(self, snapping)
end
