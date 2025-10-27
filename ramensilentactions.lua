------------------------------------------------------------
-- Ramentools - some quality-of-life improvements for ipe --
------------------------------------------------------------
-- Silent actions
-- Reduce some warnings when deleting & locking layers etc.
------------------------------------------------------------

-- Place this file in Ipe’s configuration folder
-- (you’ll find the exact location listed on the ipelet path (check Show configuration again).

-- On MacOS, it is ~/.ipe/ipelets/, 
-- on Windows, the file must be placed in the program folder, there already exists a sub-folder named ipelets. 

-- Helper function (way too complicated): Get the first available (unlocked) layer before the given layer
function getAlternativeLayer(page, layer, vno, call)
  local layers = page:layers()
  local idx = _G.indexOf(layer, layers)
  if not idx then return nil end
  -- Search before
  for i = idx - 1, 1, -1 do
    local l = layers[i]
    if call(page,l,vno) then
      return l
    end
  end
  -- Search after
  for i = idx + 1, #layers do
    local l = layers[i]
    if call(page,l,vno) then
      return l
    end
  end
  return nil
end

-- Helper function: Switch active layer in all views from 'layer' to a free (unlocked) layer before it
-- returns a conflicting view if it cannot switch (very special case)
function switchActiveLayerInViews(page, layer)
  function call(page, layer, arg)
    return not page:isLocked(layer)
  end
  local freeLayer = getAlternativeLayer(page, layer, nil, call)
  for v = 1, page:countViews() do
    if page:active(v) == layer then
      if not freeLayer then return v end
      page:setActive(v, freeLayer)
    end
  end
  return -1
end

-- Overwriting layeraction_delete to delete silently
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

-- Overwriting layeraction_lock to lock silently
function _G.MODEL:layeraction_lock(layer, arg)
  local p = self:page()
  local activeViews = {}

  for v = 1, p:countViews() do
    activeViews[v]=p:active(v)
  end
  local t = { label="set locking of layer " .. layer,
          pno=self.pno,
          vno=self.vno,
          layer=layer,
          original=p:isLocked(layer),
          locked=arg,
          activeViews=activeViews
        }
  
  if arg then 
    local conflictLayer = switchActiveLayerInViews(p, layer)
    if conflictLayer ~= -1 then
      self:warning("Cannot lock layer '" .. layer .. "'.",
        "Layer '" .. layer .. "' is the active layer of view "
          .. conflictLayer .. ".")
      return
    end
  end

  t.undo = function (t, doc)
       local p = doc[t.pno]
	     p:setLocked(t.layer, t.original)
       for v = 1, p:countViews() do
        p:setActive(v, t.activeViews[v])
       end
	   end
  t.redo = function (t, doc)
       local p = doc[t.pno]
       if t.locked then
        switchActiveLayerInViews(p, t.layer) -- we know it works, we tried above
       end
	     p:setLocked(t.layer, t.locked)
	   end
  self:register(t)
  self:deselectNotInView()
  self:setPage()
end

-- injecting a better creation 
-- if theres any enabled layer, place there instead. 
-- If there is none, make layer visible first. 
function _G.MODEL:creation(label, obj)
  local p = self:page()
  local active = p:active(self.vno)

  local t = { label=label, pno=self.pno, vno=self.vno,
        layer=self:page():active(self.vno), object=obj }
  
  if not p:visible(self.vno, active) then
    function call(page, layer, vno)
      return page:visible(self.vno, layer)
    end
    local alt = getAlternativeLayer(p, active, self.vno, call)
    if alt then
      t.layer = alt
      self:layeraction_active(alt)
    else
      self:layeraction_select(active, true)
    end
  end

  t.undo = function (t, doc) doc[t.pno]:remove(#doc[t.pno]) end
  t.redo = function (t, doc)
	     doc[t.pno]:deselectAll()
	     doc[t.pno]:insert(nil, t.object, 1, t.layer)
	   end
  self:register(t)
end
