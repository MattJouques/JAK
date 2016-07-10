module(..., package.seeall)
----------------------------------------------------------
-- Application: JAK
-- Resource: E6_B.lua
-- Version: 0.1
-- Last Edit: 24_10_12
----------------------------------------------------------

function new( )	
	
	local localGroup = display.newGroup()
	
	--Dependencies
	local jakM = require "jak"
	local widget = require "widget"											-- Require the Widget module
	local db = _G.db											   			-- Set the database
	widget.setTheme( "theme" )									 			-- Set the theme

----------------------------------------------------------
-- UI Functions --
----------------------------------------------------------
	--Required Variables
	local scratchY, scratchX, scratchW, scratchH  				 			-- Define scratchpad attributes
	local scratchText = {} 													-- Define table to store scratchpad text items
	local scratchPad 						  								-- Define the Scratchpad variable
	local Screen, ScreenInd1, ScreenInd2, ScreenInd3			   			-- Define output screen variables
	local workX, workY, workW, workH 							  			-- Define work area attributes
	local convertFrom, convertTo								   			-- Define conversion UOM variables
	local CalcInput = {}										   			-- Define Calculator Input table
	local calcOperand1, calcOperand2					   					-- Define the calculator Operand variables
	local calcOperator      									   			-- Current Operator for calculation
	local calcRes, convRes		  									       -- Define the Results table
	local hand 																-- User setting 

-- Calculator Button Creator
	local function createCalcBtn(n, l, Bx, By)					 			-- Function to create calculator buttons
		if not n then return end
		if not l then return end
		if not Bx then return end
		if not By then return end	
		-- Build the button
		local CalcBtn = widget.newButton{
			style = "CalcBtn",
			id = n,
			left = Bx,
    		top = By,
    		label = l,
			}
	return CalcBtn
	end
--UOM Button Creator
	local function createUomBtn(n, l, Bx, By)					  			-- Function to create UOM buttons
		local uomBtn = widget.newButton {
			style = "UOMBtn",
			id = n,
			left = Bx,
    		top = By,
    		label = l,
		}
		return uomBtn
	end
--Selctor Button Creator
	local function createSelectorBtn(n, l, Bx, By)					  		-- Function to create UOM buttons
		local SelectorBtn = widget.newButton {
			style = "SelectorBtn",
			id = n,
			left = Bx,
    		top = By,
    		label = l,
		}
		return SelectorBtn
	end

-- Refresh the Screen
	local function refreshScreen()					 		 				-- Function to refresh the screen components
		-- Scratchpad
		if #scratchText == 30 then table.remove ( scratchText ) end 			-- Trim the history
		scratchPad.text = table.concat(scratchText, " \n")				  	-- Add history to scratchPad
		-- Save scratchpad to Db
		local scratchCur =  (table.concat(scratchText, ","))
		local scratchDbQ = [[UPDATE AppWIP SET Value = "]] .. scratchCur ..[[" WHERE Item = "scratchPad"]]
		assert (db:exec(scratchDbQ), "Update scratchPad Failed")
		--print("scratchPad saved to Db")
		-- Indicators
		if convertFrom ~= nil then 											 -- Check to see if conversion in progress
			ScreenInd2.text = convertFrom 									  -- Set Indicator to show convert from
			if convertTo ~= nil then 										   -- Check to see if convertTo set
				ScreenInd3.text = convertTo   								  -- Set Indicator to show convert to
			else
				ScreenInd3.text = "" 		 								  -- Clear Indicator 3
				ScreenInd3.text = calcOperator								  -- Clear Indicator 3
			end
		elseif calcOperator ~= nil then 										-- check for calculation
				ScreenInd2.text = calcOperator								  -- Set Indicator to show operator
				Screen.text = ""
		else
			ScreenInd2.text = "" 
			ScreenInd3.text = "" 		
		end
		-- Screen
		if tonumber (table.concat(CalcInput)) == nil then 				  	-- Check to see if input been cleared
			Screen.text = tonumber(calcOperand1) 							   -- Set Screen to show result	
		else 																   -- Otherwise show current input
			Screen.text = table.concat(CalcInput) 
		end
		--print("Ref: calcOperand1 = ", calcOperand1)
		--print("Ref: calcOperator = ", calcOperator)
		--print("Ref: calcOperand2 = ", calcOperand2)
		--print("Ref: calcInput = ", table.concat(CalcInput))
		--print("Ref: calcRes = ", calcRes)
		--print("Ref: convertFrom = ", convertFrom)
		--print("Ref: convertTo = ", convertTo)
		--print("Ref: convRes = ", convRes)
		--print("Refresh complete")
	end

