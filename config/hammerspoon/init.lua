local border = nil
local borderWidth = 3
local borderColor = {red=1, green=0, blue=0, alpha=0.8}

local function drawBorder()
  if border then border:delete() end

  local win = hs.window.focusedWindow()
  if not win then return end

  local frame = win:frame()

  border = hs.drawing.rectangle(frame)
  border:setStrokeColor(borderColor)
  border:setFill(false)
  border:setStrokeWidth(borderWidth)
  border:setLevel("floating")
  border:show()
end

hs.window.filter.default:subscribe(hs.window.filter.windowFocused, drawBorder)
