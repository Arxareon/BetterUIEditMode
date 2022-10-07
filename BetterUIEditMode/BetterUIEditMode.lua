--[[ ADDON INFO ]]

--Addon namespace string & table
local addonNameSpace, ns = ...

--Addon display name
local _, addonTitle = GetAddOnInfo(addonNameSpace)

--Addon root folder
local root = "Interface/AddOns/" .. addonNameSpace .. "/"


--[[ ASSETS & RESOURCES ]]

--WidgetTools reference
local wt = WidgetToolbox[ns.WidgetToolsVersion]

--Strings & Localization
local strings = ns.LoadLocale()
strings.chat.keyword = "/partar"

--Colors
local colors = {
	red = {
		[0] = { r = 1, g = 0.22, b = 0 },
		[1] = { r = 1, g = 0.47, b = 0.33 },
	},
	blue = {
		[0] = { r = 0.27, g = 0.75, b = 1 },
		[1] = { r = 0.51, g = 0.88, b = 1 },
	},
}

--Fonts
local fonts = {
	[0] = { name = strings.misc.default, path = strings.misc.defaultFont },
	-- [1] = { name = "Arbutus Slab", path = root .. "Fonts/ArbutusSlab.ttf" },
	-- [2] = { name = "Caesar Dressing", path = root .. "Fonts/CaesarDressing.ttf" },
	-- [3] = { name = "Germania One", path = root .. "Fonts/GermaniaOne.ttf" },
	-- [4] = { name = "Mitr", path = root .. "Fonts/Mitr.ttf" },
	-- [5] = { name = "Oxanium", path = root .. "Fonts/Oxanium.ttf" },
	-- [6] = { name = "Pattaya", path = root .. "Fonts/Pattaya.ttf" },
	-- [7] = { name = "Reem Kufi", path = root .. "Fonts/ReemKufi.ttf" },
	-- [8] = { name = "Source Code Pro", path = root .. "Fonts/SourceCodePro.ttf" },
	-- [9] = { name = strings.misc.custom, path = root .. "Fonts/CUSTOM.ttf" },
}

--Textures
local textures = {
	logo = root .. "Textures/Logo.tga",
}

--Anchor Points
local anchors = {
	[0] = { name = strings.points.top.left, point = "TOPLEFT" },
	[1] = { name = strings.points.top.center, point = "TOP" },
	[2] = { name = strings.points.top.right, point = "TOPRIGHT" },
	[3] = { name = strings.points.left, point = "LEFT" },
	[4] = { name = strings.points.center, point = "CENTER" },
	[5] = { name = strings.points.right, point = "RIGHT" },
	[6] = { name = strings.points.bottom.left, point = "BOTTOMLEFT" },
	[7] = { name = strings.points.bottom.center, point = "BOTTOM" },
	[8] = { name = strings.points.bottom.right, point = "BOTTOMRIGHT" },
}


--[[ DATA TABLES ]]

--[ Addon DBs ]

--References
local db --Account-wide options
local dbc --Character-specific options
local cs --Cross-session account-wide data