-- Set the conversion items 
	local function UOMProcess()
		-- Check conversion UOM
		if convertTo == convertFrom then convertTo = nil end 				   -- Cancel a duplicate selection
		ScreenInd2.text = convertFrom 										  -- Set Indicator
		if convertTo == nil then return end 					  			  -- wait for covert to UOM selection
		ScreenInd3.text = convertTo 							  			  -- Set Indicator
		-- Get conversion input
		if calcOperand1 == nil then 											-- Check for existing operand1
			calcOperand1 = tonumber(table.concat ( CalcInput ))				 -- if not set current input
			--print("UOM: calcOperand1 = ", calcOperand1)
		end
		if calcOperand1 ~= nil then 								 		   -- Wait for a conversion value
			convRes = jakM.conversion(convertFrom, convertTo, calcOperand1)	 -- Perform the conversion
			local scratchUpdate = "Convert " .. calcOperand1 .. " " .. convertFrom .. " = " .. convRes  .. " " .. convertTo
			table.insert ( scratchText, 1, scratchUpdate )					  -- Update the scratchpad
			calcOperand1 = convRes
			calcOperand2 = nil
			convertFrom = convertTo
			convertTo = nil
			CalcInput = {}
			calcRes = nil
			refreshScreen()
		else
			table.insert ( scratchText, 1, "Convert from " .. convertFrom .. " to " .. convertTo)
			refreshScreen()
		end
	end

-- Equals
local function Equals ( event )
	if event.phase == "ended" then
		--print("Equals:", calcOperand1, calcOperator, calcOperand2)
		if convertTo ~= nil then UOMProcess() end
		if tonumber(calcOperand1) == nil then return false end
		if tonumber(calcOperand2) == nil then 
			calcOperand2 = table.concat(CalcInput)
		end
		if calcOperator == "+" then 
			calcRes = (tonumber ( calcOperand1 )) + (tonumber(calcOperand2))
			table.insert ( scratchText, 1, "Calculate " .. calcOperand1 .. " + " .. calcOperand2 .. " = " .. calcRes)
			calcOperand1 = calcRes
			calcOperand2 = nil
			calcOperator = nil
			CalcInput = {}
			calcRes = nil
		end
		--print("Equals: calcOperand1 = ", calcOperand1)
		--print("Equals: calcOperand2 = ", calcOperand2)
		--print("Equals: calcInput = ", table.concat(CalcInput))
		--print("Equals: calcRes = ", calcRes)
		--print("Equals: convertFrom = ", convertFrom)
		--print("Equals: convertTo = ", convertTo)
		--print("Equals: convRes = ", convRes)
		--print("Equals complete")
		refreshScreen()
	end
end
-- Clear the scratchPad
	local function scratchClr( event )
		if event.phase == "ended" then
			scratchText = {}
			refreshScreen()
		end
	end
