module(..., package.seeall)
----------------------------------------------------------
-- Application: JAK
-- Resource: splash.lua
-- Version: 0.1
-- Last Edit: 12_10_12
----------------------------------------------------------

function new( )
	local widget = require "widget"
	local localGroup = display.newGroup()
	
	-- background
	local background = display.newRect(0,0,display.contentWidth,display.contentHeight)
	background:setFillColor (255,255,255)
	localGroup:insert(background)
	
	-- page title
	local title = display.newText("Splash", menuWidth + 10, 60, native.systemFont, 12)
	title:setTextColor(0,0,0)
	localGroup:insert(title)
	
	--Show the Splash Image
	local SplashImage = display.newImageRect( "images/caraceus.png", 200, 200 )
	SplashImage:setReferencePoint( display.CenterReferencePoint )
	SplashImage.x = display.contentCenterX
	SplashImage.y = display.contentCenterY
	localGroup:insert(SplashImage)
		
	--Remove company logo and load startup checklist
	local function changeSplash( event )
		SplashImage:removeSelf()
		SplashImage = nil
		startupChkBg()
	end
	
	--StartupChecklist
	function startupChkBg ()
		--Dependencies
		--local tests = require "tests"
		
		--Define Checklist Background
		local chkBg = display.newRect( 100, display.contentCenterY - 200, display.contentWidth -200 , 400 )
		--chkBg:setFillColor(253, 253, 253)
		localGroup:insert(chkBg)
		
		-- Results table dimensions
		local check1y = display.contentCenterY - 160
		local check2y = check1y + 40
		local check3y = check2y + 40
		local checkLx = 100
		local checkRx = 400
		
		-- Database status checks
		local check1L = display.newLine(checkLx, check1y, checkRx, check1y) 
		check1L:setColor(250,250,250)
		localGroup:insert(check1L)
		
		local check1 = display.newText("Database status checks", checkLx + 10, check1y - 30, native.systemFont, 16)
		check1:setTextColor(0, 0, 0)
		localGroup:insert(check1)
		
		--Database Test
		local databaseTest = false 			--To do - Write database test
		local databaseTestImg, status
		if databaseTest == true then
			databaseTestImg = display.newImageRect( "images/pass.png", 200, 200 )
		else 
			databaseTestImg = display.newImageRect( "images/fail.png", 200, 200 )
		end
		databaseTestImg:setReferencePoint( display.CenterReferencePoint )
		databaseTestImg.x = checkLx - 20
		databaseTestImg.y = check1y - 20
		databaseTestImg.width = 25
		databaseTestImg.height = 25
		localGroup:insert(databaseTestImg)
				
		-- Conversions status checks
		local check2L = display.newLine(checkLx, check2y, checkRx, check2y) 
		check2L:setColor(250,250,250)
		localGroup:insert(check2L)
		
		local check2 = display.newText("Conversions tests", checkLx + 10, check2y - 30, native.systemFont, 16)
		check2:setTextColor(0, 0, 0)
		localGroup:insert(check2)
		
		--Conversion Test
		local conversionTest = true			--To do - Write conversion test
		local conversionTestImg, status
		if conversionTest == true then
			conversionTestImg = display.newImageRect( "images/pass.png", 200, 200 )
		else 
			conversionTestImg = display.newImageRect( "images/fail.png", 200, 200 )
		end
		conversionTestImg:setReferencePoint( display.CenterReferencePoint )
		conversionTestImg.x = checkLx - 20
		conversionTestImg.y = check2y - 20
		conversionTestImg.width = 25
		conversionTestImg.height = 25
		localGroup:insert(conversionTestImg)
		
		-- Navgation status checks
		local check3L = display.newLine(checkLx, check3y, checkRx, check3y) 
		check3L:setColor(250,250,250)
		localGroup:insert(check3L)
		
		local check3 = display.newText("Navigation tests", checkLx + 10, check3y - 30, native.systemFont, 16)
		check3:setTextColor(0, 0, 0)
		localGroup:insert(check3)
		
		--Navigation Test
		local navigationTest = true			--To do - Write Navigation test
		local navigationTestImg, status
		if navigationTest == true then
			navigationTestImg = display.newImageRect( "images/pass.png", 200, 200 )
		else 
			navigationTestImg = display.newImageRect( "images/fail.png", 200, 200 )
		end
		navigationTestImg:setReferencePoint( display.CenterReferencePoint )
		navigationTestImg.x = checkLx - 20
		navigationTestImg.y = check3y - 20
		navigationTestImg.width = 25
		navigationTestImg.height = 25
		localGroup:insert(navigationTestImg)

	--Disclaimer
		--Title
		local discTitle = display.newText( "Disclaimer", display.contentWidth / 2 - 50, check3y + 100, native.systemFont, 16 )
		discTitle:setTextColor(0,0,0,255)
		localGroup:insert(discTitle)
		--Title
		local discP1 = display.newText( [[This software does not replace the flight planning and preparation as required and considered acceptable by the respresentative ]], checkLx - 50, check3y + 150, native.systemFont, 14 )
		discP1:setTextColor(0,0,0,255)
		localGroup:insert(discP1)
		local discP2 = display.newText( [[aviation authorities, nor does it replace any advice or activity as provided by an authorised flight training instructor.]], checkLx - 50, check3y + 175, native.systemFont, 14 )
		discP2:setTextColor(0,0,0,255)
		localGroup:insert(discP2)
		local discP3 = display.newText( [[This software is not to be used as the sole source of flight planning information, and its use is provided entirely at the]], checkLx - 50, check3y + 200, native.systemFont, 14 )
		discP3:setTextColor(0,0,0,255)
		localGroup:insert(discP3)
		local discP4 = display.newText( [[risk of the user. By using this software, and by acknowledging this message, you agree to indemnify the developer, company and]], checkLx - 50, check3y + 225, native.systemFont, 14 )
		discP4:setTextColor(0,0,0,255)
		localGroup:insert(discP4)
		local discP5 = display.newText( [[any associated parties from any claim or damages from any direct or indirect association with the use of this software.]], checkLx - 50, check3y + 250, native.systemFont, 14 )
		discP5:setTextColor(0,0,0,255)
		localGroup:insert(discP5)
		
		-- Agree Button
		local function showAckBtn()
			-- Agree Button Function
			local AckBtnF = function ( event )
				if event.phase == "release" then
				director:changeScene( "dashboard", "crossfade" )
				end
			end
			-- Agree Button
			local AckBtn = widget.newButton{
			onEvent = AckBtnF,
			id = "AckBtn",
			left = appWidth - 100,
    		top = appHeight - 150,
    		width = 100, height = 100,
			default = ("images/agree.jpg")
			}
			localGroup:insert(AckBtn)
		end
		
		-- Ack buton timer
		timer2 = timer.performWithDelay(1500, showAckBtn)
	
	end

--Timers
	-- company logo timer
	timer1 = timer.performWithDelay(1500, changeSplash)
	
	return localGroup
end