--Default values
local dbDefault = {
	display = {
		position = {
			[0] = {
				point = "TOP",
				offset = { x = -320, y = -120, },
			},
			[1] = {
				point = "TOP",
				offset = { x = -320, y = -140, },
			},
			[2] = {
				point = "TOP",
				offset = { x = -320, y = -160, },
			},
			[3] = {
				point = "TOP",
				offset = { x = -320, y = -180, },
			},
			[4] = {
				point = "TOP",
				offset = { x = -320, y = -200, },
			},
			[5] = {
				point = "TOP",
				offset = { x = -320, y = -220, },
			},
			[6] = {
				point = "TOP",
				offset = { x = -320, y = -240, },
			},
			[7] = {
				point = "TOP",
				offset = { x = -320, y = -260, },
			},
			[8] = {
				point = "TOP",
				offset = { x = -320, y = -280, },
			},
			[9] = {
				point = "TOP",
				offset = { x = -320, y = -300, },
			},
			[10] = {
				point = "TOP",
				offset = { x = -220, y = -120, },
			},
			[11] = {
				point = "TOP",
				offset = { x = -220, y = -140, },
			},
			[12] = {
				point = "TOP",
				offset = { x = -220, y = -160, },
			},
			[13] = {
				point = "TOP",
				offset = { x = -220, y = -180, },
			},
			[14] = {
				point = "TOP",
				offset = { x = -220, y = -200, },
			},
			[15] = {
				point = "TOP",
				offset = { x = -220, y = -220, },
			},
			[16] = {
				point = "TOP",
				offset = { x = -220, y = -240, },
			},
			[17] = {
				point = "TOP",
				offset = { x = -220, y = -260, },
			},
			[18] = {
				point = "TOP",
				offset = { x = -220, y = -280, },
			},
			[19] = {
				point = "TOP",
				offset = { x = -220, y = -300, },
			},
			[20] = {
				point = "TOP",
				offset = { x = -120, y = -120, },
			},
			[21] = {
				point = "TOP",
				offset = { x = -120, y = -140, },
			},
			[22] = {
				point = "TOP",
				offset = { x = -120, y = 160, },
			},
			[23] = {
				point = "TOP",
				offset = { x = -120, y = -180, },
			},
			[24] = {
				point = "TOP",
				offset = { x = -120, y = -200, },
			},
			[25] = {
				point = "TOP",
				offset = { x = -120, y = -220, },
			},
			[26] = {
				point = "TOP",
				offset = { x = -120, y = -240, },
			},
			[27] = {
				point = "TOP",
				offset = { x = -120, y = -260, },
			},
			[28] = {
				point = "TOP",
				offset = { x = -120, y = -280, },
			},
			[29] = {
				point = "TOP",
				offset = { x = -120, y = -300, },
			},
			[30] = {
				point = "TOP",
				offset = { x = -20, y = -120, },
			},
			[31] = {
				point = "TOP",
				offset = { x = -20, y = -140, },
			},
			[32] = {
				point = "TOP",
				offset = { x = -20, y = -160, },
			},
			[33] = {
				point = "TOP",
				offset = { x = -20, y = -180, },
			},
			[34] = {
				point = "TOP",
				offset = { x = -20, y = -200, },
			},
			[35] = {
				point = "TOP",
				offset = { x = -20, y = -220, },
			},
			[36] = {
				point = "TOP",
				offset = { x = -20, y = -240, },
			},
			[37] = {
				point = "TOP",
				offset = { x = -20, y = -260, },
			},
			[38] = {
				point = "TOP",
				offset = { x = -20, y = -280, },
			},
			[39] = {
				point = "TOP",
				offset = { x = -20, y = -300, },
			},
		},
		text = {
			font = {
				family = fonts[0].path,
				size = 11,
				color = { r = 1, g = 1, b = 1, a = 1 },
			},
		},
		background = {
			visible = false,
			size = { width = 116, height = 16, },
			colors = {
				bg = { r = 0, g = 0, b = 0, a = 0.5 },
				border = { r = 1, g = 1, b = 1, a = 0.4 },
			},
		},
		visibility = {
			frameStrata = "HIGH",
		},
	},
}
local dbcDefault = {
	disabled = false,
}


--[[ FRAMES & EVENTS ]]

--[ Main Frame ]

--Creating frame
local partyTargets = CreateFrame("Frame", addonNameSpace, UIParent) --Main addon frame

--Registering events
partyTargets:RegisterEvent("ADDON_LOADED")
partyTargets:RegisterEvent("PLAYER_ENTERING_WORLD")
partyTargets:RegisterEvent("GROUP_ROSTER_UPDATE")

--Event handler
partyTargets:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, ...)
end)


--[[ UTILITIES ]]

---Add coloring escape sequences to a string
---@param text string Text to add coloring to
---@param color table Table containing the color values
--- - **r** number ― Red [Range: 0 - 1]
--- - **g** number ― Green [Range: 0 - 1]
--- - **b** number ― Blue [Range: 0 - 1]
--- - **a**? number *optional* ― Opacity [Range: 0 - 1, Default: 1]
---@return string
local function Color(text, color)
	local r, g, b, a = wt.UnpackColor(color)
	return WrapTextInColorCode(text, wt.ColorToHex(r, g, b, a, true, false))
end

---Find the ID of the font provided
---@param fontPath string
---@return integer
local function GetFontID(fontPath)
	local id = 0
	for i = 0, #fonts do
		if fonts[i].path == fontPath then
			id = i
			break
		end
	end
	return id
end