-- UOM functions
	-- Nm
	local function BtnNmF( event )
		if event.phase == "ended" then
			if convertFrom == nil then convertFrom = "Nm" else convertTo = "Nm" end
			UOMProcess()
		end
	end
	-- Sm
	local function BtnSmF( event )
		if event.phase == "ended" then
			if convertFrom == nil then convertFrom = "Sm" else convertTo = "Sm" end
			UOMProcess()
		end
	end
	-- Km
	local function BtnKmF( event )
		if event.phase == "ended" then
			if convertFrom == nil then convertFrom = "Km" else convertTo = "Km" end
			UOMProcess()
		end
	end
	-- Ft
	local function BtnFtF( event )
		if event.phase == "ended" then
			if convertFrom == nil then convertFrom = "Ft" else convertTo = "Ft" end
			UOMProcess()
		end
	end
	-- M
	local function BtnMF( event )
		if event.phase == "ended" then
			if convertFrom == nil then convertFrom = "M" else convertTo = "M" end
			UOMProcess()
		end
	end
	-- Kg
	local function BtnKgF( event )
		if event.phase == "ended" then
			if convertFrom == nil then convertFrom = "Kg" else convertTo = "Kg" end
			UOMProcess()
		end
	end
	-- Lb
	local function BtnLbF( event )
		if event.phase == "ended" then
			if convertFrom == nil then convertFrom = "Lb" else convertTo = "Lb" end
			UOMProcess()
		end
	end
	-- USG
	local function BtnUSGF( event )
		if event.phase == "ended" then
			if convertFrom == nil then convertFrom = "USG" else convertTo = "USG" end
			UOMProcess()
		end
	end
	-- G
	local function BtnGF( event )
		if event.phase == "ended" then
			if convertFrom == nil then convertFrom = "G" else convertTo = "G" end
			UOMProcess()
		end
	end
	-- L
	local function BtnLF( event )
		if event.phase == "ended" then
			if convertFrom == nil then convertFrom = "L" else convertTo = "L" end
			UOMProcess()
		end
	end
	-- Fpm
	local function BtnFpmF( event )
		if event.phase == "ended" then
			if convertFrom == nil then convertFrom = "Fpm" else convertTo = "Fpm" end
			UOMProcess()
		end
	end
	-- Mpm
	local function BtnMpmF( event )
		if event.phase == "ended" then
			if convertFrom == nil then convertFrom = "Mpm" else convertTo = "Mpm" end
			UOMProcess()
		end
	end
	-- Kts
	local function BtnKtsF( event )
		if event.phase == "ended" then
			if convertFrom == nil then convertFrom = "Kts" else convertTo = "Kts" end
			UOMProcess()
		end
	end
	-- Mph
	local function BtnMphF( event )
		if event.phase == "ended" then
			if convertFrom == nil then convertFrom = "Mph" else convertTo = "Mph" end
			UOMProcess()
		end
	end
	-- Kmh
	local function BtnKmhF( event )
		if event.phase == "ended" then
			if convertFrom == nil then convertFrom = "Kmh" else convertTo = "Kmh" end
			UOMProcess()
		end

	end

-- Calculator
	--0
	local function Zero( event )
		if event.phase == "ended" then
			table.insert ( CalcInput, 0 )
			refreshScreen()
		end
	end
	--1
	local function One( event )
		if event.phase == "ended" then
			table.insert ( CalcInput, 1 )
			refreshScreen()
		end
	end
	--2
	local function Two( event )
		if event.phase == "ended" then
			table.insert ( CalcInput, 2 )
			refreshScreen()
		end
	end
	--3
	local function Three( event )
		if event.phase == "ended" then
			table.insert ( CalcInput, 3 )
			refreshScreen()
		end
	end
	--4
	local function Four( event )
		if event.phase == "ended" then
			table.insert ( CalcInput, 4 )
			refreshScreen()
		end
	end
	--5
	local function Five( event )
		if event.phase == "ended" then
			table.insert ( CalcInput, 5 )
			refreshScreen()
		end
	end
	--6
	local function Six( event )
		if event.phase == "ended" then
			table.insert ( CalcInput, 6 )
			refreshScreen()
		end
	end
	--7
	local function Seven( event )
		if event.phase == "ended" then
			table.insert ( CalcInput, 7 )
			refreshScreen()
		end

	end
	--8
	local function Eight( event )
		if event.phase == "ended" then
			table.insert ( CalcInput, 8 )
			refreshScreen()
		end
	end
	--9
	local function Nine( event )
		if event.phase == "ended" then
			table.insert ( CalcInput, 9 )
			refreshScreen()
		end
	end
	--decimal
	local function Dec( event )
		if event.phase == "ended" then
			if decimal == true then return end
			table.insert ( CalcInput, "." )
			decimal = true
			refreshScreen()
		end
	end
	--C
	local function C( event )
		if event.phase == "ended" then
			CalcInput = {}												-- Clear Calculator Input
			convertFrom = nil 											-- Clear Conversion from
			convertTo = nil 											  -- Clear Conversion to
			calcRes = nil 												-- clear Calculation Result
			convRes = nil 												-- Clear Conversion result
			calcOperand1 = nil 										   -- Clear Operand1
			calcOperand2 = nil 										   -- Clear Operand2
			calcOperator = nil 										   -- Clear Operator
			refreshScreen()
		end

	end
	--+/-
	local function Neg( event )
		if event.phase == "ended" then
			if CalcInput[1] == "-" then
				table.remove ( CalcInput, 1 )
			else
				table.insert ( CalcInput, 1, "-" )
			end
			refreshScreen()
		end
	end

