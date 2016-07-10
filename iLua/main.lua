-- main.lua
----------------------------------------------------------
-- Application: JAK
-- Resource: main.lua
-- Version: 0.1
-- Last Edit: 06_10_12
----------------------------------------------------------
print("\n--- Application Initialisation ---\n")
----------------------------------------------------------  

-- Set Context
package.path = package.path .. ";./?.lua"

-- Load initiation Dependencies
package.loaded.config = nil; require "config" 
package.loaded.jak = nil; require "jak"
package.loaded.tests = nil; require "tests" 
package.loaded.weather = nil; require "weather" 
require "socket.http"

-- Initialise database
require "luasql.sqlite3"           -- load driver
env = assert (luasql.sqlite3())    -- create env obj
con = assert (env:connect("JAK_appData")) -- connect

-- Load configuration
config.appInfo()       -- Get application info
if not pcall(config.Check) then error({code=040}) end
if not pcall(config.usrConfig) then error({code=041}) end
if not pcall(tests.Execute) then error({code=080}) end

----------------------------------------------------------
print("\n--- Startup Functions ---\n")
----------------------------------------------------------

--menu.init()            -- Load the menu
--currentScreen.init()   -- Load dashboard

----------------------------------------------------------
print("\n--- Application Functions ---\n")
----------------------------------------------------------

-- User Inputs --
local usrRouteTime = [['2012-10-07 10:00:00']]
local usrWptAlts = {"'000'","'030'","'030'","'030'","'045'","'045'"}
local Aircraft1 = [['1','PA-28','Piper Cherokee','Kts','95',]] .. jak.NullPad(37)

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

print("\n--- Dashboard Functions ---\n")
plan = jak.dbQ("*", "CurrentPlan")    -- load last route
print(table.unpack(plan))  -- Display plan
print(weather.chkMet())    -- Check weather status
--print(notam.check())     -- Check NOTAM status

----------------------------------------------------------
--- WIP dbQuery ---
----------------------------------------------------------

print("\n--- WIP dbQ ---\n")
local fred = nil
local Table = [[CurrentPlan]]
local Columns = [[*]]
local Where = [[WaypointId = "EGSQ"]]

--fred = jak.dbQ(Columns,Table)

--print(jak.tableList(fred)) --expect multiple rtn in tble
--print(fred) --expect single val
--print(table.unpack(fred))
--print(# fred)
--print(fred[1])

----------------------------------------------------------
--- WIP code ---
----------------------------------------------------------

--Apply Route Extras
  --MSA NUMERIC(4)
  --MagVar INTEGER(4) , 
  --HDG_M INTEGER(3) , 
  --Com1Id INTEGER(3)  , 
  --Com2Id INTEGER(3) , 
  --Nav1Id INTEGER(3) , 
  --Nav1Brg INTEGER(3) , 
  --Nav2Id INTEGER(3) , 
  --Nav2Brg INTEGER(3) ,   
  --Remarks INTEGER(3) , 
  --Warnings TEXT(100)

--Apply aircraft elements
  --CompassDeviation from aircraft compass card
  --HDG_C INTEGER(3) ,  
  --LegFuel INTEGER(3) ,  

--Final elements
  --WaypointTime TEXT(20) ,  
  --Reccmd_Alt INTEGER(3) , 


----------------------------------------------------------
print("\n--- Close Events ---\n")
----------------------------------------------------------
collectgarbage()
k, b = collectgarbage("count")
  assert(k*1024 == math.floor(k)*1024 + b)
  print("Memory in use = " .. jak.round(k).. "Kb")

jak.databaseClose()      -- Close db
print(env)               --show Db env closed  
print(con)               --show Db con closed

print("\n--------------------\n")

---------------------------------------------------------- 



