--[[ ADDON INFO ]]

--Addon namespace string & table
local addonNameSpace, ns = ...

--Addon display name
local _, addonTitle = GetAddOnInfo(addonNameSpace)

--Addon root folder
local root = "Interface/AddOns/" .. addonNameSpace .. "/"


--[[ WIDGET TOOLS ]]

---@class WidgetToolbox
local wt = ns.WidgetToolbox


--[[ DATA TABLES ]]

--[ Addon DBs ]

--References
local db --Account-wide options
local dbc --Character-specific options
local cs --Cross-session account-wide data

--Default values
local dbDefault = {
	frames = {
		[0] = {
			name = "MainMenuBar",
			title = "Main Action Bar (|cFFFF0000EXPERIMENTAL!|r)",
			modify = false,
			dock = false,
			extend = false,
			scrollRight = false,
		},
		[1] = {
			name = "StatusTrackingBarManager",
			title = "Status Bars (EXP, Rep)",
			modify = false,
			move = {
				position = {
					anchor = "BOTTOM",
					offset = { x = 0, y = 0, },
				},
				movable = false,
				modifier = true,
			},
		},
		[2] = {
			name = "MainMenuBarBackpackButton",
			title = "Bag Buttons",
			modify = false,
			move = {
				position = {
					anchor = "TOPRIGHT",
					relativeTo = "MicroButtonAndBagsBar",
					relativePoint = "TOPRIGHT",
					offset = { x = -4, y = 2, },
				},
				movable = false,
				modifier = true,
			},
		},
		[3] = {
			name = "MicroButtonAndBagsBar",
			title = "Main Menu Buttons",
			modify = false,
			move = {
				position = {
					anchor = "BOTTOMRIGHT",
					offset = { x = 0, y = 0, },
				},
				movable = false,
				modifier = true,
			},
		},
		[4] = {
			name = "QueueStatusButton",
			title = "Group Finder Eye",
			modify = false,
			move = {
				position = {
					anchor = "BOTTOMLEFT",
					relativeTo = "MicroButtonAndBagsBar",
					relativePoint = "BOTTOMLEFT",
					offset = { x = -45, y = 4, },
				},
				movable = false,
				modifier = true,
				rule = function()
					if not db.frames[5].modify then wt.SetPosition(FramerateText, {
						anchor = "BOTTOMRIGHT",
						relativeTo = QueueStatusButton:IsVisible() and QueueStatusButton or "MicroButtonAndBagsBar",
						relativePoint = "BOTTOMLEFT",
						offset = { x = -5, y = 5, },
					}) end
					QueueStatusButton:HookScript("OnShow", function() if db.frames[4].modify and not db.frames[5].modify then wt.SetPosition(FramerateText, {
						anchor = "BOTTOMRIGHT",
						relativeTo = "MicroButtonAndBagsBar",
						relativePoint = "BOTTOMLEFT",
						offset = { x = -5, y = 5, },
					}) end end)
				end
			},
		},
		[5] = {
			name = "FramerateText",
			title = "FPS Counter",
			modify = false,
			move = {
				position = {
					anchor = "BOTTOMRIGHT",
					relativeTo = "MicroButtonAndBagsBar",
					relativePoint = "BOTTOMLEFT",
					offset = { x = -5, y = 5, },
				},
				rule = function()
					if not db.frames[5].modify and QueueStatusButton:IsVisible() then wt.SetPosition(FramerateText, {
						anchor = "BOTTOMRIGHT",
						relativeTo = "QueueStatusButton",
						relativePoint = "BOTTOMLEFT",
						offset = { x = -5, y = 5, },
					}) end
					QueueStatusButton:HookScript("OnShow", function() if db.frames[5].modify then wt.SetPosition(FramerateText, db.frames[5].move.position) end end)
					QueueStatusButton:HookScript("OnHide", function() if db.frames[5].modify then wt.SetPosition(FramerateText, db.frames[5].move.position) end end)
				end
			},
		},
		[6] = {
			name = "GameTimeFrame",
			title = "Calendar Button",
			modify = false,
			move = {
				position = {
					anchor = "TOPLEFT",
					relativeTo = "MinimapCluster.BorderTop",
					relativePoint = "TOPRIGHT",
					offset = { x = 1, y = 0, },
				},
				movable = false,
				modifier = true,
			},
		},
	}
}
local dbcDefault = {
	disabled = false,
}


--[[ FRAMES & EVENTS ]]

--[ Better UI Edit Mode Options ]

--Creating frames
local bui = CreateFrame("Frame", addonNameSpace, EditModeManagerFrame)

--Registering events
bui:RegisterEvent("ADDON_LOADED")

--Event handler
bui:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, ...)
end)


--[[ UTILITIES ]]

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
	if BetterUIEditModeDB == nil then
		BetterUIEditModeDB = wt.Clone(dbDefault)
		firstLoad = true
	end
	if BetterUIEditModeDBC == nil then BetterUIEditModeDBC = wt.Clone(dbcDefault) end
	if BetterUIEditModeCS == nil then BetterUIEditModeCS = {} end
	--Load the DBs
	db = wt.Clone(BetterUIEditModeDB) --Account-wide options DB copy
	dbc = wt.Clone(BetterUIEditModeDBC) --Character-specific options DB copy
	cs = BetterUIEditModeCS --Cross-session account-wide data direct reference
	--DB checkup & fix
	wt.RemoveEmpty(db, CheckValidity)
	wt.RemoveEmpty(dbc, CheckValidity)
	wt.AddMissing(db, dbDefault)
	wt.AddMissing(dbc, dbcDefault)
	RestoreOldData(db, dbc, wt.RemoveMismatch(db, dbDefault), wt.RemoveMismatch(dbc, dbcDefault))
	--Apply any potential fixes to the SavedVariables DBs
	BetterUIEditModeDB = wt.Clone(db)
	BetterUIEditModeDBC = wt.Clone(dbc)
	--Initialize cross-session variables
	cs.compactBackup = cs.compactBackup or true
	return firstLoad
end

--[ Action Bar Handling ]

local actionBar = nil

