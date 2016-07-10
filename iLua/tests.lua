-- tests.lua
----------------------------------------------------------
-- Application: JAK
-- Resource: tests.lua
-- Version: 0.1
-- Last Edit: 05_10_12
----------------------------------------------------------

module(..., package.seeall);

----------------------------------------------------------

function Execute()

Accumulator = 0
local testStatus = nil

--Completed tests
configUpdate()   -- Update the user config
Conversions()    -- Unit Conversions

--WIP Tests

calcHeading()    -- Calc HDG incl Winds


--Not Started Tests
--tests.usrConversions()  -- User Unit Conversions
--tests.getNavAids()     -- Get NavAids Db
--tests.getWeather()     -- Get the weather from web
--tests.importGPX()      -- Import a route
--tests.importWypnt      -- Import ANP waypoints


if Accumulator == 3 then 
    print("Self Tests passed")
    Status = True
  else 
    print("Self Tests failed")
    Status = False
  end
  collectgarbage()
  k, b = collectgarbage("count")
  assert(k*1024 == math.floor(k)*1024 + b)
  print("Memory in use = ", jak.round(k), "Kb")
end

---------------------------------------------------------

--tests.configUpdate()   -- Update the user config

function configUpdate()

-- Inputs
  local testResult, testOrig, i, t, testInputKey, testInputValue

-- Test Execution
  testInputKey = jak.dbQ("Key" , "Config")
  testInputValue = jak.dbQ("Value" , "Config")
  jak.dbUpdate("Config", "Value", 999, [[Key = "Check"]])
  t = {jak.dbQ("Value" , "Config", [[Key = "Check"]])}
  if (table.unpack(t)) == [[999]] then
    Accumulator = Accumulator + 1
  else 
    print("! Config update failed")
  end
  jak.dbUpdate("Config", "Value", "1", [[Key = "Check"]])  -- Reset from Test
end

----------------------------------------------------------

--tests.Conversions()    -- Unit Conversions

function Conversions()

  local count = 0

-- C (28.5) to F (83.3)
local tR1 = (jak.unitConv([["C"]], 28.5, [["F"]]))
if tR1 == 83.3 then count = count + 1
else print("Failed: C (28.5) to F (83.3) : " .. tR1) end

-- F (75) to C (23.9)
local tR2 = (jak.unitConv([["F"]], 75, [["C"]]))
if tR2 == 23.9 then count = count + 1
else print("Failed: F (75) to C (23.9) : " .. tR2) end

-- Nm (571.6) to Sm (657.79)
local tR3 = (jak.unitConv([["Nm"]], 571.6, [["Sm"]]))
if tR3 == 657.79 then count = count + 1
else print("Failed: Nm (571.6) to Sm (657.79) : " .. tR3) end

-- Sm (54.9) to Nm (47.71)
local tR4 = (jak.unitConv([["Sm"]], 54.9, [["Nm"]]))
if tR4 == 47.71 then count = count + 1
else print("Failed: Sm (54.9) to Nm (47.71) : " .. tR4) end

-- Nm (82.4) to Km (152.60)
local tR5 = (jak.unitConv([["Nm"]], 82.4, [["Km"]]))
if tR5 == 152.60 then count = count + 1
else print("Failed: Nm (82.4) to Km (152.60) : " .. tR5) end

-- Km (29.4) to Nm (15.87)
local tR6 = (jak.unitConv([["Km"]], 29.4, [["Nm"]]))
if tR6 == 15.87 then count = count + 1
else print("Failed: Km (29.4) to Nm (15.87) : " .. tR6) end

-- Km (29.4) to Sm (18.27)
local tR7 = (jak.unitConv([["Km"]], 29.4, [["Sm"]]))
if tR7 == 18.27 then count = count + 1
else print("Failed: Km (29.4) to Sm (18.27) : " .. tR7) end

-- Sm (54.9) to Km (88.35)
local tR8 = (jak.unitConv([["Sm"]], 54.9, [["Km"]]))
if tR8 == 88.35 then count = count + 1
else print("Failed: Sm (54.9) to Km (88.35) : " .. tR8) end

-- Ft (86.4) to M (26.33)
local tR9 = (jak.unitConv([["Ft"]], 86.4, [["M"]]))
if tR9 == 26.33 then count = count + 1
else print("Failed: Ft (86.4) to M (26.33) : " .. tR9) end

-- M (786) to Ft (2578.74)
local tR10 = (jak.unitConv([["M"]], 786, [["Ft"]]))
if tR10 == 2578.74 then count = count + 1
else print("Failed: M (786) to Ft (2578.74) : " .. tR10) end

-- Lb (335) to Kg (151.95)
local tR11 = (jak.unitConv([["Lb"]], 335, [["Kg"]]))
if tR11 == 151.95 then count = count + 1
else print("Failed: Lb (335) to Kg (151.95) : " .. tR11) end

