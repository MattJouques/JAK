----------------------------------------------------------
-- Application: JAK
-- Resource: theme.lua
-- Version: 0.1
-- Last Edit: 19_10_12
----------------------------------------------------------
local modname = ...
local themeTable = {}
package.loaded[modname] = themeTable
local assetDir = "images/"
----------------------------------------------------------
-- Buttons
----------------------------------------------------------
themeTable.button = {
	-- if no style is specified, will use default:
	default = assetDir .. "default.png",
	over = assetDir .. "over.png",
	width = 60, height = 40,
	font = "Helvetica-Bold",
	fontSize = 18,
	labelColor = { default={0}, over={255} },
	emboss = true,
	
	-- button styles
	
	CalcBtn = {
		default = assetDir .. "default.png",
		over = assetDir .. "over.png",
		width = 60, height = 40,
		font = "HelveticaNeue-Bold",
		fontSize = 18,
		labelColor = { default={0}, over={255} },
		emboss = true,
	},
	ZeroBtn = {
		default = assetDir .. "default.png",
		over = assetDir .. "over.png",
		width = 140, height = 40,
		font = "HelveticaNeue-Bold",
		fontSize = 18,
		labelColor = { default={0}, over={255} },
		emboss = true,
	},
	EqualBtn = {
		default = assetDir .. "default.png",
		over = assetDir .. "over.png",
		width = 60, height = 100,
		font = "HelveticaNeue-Bold",
		fontSize = 18,
		labelColor = { default={0}, over={255} },
		emboss = true,
	},
	UOMBtn = {
		default = assetDir .. "default.png",
		over = assetDir .. "over.png",
		width = 50, height = 30,
		font = "HelveticaNeue-Bold",
		fontSize = 14,
		labelColor = { default={0}, over={255} },
		emboss = true,
	},
	SelectorBtn = {
		default = assetDir .. "red_def.png",
		over = assetDir .. "red_over.png",
		width = 50, height = 30,
		font = "HelveticaNeue",
		fontSize = 14,
		labelColor = { default={255}, over={255} },
		emboss = true,
	},
	iosBtn = {
		default = assetDir .. "blue_def.png",
		over = assetDir .. "blue_over.png",
		width = 60, height = 30,
		font = "HelveticaNeue",
		fontSize = 14,
		labelColor = { default={255}, over={255} },
		emboss = true,
	}
}