-- Process Functions

-- Plus
local function Plus ( event )
	if event.phase == "ended" then
		calcOperator = "+"
		if calcOperand1 == nil then 		  									-- Check if already have operand1
			calcOperand1 = tonumber( table.concat(CalcInput) )					-- if not set as current input
			CalcInput = {}														-- Clear the current input
		else 
			if tonumber( table.concat(CalcInput) ) ~= nil then 
				calcOperand2 = tonumber( table.concat(CalcInput) )				-- if have Operand1 set current input to op2
				calcRes = tonumber(calcOperand1) + tonumber(calcOperand2)		 -- Perform the calculation
				calcOperand1 = calcRes 										   -- set Operand1 to result				
				calcOperand2 = nil 											   -- Clear operand2
				calcRes = nil 
				convRes = nil
				CalcInput = {} 
			end
		end
		refreshScreen()
	end
end

----------------------------------------------------------
-- UI workspace Objects --
----------------------------------------------------------

	-- page title
	local title = display.newText("E6-B", menuWidth + 10, 60, native.systemFont, 12)
	title:setTextColor(0,0,0)
	localGroup:insert(title)
	
-- Object Space Definitions

	for row in db:nrows([[SELECT Value FROM Config WHERE Key = "Hand"]]) do 
		hand = row.Value
	end

	-- Set the relative hand
	if hand == "left" then 								-- Determine Left or Right Handed User and set Work area
		scratchY = _G.rightpanelY
		scratchX = _G.rightpanelX + 40
		scratchW = _G.rightpanelW - 10
		scratchH = _G.rightpanelH
		workX = _G.leftpanelX
		workY = _G.leftpanelY
		workW = _G.leftpanelW - 15
		workH = _G.leftpanelH
	else
		scratchY = _G.leftpanelY
		scratchX = _G.leftpanelX
		scratchW = _G.leftpanelW - 15
		scratchH = _G.leftpanelH
		workX = _G.rightpanelX + 40
		workY = _G.rightpanelY
		workW = _G.rightpanelW - 10
		workH = _G.rightpanelH
	end
	-- Sub-Divide the workspace
	local calcX = workX
	local calcY = workY + 275
	local calcW = workW
	local calcH = workH - 225
	local selectorX = workX
	local selectorY = workY + 75
	local selectorW = workW
	local selectorH = 150
	local screenX = workX
	local screenY = workY + 50
	local screenW = workW
	local screenH = 75

	-- Calculator Layout
	local CalcCol1 = calcX + 20
	local CalcCol2 = calcX + 120
	local CalcCol3 = calcX + 200
	local CalcCol4 = calcX + 280
	local CalcCol5 = calcX + 360
	local CalcRow1 = calcY + 50
	local CalcRow2 = CalcRow1 + 50
	local CalcRow3 = CalcRow2 + 50
	local CalcRow4 = CalcRow3 + 50
	local CalcRow5 = CalcRow4 + 50
	local CalcRow6 = CalcRow5 + 50

	-- Selector Layout
	local selCol1 = selectorX + 16
	local selCol2 = selCol1 + 60
	local selCol3 = selCol2 + 60
	local selCol4 = selCol3 + 60
	local selCol5 = selCol4 + 60
	local selCol6 = selCol5 + 60
	local selCol7 = selCol6 + 60
	local selRow1 = selectorY + 100
	local selRow2 = selRow1 + 50
	local selRow3 = selRow2 + 50

