----------------------------------------------------------
-- Application: JAK
-- Resource: config.lua
-- Version: 0.1
-- Last Edit: 10_10_12
----------------------------------------------------------
local configM = {}
----------------------------------------------------------
-- iOS Applicaton Config --
----------------------------------------------------------
application =
{
	content =
	{
		width = 768,
		height = 1024,
		scale = "zoomEven",
		fps = 30,
		antialias = false,
		xalign = "left",
		yalign = "top"
	}
}
----------------------------------------------------------
-- JAK Applicaton Config --
----------------------------------------------------------

-- Set Application --

local appInfo = function()
  appName = "JAK"      --Application Name
  appVersion = "0.1"   --Application Version

  print("-------------------------------")
  print(appName .. " v" .. appVersion)
  print(os.date())
  print("------------------------------- \n")
end

-- Initialise sqlite database --

local dbInit = function()
	local path = system.pathForFile("JAK.db", system.DocumentsDirectory)
	_G.db = sqlite3.open( path )
	print( "Sqlite version " .. sqlite3.version() )
	--Config check
	local function dbStatus(db)
		for row in db:nrows([[SELECT Value FROM Config WHERE Key = "State"]]) do
			print("Database Build status =", row.Value)
			if row.Value == "Complete" then
				return db
			else
				print("Database build completion failure detected")
				local zSetup = require "zSetup"
				zSetup.dbSetup(db)		-- Initiate Rebuild
			end
		end
	end
	--database check
	if not pcall(dbStatus, db) then
		local zSetup = require "zSetup"
		print("Database missing or corrupt - ", db)
		zSetup.dbSetup(db)				-- Initiate Rebuild
	end
return db
end

----------------------------------------------------------
-- package / module definitions --
----------------------------------------------------------
configM.dbInit = dbInit
configM.appInfo = appInfo
return configM