---Update the position and size of the extender action bar elements
---@param extensionBar Frame Reference to the extra action bar the Main Menu Bar is extended with
local function UpdateBarExtension(extensionBar)
	--Integrate the extension bar
	extensionBar:Show()
	extensionBar:SetPoint("BOTTOMRIGHT", actionBar, "BOTTOMRIGHT", 0, 0)
	--Resize the action bar
	actionBar:SetSize(MainMenuBar:GetWidth() + extensionBar:GetWidth() + MainMenuBar.buttonPadding, ActionButton1:GetHeight())
	--Resize the bar art
	MainMenuBar.BorderArt.BottomEdge:SetWidth(actionBar:GetWidth() - 26)
	MainMenuBar.BorderArt.TopEdge:SetWidth(actionBar:GetWidth() - 26)
	MainMenuBar.BorderArt.RightEdge:SetHeight(MainMenuBar.BorderArt.LeftEdge:GetHeight())
end

--Update the positions of the action bar based on the status bars
local function UpdateBarDock()
	--Reposition the action bar
	if StatusTrackingBarManager.TopBarFrameTexture:IsVisible() then
		actionBar:SetPoint("BOTTOM", StatusTrackingBarManager, "TOP", 0, -1)
	elseif StatusTrackingBarManager.BottomBarFrameTexture:IsVisible() then
		actionBar:SetPoint("BOTTOM", StatusTrackingBarManager, "TOP", 0, -14)
	else
		actionBar:SetPoint("BOTTOM", 0, 15)
	end
end

---Turn on the continuous update of the action bar elements
---@param dock boolean Whether to dock the action bar with the Status Tracking Bar Manager
---@param extend boolean Whether to extend the Main Menu Bar with another action bar
---@param extensionBar Frame Reference to the extra action bar to extend the Main Menu Bar with
local function StartBarUpdates(dock, extend, extensionBar)
	--Set the action bar holder
	if not actionBar then
		actionBar = CreateFrame("Frame", addonNameSpace .. "ActionBar", UIParent)
		actionBar:SetPoint(MainMenuBar:GetPoint())
		actionBar:SetSize(MainMenuBar:GetSize())
	end
	--Move the bar art
	if extend then if MainMenuBar.EndCaps:IsVisible() then
		MainMenuBar.EndCaps.RightEndCap:SetPoint("BOTTOMLEFT", actionBar, "BOTTOMRIGHT", -8, -22)
		MainMenuBar.BorderArt.TopEdge:SetPoint("TOP", actionBar, "TOP", 0, 4)
		MainMenuBar.BorderArt.TopEdge:SetPoint("TOP", actionBar, "TOP", 0, 4)
		MainMenuBar.BorderArt.BottomEdge:SetPoint("BOTTOM", actionBar, "BOTTOM", 0, -7)
		MainMenuBar.BorderArt.RightEdge:SetPoint("RIGHT", actionBar, "RIGHT", 9, 2)
		MainMenuBar.BorderArt.TopRightCorner:SetPoint("TOPRIGHT", actionBar, "TOPRIGHT", 9, 4)
		MainMenuBar.BorderArt.BottomRightCorner:SetPoint("BOTTOMRIGHT", actionBar, "BOTTOMRIGHT", 9, -7)
	end end
	--Dock the Status Tracking Bar Manager
	if dock then StatusTrackingBarManager:SetPoint("BOTTOM", 0, -4) end
	--Start action bar updates
	if dock and extend then actionBar:SetScript("OnUpdate", function()
		UpdateBarExtension(extensionBar)
		UpdateBarDock()
		MainMenuBar:SetPoint("BOTTOMLEFT", actionBar, "BOTTOMLEFT", 0, 0)
	end)
	elseif dock then actionBar:SetScript("OnUpdate", function()
		UpdateBarDock()
		MainMenuBar:SetPoint("BOTTOMLEFT", actionBar, "BOTTOMLEFT", 0, 0)
	end)
	elseif extend then actionBar:SetScript("OnUpdate", function()
		UpdateBarExtension(extensionBar)
		MainMenuBar:SetPoint("BOTTOMLEFT", actionBar, "BOTTOMLEFT", 0, 0)
	end) end
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
		title = ns.strings.options.advanced.title,
		tooltip = { lines = {
			[0] = { text = ns.strings.options.advanced.description:gsub("#ADDON", addonTitle), },
			[1] = { text = ns.strings.temp.dfOpenSettings:gsub("#ADDON", addonTitle), color = { r = 1, g = 0.24, b = 0.13 } }
		} },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -10, y = -30 }
		},
		size = { width = 120, },
		events = { OnClick = function() options.advancedOptions.open() end, },
		disabled = true,
	})
end
local function CreateAboutInfo(parentFrame)
	--Text: Version
	local version = wt.CreateText({
		parent = parentFrame,
		name = "Version",
		position = { offset = { x = 16, y = -33 } },
		width = 84,
		text = ns.strings.options.main.about.version:gsub("#VERSION", WrapTextInColorCode(GetAddOnMetadata(addonNameSpace, "Version"), "FFFFFFFF")),
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
		text = ns.strings.options.main.about.date:gsub(
			"#DATE", WrapTextInColorCode(ns.strings.misc.date:gsub(
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
		text = ns.strings.options.main.about.author:gsub("#AUTHOR", WrapTextInColorCode(GetAddOnMetadata(addonNameSpace, "Author"), "FFFFFFFF")),
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
		text = ns.strings.options.main.about.license:gsub("#LICENSE", WrapTextInColorCode(GetAddOnMetadata(addonNameSpace, "X-License"), "FFFFFFFF")),
		template = "GameFontNormalSmall",
		justify = "LEFT",
	})
	--EditScrollBox: Changelog
	options.about.changelog = wt.CreateEditScrollBox({
		parent = parentFrame,
		name = "Changelog",
		title = ns.strings.options.main.about.changelog.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.main.about.changelog.tooltip, }, } },
		position = {
			relativeTo = version,
			relativePoint = "BOTTOMLEFT",
			offset = { y = -12 }
		},
		size = { width = parentFrame:GetWidth() - 32, height = 139 },
		font = "GameFontDisableSmall",
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
		title = ns.strings.options.main.support.curseForge .. ":",
		position = { offset = { x = 16, y = -33 } },
		width = parentFrame:GetWidth() / 2 - 22,
		text = "curseforge.com/wow/addons/party-targets",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})
	--Copybox: Wago
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "Wago",
		title = ns.strings.options.main.support.wago .. ":",
		position = {
			anchor = "TOP",
			offset = { x = (parentFrame:GetWidth() / 2 - 22) / 2 + 8, y = -33 }
		},
		width = parentFrame:GetWidth() / 2 - 22,
		text = "addons.wago.io/addons/party-targets",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})
	--Copybox: Repository
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "Repository",
		title = ns.strings.options.main.support.repository .. ":",
		position = { offset = { x = 16, y = -70 } },
		width = parentFrame:GetWidth() / 2 - 22,
		text = "github.com/Arxareon/BetterUIEditMode",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})
	--Copybox: Issues
	wt.CreateCopyBox({
		parent = parentFrame,
		name = "Issues",
		title = ns.strings.options.main.support.issues .. ":",
		position = {
			anchor = "TOP",
			offset = { x = (parentFrame:GetWidth() / 2 - 22) / 2 + 8, y = -70 }
		},
		width = parentFrame:GetWidth() / 2 - 22,
		text = "github.com/Arxareon/BetterUIEditMode/issues",
		template = "GameFontNormalSmall",
		color = { r = 0.6, g = 0.8, b = 1, a = 1 },
		colorOnMouse = { r = 0.8, g = 0.95, b = 1, a = 1 },
	})
