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

-- auto clicker: toggle with cmd+alt+ctrl+0, clicks at cursor 10x/sec
local clickerTimer = nil
local clickerIndicator = nil

local function hideClickerIndicator()
	if clickerIndicator then
		clickerIndicator:delete()
		clickerIndicator = nil
	end
end

local function showClickerIndicator()
	hideClickerIndicator()
	local screen = hs.screen.mainScreen():frame()
	clickerIndicator = hs.canvas.new({ x = screen.x + screen.w - 140, y = screen.y + 20, w = 120, h = 28 })
	clickerIndicator:appendElements({
		type = "rectangle",
		action = "fill",
		fillColor = { red = 0, green = 0, blue = 0, alpha = 0.7 },
		roundedRectRadii = { xRadius = 6, yRadius = 6 },
	}, {
		type = "text",
		text = "● auto-click",
		textColor = { red = 1, green = 0.3, blue = 0.3, alpha = 1 },
		textSize = 14,
		textAlignment = "center",
		frame = { x = 0, y = 5, w = 120, h = 22 },
	})
	clickerIndicator:level(hs.canvas.windowLevels.overlay)
	clickerIndicator:show()
end

local function toggleAutoClicker()
	if clickerTimer then
		clickerTimer:stop()
		clickerTimer = nil
		hideClickerIndicator()
		return
	end
	clickerTimer = hs.timer.doEvery(0.01, function()
		hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, hs.mouse.absolutePosition()):post()
		hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, hs.mouse.absolutePosition()):post()
	end)
	showClickerIndicator()
end

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "0", toggleAutoClicker)

-- app hotkeys: cmd+alt+ctrl+1 ghostty, cmd+alt+ctrl+2 default browser
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "1", function()
	hs.application.launchOrFocusByBundleID("com.mitchellh.ghostty")
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "2", function()
	hs.application.launchOrFocusByBundleID(hs.urlevent.getDefaultHandler("http"))
end)
