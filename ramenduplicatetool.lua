------------------------------------------------------------
-- Ramentools - some quality-of-life improvements for ipe --
------------------------------------------------------------
-- Duplicate at mouse & keep layers-tool with Ctrl+D
-- Shift or Ctrl to create stamps
------------------------------------------------------------

-- Place this file in ...
-- ~/.ipe/ipelets/ (on Mac)
-- %userprofile%/ipelets/ (on Windows)

label = "Duplicate at cursor"
about = "by Ramen (who told claude to do the work)"
    --- the code worked at an instant except for one . that was mistaken for a : 
    --- Also, it guessed that p:layerOf(i) exists, which was not in the original code

DUPLICATETOOL = {}
DUPLICATETOOL.__index = DUPLICATETOOL

function DUPLICATETOOL:new(model, selection)
  local tool = {}
  _G.setmetatable(tool, DUPLICATETOOL)
  tool.model = model
  tool.prim = model:page():primarySelection()

  local p = model:page()
  tool.elements = {}
  tool.layers = {}

  tool.stamps = 0
  tool.array = 0
  tool.arraySuggested = false
  
  for _,i in ipairs(selection) do
    tool.elements[#tool.elements+1] = p[i]:clone()
    tool.layers[#tool.layers+1] = p:layerOf(i) --wtf claude did GUESS that
  end
  
  tool.start = model.ui:pos()
  
  -- create group for preview
  local obj = ipe.Group(tool.elements)
  tool.pinned = obj:get("pinned")
  model.ui:pasteTool(obj, tool) --initiates the tool somehow? Without there is no setColor
  tool.setColor(1.0, 0, 0)
  tool:computeTranslation()
  tool.setMatrix(ipe.Translation(tool.translation)) --setMatrix something internal as well?
  
  return tool
end

function DUPLICATETOOL:computeTranslation()
  self.translation = self.model.ui:pos() - self.start
  if self.pinned == "horizontal" or self.pinned == "fixed" then
    self.translation = ipe.Vector(0, self.translation.y)
  end
  if self.pinned == "vertical" or self.pinned == "fixed" then
    self.translation = ipe.Vector(self.translation.x, 0)
  end
end

function DUPLICATETOOL:mouseButton(button, modifiers, press)
  if not press then return end

  if button == 2 then -- right click, remove stamp or finish
    if self.stamps > 0 then
      self.model:action_undo()
      self.stamps = self.stamps - 1
      self.array = 0
    else 
      self.model.ui:finishTool()
      return
    end
    return
  end

  local continue = modifiers.control or modifiers.shift or modifiers.command

  if not continue then
    self.model.ui:finishTool()
  end

  self.stamps = self.stamps + 1

  if self.array <= 1 then
    self:computeTranslation()
  end

  local p = self.model:page()
  local pLayers = p:layers()
  local active = p:active(self.model.vno)
  local impossible = {}
  local finalLayers = {}
  
  -- Check layer availability as in paste_with_layer
  for i,_ in ipairs(self.layers) do
    l = self.layers[i]
    if l == "" or _G.indexOf(l, pLayers) == nil or p:isLocked(l) then
      if _G.indexOf(l, impossible) == nil then
        impossible[#impossible+1] = l
      end
      finalLayers[#finalLayers+1] = active  -- active layer as fallback
    else
      finalLayers[#finalLayers+1] = l
    end
  end
  
  -- Warning at impossible layers
  if #impossible > 0 then
    local impossibleText = ""
    for _,l in ipairs(impossible) do
      impossibleText = impossibleText .. l .. ", "
    end
    self.model:warning("Impossible to duplicate to specified layer",
      "Some of the layers of the duplicated objects either do " ..
      "not exist on this page, or are locked.\n\n" ..
      "I have used the active layer instead.\n\n" ..
      "The following layer names could not be used:\n\n" .. impossibleText)
  end
  local t = { 
    label = "duplicate objects at cursor",
    pno = self.model.pno,
    vno = self.model.vno,
    elements = self.elements,
    layers = finalLayers,
    translation = ipe.Translation(self.translation),
  }
  
  t.undo = function (t, doc)
    local p = doc[t.pno]
    for i = 1,#t.elements do 
      p:remove(#p) 
    end
  end
  
  t.redo = function (t, doc)
    local p = doc[t.pno]
    p:deselectAll()
    for i,obj in ipairs(t.elements) do
      p:insert(nil, obj:clone(), 2, t.layers[i])
      p:transform(#p, t.translation)
    end
    p:ensurePrimarySelection()
  end
  
  --self.model:page():deselectAll()
  self.model:register(t) --on undo, register restores the selection from the state here rn, so we dont want a deselect here! 
  if continue then
    if not self.arraySuggested then 
      self.array = self.array + 1
      if self.array == 1 then
        self.prevStampPos = self.model.ui:pos()
      elseif self.array > 1 then
        --suggest next stamp in same distance as first 2
        local diff = self.model.ui:pos() - self.prevStampPos
        self.model.ui:explain("lol "..diff.x.." "..self.model.ui:pos().x.." "..self.prevStampPos.y)
        self.translation = self.translation + diff
        self.setMatrix(ipe.Translation(self.translation))
        self.model.ui:update(false)
      end
    end
  else
    self.model:autoRunLatex()
  end
end

function DUPLICATETOOL:mouseMove()
  if self.array > 1 then
    self.array = 0
    self.arraySuggested = true
  end
  self:computeTranslation()
  self.setMatrix(ipe.Translation(self.translation))
  self.model.ui:update(false) -- update tool
end

function DUPLICATETOOL:key(text, modifiers)
  if text == "\027" then
    self.model.ui:finishTool()
    return true
  else
    return false
  end
end

---

function run(model)
  local selection = model:selection()
  if #selection == 0 then
    model.ui:explain("Nothing selected to duplicate")
    return
  end
  
  DUPLICATETOOL:new(model, selection)
end

shortcuts.ipelet_1_ramenduplicatetool = "Ctrl+D"