-- Kg (67.5) to Lb (148.81)
local tR12 = (jak.unitConv([["Kg"]], 67.5, [["Lb"]]))
if tR12 == 148.81 then count = count + 1
else print("Failed: Kg (67.5) to Lb (148.81) : " .. tR12) end

-- USG (571) to L (2161.47)
local tR13 = (jak.unitConv([["USG"]], 571, [["L"]]))
if tR13 == 2161.47 then count = count + 1
else print("Failed: USG (571) to L (2161.47)) : " .. tR13) end

-- L (74) to USG (19.55)
local tR14 = (jak.unitConv([["L"]], 74, [["USG"]]))
if tR14 == 19.55 then count = count + 1
else print("Failed: L (74) to USG (19.55) : " .. tR14) end

-- G (98.4) to USG (118.7)
local tR15 = (jak.unitConv([["G"]], 98.4, [["USG"]]))
if tR15 == 118.17 then count = count + 1
else print("Failed: G (98.4) to USG (118.17) : " .. tR15) end

-- USG (19.55) to G (16.28)
local tR16 = (jak.unitConv([["USG"]], 19.55, [["G"]]))
if tR16 == 16.28 then count = count + 1
else print("Failed: USG (19.55) to G (16.28) : " .. tR16) end

-- L (74) to G (16.28)
local tR17 = (jak.unitConv([["L"]], 74, [["G"]]))
if tR17 == 16.28 then count = count + 1
else print("Failed: L (74) to G (16.28) : " .. tR17) end

-- G (98.4) to L (447.34)
local tR18 = (jak.unitConv([["G"]], 98.4, [["L"]]))
if tR18 == 447.34 then count = count + 1
else print("Failed: G (98.4) to L (447.34) : " .. tR18) end

-- USG(38) to Lb (228) Avgas
--local tR19 = (jak.unitConv([["USG"]], 38, [["Lb"]]))
--if tR19 == 228 then count = count + 1
--else print("Failed: USG(38) to Lb (228) Avgas : " .. tR19) end

-- Lb (965) to USG (160.83) Avgas
--local tR20 = jak.round((jak.unitConv([["Lb"]], 28.5, [["USG"]])),2)
--if tR20 == 83.3 then count = count + 1
--else print("Failed: Lb (965) to USG (160.83) Avgas : " .. tR20) end

-- Hg (24.6) to hPa (833.05)
local tR21 = (jak.unitConv([["Hg"]], 24.6, [["hPa"]]))
if tR21 == 833.05 then count = count + 1
else print("Failed: Hg (24.6) to hPa (833.05) : " .. tR21) end

-- hPa(1024) to Hg (30.24)
local tR22 = (jak.unitConv([["hPa"]], 1024, [["Hg"]]))
if tR22 == 30.24 then count = count + 1
else print("Failed: hPa(1024) to Hg (30.24) : " .. tR22) end

--Test Results
  if count == 20 then Accumulator = Accumulator + 1
  else
    print("! Converion tests Failed " .. count .. "/20 passed")
  end
return  
end

----------------------------------------------------------

--tests.usrConversions()    -- Usr Unit Conversions

function usrConversions()

-- Inputs
  --print(usrDistance)
  --print(usrHeight)
  --print(usrLength)
  --print(usrPressure)
  --print(usrSpeed)
  --print(usrTemp)
  --print(usrVolume)
  --print(usrWeight)

-- Test Execution
  
  
-- Test Results

-- Expected Results
  
end

----------------------------------------------------------

--tests.getNavAids()     -- Get NavAids Db

--tests.getWeather()     -- Get the weather from web

--tests.importGPX()      -- Import a route

--tests.importWypnt      -- Import ANP waypoints

----------------------------------------------------------

--tests.calcHeading()    -- Calc HDG incl Winds

function calcHeading()
count = 0

local tr1 = jak.round(jak.headingCalc(180, 100, 090, 12))
if tr1 == 173 then count = count + 1 else
print("Heading Calc failed: 180, 100, 090, 12: " .. tr1)
end

local tr2 = jak.round(jak.headingCalc(180, 100, 359, 12))
if tr2 == 180 then count = count + 1 else
print("Heading Calc failed: 180, 100, 359, 12: " .. tr2)
end

local tr3 = jak.round(jak.headingCalc(359, 100, 030, 12))
if tr3 == 3 then count = count + 1 else
print("Heading Calc failed: 359, 100, 030, 12: " .. tr3)
end

local tr4 = jak.round(jak.headingCalc(010, 100, 270, 30))
if tr4 == 353 then count = count + 1 else
print("Heading Calc failed: 010, 100, 270, 30: " .. tr4)
end

if count == 4 then Accumulator = Accumulator + 1
  else
    print("! Heading tests Failed " .. count .. "/20 passed")
  end
return  

end

----------------------------------------------------------










