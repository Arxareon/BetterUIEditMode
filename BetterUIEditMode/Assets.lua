--[[ ADDON INFO ]]

--Addon namespace string & table
local addonNameSpace, ns = ...

--Addon root folder
local root = "Interface/AddOns/" .. addonNameSpace .. "/"


--[[ CHANGELOG ]]

local changelogDB = {
	[0] = {
		[0] = "#V_Version 1.0_# #H_(9/2/2022)_#",
		[1] = "#H_It's alive!_#",
	},
}

--Get an assembled & formatted string of the full changelog
ns.GetChangelog = function()
	--Colors
	local version = "FFFFFFFF"
	local new = "FF66EE66"
	local fix = "FFEE4444"
	local change = "FF8888EE"
	local note = "FFEEEE66"
	local highlight = "FFBBBBBB"
	--Assemble the changelog
	local changelog = ""
		for i = #changelogDB, 0, -1 do
			for j = 0, #changelogDB[i] do
				changelog = changelog .. (j > 0 and "\n\n" or "") .. changelogDB[i][j]:gsub(
					"#V_(.-)_#", (i < #changelogDB and "\n\n\n" or "") .. "|c" .. version .. "%1|r"
				):gsub(
					"#N_(.-)_#", "|c".. new .. "%1|r"
				):gsub(
					"#F_(.-)_#", "|c".. fix .. "%1|r"
				):gsub(
					"#C_(.-)_#", "|c".. change .. "%1|r"
				):gsub(
					"#O_(.-)_#", "|c".. note .. "%1|r"
				):gsub(
					"#H_(.-)_#", "|c".. highlight .. "%1|r"
				)
			end
		end
	return changelog
end


--[[ LOCALIZATIONS ]]

local english = {
	temp = {
		dfOpenSettings = "\nOpening subcategories is not yet supported in Dragonflight. Expand the #ADDON options on the left to navitage here manually." --# flags will be replaced with code, \n represents the newline character
	},
	options = {
		name = "#ADDON options",
		defaults = "The default options and the Custom preset have been reset.",
		main = {
			name = "Main page",
			description = "Customize #ADDON to fit your needs. Type #KEYWORD for chat commands.", --# flags will be replaced with code
			shortcuts = {
				title = "Shortcuts",
				description = "Access customization options by expanding the #ADDON categories on the left or by clicking a button here.", --# flags will be replaced with code
			},
			about = {
				title = "About",
				description = "Thank you for using #ADDON!", --# flags will be replaced with code
				version = "Version: #VERSION", --# flags will be replaced with code
				date = "Date: #DATE", --# flags will be replaced with code
				author = "Author: #AUTHOR", --# flags will be replaced with code
				license = "License: #LICENSE", --# flags will be replaced with code
				changelog = {
					label = "Changelog",
					tooltip = "Notes of all the changes included in the addon updates for all versions.\n\nThe changelog is only available in English for now.", --\n represents the newline character
				},
			},
			support = {
				title = "Support",
				description = "Follow the links to see how you can provide feedback, report bugs, get help and support development.",
				curseForge = "CurseForge Page",
				wago = "Wago Page",
				repository = "GitHub Repository",
				issues = "Issues & Ideas",
			},
			feedback = {
				title = "Feedback",
				description = "Visit #ADDON online if you have something to report.", --# flags will be replaced with code
			},
		},
		advanced = {
			title = "Advanced",
			description = "Configure #ADDON settings further, change options manually or backup your data by importing, exporting settings.", --# flags will be replaced with code
			profiles = {
				title = "Profiles",
				description = "Create, edit and apply unique options profiles to customize #ADDON separately between your characters. (Soon™)", --# flags will be replaced with 
			},
			backup = {
				title = "Backup",
				description = "Import or export #ADDON options to save, share or apply them between your accounts.", --# flags will be replaced with code
				backupBox = {
					label = "Import & Export",
					tooltip = {
						[0] = "The backup string in this box contains the currently saved addon data and frame positions.",
						[1] = "Copy it to save, share or use it for another account.",
						[2] = "If you have a string, just override the text inside this box. Select it, and paste your string here. Press #ENTER to load the data stored in it.", --# flags will be replaced with code
						[3] = "Note: If you are using a custom font file, that file can not carry over with this string. It will need to be inserted into the addon folder to be applied.",
						[4] = "Only load strings that you have verified yourself or trust the source of!",
					},
				},
				compact = {
					label = "Compact",
					tooltip = "Toggle between a compact and a readable view.",
				},
				load = {
					label = "Load",
					tooltip = "Check the current string, and attempt to load all data from it.",
				},
				reset = {
					label = "Reset",
					tooltip = "Reset the string to reflect the currently stored values.",
				},
				import = "Load the string",
				warning = "Are you sure you want to attempt to load the currently inserted string?\n\nIf you've copied it from an online source or someone else has sent it to you, only load it after checking the code inside and you know what you are doing.\n\nIf don't trust the source, you may want to cancel to prevent any unwanted events.", --\n represents the newline character
				error = "The provided backup string could not be validated and no data was loaded. It might be missing some characters, or errors may have been introduced if it was edited.",
			},
		},
	},
	extra = {
		modify = {
			tooltip = "Enable the special options for this frame: #FRAME", --# flags will be replaced with code, \n represents the newline character
		},
		defaults = {
			label = "Defaults",
			tooltip = "Restore the default options for this frame.",
		},
		move = {
			tip = {
				title = "Tip:",
				description = "You can drag & drop the highlighted frame.",
			},
			anchor = {
				label = "Anchor",
				tooltip = "Select which point of the screen should the frame be anchored to.",
			},
			xOffset = {
				label = "Horizontal Offset",
				tooltip = "Set the amount of horizontal offset (X axis) of the frame from the selected anchor point.",
			},
			yOffset = {
				label = "Vertical Offset",
				tooltip = "Set the amount of vertical offset (Y axis) of the frame from the selected anchor point.",
			},
			relativeTo = {
				label = "Link to Frame",
				tooltip = "Type the name of another frame to link the position of this one to.\n\nFind out the names of frames by toggling the debug UI via /framestack.",
			},
			relativePoint = {
				label = "Link at",
				tooltip = "Attach the chosen anchor point of this frame to the selected link point of the frame specified for linking.",
			},
			movable = {
				label = "Keep movable",
				tooltip = "Keep the frame freely movable outside of Edit Mode.\n\nPlease note, that enabling this may cause some funny business in some cases (for example certain default mouseover functionality not working).",
			},
			modifier = {
				label = "Move key: SHIFT",
				tooltip = "Only allow moving the frame outside of Edit Mode while the SHIFT key is being pressed.",
			},
		},
		mmb = {
			dock = {
				label = "Dock with the Status Tracking Bar",
				tooltip = "Dock the Status Tracking Bar Manager (exp/rep or other progress bars) to the bottom of the screen, and link the position of the main Action Bar 1 frame to it. It will move up and down based on how many statuses are being tracked currently - how many bars are visible.",
			},
			extend = {
				label = "Extend with another Action Bar",
				tooltip = "Integrate a selected action bar into the Main Menu Bar (Action Bar 1) frame, extending its size to house up to 24 buttons, so you can build action bars more horizontally instead of stacking more vertically while keeping the bar art.",
			},
			scroll = {
				label = "Move the page scroller to the right",
				tooltip = "Uproot the action page number scroller and move it to the right side.",
			},
			notice = "Reload the interface to restore the default state of the action bar frames.",
		}
	},
	chat = {
		status = {
			enabled = "#ADDON is enabled for this character.", --# flags will be replaced with code
			disabled = "#ADDON is disabled for this character.", --# flags will be replaced with code
		},
		help = {
			command = "help",
			thanks = "Thank you for using #ADDON!", --# flags will be replaced with code
			hint = "Type #HELP_COMMAND to see the full command list.", --# flags will be replaced with code
			move = "Hold #SHIFT to drag the #ADDON display anywhere you like.", --# flags will be replaced with code
			list = "chat command list",
		},
		options = {
			command = "options",
			description = "open the #ADDON options", --# flags will be replaced with code
		},
		toggle = {
			command = "toggle",
			description = "toggle #ADDON for this character (#STATE)", --# flags will be replaced with code
			enabled = "#ADDON has been enabled for this character.", --# flags will be replaced with code
			disabled = "#ADDON has been disabled for this character.", --# flags will be replaced with code
		},
	},
	keys = {
		shift = "SHIFT",
		enter = "ENTER",
	},
	misc = {
		date = "#MONTH/#DAY/#YEAR", --# flags will be replaced with code
		default = "Default",
		custom = "Custom",
		override = "Override",
		enabled = "enabled",
		disabled = "disabled",
		days = "days",
		hours = "hours",
		minutes = "minutes",
		seconds = "seconds",
	},
}


--[[ Load Localization ]]

--Load the proper localization table based on the client language
ns.LoadLocale = function()
	local strings
	if (GetLocale() == "") then
		--TODO: Add localization for other languages (locales: https://wowwiki-archive.fandom.com/wiki/API_GetLocale#Locales)
		--Different font locales: https://github.com/tomrus88/BlizzardInterfaceCode/blob/master/Interface/FrameXML/Fonts.xml
	else --Default: English (UK & US)
		strings = english
		strings.misc.defaultFont = UNIT_NAME_FONT_ROMAN:gsub("\\", "/")
	end
	return strings
end


--[[ ASSETS & RESOURCES ]]

--Strings
ns.strings = ns.LoadLocale()
ns.strings.chat.keyword = "/bui"

--Colors
ns.colors = {
	grey = { r = 0.7, g = 0.7, b = 0.7, a = 0.5 },
	blue = { r = 0.7, g = 0.9, b = 1, a = 0.5 },
	yellow = { r = 1, g = 0.9, b = 0.7, a = 0.5 },
}

--Textures
ns.textures = {
	logo = root .. "Textures/Logo.tga",
}