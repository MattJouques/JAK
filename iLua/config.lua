-- config.lua
----------------------------------------------------------
-- Application: JAK
-- Resource: config.lua
-- Version: 0.1
-- Last Edit: 06_10_12
----------------------------------------------------------

module(..., package.seeall);

----------------------------------------------------------
-- Set Application configuration --
----------------------------------------------------------
application = {
	content = {
		width = 1024,
		height = 768, 
		scale = "letterBox",
		fps = 30,
		
		--[[
        imageSuffix = {
		    ["@2x"] = 2,
		}
		--]]
	},

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    
}
function appInfo()
  appName = "JAK"      --Application Name
  appVersion = "0.1"   --Application Version

  print("-------------------------------")
  print(appName .. " v" .. appVersion)
  print(env)
  print(con)
  print(os.date())
  print("------------------------------- \n")
end

----------------------------------------------------------
-- User Configuration --
----------------------------------------------------------

function usrConfig()
  
usrDist = jak.dbQ("Value","Config",[[Key = "Distance"]])
usrHeight = jak.dbQ("Value","Config",[[Key = "Height"]])
usrLength = jak.dbQ("Value","Config",[[Key = "Length"]])
usrPres = jak.dbQ("Value","Config",[[Key = "Pressure"]])
usrSpeed = jak.dbQ("Value","Config",[[Key = "Speed"]])
usrTemp = jak.dbQ("Value","Config",[[Key = "Temp"]])
usrVolume = jak.dbQ("Value","Config",[[Key = "Volume"]])
usrWeight = jak.dbQ("Value","Config",[[Key = "Weight"]])

return
end

----------------------------------------------------------
--- Load Data ---
----------------------------------------------------------

function loadData()
  
  return
end

function importGPX()
res = assert (con:execute([[
INSERT INTO gpxRoutes VALUES('1','EGSR-EGCL','52.740000','1.603284','51.776066','-0.030000','<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<gpx xmlns="http://www.topografix.com/GPX/1/1" creator="Air Navigation for iOS" version="1.1"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd">
	<metadata>
	<link href="http://www.xample.ch">
	<text>Air Navigation - real time navigation software for iPhone/iPad</text></link>
	<bounds maxlat="52.740000" maxlon="1.603284" minlat="51.776066" minlon="-0.030000"/>
</metadata>
<wpt lat="51.914000" lon="0.683000">
<name>EGSR</name>
<cmt>EARLS COLNE</cmt>
<sym>Waypoint</sym>
</wpt><wpt lat="51.776066" lon="0.924144">
<name>W.MERSEA</name>
<cmt>WEST MERSEA</cmt>
<sym>Waypoint</sym>
</wpt><wpt lat="51.785000" lon="1.130000">
<name>EGSQ</name>
<cmt>CLACTON</cmt>
<sym>Waypoint</sym>
</wpt><wpt lat="52.150406" lon="1.603284">
<name>ALBH</name>
<cmt>ALDEBURGH</cmt>
<sym>Waypoint</sym>
</wpt><wpt lat="52.412460" lon="0.744036">
<name>THFD</name>
<cmt>THETFORD</cmt>
<sym>Waypoint</sym>
</wpt><wpt lat="52.740000" lon="-0.030000">
<name>EGCL</name>
<cmt>FENLAND</cmt>
<sym>Waypoint</sym>
</wpt><rte>
<name>EGSR-EGCL</name>
<rtept lat="51.914000" lon="0.683000">
<name>EGSR</name>
<sym>Waypoint</sym>
</rtept><rtept lat="51.776066" lon="0.924144">
<name>W.MERSEA</name>
<sym>Waypoint</sym>
</rtept><rtept lat="51.785000" lon="1.130000">
<name>EGSQ</name>
<sym>Waypoint</sym>
</rtept><rtept lat="52.150406" lon="1.603284">
<name>ALBH</name>
<sym>Waypoint</sym>
</rtept><rtept lat="52.412460" lon="0.744036">
<name>THFD</name>
<sym>Waypoint</sym>
</rtept><rtept lat="52.740000" lon="-0.030000">
<name>EGCL</name>
<sym>Waypoint</sym>
</rtept></rte>
</gpx>')]]))

return "gpx Route imported"
end


----------------------------------------------------------
--- Application Db Build ---
----------------------------------------------------------

function Check(c)
  if c == "Rebuild" then 
    print("App Rebuild initiated")
    Rebuild() 
  elseif c == "Wipe" then
    print("App Wipe initiated")
    Wipe()
  else
    if not pcall(jak.dbQ, "Value", "Config") then
      print("Database not found or corrupt")
      Wipe()
    else
      print("db Configuration check ok")
    end
  end
end

----------------------------------------------------------

function Wipe()

  print("Full Database Rebuild initiated")
  package.loaded.zSetup = nil; require "zSetup" 

  print("dbSetupConfig initiated")
  zSetup.dbSetupConfig()

  print("dbSetupgpxRoutes initiated")
  zSetup.dbSetupgpxRoutes()

  print("dbSetupAircraftTypes initiated")
  zSetup.dbSetupAircraftTypes()

  Rebuild()

end

----------------------------------------------------------

function Rebuild()

  print("Database App table Rebuild initiated")
  package.loaded.zSetup = nil; require "zSetup" 

  print("dbSetupReferenceData initiated")
  zSetup.dbSetupReferenceData()

  print("dbSetupzConversions initiated")
  zSetup.dbSetupzConversions()

  print("dbSetupNwxWinds initiated")
  zSetup.dbSetupNwxWinds()

  print("dbSetupCurrentPlan initiated")
  zSetup.dbSetupCurrentPlan()

--Set Config Flag
  local dbUpdateRes = (jak.dbUpdate("Config", "Value", [["Complete"]], [[Key = "State"]]))
  print("dbSetup Complete")
end


function dbSetupNotUsed()

  print("dbSetupWaypoints initiated")
  zSetup.dbSetupWaypoints()

  print("dbSetupAircraft initiated")
  zSetup.dbSetupAircraft()

  print("dbSetupNavAids initiated")
  zSetup.dbSetupNavAids()

  print("dbSetupRoutes initiated")
  zSetup.dbSetupRoutes()

  print("dbSetupAirports initiated")
  zSetup.dbSetupAirports()

  --from rebuild
  print("dbSetupWeightBalance initiated")
  zSetup.dbSetupWeightBalance()

  print("dbSetupWxWinds initiated")
  zSetup.dbSetupWxWinds()

  print("dbSetupzCalcs initiated")
  zSetup.dbSetupzCalcs()

  print("dbBuildIndexs initiated")
  zSetup.dbBuildIndexs()

end


