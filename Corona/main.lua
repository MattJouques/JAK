----------------------------------------------------------
-- Application: JAK
-- Resource: main.lua
-- Version: 0.1
-- Last Edit: 10_10_12
----------------------------------------------------------
print("\n--- Application Initialisation ---\n")
----------------------------------------------------------  

-- Load initiation Dependencies
require "sqlite3"
local configM = require "config"
local jakM = require "jak"
local director = require "director"
local widget = require "widget"
--require "tests" 
--require "weather" 
--require "socket.http"

--------------------- Initialise sqlite database ------------------------
configM.dbInit()
--Handle the applicationExit event to close the db
local function onSystemEvent( event )
	if( event.type == "applicationExit" ) then              
		db:close()
	end
end
print("database is ", db)
--------------------- Load Configuration ------------------------
configM.appInfo()     												 -- Get application info
--if not pcall(config.Check) then error({code=040}) end								-- Check Database config
--if not pcall(config.usrConfig) then error({code=041}) end
--if not pcall(tests.Execute) then error({code=080}) end

-- Variables
_G.menuWidth = 60
_G.appWidth = display.contentWidth - menuWidth
_G.appHeight = display.contentHeight
_G.appMidWidth = appWidth / 2

-- Application Workspaces
_G.fullscreenX = menuWidth
_G.fullscreenY = 50
_G.leftpanelX = fullscreenX + 30
_G.leftpanelY = fullscreenY + 40
_G.leftpanelW = appMidWidth - 30
_G.leftpanelH = appHeight - 120
_G.rightpanelX = appMidWidth + 30
_G.rightpanelY = fullscreenY + 40
_G.rightpanelW = appMidWidth - 30
_G.rightpanelH = appHeight - 120
_G.appX = menuWidth
_G.appY = 50

----------------------------------------------------------
print("\n--- Startup Functions ---\n")
----------------------------------------------------------

--Set Application Background
local contentBg = display.newRect( menuWidth, 50, appWidth, appHeight  )
contentBg:setFillColor(225, 225, 225)

--Menu Focus Pointer

local MenuPointer = display.newRect(48,112,25,25)
MenuPointer:setFillColor (0,0,0)
MenuPointer.rotation = 45
MenuPointer.strokeWidth = 2

--Set Menu Background
local menuBg = display.newRect( 0, 0, menuWidth, appHeight)
menuBg:setFillColor(0, 0, 0)

-- Title Bar
local titleG = graphics.newGradient({200,200,200},{151,151,151},"down")
local titleBg = display.newRect( 0, 0, display.contentWidth, 50 )
local title = display.newRetinaText(appName .. " v" .. appVersion, appMidWidth, 25, native.systemFont, 12)
title:setTextColor(0,0,0)
titleBg:setFillColor(titleG)

----------------------------------------------------------
--- Menu ---
----------------------------------------------------------