-- Draw Work Object
	--work object shadow
	local workSdwB = display.newImageRect("images/shadowB.png", workW - 10, 10)
		workSdwB:setReferencePoint( display.TopLeftReferencePoint )
		workSdwB.x = workX + 10
		workSdwB.y = workY + workH
		localGroup:insert(workSdwB)
	local workSdwR = display.newImageRect("images/shadowR.png", 10, workH - 10)
		workSdwR:setReferencePoint( display.BottomLeftReferencePoint )
		workSdwR.x = workX + workW
		workSdwR.y = workY + workH
		localGroup:insert(workSdwR)	
	local WorkSdwTR = display.newImageRect("images/shadowTR.png", 10, 10)
		WorkSdwTR:setReferencePoint( display.TopLeftReferencePoint )
		WorkSdwTR.x = workX + workW
		WorkSdwTR.y = workY
		localGroup:insert(WorkSdwTR)	
	local workSdwBR = display.newImageRect("images/shadowBR.png", 10, 10)
		workSdwBR:setReferencePoint( display.TopLeftReferencePoint )
		workSdwBR.x = workX + workW
		workSdwBR.y = workY + workH
		localGroup:insert(workSdwBR)	
	local workSdwBL = display.newImageRect("images/shadowBL.png", 10, 10)
		workSdwBL:setReferencePoint( display.TopLeftReferencePoint )
		workSdwBL.x = workX
		workSdwBL.y = workY + workH
		localGroup:insert(workSdwBL)	

-- Draw ScratchPad Object 
	--scratchpad shadow
	local SplashSdwB = display.newImageRect("images/shadowB.png", scratchW - 10, 10)
		SplashSdwB:setReferencePoint( display.TopLeftReferencePoint )
		SplashSdwB.x = scratchX + 10
		SplashSdwB.y = scratchY + scratchH
		localGroup:insert(SplashSdwB)
	local SplashSdwR = display.newImageRect("images/shadowR.png", 10, scratchH - 10)
		SplashSdwR:setReferencePoint( display.BottomLeftReferencePoint )
		SplashSdwR.x = scratchX + scratchW
		SplashSdwR.y = scratchY + scratchH
		localGroup:insert(SplashSdwR)	
	local SplashSdwTR = display.newImageRect("images/shadowTR.png", 10, 10)
		SplashSdwTR:setReferencePoint( display.TopLeftReferencePoint )
		SplashSdwTR.x = scratchX + scratchW
		SplashSdwTR.y = scratchY
		localGroup:insert(SplashSdwTR)	
	local SplashSdwBR = display.newImageRect("images/shadowBR.png", 10, 10)
		SplashSdwBR:setReferencePoint( display.TopLeftReferencePoint )
		SplashSdwBR.x = scratchX + scratchW
		SplashSdwBR.y = scratchY + scratchH
		localGroup:insert(SplashSdwBR)	
	local SplashSdwBL = display.newImageRect("images/shadowBL.png", 10, 10)
		SplashSdwBL:setReferencePoint( display.TopLeftReferencePoint )
		SplashSdwBL.x = scratchX
		SplashSdwBL.y = scratchY + scratchH
		localGroup:insert(SplashSdwBR)	
	
----------------------------------------------------------
-- UI Components --
----------------------------------------------------------
--Scratchpad Panel
	-- ScratchPad Controls 
	-- Bar
	local scratchBarG = graphics.newGradient( {150,150,150}, {255,255,255}, up )
	local scratchBar = display.newRect( scratchX, scratchY, scratchW, 50 )
	scratchBar:setFillColor ( scratchBarG )
	localGroup:insert(scratchBar)
	-- Title
	local scratchBarT = display.newRetinaText(  "scratchPad", scratchX + 20, scratchY + 10, native.systemFontBold, 18 )
	scratchBarT:setTextColor(150,150,150)
	-- Clear Button
	local scratchBtn = widget.newButton{
		style = "iosBtn",
		id = scratchBtn,
		label = "Clear",
		left = scratchX + scratchW - 70,
    	top = scratchY + 10
	}
	-- ScratchPad
	scratchPad = native.newTextBox(scratchX, scratchY + 50, scratchW, scratchH - 50)
	scratchPad.font = native.newFont ( "Monaco", 14 )
	scratchPad:setTextColor(150,150,150)
	localGroup:insert(scratchPad)
	-- Read in current scratchpad from db
	for row in db:nrows([[SELECT Value FROM AppWIP WHERE Item = "scratchPad"]]) do 
		local scratchTmp = row.Value
		local value
    	for value in scratchTmp:gmatch("[^,]*") do
			if value ~= "" then
				--print("scarcthDB read = ", value)
				table.insert (scratchText, 1, value)
			end
		end
    end
	scratchPad.text = table.concat (scratchText, "\n")
