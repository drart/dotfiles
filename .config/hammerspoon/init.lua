hs.loadSpoon("Cherry")


-- hs.hotkey.bind({}, "F18", function()
--     print("hello world");
--     hs.alert.show("hello world")
--     -- hs.application.launchOrFocus("Safari")
--     spoon.HSKeybindings:show()
-- end)
--
--
hs.loadSpoon("Hammerflow")

spoon.Hammerflow.registerFormat({
	fillColor = { alpha = .875, hex = "282b36" },
	padding = 18,
	radius = 12,
	strokeColor = { alpha = .875, hex = "f1fa8b" },
	textColor = { alpha = 1, hex = "bd93f9" },
	textStyle = {
		paragraphStyle = { lineSpacing = 6 },
		shadow = { offset = { h = -1, w = 1 }, blurRadius = 10, color = { alpha = .50, white = 0 } }
	},
	strokeWidth = 6,
	textFont = "Monaco",
	textSize = 18,
})

spoon.Hammerflow.loadFirstValidTomlFile({
    "flow.toml"
    -- "Spoons/Hammerflow.spoon/sample.tom 
})

require("confetti")