---Find the ID of the anchor point provided
---@param point AnchorPoint
---@return integer
local function GetAnchorID(point)
	local id = 0
	for i = 0, #anchors do
		if anchors[i].point == point then
			id = i
			break
		end
	end
	return id
end

--[ Target Frames Management ]

--Currently active group type ("party" | "raid")
local groupType = "party"

--Indexed table containing subtables with target frame and text references
local targetFrames = {}

--Update the target info displayed on a target frame
local function UpdateTargetFrame(index)
	local memberID = groupType .. index + 1
	--Update name
	targetFrames[index].text:SetText("|T" .. textures.logo .. ":0|t " .. (UnitName(memberID .. "target") or ""))
	--Update healt bar
	local max = UnitHealthMax(memberID .. "target")
	local healthPercentage = wt.FormatThousands(UnitHealth(memberID .. "target") / (max == 0 and 1 or max))
end

--Show an already existing target frame & enable target checking
local function EnableTargetFrame(index)
	targetFrames[index].frame:Show()
	targetFrames[index].frame:SetScript("OnUpdate", function()
		UpdateTargetFrame(index)
		--Find the true position
		-- for i = 1, GetNumGroupMembers() do
		-- 	if (UnitName(groupType .. index + 1) or "") == UnitName("player") then
		-- 		targetFrames[index].frame:Hide()
		-- 		break
		-- 	-- elseif _G["CompactRaidFrame" .. i .. "Name"]:GetText() == UnitName(groupType .. index + 1) then
		-- 	-- 	targetFrames[index].frame:SetPoint("LEFT", _G["CompactRaidFrame" .. i], "LEFT", 0, 0)
		-- 	-- 	--Stop looking for the true position
		-- 	-- 	targetFrames[index].frame:SetScript("OnUpdate", function() UpdateTargetFrame(index) end)
		-- 	-- 	break
		-- 	end
		-- end
	end)
end

---Create and add a new target Frame & FontString to the targetFrames table
local function CreateTargetFrame()
	--Create the subtable
	local i = targetFrames[0] == nil and 0 or #targetFrames + 1
	targetFrames[i] = {}
	--Create the frame & text
	targetFrames[i].frame = CreateFrame("Frame", partyTargets:GetName() .. "Display".. i + 1, partyTargets, BackdropTemplateMixin and "BackdropTemplate")
	targetFrames[i].text = targetFrames[i].frame:CreateFontString(targetFrames[i].frame:GetName() .. "Text", "OVERLAY")
	targetFrames[i].text:SetFont(fonts[0].path, 11, "THINOUTLINE")
	--Position & dimensions
	targetFrames[i].frame:SetSize(_G["CompactRaidFrame1"]:GetWidth(), 16)
	-- targetFrames[i].frame:SetPoint("TOPLEFT", UIParent, db.display.position[i].point, db.display.position[i].offset.x, db.display.position[i].offset.y)
	-- targetFrames[i].frame:SetPoint("LEFT", _G["CompactRaidFrame" .. i + 1], "LEFT", 0, 0)
	targetFrames[i].text:SetPoint("LEFT")
	--Making the frame moveable
	targetFrames[i].frame:SetMovable(true)
	targetFrames[i].frame:SetScript("OnMouseDown", function()
		if IsShiftKeyDown() and not targetFrames[i].frame.isMoving then
			targetFrames[i].frame:StartMoving()
			targetFrames[i].frame.isMoving = true
		end
	end)
	targetFrames[i].frame:SetScript("OnMouseUp", function()
		if targetFrames[i].frame.isMoving then
			targetFrames[i].frame:StopMovingOrSizing()
			targetFrames[i].frame.isMoving = false
		end
	end)
	--Start checking the targets
	EnableTargetFrame(i)
end

--Update all target frames for the current group setup
local function UpdateTargetFrames()
	local members = GetNumGroupMembers()
	if members > 0 then
		local raidID = UnitInRaid("player")
		groupType = raidID and "raid" or "party"
		--Enable or create target frames
		for i = 0, members - 1 do
			if targetFrames[i] == nil then CreateTargetFrame() else EnableTargetFrame(i) end
			--Update the position
			targetFrames[i].frame:SetPoint("LEFT", _G["CompactRaidFrame" .. i + 1], "LEFT", 0, 0)
		end
		--Disable unneeded target frames
		for i = members, #targetFrames do targetFrames[i].frame:Hide() end
	else
		--Disable all target frames
		for i = 0, #targetFrames do
			if targetFrames[i] == nil then break end
			targetFrames[i].frame:Hide()
		end
	end
