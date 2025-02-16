local spaces = require("hs.spaces") -- https://github.com/asmagill/hs._asm.spaces

-- Switch ghostty
hs.hotkey.bind({ "ctrl" }, "`", function()
	local BUNDLE_ID = "com.mitchellh.ghostty" -- more accurate to avoid mismatching on browser titles
	function moveWindow(ghostty, space, mainScreen)
		-- move to main space
		local win = nil
		while win == nil do
			win = ghostty:mainWindow()
		end
		print("win=" .. tostring(win))
		print("space=" .. tostring(space))
		print("screen=" .. tostring(win:screen()))
		print("mainScr=" .. tostring(mainScreen))
		if win:isFullScreen() then
			hs.eventtap.keyStroke("cmd", "return", 0, ghostty)
		end
		winFrame = win:frame()
		scrFrame = mainScreen:fullFrame()
		winFrame.w = scrFrame.w
		winFrame.y = scrFrame.y
		winFrame.x = scrFrame.x
		print("winFrame=" .. tostring(winFrame))
		win:setFrame(winFrame, 0)
		print("win:frame=" .. tostring(win:frame()))
		spaces.moveWindowToSpace(win, space)
		if win:isFullScreen() then
			hs.eventtap.keyStroke("cmd", "return", 0, ghostty)
		end
		win:focus()
	end
	local ghostty = hs.application.get(BUNDLE_ID)
	if ghostty ~= nil and ghostty:isFrontmost() then
		ghostty:hide()
	else
		local space = spaces.activeSpaceOnScreen()
		local mainScreen = hs.screen.mainScreen()
		if ghostty == nil and hs.application.launchOrFocusByBundleID(BUNDLE_ID) then
			local appWatcher = nil
			print("create app watcher")
			appWatcher = hs.application.watcher.new(function(name, event, app)
				print("name=" .. name)
				print("event=" .. event)
				if event == hs.application.watcher.launched and app:bundleID() == BUNDLE_ID then
					app:hide()
					moveWindow(app, space, mainScreen)
					print("stop watcher")
					appWatcher:stop()
				end
			end)
			print("start watcher")
			appWatcher:start()
		end
		if ghostty ~= nil then
			moveWindow(ghostty, space, mainScreen)
		end
	end
end)