-- Calculator
	--background for calculator and selector merged
	local bgG = graphics.newGradient( {255,255,255}, {100,100,100}, down )
	local CalcBg = display.newRect(calcX, selectorY, calcW, calcH + selectorH)
	CalcBg:setFillColor ( bgG )
	localGroup:insert(CalcBg)

	-- Bar
	local calcBarG = graphics.newGradient( {150,150,150}, {255,255,255}, up )
	local calcBar = display.newRect( workX, workY, workW, 50 )
	calcBar:setFillColor ( calcBarG )
	localGroup:insert(calcBar)
	-- Title
	local calcBarT = display.newRetinaText(  "E6-B Calculator", screenX + 20, workY + 10, native.systemFontBold, 18 )
	calcBarT:setTextColor(150,150,150)

	--Calculator Buttons

	-- 2nd Row
	local BtnC = createCalcBtn("BtnC", "C", CalcCol2, CalcRow2)
	local BtnNeg = createCalcBtn("BtnNeg", "+/-", CalcCol3, CalcRow2)
	local BtnDiv = createCalcBtn("BtnDiv", "÷", CalcCol4, CalcRow2)
	local BtnMul = createCalcBtn("BtnMul", "x", CalcCol5, CalcRow2)

	-- 3rd Row
	local Btn7 = createCalcBtn("Btn7", "7", CalcCol2, CalcRow3)
	local Btn8 = createCalcBtn("Btn8", "8", CalcCol3, CalcRow3)
	local Btn9 = createCalcBtn("Btn9", "9", CalcCol4, CalcRow3)
	local BtnMin = createCalcBtn("BtnMin", "-", CalcCol5, CalcRow3)

	-- 4th Row
	local Btn4 = createCalcBtn("Btn4", "4", CalcCol2, CalcRow4)
	local Btn5 = createCalcBtn("Btn5", "5", CalcCol3, CalcRow4)
	local Btn6 = createCalcBtn("Btn6", "6", CalcCol4, CalcRow4)
	local BtnPlus = createCalcBtn("BtnPlus", "+", CalcCol5, CalcRow4)

	-- 5th Row
	local Btn1 = createCalcBtn("Btn1", "1", CalcCol2, CalcRow5)
	local Btn2 = createCalcBtn("Btn2", "2", CalcCol3, CalcRow5)
	local Btn3 = createCalcBtn("Btn3", "3", CalcCol4, CalcRow5)
	local EqualBtn = widget.newButton{
		style = "EqualBtn",
		id = EqualBtn,
		label = "=",
		left = CalcCol5,
    	top = CalcRow5
	}

	-- 6th Row
	local ZeroBtn = widget.newButton{
		style = "ZeroBtn",
		id = ZeroBtn,
    	label = "0",
		left = CalcCol2,
    	top = CalcRow6
	}
	local BtnDec = createCalcBtn("BtnDec", ".", CalcCol4, CalcRow6)

--Screen (calculator)
	-- Object background
	local screenBg = display.newRect(screenX, screenY, screenW, screenH + 25)
	screenBg:setFillColor ( 255,255,255 )
	localGroup:insert(screenBg)
	-- Screen Display
	Screen = native.newTextField(screenX + 10, screenY +10, screenW - 70, screenH)
	Screen:setTextColor(150,150,150)
	Screen.font = native.newFont(native.systemFontBold, 40)
	Screen.align = "right"
	localGroup:insert(Screen)