end

--[ DB Management ]

--Check the validity of the provided key value pair
local function CheckValidity(k, v)
	if type(v) == "number" then
		--Non-negative
		if k == "size" then return v > 0 end
		--Range constraint: 0 - 1
		if k == "r" or k == "g" or k == "b" or k == "a" or k == "text" or k == "background" then return v >= 0 and v <= 1 end
	end return true
end

---Restore old data to an account-wide and character-specific DB by matching removed items to known old keys
---@param data table
---@param characterData table
---@param recoveredData? table
---@param recoveredCharacterData? table
local function RestoreOldData(data, characterData, recoveredData, recoveredCharacterData)
	-- if recoveredData ~= nil then for k, v in pairs(recoveredData) do
	-- 	if k == "" then data. = v
	-- 	elseif k == "" then data. = v
	-- 	end
	-- end end
	-- if recoveredCharacterData ~= nil then for k, v in pairs(recoveredCharacterData) do
	-- 	if k == "" then characterData. = v
	-- 	elseif k == "" then characterData. = v
	-- 	end
	-- end end
end

---Load the addon databases from the SavedVariables tables specified in the TOC
---@return boolean firstLoad True is returned when the addon SavedVariables tabled didn't exist prior to loading, false otherwise
local function LoadDBs()
	local firstLoad = false
	--First load
	if PartyTargetsDB == nil then
		PartyTargetsDB = wt.Clone(dbDefault)
		firstLoad = true
	end
	if PartyTargetsDBC == nil then PartyTargetsDBC = wt.Clone(dbcDefault) end
	if PartyTargetsCS == nil then PartyTargetsCS = {} end
	--Load the DBs
	db = wt.Clone(PartyTargetsDB) --Account-wide options DB copy
	dbc = wt.Clone(PartyTargetsDBC) --Character-specific options DB copy
	cs = PartyTargetsCS --Cross-session account-wide data direct reference
	--DB checkup & fix
	wt.RemoveEmpty(db, CheckValidity)
	wt.RemoveEmpty(dbc, CheckValidity)
	wt.AddMissing(db, dbDefault)
	wt.AddMissing(dbc, dbcDefault)
	RestoreOldData(db, dbc, wt.RemoveMismatch(db, dbDefault), wt.RemoveMismatch(dbc, dbcDefault))
	--Apply any potential fixes to the SavedVariables DBs
	PartyTargetsDB = wt.Clone(db)
	PartyTargetsDBC = wt.Clone(dbc)
	return firstLoad
end


--[[ INTERFACE OPTIONS ]]

--Options frame references
local options = {
	about = {},
	presets = {},
	position = {},
	visibility = {
		fade = {},
	},
	background = {
		colors = {},
		size = {},
	},
	text = {
		font = {},
	},
	enhancement = {},
	removals = {},
	notifications = {},
	backup = {},
}

--[ Options Widgets ]

--Main page
local function CreateOptionsShortcuts(parentFrame)
	--Button: Advanced page
	wt.CreateButton({
		parent = parentFrame,
		name = "AdvancedPage",
		title = strings.options.advanced.title,
		tooltip = { [0] = { text = strings.options.advanced.description:gsub("#ADDON", addonTitle) }, },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -10, y = -30 }
		},
		width = 120,
		onClick = function() InterfaceOptionsFrame_OpenToCategory(options.advancedOptionsPage) end,
	})