end
local function CreateMainCategoryPanels(parentFrame) --Add the main page widgets to the category panel frame
	--Shortcuts
	local shortcutsPanel = wt.CreatePanel({
		parent = parentFrame,
		name = "Shortcuts",
		title = ns.strings.options.main.shortcuts.title,
		description = ns.strings.options.main.shortcuts.description:gsub("#ADDON", addonTitle),
		position = { offset = { x = 10, y = -82 } },
		size = { height = 64 },
	})
	CreateOptionsShortcuts(shortcutsPanel)
	--About
	local aboutPanel = wt.CreatePanel({
		parent = parentFrame,
		name = "About",
		title = ns.strings.options.main.about.title,
		description = ns.strings.options.main.about.description:gsub("#ADDON", addonTitle),
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
		title = ns.strings.options.main.support.title,
		description = ns.strings.options.main.support.description,
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
		text = ns.strings.options.advanced.backup.warning,
		accept = ns.strings.options.advanced.backup.import,
		onAccept = function()
			--Load from string to a temporary table
			local success, t = pcall(loadstring("return " .. wt.Clear(options.backup.string:GetText())))
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
				--Update the interface options
				wt.LoadOptionsData(addonNameSpace)
			else print(wt.Color(addonTitle .. ":", ns.colors.yellow[0]) .. " " .. wt.Color(ns.strings.options.advanced.backup.error, ns.colors.blue[0])) end
		end
	})
	local backupBox
	options.backup.string, backupBox = wt.CreateEditScrollBox({
		parent = parentFrame,
		name = "ImportExport",
		title = ns.strings.options.advanced.backup.backupBox.label,
		tooltip = {
			[0] = { text = ns.strings.options.advanced.backup.backupBox.tooltip[0], },
			[1] = { text = ns.strings.options.advanced.backup.backupBox.tooltip[1], },
			[2] = { text = "\n" .. ns.strings.options.advanced.backup.backupBox.tooltip[2]:gsub("#ENTER", ns.strings.keys.enter), },
			[3] = { text = ns.strings.options.advanced.backup.backupBox.tooltip[3], color = { r = 0.89, g = 0.65, b = 0.40 }, },
			[4] = { text = "\n" .. ns.strings.options.advanced.backup.backupBox.tooltip[4], color = { r = 0.92, g = 0.34, b = 0.23 }, },
		},
		position = { offset = { x = 16, y = -30 } },
		size = { width = parentFrame:GetWidth() - 32, height = 276 },
		font = "GameFontWhiteSmall",
		maxLetters = 5400,
		scrollSpeed = 60,
		events = {
			OnEnterPressed = function() StaticPopup_Show(importPopup) end,
			OnEscapePressed = function(self) self:SetText(wt.TableToString({ account = db, character = dbc }, options.backup.compact:GetChecked(), true)) end,
		},
		optionsData = {
			optionsKey = addonNameSpace,
			onLoad = function(self) self:SetText(wt.TableToString({ account = db, character = dbc }, options.backup.compact:GetChecked(), true)) end,
		}
	})
	--Checkbox: Compact
	options.backup.compact = wt.CreateCheckbox({
		parent = parentFrame,
		name = "Compact",
		title = ns.strings.options.advanced.backup.compact.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.advanced.backup.compact.tooltip, }, } },
		position = {
			relativeTo = backupBox,
			relativePoint = "BOTTOMLEFT",
			offset = { x = -8, y = -13 }
		},
		events = { OnClick = function(_, state)
			options.backup.string:SetText(wt.TableToString({ account = db, character = dbc }, state, true))
			--Set focus after text change to set the scroll to the top and refresh the position character counter
			options.backup.string:SetFocus()
			options.backup.string:ClearFocus()
		end, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = cs,
			storageKey = "compactBackup",
		}
	})
	--Button: Load
	local load = wt.CreateButton({
		parent = parentFrame,
		name = "Load",
		title = ns.strings.options.advanced.backup.load.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.advanced.backup.load.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			relativeTo = backupBox,
			relativePoint = "BOTTOMRIGHT",
			offset = { x = 6, y = -13 }
		},
		events = { OnClick = function() StaticPopup_Show(importPopup) end, },
	})
	--Button: Reset
	wt.CreateButton({
		parent = parentFrame,
		name = "Reset",
		title = ns.strings.options.advanced.backup.reset.label,
		tooltip = { lines = { [0] = { text = ns.strings.options.advanced.backup.reset.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			relativeTo = load,
			relativePoint = "TOPLEFT",
			offset = { x = -10, }
		},
		events = { OnClick = function()
			options.backup.string:SetText(wt.TableToString({ account = db, character = dbc }, options.backup.compact:GetChecked(), true))
			--Set focus after text change to set the scroll to the top and refresh the position character counter
			options.backup.string:SetFocus()
			options.backup.string:ClearFocus()
		end, },
	})
end
local function CreateAdvancedCategoryPanels(parentFrame) --Add the advanced page widgets to the category panel frame
	--Profiles
	local profilesPanel = wt.CreatePanel({
		parent = parentFrame,
		name = "Profiles",
		title = ns.strings.options.advanced.profiles.title,
		description = ns.strings.options.advanced.profiles.description:gsub("#ADDON", addonTitle),
		position = { offset = { x = 10, y = -82 } },
		size = { height = 64 },
	})
	CreateOptionsProfiles(profilesPanel)
	---Backup
	local backupOptions = wt.CreatePanel({
		parent = parentFrame,
		name = "Backup",
		title = ns.strings.options.advanced.backup.title,
		description = ns.strings.options.advanced.backup.description:gsub("#ADDON", addonTitle),
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
	BetterUIEditModeDB = wt.Clone(db)
	BetterUIEditModeDBC = wt.Clone(dbc)
end
--Cancel all potential changes made in all option categories
local function CancelChanges()
	LoadDBs()
end
--Restore all the settings under the main option category to their default values
local function DefaultOptions()
	--Reset the DBs
	BetterUIEditModeDB = wt.Clone(dbDefault)
	BetterUIEditModeDBC = wt.Clone(dbcDefault)
	wt.CopyValues(dbDefault, db)
	wt.CopyValues(dbcDefault, dbc)
	--Update the interface options
	wt.LoadOptionsData(addonNameSpace)
	--Notification
	print(wt.Color(addonTitle .. ":", ns.colors.yellow[0]) .. " " .. wt.Color(ns.strings.options.defaults, ns.colors.blue[0]))
end

--Create and add the options category panel frames to the WoW Interface Options
local function LoadInterfaceOptions()
	--Main options panel
	options.mainOptions = wt.CreateOptionsCategory({
		addon = addonNameSpace,
		name = "Main",
		description = ns.strings.options.main.description:gsub("#ADDON", addonTitle):gsub("#KEYWORD", ns.strings.chat.keyword),
		logo = ns.textures.logo,
		titleLogo = true,
		save = SaveOptions,
		cancel = CancelChanges,
		default = DefaultOptions,
		optionsKey = addonNameSpace,
		autoSave = false,
		autoLoad = false,
	})
	CreateMainCategoryPanels(options.mainOptions.canvas) --Add categories & GUI elements to the panel
	--Advanced options panel
	options.advancedOptions = wt.CreateOptionsCategory({
		parent = options.mainOptions.category,
		addon = addonNameSpace,
		name = "Advanced",
		title = ns.strings.options.advanced.title,
		description = ns.strings.options.advanced.description:gsub("#ADDON", addonTitle),
		logo = ns.textures.logo,
		save = SaveOptions,
		cancel = CancelChanges,
		default = DefaultOptions,
		optionsKey = addonNameSpace,
		autoSave = false,
		autoLoad = false,
	})
	CreateAdvancedCategoryPanels(options.advancedOptions.canvas) --Add categories & GUI elements to the panel
end


--[[ CHAT CONTROL ]]

--[ Chat Utilities ]

---Print visibility info
---@param load boolean [Default: false]
local function PrintStatus(load)
	if load == true and not db.statusNotice then return end
	print(wt.Color(bui:IsVisible() and ns.strings.chat.status.enabled:gsub(
		"#ADDON", wt.Color(addonTitle, ns.colors.yellow[0])
	) or ns.strings.chat.status.disabled:gsub(
		"#ADDON", wt.Color(addonTitle, ns.colors.yellow[0])
	), ns.colors.blue[0]))
end
--Print help info
local function PrintInfo()
	-- print(wt.Color(strings.chat.help.thanks:gsub("#ADDON", wt.Color(addonTitle, colors.yellow[0])), colors.blue[0]))
	-- PrintStatus()
	-- print(wt.Color(strings.chat.help.hint:gsub( "#HELP_COMMAND", wt.Color(strings.chat.keyword .. " " .. strings.chat.help.command, colors.yellow[1])), colors.blue[1]))
	-- print(wt.Color(strings.chat.help.move:gsub("#SHIFT", wt.Color(strings.keys.shift, colors.yellow[1])):gsub("#ADDON", addonTitle), colors.blue[1]))
end
--Print the command list with basic functionality info
local function PrintCommands()
	print(wt.Color(addonTitle, ns.colors.yellow[0]) .. " ".. wt.Color(ns.strings.chat.help.list .. ":", ns.colors.blue[0]))
	--Index the commands (skipping the help command) and put replacement code segments in place
	local commands = {
		[0] = {
			command = ns.strings.chat.options.command,
			description = ns.strings.chat.options.description:gsub("#ADDON", addonTitle)
		},
		[1] = {
			command = ns.strings.chat.toggle.command,
			description = ns.strings.chat.toggle.description:gsub("#ADDON", addonTitle):gsub(
				"#STATE", wt.Color(dbc.disabled and ns.strings.misc.disabled or ns.strings.misc.enabled, ns.colors.yellow[1])
			)
		},
	}
	--Print the list
	for i = 0, #commands do
		print("    " .. wt.Color(ns.strings.chat.keyword .. " " .. commands[i].command, ns.colors.yellow[1]) .. wt.Color(" - " .. commands[i].description, ns.colors.blue[1]))
	end
end

--[ Slash Command Handlers ]

local function ToggleCommand()
	dbc.disabled = not dbc.disabled
	wt.SetVisibility(bui, not dbc.disabled)
	--Response
	print(wt.Color((dbc.disabled and ns.strings.chat.toggle.disabled or ns.strings.chat.toggle.enabled):gsub(
		"#ADDON", wt.Color(addonTitle, ns.colors.yellow[0])
	), ns.colors.blue[0]))
	--Update in the SavedVariabes DB
	BetterUIEditModeDBC.disabled = dbc.disabled
end

SLASH_PARTAR1 = ns.strings.chat.keyword
function SlashCmdList.PARTAR(line)
	local command, parameter = strsplit(" ", line)
	if command == ns.strings.chat.help.command then PrintCommands()
	elseif command == ns.strings.chat.options.command then options.mainOptions.open()
	elseif command == ns.strings.chat.toggle.command then ToggleCommand()
	else PrintInfo() end
end

--[[ INITIALIZATION ]]

--[ Extra Options ]

--Add unique options for the MainMenuBar
local function AddMainMenuBarOptions(k, o, statusBars)

	--Local references
	local frame = wt.ToFrame(db.frames[k].name)

	--[ Add Widgets ]

	--Resize the options panel
	o.options:SetHeight(o.options:GetHeight() + 94)

	--Checkbox: Dock
	o.dock = wt.CreateCheckbox({
		parent = o.options,
		name = "Dock",
		title = ns.strings.extra.mmb.dock.label,
		tooltip = { lines = { [0] = { text = ns.strings.extra.mmb.dock.tooltip, }, } },
		position = { offset = { x = 6, y = -6 } },
		events = { OnClick = function(_, state)
			local extend = o.extend:GetChecked()
			if state then
				--Start action bar updates
				StartBarUpdates(state, extend, MultiBar7)
			else
				--Stop action bar updates
				if not extend then actionBar:SetScript("OnUpdate", nil) end
				--Reload notice
				wt.CreateReloadNotice({
					message = ns.strings.extra.mmb.notice,
					position = {
						anchor = "BOTTOMLEFT",
						relativeTo = bui,
						relativePoint = "TOPLEFT",
						offset = { y = 24 }
					}
				})
			end
		end, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.frames[k],
			storageKey = "dock",
		}
	})

	--Checkbox: Extend
	o.extend = wt.CreateCheckbox({
		parent = o.options,
		name = "Extend",
		title = ns.strings.extra.mmb.extend.label,
		tooltip = { lines = { [0] = { text = ns.strings.extra.mmb.extend.tooltip, }, } },
		position = {
			relativeTo = o.dock,
			relativePoint = "BOTTOMLEFT",
		},
		events = { OnClick = function(_, state)
			local dock = o.dock:GetChecked()
			if state then
				--Start action bar updates
				StartBarUpdates(dock, state, MultiBar7)
			else
				--Stop action bar updates
				if not dock then actionBar:SetScript("OnUpdate", nil) end
				--Reload notice
				wt.CreateReloadNotice({
					message = ns.strings.extra.mmb.notice,
					position = {
						anchor = "BOTTOMLEFT",
						relativeTo = bui,
						relativePoint = "TOPLEFT",
						offset = { y = 24 }
					}
				})
			end
		end, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.frames[k],
			storageKey = "extend",
		}
	})

	--Checkbox: Scroll right
	o.scroll = wt.CreateCheckbox({
		parent = o.options,
		name = "ScrollRight",
		title = ns.strings.extra.mmb.scroll.label,
		tooltip = { lines = { [0] = { text = ns.strings.extra.mmb.scroll.tooltip, }, } },
		position = {
			relativeTo = o.extend,
			relativePoint = "BOTTOMLEFT",
		},
		events = { OnClick = function(_, state)
			if state then MainMenuBar.ActionBarPageNumber:SetPoint("LEFT", MainMenuBar.EndCaps.RightEndCap, "LEFT", 12, -1)
			else MainMenuBar.ActionBarPageNumber:SetPoint("BOTTOMRIGHT", MainMenuBar, "BOTTOMLEFT", -4, 9) end
		end, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.frames[k],
			storageKey = "scrollRight",
		}
	})

	--[ Integrate ]

	--Set Status Tracking Bar Manager options dependencies
	-- wt.SetDependencies({
	-- 	[1] = {
	-- 		frame = o.toggle,
	-- 		evaluate = function(value) return not value or not o.dock:GetChecked() end
	-- 	},
	-- 	[0] = {
	-- 		frame = o.dock,
	-- 		evaluate = function(value) return not value or not o.toggle:GetChecked() end
	-- 	},
	-- }, function(state)
	-- 	if not state then
	-- 		statusBars.toggle:SetChecked(true) --Set the opposite to be able to call Click
	-- 		statusBars.toggle:Click() --Call Click to simulate a user input to force OnClick to be called
	-- 		statusBars.toggle:SetEnabled(false)
	-- 	else
	-- 		statusBars.toggle:SetEnabled(true)
	-- 		statusBars.toggle:SetChecked(not db.frames[1].modify) --Set the opposite to be able to call Click
	-- 		statusBars.toggle:Click() --Call Click to simulate a user input to force OnClick to be called
	-- 	end
	-- 	_G[statusBars.toggle:GetName() .. "Text"]:SetFontObject(state and "GameFontHighlight" or "GameFontDisable")
	-- end)

	--Hook toggle
	o.toggle:HookScript("OnClick", function(self)
		local state = self:GetChecked()
		local dock = o.dock:GetChecked()
		local extend = o.extend:GetChecked()
		--Toggle the bar updates
		if state and not dock and not extend then
			--Start action bar updates
			StartBarUpdates(state, o.extend:GetChecked(), MultiBar7)
			--Place the page scroller
			if o.scroll:GetChecked() then MainMenuBar.ActionBarPageNumber:SetPoint("LEFT", MainMenuBar.EndCaps.RightEndCap, "LEFT", 12, -1)
			else MainMenuBar.ActionBarPageNumber:SetPoint("BOTTOMRIGHT", MainMenuBar, "BOTTOMLEFT", -4, 9) end
		elseif actionBar then
			--Stop action bar updates
				actionBar:SetScript("OnUpdate", nil)
			--Reload notice
			wt.CreateReloadNotice({
				message = ns.strings.extra.mmb.notice,
				position = {
					anchor = "BOTTOMLEFT",
					relativeTo = bui,
					relativePoint = "TOPLEFT",
					offset = { y = 24 }
				}
			})
		end
	end)

	--Hook defaults
	o.defaults:HookScript("OnClick", function()
		--Update the widgets
		o.dock:SetChecked(not dbDefault.frames[k].dock) --Set the opposite to be able to call Click
		o.dock:Click() --Call Click to simulate a user input to force check dependencies for dependent widgets
		o.extend:SetChecked(dbDefault.frames[k].extend)
		o.scroll:SetChecked(dbDefault.frames[k].scrollRight)
		--Toggle the action bar updates
		if dbDefault.frames[k].dock or dbDefault.frames[k].extend then
			--Start action bar updates
			StartBarUpdates(dbDefault.frames[k].dock, dbDefault.frames[k].extend, MultiBar7)
		elseif actionBar then
			--Stop action bar updates
			actionBar:SetScript("OnUpdate", nil)
			--Reload notice
			wt.CreateReloadNotice({
				message = ns.strings.extra.mmb.notice,
				position = {
					anchor = "BOTTOMLEFT",
					relativeTo = bui,
					relativePoint = "TOPLEFT",
					offset = { y = 24 }
				}
			})
		end
		--Place the page scroller
		if dbDefault.frames[k].scrollRight then MainMenuBar.ActionBarPageNumber:SetPoint("LEFT", MainMenuBar.EndCaps.RightEndCap, "LEFT", 12, -1)
		else MainMenuBar.ActionBarPageNumber:SetPoint("BOTTOMRIGHT", MainMenuBar, "BOTTOMLEFT", -4, 9) end
	end)
end

---Add position options to the extra options of a frame
---@param k integer Index key pointing to the frame's data table in the DB
---@param o table Table containing the frame-specific options widget references
local function AddPositionOptions(k, o)

	--Local references
	local frame = wt.ToFrame(db.frames[k].name)

	--[ Make Movable in Edit Mode ]

	--Highlight texture
	o.selection = wt.CreateTexture({
		parent = bui,
		position = {
			relativeTo = frame,
			relativePoint = "TOPLEFT",
		},
		name = "Selection",
		size = { width = frame:GetWidth(), height = frame:GetHeight() },
		path = "Interface/ChatFrame/ChatFrameBackground",
		color = ns.colors.grey,
	})
	o.selection:SetScript("OnShow", function() if db.frames[k].modify then o.selection:SetColorTexture(wt.UnpackColor(ns.colors.blue)) end end)

	--Make the frame movable in Edit Mode
	wt.SetMovability(frame, db.frames[k].modify, nil, o.selection, {
		onStart = function()
			--Recolor the selection texture
			o.selection:SetColorTexture(wt.UnpackColor(ns.colors.yellow))
		end,
		onStop = function ()
			--Grab the position & update the widgets
			local point, relativeTo, relativePoint, xOffset, yOffset = frame:GetPoint()
			o.anchor.setSelected(point)
			o.xOffset:SetValue(xOffset)
			o.yOffset:SetValue(yOffset)
			o.relativePoint.setSelected(relativeTo and relativePoint or nil)
			o.relativeTo:SetText(relativeTo or "")
			--Recolor the selection texture
			o.selection:SetColorTexture(wt.UnpackColor(ns.colors.blue))
		end,
	})

	--[ Add Widgets ]

	--Resize the options panel
	o.options:SetHeight(o.options:GetHeight() + 146)

	--Text: Tip
	local tip = wt.CreateText({
		parent = o.options,
		name = "Tip",
		position = { offset = { x = 12, y = -6 } },
		text = WrapTextInColorCode(ns.strings.extra.move.tip.title, "FFCECECE") .. " " .. ns.strings.extra.move.tip.description,
		template = "GameFontDisableSmall",
	})
	tip:SetTextColor(0.65, 0.65, 0.65)

	--Selector: Anchor point
	o.anchor = wt.CreateAnchorSelector({
		parent = o.options,
		name = "Anchor",
		title = ns.strings.extra.move.anchor.label,
		tooltip = { lines = { [0] = { text = ns.strings.extra.move.anchor.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -6, y = -8.5 }
		},
		onSelection = function(point)
			if not point then o.anchor.setSelected(0, true) end
			wt.SetPosition(frame, wt.PackPosition(point, wt.ToFrame(wt.Clear(o.relativeTo:GetText())), o.relativePoint.getSelected(), o.xOffset:GetValue(), o.yOffset:GetValue()))
		end,
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.frames[k].move.position,
			storageKey = "anchor",
		}
	})

	--Slider: X offset
	o.xOffset = wt.CreateSlider({
		parent = o.options,
		name = "OffsetX",
		title = ns.strings.extra.move.xOffset.label,
		tooltip = { lines = { [0] = { text = ns.strings.extra.move.xOffset.tooltip, }, } },
		position = { offset = { x = 12, y = -24 } },
		width = 120,
		value = { min = -500, max = 500, fractional = 2 },
		events = { OnValueChanged = function(_, value, user)
			if not user then return end
			wt.SetPosition(frame, wt.PackPosition(o.anchor.getSelected(), wt.ToFrame(wt.Clear(o.relativeTo:GetText())), o.relativePoint.getSelected(), value, o.yOffset:GetValue()))
		end, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.frames[k].move.position.offset,
			storageKey = "x",
		}
	})

	--Slider: Y offset
	o.yOffset = wt.CreateSlider({
		parent = o.options,
		name = "OffsetY",
		title = ns.strings.extra.move.yOffset.label,
		tooltip = { lines = { [0] = { text = ns.strings.extra.move.yOffset.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -o.anchor:GetWidth() - 12, y = -24 }
		},
		width = 120,
		value = { min = -500, max = 500, fractional = 2 },
		events = { OnValueChanged = function(_, value, user)
			if not user then return end
			wt.Dump(wt.PackPosition(o.anchor.getSelected(), wt.ToFrame(wt.Clear(o.relativeTo:GetText())), o.relativePoint.getSelected(), o.xOffset:GetValue(), value))
			wt.SetPosition(frame, wt.PackPosition(o.anchor.getSelected(), wt.ToFrame(wt.Clear(o.relativeTo:GetText())), o.relativePoint.getSelected(), o.xOffset:GetValue(), value))
		end, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.frames[k].move.position.offset,
			storageKey = "y",
		}
	})

	--EditBox: Relative frame
	o.relativeTo = wt.CreateEditBox({
		parent = o.options,
		title = ns.strings.extra.move.relativeTo.label,
		tooltip = { lines = { [0] = { text = ns.strings.extra.move.relativeTo.tooltip, }, } },
		position = { offset = { x = 14, y = -o.anchor:GetHeight() - 9 }, },
		width = o.options:GetWidth() - o.anchor:GetWidth() - 22,
		events = {
			OnTextChanged = function(self, _, text)
				text = wt.Clear(text)
				if not wt.ToFrame(text) then self:SetText(wt.Color(text, { r = 1, g = 0.3, b = 0.3 })) else self:SetText(wt.Color(text), { r = 1, g = 1, b = 1 }) end
			end,
			OnEnterPressed = function(self, text)
				text = wt.Clear(text)
				if not wt.ToFrame(text) then
					self:SetText("")
					o.relativePoint.setSelected(nil)
				end
				wt.SetPosition(frame, wt.PackPosition(o.anchor.getSelected(), wt.ToFrame(text), o.relativePoint.getSelected(), o.xOffset:GetValue(), o.yOffset:GetValue()))
			end,
			OnEscapePressed = function(self) self:SetText(db.frames[k].move.position.relativeTo) end,
		},
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.frames[k].move.position,
			storageKey = "relativeTo",
			convertSave = function(value)
				local text = wt.Clear(value)
				return wt.ToFrame(text) and text or nil
			end,
			convertLoad = function(value) return value or "" end,
		}
	})

	--Selector: Relative point
	o.relativePoint = wt.CreateAnchorSelector({
		parent = o.options,
		name = "RelativeAnchor",
		title = ns.strings.extra.move.relativePoint.label,
		tooltip = { lines = { [0] = { text = ns.strings.extra.move.relativePoint.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -6, y = -o.anchor:GetHeight() - 9 },
		},
		onSelection = function(point)
			if not point then o.relativeTo:SetText("") end
			wt.SetPosition(frame, wt.PackPosition(o.anchor.getSelected(), wt.ToFrame(wt.Clear(o.relativeTo:GetText())), point, o.xOffset:GetValue(), o.yOffset:GetValue()))
		end,
		dependencies = { [0] = { frame = o.relativeTo, evaluate = function(text) return wt.ToFrame(wt.Clear(text)) end }, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.frames[k].move.position,
			storageKey = "relativePoint",
		}
	})

	--Checkbox: Keep movable
	o.movable = wt.CreateCheckbox({
		parent = o.options,
		name = "Movable",
		title = ns.strings.extra.move.movable.label,
		tooltip = { lines = { [0] = { text = ns.strings.extra.move.movable.tooltip, }, } },
		position = {
			anchor = "BOTTOMLEFT",
			offset = { x = 6, y = 6 }
		},
		disabled = not frame.SetMovable,
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.frames[k].move,
			storageKey = "movable",
			onSave = function(_, value) wt.SetMovability(frame, value, o.modifier:GetChecked() and "SHIFT" or nil, nil, {
				onStop = function()
					wt.CopyValues(wt.PackPosition(frame:GetPoint()), db.frames[k].move.position)
					BetterUIEditModeDB.frames[k].move.position = wt.Clone(db.frames[k].move.position)
				end,
			}) end,
		}
	})

	--Checkbox: Modifier
	o.modifier = wt.CreateCheckbox({
		parent = o.options,
		name = "Modifier",
		title = ns.strings.extra.move.modifier.label,
		tooltip = { lines = { [0] = { text = ns.strings.extra.move.modifier.tooltip, }, } },
		position = {
			anchor = "BOTTOMLEFT",
			offset = { x = 134, y = 6 }
		},
		disabled = not frame.SetMovable,
		dependencies = { [0] = { frame = o.movable, }, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.frames[k].move,
			storageKey = "modifier",
		}
	})

	--[ Integrate ]

	--Hook toggle
	o.toggle:HookScript("OnClick", function(self)
		local state = self:GetChecked()
		--Toggle movability
		if state then
			--Move the frame
			wt.SetPosition(frame, wt.PackPosition(
				o.anchor.getSelected(), wt.ToFrame(wt.Clear(o.relativeTo:GetText())), o.relativePoint.getSelected(), o.xOffset:GetValue(), o.yOffset:GetValue()
			))
			--Make the frame movable in Edit Mode
			wt.SetMovability(frame, true, nil, o.selection, {
				onStart = function()
					--Recolor the selection texture
					o.selection:SetColorTexture(wt.UnpackColor(ns.colors.yellow))
				end,
				onStop = function ()
					--Grab the position & update the widgets
					local point, relativeTo, relativePoint, xOffset, yOffset = frame:GetPoint()
					o.anchor.setSelected(point)
					o.xOffset:SetValue(xOffset)
					o.yOffset:SetValue(yOffset)
					o.relativePoint.setSelected(relativeTo and relativePoint or nil)
					o.relativeTo:SetText(relativeTo or "")
					--Recolor the selection texture
					o.selection:SetColorTexture(wt.UnpackColor(ns.colors.blue))
				end,
			})
			--Execute special movement rules
			if db.frames[k].move.rule then db.frames[k].move.rule() end
			--Recolor the selection texture
			o.selection:SetColorTexture(wt.UnpackColor(ns.colors.blue))
		else
			--Make the frame unmovable in Edit Mode
			o.selection:EnableMouse(false)
			if frame.SetMovable then frame:SetMovable(o.movable:GetChecked()) end
			--Restore the frame
			wt.SetPosition(frame, dbDefault.frames[k].move.position)
			--Execute special movement rules
			if db.frames[k].move.rule then db.frames[k].move.rule() end
			--Recolor the selection texture
			o.selection:SetColorTexture(wt.UnpackColor(ns.colors.grey))
		end
	end)

	--Hook defaults
	o.defaults:HookScript("OnClick", function()
		--Update the widgets
		o.anchor.setSelected(dbDefault.frames[k].move.position.anchor)
		o.xOffset:SetValue(dbDefault.frames[k].move.position.offset.x)
		o.yOffset:SetValue(dbDefault.frames[k].move.position.offset.y)
		o.relativePoint.setSelected(dbDefault.frames[k].move.position.relativeTo and dbDefault.frames[k].move.position.relativePoint or nil)
		o.relativeTo:SetText(dbDefault.frames[k].move.position.relativeTo or "")
		o.movable:SetChecked(not dbDefault.frames[k].move.movable) --Set the opposite to be able to call Click
		o.movable:Click() --Call Click to simulate a user input to force check dependencies for dependent widgets
		o.modifier:SetChecked(dbDefault.frames[k].move.modifier)
		--Restore the frame
		wt.SetPosition(frame, dbDefault.frames[k].move.position)
	end)
end

---Create an options panel to add extra options to for a frame
---@param k integer Index key pointing to a valid frame's data table in the DB
---@param linkTo table Table containing the options widget references of the frame to link this frame's options under
local function CreateFrameOptions(k, linkTo)

	--Local references
	local o = {}
	local parent = _G[bui:GetName() .. "Options"]
	local frame = wt.ToFrame(db.frames[k].name)
	local initials = db.frames[k].name:gsub("%l", "")

	--Checkbox: Toggle
	o.toggle = wt.CreateCheckbox({
		parent = parent,
		name = initials .. "Toggle",
		title = db.frames[k].title,
		tooltip = { lines = { [0] = { text = ns.strings.extra.modify.tooltip:gsub("#FRAME", wt.Color(frame:GetName():gsub("(%u)", " %1"):sub(2), ns.colors.blue)), }, } },
		position = { offset = { x = 10, y = -10 } },
		events = { OnClick = function(_, state)
			wt.SetVisibility(o.options, state)
			--Update options scroll size
			parent:SetHeight(parent:GetHeight() + (state and o.options:GetHeight() + 3 or -o.options:GetHeight() - 3))
		end, },
		optionsData = {
			optionsKey = addonNameSpace,
			storageTable = db.frames[k],
			storageKey = "modify",
			onLoad = function(_, state)
				wt.SetVisibility(o.options, state)
				--Update options scroll size
				parent:SetHeight(parent:GetHeight() + (state and o.options:GetHeight() + 3 or 0))
			end,
		}
	})
	if linkTo then
		linkTo.toggle:HookScript("OnClick", function(self)
			o.toggle:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -(self:GetChecked() and linkTo.options:GetHeight() + 4 or 0) - 4)
		end)
		linkTo.toggle:HookScript("OnAttributeChanged", function(name, value)
			if name ~= "loaded" and not value then return end
			o.toggle:SetPoint("TOPLEFT", linkTo.toggle, "BOTTOMLEFT", 0, -(linkTo.toggle:GetChecked() and linkTo.options:GetHeight() + 4 or 0) - 4)
		end)
	end

	--Options panel
	o.options = wt.CreatePanel({
		parent = o.toggle,
		name = parent:GetName() .. initials,
		append = false,
		label = false,
		position = {
			relativeTo = o.toggle,
			relativePoint = "BOTTOMLEFT",
			offset = { x = -4, }
		},
		size = { width = parent:GetWidth() - 12, height = 0 },
		background = { color = { r = 0.25, g = 0.25, b = 0.25, a = 0.4 } },
	})

	--Button: Defaults
	o.defaults = wt.CreateButton({
		parent= o.options,
		title = ns.strings.extra.defaults.label,
		tooltip = { lines = { [0] = { text = ns.strings.extra.defaults.tooltip, }, } },
		position = {
			anchor = "TOPRIGHT",
			offset = { x = -6, y = 24 }
		},
		events = { OnClick = function()
			--Reset the DBs
			BetterUIEditModeDB[k] = wt.Clone(dbDefault.frames[k])
			wt.CopyValues(dbDefault.frames[k], db.frames[k])
		end, },
	})

	--Add position options
	if db.frames[k].move then AddPositionOptions(k, o) end

	--Update options scroll size
	parent:SetHeight(parent:GetHeight() + o.toggle:GetHeight() + (linkTo and 6 or 12))

	return o
end

--Set up the extra Edit Mode options
local function SetUpExtraOptions()

	--[ Main Frame ]

	bui:SetSize(368, 20)
	bui:SetPoint("TOPLEFT", EditModeManagerFrame, "TOPRIGHT", 0, -20)
	bui:SetFrameStrata("HIGH")

	--[ Extra Options Frame ]

	--Background panel
	local optionsPanel = wt.CreatePanel({
		parent = bui,
		name = "BGPanel",
		title = addonTitle,
		size = { width = bui:GetWidth() + 8, height = 480 },
		background = { color = { r = 0.1, g = 0.1, b = 0.1, a = 0.8 } },
	})

	--ScrollFrame: Options panel
	optionsPanel = wt.CreateScrollFrame({
		parent = bui,
		scrollName = "Options",
		position = { offset = { x = 4, y = -4 } },
		size = { width = bui:GetWidth(), height = optionsPanel:GetHeight() - 8},
		scrollSize = { height = 0 },
		scrollSpeed = 88
	})

	--[ Custom Options ]

	local extraOptions = {}

	--Create base (& position) options for each valid frame
	for i = 0, #db.frames do if wt.ToFrame(db.frames[i].name) then
		extraOptions[extraOptions[0] and #extraOptions + 1 or 0] = CreateFrameOptions(i, extraOptions[extraOptions[0] and #extraOptions])
	end end

	--Unique options: MainMenuBar
	AddMainMenuBarOptions(0, extraOptions[0], extraOptions[1])

	--[ Manage Options Data ]

	--Load the extra options when entering Edit Mode
	GameMenuButtonEditMode:HookScript("OnClick", function()
		--Load the saved options
		wt.LoadOptionsData(addonNameSpace)
		--Uproot the valid frames movable in Edit Mode
		for i = 0, #db.frames do
			local frame = wt.ToFrame(db.frames[i].name)
			if frame then if frame.SetMovable and db.frames[i].modify and db.frames[i].move then frame:SetMovable(true) end end
		end
	end)

	--Save the extra options on Edit Mode exit
	bui:HookScript("OnHide", function()
		--Save the specified options
		wt.SaveOptionsData(addonNameSpace)
		--Commit the changes & update the DB
		BetterUIEditModeDB = wt.Clone(db)
		--Freeze the valid frames movable in Edit Mode
		for i = 0, #db.frames do
			local frame = wt.ToFrame(db.frames[i].name)
			if frame then if frame.SetMovable and db.frames[i].modify and db.frames[i].move and not (db.frames[i].move or {}).movable then frame:SetMovable(false) end end
		end
	end)
end

--Apply the extra options specified for each frame to the UI
local function ApplyUIChanges()

	--[ Base Options ]

	--Set the position & movability of each valid frame
	for i = 0, #db.frames do if db.frames[i].modify then
		local frame = wt.ToFrame(db.frames[i].name)
		if frame and db.frames[i].move then
			--Position frames
			wt.SetPosition(frame, db.frames[i].move.position)
			--Make frames movable
			if db.frames[i].move.movable then wt.SetMovability(frame, true, db.frames[i].move.modifier and "SHIFT" or nil, nil, {
				onStop = function()
					wt.CopyValues(wt.PackPosition(frame:GetPoint()), db.frames[i].move.position)
					BetterUIEditModeDB.frames[i].move.position = wt.Clone(db.frames[i].move.position)
				end,
			}) end
			--Execute special movement rules
			if db.frames[i].move.rule then db.frames[i].move.rule() end
		end
	end end

	--[ Unique Options ]

	--Main Menu Bar
	if db.frames[0].modify then
		--Start action bar updates
		StartBarUpdates(db.frames[0].dock, db.frames[0].extend, MultiBar7)
		--Move the page scrolling
		if db.frames[0].scrollRight then MainMenuBar.ActionBarPageNumber:SetPoint("LEFT", MainMenuBar.EndCaps.RightEndCap, "LEFT", 12, -1) end
	end
end

--[ Loading ]

function bui:ADDON_LOADED(name)
	if name ~= addonNameSpace then return end
	bui:UnregisterEvent("ADDON_LOADED")
	--Load & check the DBs
	if LoadDBs() then PrintInfo() end
	--Set up the interface options
	LoadInterfaceOptions()
	--Set up the extra Edit Mode options
	SetUpExtraOptions()
	--Apply the saved settings to the UI
	ApplyUIChanges()
end