--Screen UOM Indicators

	-- Define Indicator Height
	local IndicatorH = screenH / 3

	-- Level 1 indicator
	ScreenInd1 = native.newTextField(screenX + screenW - 60, screenY + 10, 50, IndicatorH)
	ScreenInd1:setTextColor(200,200,200)
	ScreenInd1.font = native.newFont(native.systemFontBold, 15)
	ScreenInd1.align = "left"
	ScreenInd1.text = "Calc"
	localGroup:insert(ScreenInd1)

	-- Level 2 indicator
	ScreenInd2 = native.newTextField(screenX + screenW - 60, screenY + 10 + IndicatorH, 50, IndicatorH)
	ScreenInd2:setTextColor(200,200,200)
	ScreenInd2.font = native.newFont(native.systemFontBold, 15)
	ScreenInd2.align = "left"
	localGroup:insert(ScreenInd2)

	-- Level 3 indicator
	ScreenInd3 = native.newTextField(screenX + screenW - 60, screenY + 10 + IndicatorH * 2, 50, IndicatorH)
	ScreenInd3:setTextColor(200,200,200)
	ScreenInd3.font = native.newFont(native.systemFontBold, 15)
	ScreenInd3.align = "left"
	localGroup:insert(ScreenInd2)

--Level 1 Selector buttons
	local BtnDst = createSelectorBtn("Btn4", "Dist", selCol1, selRow1)
	local BtnWgt = createSelectorBtn("BtnWgt", "Wgt", selCol2, selRow1)
	local BtnVol = createSelectorBtn("BtnVol", "Vol", selCol3, selRow1)
	local BtnSpd = createSelectorBtn("BtnSpd", "Spd", selCol4, selRow1)
	local BtnTrk = createSelectorBtn("BtnTrk", "Trk", selCol5, selRow1)
	local BtnWx = createSelectorBtn("BtnWx", "Wx", selCol6, selRow1)
	local BtnCal = createSelectorBtn("BtnCal", "Calc", selCol7, selRow1)

