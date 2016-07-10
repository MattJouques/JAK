-----------------------------------------------------------------------------------------
-- 
-- File: main.lua
-- Project: JAK
-----------------------------------------------------------------------------------------



-----------------------------------------------------------------------------------------

Setup Database

-----------------------------------------------------------------------------------------

--Include sqlite
require "sqlite3"
--Open data.db.  If the file doesn't exist it will be created
local path = system.pathForFile("JAK.db", system.DocumentsDirectory)
db = sqlite3.open( path )   
 
--Handle the applicationExit event to close the db
local function onSystemEvent( event )
        if( event.type == "applicationExit" ) then              
            db:close()
        end
end

-----------------------------------------------------------------------------------------

Setup Screens

-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )

-- include Corona's "widget" library
local widget = require "widget"
local storyboard = require "storyboard"

-- event listeners for tab buttons:
local function onFirstView( event )
	storyboard.gotoScene( "view1" )
end

local function onSecondView( event )
	storyboard.gotoScene( "view2" )
end

-- create a tabBar widget with two buttons at the bottom of the screen

-- table to setup buttons
local tabButtons = {
	{ label="First", up="icon1.png", down="icon1-down.png", width = 32, height = 32, onPress=onFirstView, selected=true },
	{ label="Second", up="icon2.png", down="icon2-down.png", width = 32, height = 32, onPress=onSecondView },
}

-- create the actual tabBar widget
local tabBar = widget.newTabBar{
	top = display.contentHeight - 50,	-- 50 is default height for tabBar widget
	buttons = tabButtons
}

onFirstView()	-- invoke first tab button's onPress event manually

----------------------------------------------

APP Code

--------------------------------------------------------------

--Add rows with a auto index in 'id'. You don't need to specify a set of values because we're populating all of them
local testvalue = {}
testvalue[1] = 'Hello'
testvalue[2] = 'World'
testvalue[3] = 'Lua'
local tablefill =[[INSERT INTO test VALUES (NULL, ']]..testvalue[1]..[[',']]..testvalue[2]..[['); ]]
local tablefill2 =[[INSERT INTO test VALUES (NULL, ']]..testvalue[2]..[[',']]..testvalue[1]..[['); ]]
local tablefill3 =[[INSERT INTO test VALUES (NULL, ']]..testvalue[1]..[[',']]..testvalue[3]..[['); ]]
db:exec( tablefill )
db:exec( tablefill2 )
db:exec( tablefill3 )
 
--print the sqlite version to the terminal
print( "version " .. sqlite3.version() )
 
--print all the table contents
for row in db:nrows("SELECT * FROM test") do
  local text = row.content.." "..row.content2
  local t = display.newText(text, 20, 120 + (20 * row.id), native.systemFont, 16)
  t:setTextColor(255,0,255)
end

-----------------------------------------------------------------------------------------

Configure Exit

-----------------------------------------------------------------------------------------


--setup the system listener to catch applicationExit
Runtime:addEventListener( "system", onSystemEvent )