-- Menu functions
	-- Dashboard button function
	local DashBtn = function ( event )
		if event.phase == "release" then
			director:changeScene( "dashboard", "crossfade" )
			transition.to(MenuPointer,{x=60,y=124})
		end
	end
	-- Dashboard Button
	local DashBtn = widget.newButton{
		default = "images/dashboard.png",
		over = "images/dashboard_over.png",
		onEvent = DashBtn,
		id = "DashBtn",
		left = 10,
    	top = 100,
    	width = 40,
    	height = 40,
    	label = "Dashboard",
		fontSize = 8,
		yOffset = 25,
		labelColor = { default={ 155 }, over={ 255 } },
		emboss = true
	}
	-- Route button function
	local RouteBtn = function ( event )
		if event.phase == "release" then
			director:changeScene( "route", "crossfade" )
			transition.to(MenuPointer,{x=60,y=194})
		end
	end
	-- Route Button
	local RouteBtn = widget.newButton{
		default = "images/route.png",
		over = "images/route_over.png",
		onEvent = RouteBtn,
		id = "RouteBtn",
		left = 10,
    	top = 170,
    	width = 40,
    	height = 40,
    	label = "Route",
		fontSize = 8,
		yOffset = 25,
		labelColor = { default={ 155 }, over={ 255 } },
		emboss = true
	}
	-- Weather button function
	local WxBtn = function ( event )
		if event.phase == "release" then
			director:changeScene( "weather", "crossfade" )
			transition.to(MenuPointer,{x=60,y=264})
		end
	end
	-- Weather button
	local WxBtn = widget.newButton{
		default = "images/weather.png",
		over = "images/weather_over.png",
		onEvent = WxBtn,
		id = "WxBtn",
		left = 10,
    	top = 240,
    	width = 40,
    	height = 40,
    	label = "Weather",
		fontSize = 8,
		yOffset = 25,
		labelColor = { default={ 155 }, over={ 255 } },
		emboss = true
	}
	-- NOTAM button function
	local NotamBtn = function ( event )
		if event.phase == "release" then
			director:changeScene( "notams", "crossfade" )
			transition.to(MenuPointer,{x=60,y=334})
		end
	end
	-- NOTAM Button
	local NotamBtn = widget.newButton{
		default = "images/notam.png",
		over = "images/notam_over.png",
		onEvent = NotamBtn,
		id = "NotamBtn",
		left = 10,
    	top = 310,
    	width = 40,
    	height = 40,
    	label = "NOTAMS",
		fontSize = 8,
		yOffset = 25,
		labelColor = { default={ 155 }, over={ 255 } },
		emboss = true
	}
	-- E6-B Button function
	local CalcBtn = function ( event )
		if event.phase == "release" then
			director:changeScene( "E6-B", "crossfade" )
			transition.to(MenuPointer,{x=60,y=474})
		end
	end
	-- E6-B Button function
	local CalcBtn = widget.newButton{
		default = "images/e6b.png",
		over = "images/e6b_over.png",
		onEvent = CalcBtn,
		id = "CalcBtn",
		left = 10,
    	top = 450,
    	width = 40,
    	height = 40,
    	label = "E6-B",
		fontSize = 8,
		yOffset = 25,
		labelColor = { default={ 155 }, over={ 255 } },
		emboss = true
	}
	-- Aircraft Button function
	local AcBtn = function ( event )
		if event.phase == "release" then
			director:changeScene( "aircraft", "crossfade" )
			transition.to(MenuPointer,{x=60,y=404})
		end
	end
	-- Aircraft Button function
	local AcBtn = widget.newButton{
		default = "images/aircraft.png",
		over = "images/aircraft_over.png",
		onEvent = AcBtn,
		id = "AcBtn",
		left = 10,
    	top = 380,
    	width = 40,
    	height = 40,
    	label = "Aircraft",
		fontSize = 8,
		yOffset = 25,
		labelColor = { default={ 155 }, over={ 255 } },
		emboss = true
	}
	-- Setup Button function
	local SetupBtn = function ( event )
		if event.phase == "release" then
			director:changeScene( "setup", "crossfade" )
			transition.to(MenuPointer,{x=60,y=704})
		end
	end
	-- Setup Button
	local SetupBtn = widget.newButton{
		default = "images/setup.png",
		over = "images/setup_over.png",
		onEvent = SetupBtn,
		id = "SetupBtn",
		left = 10,
    	top = 680,
    	width = 40,
    	height = 40,
    	label = "Setup",
		fontSize = 8,
		yOffset = 25,
		labelColor = { default={ 155 }, over={ 255 } },
		emboss = true
	}

----------------------------------------------------------
--- Director ---
----------------------------------------------------------

-- Initialise the Director
local mainGroup = display.newGroup()

local function main()
	mainGroup:insert(director.directorView)
	director:changeScene("E6-B")
end

main()




----------------------------------------------------------
print("\n--- Application Functions ---\n")
----------------------------------------------------------

-- User Inputs --
--local usrRouteTime = [['2012-10-07 10:00:00']]
--local usrWptAlts = {"'000'","'030'","'030'","'030'","'045'","'045'"}
--local Aircraft1 = [['1','PA-28','Piper Cherokee','Kts','95',]] .. jak.NullPad(37)


--setup the system listener to catch applicationExit
Runtime:addEventListener( "system", onSystemEvent )



-- User Functions --
--config.importGPX()          -- Import Route ! write
--jak.loadGPX("1")            -- Load Route to plan
--jak.routeTime(usrRouteTime) -- Apply time to plan
--jak.routeAlts(usrWptAlts)   -- Apply Alts to plan
--jak.acTAS()                 -- Apply TAS to plan
--jak.calcHeading()           -- Calc HDG_T, GS & leg

--if not pcall(weather.getMet) then error({code=090}) end
--                            -- Get NOTAMs
--                            -- Weight & Balance

-- Setup Functions --
--jak.dbInsert("AircraftTypes", Aircraft1)
--                    -- Configure Aircraft
--                    -- Configure Airfields

-- Output Functions --
--                    -- Flight Briefing
--                    -- Performance Sheet
--                    -- PLOG

-- Additional functions --
--                    -- Load Map
--                    -- Plot Route on Map
--                    -- import NavAids

--print("\n--- Dashboard Functions ---\n")
--plan = jak.dbQ("*", "CurrentPlan")    -- load last route
--print(table.unpack(plan))  -- Display plan
--print(weather.chkMet())    -- Check weather status
--print(notam.check())     -- Check NOTAM status
--jakM.dbQ("*", "Config")