end
local function CreateAboutInfo(parentFrame)
	--Text: Version
	local version = wt.CreateText({
		parent = parentFrame,
		name = "Version",
		position = { offset = { x = 16, y = -33 } },
		width = 84,
		text = strings.options.main.about.version:gsub("#VERSION", WrapTextInColorCode(GetAddOnMetadata(addonNameSpace, "Version"), "FFFFFFFF")),
		justify = "LEFT",
		template = "GameFontNormalSmall",
	})
	--Text: Date
	local date = wt.CreateText({
		parent = parentFrame,
		name = "Date",
		position = {
			relativeTo = version,
			relativePoint = "TOPRIGHT",
			offset = { x = 10, }
		},
		width = 102,
		text = strings.options.main.about.date:gsub(
			"#DATE", WrapTextInColorCode(strings.misc.date:gsub(
				"#DAY", GetAddOnMetadata(addonNameSpace, "X-Day")
			):gsub(
				"#MONTH", GetAddOnMetadata(addonNameSpace, "X-Month")
			):gsub(
				"#YEAR", GetAddOnMetadata(addonNameSpace, "X-Year")
			), "FFFFFFFF")
		),
		template = "GameFontNormalSmall",
		justify = "LEFT",
	})
	--Text: Author
	local author = wt.CreateText({
		parent = parentFrame,
		name = "Author",
		position = {
			relativeTo = date,
			relativePoint = "TOPRIGHT",
			offset = { x = 10, }
		},
		width = 186,
		text = strings.options.main.about.author:gsub("#AUTHOR", WrapTextInColorCode(GetAddOnMetadata(addonNameSpace, "Author"), "FFFFFFFF")),
		template = "GameFontNormalSmall",
		justify = "LEFT",
	})
	--Text: License
	wt.CreateText({
		parent = parentFrame,
		name = "License",
		position = {
			relativeTo = author,
			relativePoint = "TOPRIGHT",
			offset = { x = 10, }
		},
		width = 156,
		text = strings.options.main.about.license:gsub("#LICENSE", WrapTextInColorCode(GetAddOnMetadata(addonNameSpace, "X-License"), "FFFFFFFF")),
		template = "GameFontNormalSmall",
		justify = "LEFT",
	})
	--EditScrollBox: Changelog
	options.about.changelog = wt.CreateEditScrollBox({
		parent = parentFrame,
		name = "Changelog",
		title = strings.options.main.about.changelog.label,
		tooltip = { [0] = { text = strings.options.main.about.changelog.tooltip }, },
		position = {
			relativeTo = version,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -12 }
		},
		size = { width = parentFrame:GetWidth() - 32, height = 139 },
		fontObject = "GameFontDisableSmall",
		text = ns.GetChangelog(),
		readOnly = true,
		scrollSpeed = 45,
	})
end
local function CreateSupportInfo(parentFrame)
	--Copybox: CurseForge
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "CurseForge",
		title = strings.options.main.support.curseForge .. ":",
		position = { offset = { x = 16, y = -33 } },
		width = parentFrame:GetWidth() / 2 - 22,
		text = "curseforge.com/wow/addons/party-targets",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.75, g = 0.95, b = 1, a = 1 },
	})
	--Copybox: Wago
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "Wago",
		title = strings.options.main.support.wago .. ":",
		position = {
			anchor = "TOP",
			offset = { x = (parentFrame:GetWidth() / 2 - 22) / 2 + 8, y = -33 }
		},
		width = parentFrame:GetWidth() / 2 - 22,
		text = "addons.wago.io/addons/party-targets",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.75, g = 0.95, b = 1, a = 1 },
	})
	--Copybox: Repository
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "Repository",
		label = strings.options.main.support.repository .. ":",
		position = { offset = { x = 16, y = -70 } },
		width = parentFrame:GetWidth() / 2 - 22,
		text = "github.com/Arxareon/PartyTargets",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.75, g = 0.95, b = 1, a = 1 },
	})
	--Copybox: Issues
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "Issues",
		title = strings.options.main.support.issues .. ":",
		position = {
			anchor = "TOP",
			offset = { x = (parentFrame:GetWidth() / 2 - 22) / 2 + 8, y = -70 }
		},
		width = parentFrame:GetWidth() / 2 - 22,
		text = "github.com/Arxareon/PartyTargets/issues",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.75, g = 0.95, b = 1, a = 1 },
	})
end
local function CreateMainCategoryPanels(parentFrame) --Add the main page widgets to the category panel frame
	--Shortcuts
	local shortcutsPanel = wt.CreatePanel({
		parent = parentFrame,
		name = "Shortcuts",
		title = strings.options.main.shortcuts.title,
		description = strings.options.main.shortcuts.description:gsub("#ADDON", addonTitle),
		position = { offset = { x = 16, y = -82 } },
		size = { height = 64 },
	})
	CreateOptionsShortcuts(shortcutsPanel)
	--About
	local aboutPanel = wt.CreatePanel({
		parent = parentFrame,
		name = "About",
		title = strings.options.main.about.title,
		description = strings.options.main.about.description:gsub("#ADDON", addonTitle),
		position = {
			relativeTo = shortcutsPanel,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 231 },
	})
	CreateAboutInfo(aboutPanel)
	--Support
	local supportPanel = wt.CreatePanel({
		parent = parentFrame,
		name = "Support",
		title = strings.options.main.support.title,
		description = strings.options.main.support.description:gsub("#ADDON", addonTitle),
		position = {
			relativeTo = aboutPanel,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 111 },
	})
	CreateSupportInfo(supportPanel)
