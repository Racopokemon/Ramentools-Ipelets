------------------------------------------------------------
-- Ramentools - some quality-of-life improvements for ipe --
------------------------------------------------------------
-- Silent actions
-- Reduce some warnings when deleting layers etc.
------------------------------------------------------------

-- Place this file in Ipe’s configuration folder
-- (you’ll find the exact location listed on the ipelet path (check Show configuration again).

-- On MacOS, it is ~/.ipe/ipelets/, 
-- on Windows, the file must be placed in the program folder, there already exists a sub-folder named ipelets. 



-- Helper function: Get the first available (unlocked) layer before the given layer
function getAlternativeLayer(page, layer)
  local layers = page:layers()
  local idx = nil
  for i, l in ipairs(layers) do
    if l == layer then
      idx = i
      break
    end
  end
  if not idx then return nil end
  -- Search before
  for i = idx - 1, 1, -1 do
    local l = layers[i]
    if not page:isLocked(l) then
      return l
    end
  end
  -- Search after
  for i = idx + 1, #layers do
    local l = layers[i]
    if not page:isLocked(l) then
      return l
    end
  end
  return nil
end

-- Helper function: Switch active layer in all views from 'layer' to a free (unlocked) layer before it
-- returns a conflicting view if it cannot switch (very special case)
function switchActiveLayerInViews(page, layer)
  local freeLayer = getAlternativeLayer(page, layer)
  for v = 1, page:countViews() do
    if page:active(v) == layer then
      if not freeLayer then return v end
      page:setActive(v, freeLayer)
    end
  end
  return -1
end

-- Silent layeraction_delete
function _G.MODEL:layeraction_delete(layer)
  local p = self:page()
  local t = { label="delete layer " .. layer,
          pno=self.pno,
          vno=self.vno,
          original=p:clone(),
          layer=layer,
          undo=_G.revertOriginal
        }
  
  --bit unclean code, but should be alright. We call it twice, so redo() call doesnt do stuff or we know from here that it always works. 
  local conflictLayer = switchActiveLayerInViews(p, t.layer)
  if conflictLayer ~= -1 then
      self:warning("Cannot delete layer '" .. layer .. "'.",
		   "Layer '" .. layer .. "' is the active layer of view "
		     .. conflictLayer .. ".")
    return
  end

  t.redo = function (t, doc)
    local p = doc[t.pno]
    switchActiveLayerInViews(p, t.layer)
    for i = #p,1,-1 do
      if p:layerOf(i) == t.layer then
        p:remove(i)
      end
    end
    p:removeLayer(t.layer)
  end
  self:register(t)
end

-- Adapted layeraction_lock
function _G.MODEL:layeraction_lock(layer, arg)
  local p = self:page()
  if arg then
    switchActiveLayerInViews(p, layer)
  end
  local t = { label="set locking of layer " .. layer,
          pno=self.pno,
          vno=self.vno,
          layer=layer,
          original=p:isLocked(layer),
          locked=arg,
        }
  t.undo = function (t, doc)
    local p = doc[t.pno]
    if t.locked then
      switchActiveLayerInViews(p, t.layer)
    end
    p:setLocked(t.layer, t.original)
  end
  t.redo = function (t, doc)
    local p = doc[t.pno]
    if t.locked then
      switchActiveLayerInViews(p, t.layer)
    end
    p:setLocked(t.layer, t.locked)
  end
  self:register(t)
  self:deselectNotInView()
  self:setPage()
end