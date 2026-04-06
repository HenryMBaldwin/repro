local border = nil
local borderTimer = nil
local borderWidth = 5
local borderColor = { red = 0xd2 / 0xff, green = 0x0f / 0xff, blue = 0x39 / 0xff, alpha = 0.8 }
local lastFrame = nil

local function deleteBorder()
	if border then
		border:delete()
		border = nil
	end
	lastFrame = nil
end

local function drawBorder()
	local win = hs.window.focusedWindow()
	if not win then
		deleteBorder()
		return
	end

	local f = win:frame()

	-- skip redraw if frame hasn't changed
	if lastFrame and f.x == lastFrame.x and f.y == lastFrame.y and f.w == lastFrame.w and f.h == lastFrame.h then
		return
	end
	lastFrame = f

	if border then
		border:delete()
	end

	border = hs.canvas.new(f)
	border:appendElements({
		type = "rectangle",
		action = "stroke",
		strokeColor = borderColor,
		strokeWidth = borderWidth,
	})
	border:level(hs.canvas.windowLevels.floating)
	border:show()
end

-- timer for tracking drags in real-time
borderTimer = hs.timer.new(0.05, drawBorder)
borderTimer:start()

-- window filter events for instant response to programmatic moves (e.g. Rectangle)
local wf = hs.window.filter.default
wf:subscribe(hs.window.filter.windowMoved, drawBorder)
wf:subscribe(hs.window.filter.windowFocused, drawBorder)
wf:subscribe(hs.window.filter.windowUnfocused, deleteBorder)
