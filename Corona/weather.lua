module(..., package.seeall)
----------------------------------------------------------
-- Application: JAK
-- Resource: weather.lua
-- Version: 0.1
-- Last Edit: 11_10_12
----------------------------------------------------------

function new( )
	
	local localGroup = display.newGroup()
	
	-- page title
	local title = display.newText("Weather", menuWidth + 10, 60, native.systemFont, 12)
	title:setTextColor(0,0,0)
	localGroup:insert(title)
	
	local myEnemy = display.newRect(200,200,100,100)
	myEnemy:setFillColor (255,0,0)
	localGroup:insert(myEnemy)
	
	return localGroup
	
end