end

--Advanced page
local function CreateOptionsProfiles(parentFrame)
	--TODO: Add profiles handler widgets
end
local function CreateBackupOptions(parentFrame)
	--EditScrollBox & Popup: Import & Export
	local importPopup = wt.CreatePopup({
		addon = addonNameSpace,
		name = "IMPORT",
		text = strings.options.advanced.backup.warning,
		accept = strings.options.advanced.backup.import,
		onAccept = function()
			--Load from string to a temporary table
			local success, t = pcall(loadstring("return " .. wt.ClearFormatting(options.backup.string:GetText())))
			if success and type(t) == "table" then
				--Run DB checkup on the loaded table
				wt.RemoveEmpty(t.account, CheckValidity)
				wt.RemoveEmpty(t.character, CheckValidity)
				wt.AddMissing(t.account, db)
				wt.AddMissing(t.character, dbc)
				RestoreOldData(t.account, t.character, wt.RemoveMismatch(t.account, db), wt.RemoveMismatch(t.character, dbc))
				--Copy values from the loaded DBs to the addon DBs
				wt.CopyValues(t.account, db)
				wt.CopyValues(t.character, dbc)
				--Main display
				-- SetDisplayValues(mainDisplay, mainDisplayText, db, dbc)
				--Update the interface options
				wt.LoadOptionsData(addonNameSpace)
			else print(Color(addonTitle .. ":", colors.red[0]) .. " " .. Color(strings.options.advanced.backup.error, colors.blue[0])) end
		end
	})
	local backupBox
	options.backup.string, backupBox = wt.CreateEditScrollBox({
		parent = parentFrame,
		name = "ImportExport",
		title = strings.options.advanced.backup.backupBox.label,
		tooltip = {
			[0] = { text = strings.options.advanced.backup.backupBox.tooltip[0] },
			[1] = { text = strings.options.advanced.backup.backupBox.tooltip[1] },
			[2] = { text = "\n" .. strings.options.advanced.backup.backupBox.tooltip[2]:gsub("#ENTER", strings.keys.enter) },
			[3] = { text = strings.options.advanced.backup.backupBox.tooltip[3], color = { r = 0.89, g = 0.65, b = 0.40 } },
			[4] = { text = "\n" .. strings.options.advanced.backup.backupBox.tooltip[4], color = { r = 0.92, g = 0.34, b = 0.23 } },
		},
		position = { offset = { x = 16, y = -30 } },
		size = { width = parentFrame:GetWidth() - 32, height = 276 },
		maxLetters = 5400,
		fontObject = "GameFontWhiteSmall",
		scrollSpeed = 60,
		onEnterPressed = function() StaticPopup_Show(importPopup) end,
		onEscapePressed = function(self) self:SetText(wt.TableToString({ account = db, character = dbc }, options.backup.compact:GetChecked(), true)) end,
		optionsData = {
			optionsKey = addonNameSpace,
			onLoad = function(self) self:SetText(wt.TableToString({ account = db, character = dbc }, options.backup.compact:GetChecked(), true)) end,
		}
	})
	--Checkbox: Compact
	options.backup.compact = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Compact",
		title = strings.options.advanced.backup.compact.label,
		tooltip = { [0] = { text = strings.options.advanced.backup.compact.tooltip }, },
		position = {
			relativeTo = backupBox,
			relativePoint = "BOTTOMLEFT",
			offset = { x = -8, y = -13 }
		},
		onClick = function(self)
			options.backup.string:SetText(wt.TableToString({ account = db, character = dbc }, self:GetChecked(), true))
			--Set focus after text change to set the scroll to the top and refresh the position character counter
			options.backup.string:SetFocus()
			options.backup.string:ClearFocus()
		end,
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = cs,
			storageKey = "compactBackup",
		},
	})
	--Button: Load
	local load = wt.CreateButton({
		parent = parentFrame,
		name = "Load",
		title = strings.options.advanced.backup.load.label,
		tooltip = { [0] = { text = strings.options.advanced.backup.load.tooltip }, },
		position = {
			anchor = "TOPRIGHT",
			relativeTo = backupBox,
			relativePoint = "BOTTOMRIGHT",
			offset = { x = 6, y = -13 }
		},
		width = 80,
		onClick = function() StaticPopup_Show(importPopup) end,
	})
	--Button: Reset
	wt.CreateButton({
		parent = parentFrame,
		name = "Reset",
		title = strings.options.advanced.backup.reset.label,
		tooltip = { [0] = { text = strings.options.advanced.backup.reset.tooltip }, },
		position = {
			anchor = "TOPRIGHT",
			relativeTo = load,
			relativePoint = "TOPLEFT",
			offset = { x = -10, }
		},
		width = 80,
		onClick = function()
			options.backup.string:SetText("") --Remove text to make sure OnTextChanged will get called
			options.backup.string:SetText(wt.TableToString({ account = db, character = dbc }, options.backup.compact:GetChecked(), true))
			--Set focus after text change to set the scroll to the top and refresh the position character counter
			options.backup.string:SetFocus()
			options.backup.string:ClearFocus()
		end,
	})