--Level 2 Selector buttons
	local uomGroup = display.newGroup()

	--Distance
	local function distance( event )
		if event.phase == "ended" then
			-- Clean up 
			convertFrom = nil
			convertTo = nil
			display.remove (uomGroup)
			uomGroup = display.newGroup()
			-- Draw Level 2 buttons
			local BtnNm = createUomBtn("BtnNm", "Nm", selCol1, selRow2)
			BtnNm:addEventListener ( "touch", BtnNmF )
			uomGroup:insert( BtnNm )
			--localGroup:insert (BtnNm)
			local BtnSm = createUomBtn("BtnSm", "Sm", selCol2, selRow2)
			BtnSm:addEventListener ( "touch", BtnSmF )
			uomGroup:insert( BtnSm )
			--localGroup:insert (BtnSm)
			local BtnKm = createUomBtn("BtnKm", "Km", selCol3, selRow2)
			BtnKm:addEventListener ( "touch", BtnKmF )
			uomGroup:insert( BtnKm )
			local BtnFt = createUomBtn("BtnNm", "Ft", selCol4, selRow2)
			BtnFt:addEventListener ( "touch", BtnFtF )
			uomGroup:insert( BtnFt )
			local BtnM = createUomBtn("BtnNm", "M", selCol5, selRow2)
			BtnM:addEventListener ( "touch", BtnMF )
			uomGroup:insert( BtnM )
			--Set Indicator
			ScreenInd1.text = "Dst"
			ScreenInd2.text = ""
			ScreenInd3.text = ""
		end
		refreshScreen()
	end

	--Weight
	local function weight( event )
		if event.phase == "ended" then
			-- Clean up 
			convertFrom = nil
			convertTo = nil
			display.remove (uomGroup)
			uomGroup = display.newGroup()
			-- Draw Level 2 buttons
			local BtnKg = createUomBtn("BtnKg", "Kg", selCol1, selRow2)
			BtnKg:addEventListener ( "touch", BtnKgF )
			uomGroup:insert (BtnKg)
			local BtnLb = createUomBtn("BtnLb", "Lb", selCol2, selRow2)
			BtnLb:addEventListener ( "touch", BtnLbF )
			uomGroup:insert (BtnLb)
			local BtnUSG = createUomBtn("BtnUSG", "USG", selCol3, selRow2)
			BtnUSG:addEventListener ( "touch", BtnUSGF )
			uomGroup:insert (BtnUSG)
			local BtnL = createUomBtn("BtnL", "L", selCol4, selRow2)
			BtnL:addEventListener ( "touch", BtnLF )
			uomGroup:insert (BtnL)
			ScreenInd1.text = "Wgt"
			ScreenInd2.text = ""
			ScreenInd3.text = ""
		end
		refreshScreen()
	end

	-- Volume
	local function volume( event )
		if event.phase == "ended" then
			-- Clean up 
			convertFrom = nil
			convertTo = nil
			display.remove (uomGroup)
			uomGroup = display.newGroup()
			-- Draw Level 2 buttons
			local BtnUSG = createUomBtn("BtnUSG", "USG", selCol1, selRow2)
			BtnUSG:addEventListener ( "touch", BtnUSGF )
			uomGroup:insert (BtnUSG)
			local BtnL = createUomBtn("BtnL", "L", selCol2, selRow2)
			BtnL:addEventListener ( "touch", BtnLF )
			uomGroup:insert (BtnL)
			local BtnG = createUomBtn("BtnG", "G", selCol3, selRow2)
			BtnG:addEventListener ( "touch", BtnGF )
			uomGroup:insert (BtnG)
			ScreenInd1.text = "Vol"
			ScreenInd2.text = ""
			ScreenInd3.text = ""
		end
		refreshScreen()
	end

	-- Speed
	local function speed( event )
	if event.phase == "ended" then
		-- Clean up 
		convertFrom = nil
		convertTo = nil
		display.remove (uomGroup)
		uomGroup = display.newGroup()
		-- Draw Level 2 buttons
		local BtnFpm = createUomBtn("BtnFpm", "Fpm", selCol1, selRow2)
		BtnFpm:addEventListener ( "touch", BtnFpmF )
		uomGroup:insert (BtnFpm)
		local BtnMpm = createUomBtn("BtnMpm", "Mpm", selCol2, selRow2)
		BtnMpm:addEventListener ( "touch", BtnMpmF )
		uomGroup:insert (BtnMpm)
		local BtnKts = createUomBtn("BtnKts", "Kts", selCol3, selRow2)
		BtnKts:addEventListener ( "touch", BtnKtsF )
		uomGroup:insert (BtnKts)
		local BtnMph = createUomBtn("BtnMph", "Mph", selCol4, selRow2)
		BtnMph:addEventListener ( "touch", BtnMphF )
		uomGroup:insert (BtnMph)
		local BtnKmh = createUomBtn("BtnKmh", "Kmh", selCol5, selRow2)
		BtnKmh:addEventListener ( "touch", BtnKmhF )
		uomGroup:insert (BtnKmh)
		ScreenInd1.text = "Spd"
		ScreenInd2.text = ""
		ScreenInd3.text = ""
	end
	refreshScreen()
end

-- Track UOM Functions

-- Wx UOM Functions

-- Calc Operator Functions

----------------------------------------------------------
-- Listeners --
----------------------------------------------------------
	--Selector button events
	BtnDst:addEventListener ( "touch", distance )
	BtnWgt:addEventListener ( "touch", weight )
	BtnVol:addEventListener ( "touch", volume )
	BtnSpd:addEventListener ( "touch", speed )

	-- Calculator button events
	Btn1:addEventListener ( "touch", One )
	Btn2:addEventListener ( "touch", Two )
	Btn3:addEventListener ( "touch", Three )
	Btn4:addEventListener ( "touch", Four )
	Btn5:addEventListener ( "touch", Five )
	Btn6:addEventListener ( "touch", Six )
	Btn7:addEventListener ( "touch", Seven )
	Btn8:addEventListener ( "touch", Eight )
	Btn9:addEventListener ( "touch", Nine )
	ZeroBtn:addEventListener ( "touch", Zero )
	EqualBtn:addEventListener ( "touch", Equals )
	BtnDec:addEventListener ( "touch", Dec )
	BtnC:addEventListener ( "touch", C )
	BtnNeg:addEventListener ( "touch", Neg )
	BtnPlus:addEventListener( "touch" , Plus)

	--Other Button events
	scratchBtn:addEventListener( "touch" , scratchClr)
	
----------------------------------------------------------
	return localGroup
end
----------------------------------------------------------