end
local function CreateAdvancedCategoryPanels(parentFrame) --Add the advanced page widgets to the category panel frame
	--Profiles
	local profilesPanel = wt.CreatePanel({
		parent = parentFrame,
		name = "Profiles",
		title = strings.options.advanced.profiles.title,
		description = strings.options.advanced.profiles.description:gsub("#ADDON", addonTitle),
		position = { offset = { x = 16, y = -82 } },
		size = { height = 64 },
	})
	CreateOptionsProfiles(profilesPanel)
	---Backup
	local backupOptions = wt.CreatePanel({
		parent = parentFrame,
		name = "Backup",
		title = strings.options.advanced.backup.title,
		description = strings.options.advanced.backup.description:gsub("#ADDON", addonTitle),
		position = {
			relativeTo = profilesPanel,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -32 }
		},
		size = { height = 374 },
	})
	CreateBackupOptions(backupOptions)
end

--[ Options Category Panels ]

--Save the pending changes
local function SaveOptions()
	--Update the SavedVariabes DBs
	PartyTargetsDB = wt.Clone(db)
	PartyTargetsDBC = wt.Clone(dbc)
end
--Cancel all potential changes made in all option categories
local function CancelChanges()
	LoadDBs()
end
--Restore all the settings under the main option category to their default values
local function DefaultOptions()
	--Reset the DBs
	PartyTargetsDB = wt.Clone(dbDefault)
	PartyTargetsDBC = wt.Clone(dbcDefault)
	wt.CopyValues(dbDefault, db)
	wt.CopyValues(dbcDefault, dbc)
	--Update the interface options
	wt.LoadOptionsData(addonNameSpace)
	--Notification
	print(Color(addonTitle .. ":", colors.red[0]) .. " " .. Color(strings.options.defaults, colors.blue[0]))
end

--Create and add the options category panel frames to the WoW Interface Options
local function LoadInterfaceOptions()
	--Main options panel
	options.mainOptionsPage = wt.CreateOptionsPanel({
		addon = addonNameSpace,
		name = "Main",
		description = strings.options.main.description:gsub("#ADDON", addonTitle):gsub("#KEYWORD", strings.chat.keyword),
		logo = textures.logo,
		titleLogo = true,
		okay = SaveOptions,
		cancel = CancelChanges,
		default = DefaultOptions,
		optionsKey = addonNameSpace,
	})
	CreateMainCategoryPanels(options.mainOptionsPage) --Add categories & GUI elements to the panel
	--Advanced options panel
	options.advancedOptionsPage = wt.CreateOptionsPanel({
		parent = options.mainOptionsPage.name,
		addon = addonNameSpace,
		name = "Advanced",
		title = strings.options.advanced.title,
		description = strings.options.advanced.description:gsub("#ADDON", addonTitle),
		logo = textures.logo,
		default = DefaultOptions,
	})
	CreateAdvancedCategoryPanels(options.advancedOptionsPage) --Add categories & GUI elements to the panel
end


--[[ CHAT CONTROL ]]

--[ Chat Utilities ]

---Print visibility info
---@param load boolean [Default: false]
local function PrintStatus(load)
	if load == true and not db.statusNotice then return end
	print(Color(partyTargets:IsVisible() and strings.chat.status.enabled:gsub(
		"#ADDON", Color(addonTitle, colors.red[0])
	) or strings.chat.status.disabled:gsub(
		"#ADDON", Color(addonTitle, colors.red[0])
	), colors.blue[0]))
end
--Print help info
local function PrintInfo()
	print(Color(strings.chat.help.thanks:gsub("#ADDON", Color(addonTitle, colors.red[0])), colors.blue[0]))
	PrintStatus()
	print(Color(strings.chat.help.hint:gsub( "#HELP_COMMAND", Color(strings.chat.keyword .. " " .. strings.chat.help.command, colors.red[1])), colors.blue[1]))
	print(Color(strings.chat.help.move:gsub("#SHIFT", Color(strings.keys.shift, colors.red[1])):gsub("#ADDON", addonTitle), colors.blue[1]))
end
--Print the command list with basic functionality info
local function PrintCommands()
	print(Color(addonTitle, colors.red[0]) .. " ".. Color(strings.chat.help.list .. ":", colors.blue[0]))
	--Index the commands (skipping the help command) and put replacement code segments in place
	local commands = {
		[0] = {
			command = strings.chat.options.command,
			description = strings.chat.options.description:gsub("#ADDON", addonTitle)
		},
		[1] = {
			command = strings.chat.toggle.command,
			description = strings.chat.toggle.description:gsub("#ADDON", addonTitle):gsub(
				"#STATE", Color(dbc.disabled and strings.misc.disabled or strings.misc.enabled, colors.red[1])
			)
		},
	}
	--Print the list
	for i = 0, #commands do
		print("    " .. Color(strings.chat.keyword .. " " .. commands[i].command, colors.red[1]) .. Color(" - " .. commands[i].description, colors.blue[1]))
	end
end

--[ Slash Command Handlers ]

local function ToggleCommand()
	dbc.disabled = not dbc.disabled
	wt.SetVisibility(partyTargets, not dbc.disabled)
	--Response
	print(Color(dbc.disabled and strings.chat.toggle.disabled:gsub(
			"#ADDON", Color(addonTitle, colors.red[0])
		) or strings.chat.toggle.enabled:gsub(
			"#ADDON", Color(addonTitle, colors.red[0])
		), colors.blue[0]))
	--Update in the SavedVariabes DB
	PartyTargetsDBC.disabled = dbc.disabled
end

SLASH_PARTAR1 = strings.chat.keyword
function SlashCmdList.PARTAR(line)
	local command, parameter = strsplit(" ", line)
	if command == strings.chat.help.command then
		PrintCommands()
	elseif command == strings.chat.options.command then
		InterfaceOptionsFrame_OpenToCategory(options.mainOptionsPage)
		InterfaceOptionsFrame_OpenToCategory(options.mainOptionsPage) --Load twice to make sure the proper page and category is loaded
	elseif command == strings.chat.toggle.command then
		ToggleCommand()
	else
		PrintInfo()
	end
end


--[[ INITIALIZATION ]]

--[ Target Display Setup ]

--Set frame parameters
local function SetUpMainDisplayFrame()
	--Main frame
	partyTargets:SetToplevel(true)
	partyTargets:SetSize(16, 16)
	partyTargets:SetPoint("TOPLEFT", 2, -2)
	local logo = wt.CreateTexture({
		parent = partyTargets,
		name = "Icon",
		path = textures.logo,
		position = { anchor = "CENTER", },
		size = { width = 16, height = 16 },
	})
	logo:SetAlpha(0.6)
end

--[ Loading ]

function partyTargets:ADDON_LOADED(name)
	if name ~= addonNameSpace then return end
	partyTargets:UnregisterEvent("ADDON_LOADED")
	--Load & check the DBs
	if LoadDBs() then PrintInfo() end
	--Create cross-session character-specific variables
	if cs.compactBackup == nil then cs.compactBackup = true end
	--Set up the interface options
	LoadInterfaceOptions()
end
function partyTargets:PLAYER_ENTERING_WORLD()
	--Set up the main frame & text
	SetUpMainDisplayFrame()
	--Set state
	wt.SetVisibility(partyTargets, not dbc.disabled)
	--Visibility notice
	if not partyTargets:IsVisible() then PrintStatus(true) end
	--Update target frames
	UpdateTargetFrames()
end