----------------------------------------------------------
-- Application: JAK
-- Resource: zSetup.lua
-- Version: 0.1
-- Last Edit: 10_10_12
----------------------------------------------------------
module(..., package.seeall)
----------------------------------------------------------

function dbSetup()
	local db = db
	print("Db in zSetup is ", db)
	dbSetupAircraftTypes(db)
	dbSetupConfig(db)
	dbSetupzConversions(db)
	dbSetupCurrentPlan(db)
	dbSetupNwxWinds(db)
	dbSetupReferenceData(db)
	dbSetupAppWIP(db)
	assert (db:exec([[UPDATE Config SET Value = "Complete" WHERE Key = "State"]]), "Update Config Table Failed")
	print("Database Rebuild Complete")
end

----------------------------------------------------------

-- Config 

function dbSetupConfig(db)
	assert (db:exec([[DROP TABLE IF EXISTS Config]]), "Drop Table Failed")
	local dbcreateConfig = [[CREATE TABLE Config (
		id INTEGER PRIMARY KEY ,
		Type TEXT(5)  NOT NULL , 
		Key TEXT(6)  NOT NULL , 
		Value TEXT(100)  NOT NULL );
	]]
	assert (db:exec( dbcreateConfig ),"Database Create for Config failed")
	local dbpopulateConfig = [[
		INSERT INTO Config VALUES(NULL,'App','State','Build');
		INSERT INTO Config VALUES(NULL,'App','Hand','right');
		INSERT INTO Config VALUES(NULL,'Lang','En','English');
		INSERT INTO Config VALUES(NULL,'Units','Height','Ft');
		INSERT INTO Config VALUES(NULL,'Units','Distance','Nm');
		INSERT INTO Config VALUES(NULL,'Units','Pressure','hPa');
		INSERT INTO Config VALUES(NULL,'Units','Speed','Kts');
		INSERT INTO Config VALUES(NULL,'Units','Length','M');
		INSERT INTO Config VALUES(NULL,'Units','Temp','C');
		INSERT INTO Config VALUES(NULL,'Units','Weight','Lb');
		INSERT INTO Config VALUES(NULL,'Units','Volume','L');
		INSERT INTO Config VALUES(NULL,'Plan','Aircraft','1');
		INSERT INTO Config VALUES(NULL,'Route','Last','1');
		INSERT INTO Config VALUES(NULL,'App','Check','1')
	]]
	assert (db:exec( dbpopulateConfig ), "Database inserts for Config Failed")
	print("Config updates completed")
end

-- ReferenceData 

function dbSetupReferenceData(db)
	assert (db:exec([[DROP TABLE IF EXISTS ReferenceData]]), "Drop Table Failed")
	local dbcreateRefData = [[CREATE TABLE IF NOT EXISTS ReferenceData ( 
		Key INTEGER(4) NOT NULL , 
    	Value VARCHAR(25)  NOT NULL , 
    	Label TEXT(25)  NOT NULL , 
    	Type TEXT(6)  NOT NULL , 
    	Lang TEXT(2)  DEFAULT 'En');
	]]
	assert (db:exec( dbcreateRefData ),"Database Create for dbcreateRefData failed")
	local dbpopulateRefData = [[
		INSERT INTO ReferenceData VALUES(1,'Grass','Grass','RWYSFC','En');
		INSERT INTO ReferenceData VALUES(2,'Concrete','Concrete','RWYSFC','En');
		INSERT INTO ReferenceData VALUES(3,'Asphalt','Asphalt','RWYSFC','En');
		INSERT INTO ReferenceData VALUES(4,'Grass / Asphalt','Grass / Asphalt','RWYSFC','En');
		INSERT INTO ReferenceData VALUES(1,'VOR','VOR','NavAid','En');
		INSERT INTO ReferenceData VALUES(2,'VOR/DME','DME','NavAid','En');
		INSERT INTO ReferenceData VALUES(3,'TACAN','TACAN','NavAid','En');
		INSERT INTO ReferenceData VALUES(4,'VORTAC','VORTAC','NavAid','En');
		INSERT INTO ReferenceData VALUES(5,'NDB','NDB','NavAid','En');
		INSERT INTO ReferenceData VALUES(1,'AIRPORT','Airport','WaypointType','En');
		INSERT INTO ReferenceData VALUES(2,'FIX','Fix','WaypointType','En');
		INSERT INTO ReferenceData VALUES(3,'WAYPOINT','Waypoint','WaypointType','En');
		INSERT INTO ReferenceData VALUES(4,'HELIPORT','Heliport','WaypointType','En');
		INSERT INTO ReferenceData VALUES(5,'SEAPLANEBASE','Seaplane base','WaypointType','En');
		INSERT INTO ReferenceData VALUES(8,'IFRWAYPOINT','IFR Waypoint','WaypointType','En');
		INSERT INTO ReferenceData VALUES(10,'DME','DME','WaypointType','En');
		INSERT INTO ReferenceData VALUES(11,'NDB','NDB','WaypointType','En');
		INSERT INTO ReferenceData VALUES(12,'VOR','VOR','WaypointType','En');
		INSERT INTO ReferenceData VALUES(13,'NDB/DME','NDB/DME','WaypointType','En');
		INSERT INTO ReferenceData VALUES(14,'VOR/DME','VOR/DME','WaypointType','En');
		INSERT INTO ReferenceData VALUES(15,'TACAN','TACAN','WaypointType','En');
		INSERT INTO ReferenceData VALUES(16,'VORTAC','VORTAC','WaypointType','En');
		INSERT INTO ReferenceData VALUES('En','English','English','Lang','En')
	]]
	assert (db:exec( dbpopulateRefData ), "Database inserts for Ref Data Failed")
	print("Ref Data updates completed")
end

-- zConversions

function dbSetupzConversions(db)
	assert (db:exec([[DROP TABLE IF EXISTS zConversions]]), "Drop Table Failed")
	local dbcreateConv = [[CREATE TABLE IF NOT EXISTS zConversions ( 
		ConvType TEXT(10) NOT NULL , 
		BaseUnit TEXT(10)  NOT NULL , 
    	BaseValue INTEGER(10)  DEFAULT '1' , 
    	ConvUnit TEXT(10)  NOT NULL , 
    	ConvValue NUMERIC(10)  NOT NULL);
	]]
	assert (db:exec( dbcreateConv ),"Database Create for dbcreateConv failed")
	local dbpopulateConv = [[
		INSERT INTO zConversions VALUES('Distance','Nm',1,'Km',1.852);
		INSERT INTO zConversions VALUES('Distance','Nm',1,'Sm',1.150779);
		INSERT INTO zConversions VALUES('Distance','Sm',1,'Nm',0.868976);
		INSERT INTO zConversions VALUES('Distance','Sm',1,'Km',1.609344);
		INSERT INTO zConversions VALUES('Distance','Km',1,'Sm',0.621371);
		INSERT INTO zConversions VALUES('Distance','Km',1,'Nm',0.539956);
		INSERT INTO zConversions VALUES('Distance','Ft',1,'M',0.3048);
		INSERT INTO zConversions VALUES('Distance','M',1,'Ft',3.280839);
		INSERT INTO zConversions VALUES('Other','hPa',1,'Hg',0.029529983);
		INSERT INTO zConversions VALUES('Other','Hg',1,'hPa',33.863886);
		INSERT INTO zConversions VALUES('Speed','Fpm',1,'Mpm',0.304799);
		INSERT INTO zConversions VALUES('Speed','Mpm',1,'Fpm',3.280839);
		INSERT INTO zConversions VALUES('Speed','Kts',1,'Kmh',1.852);
		INSERT INTO zConversions VALUES('Speed','Kmh',1,'Kts',0.539956);
		INSERT INTO zConversions VALUES('Speed','Kts',1,'Mph',1.150779);
		INSERT INTO zConversions VALUES('Speed','Mph',1,'Kts',0.868976);
		INSERT INTO zConversions VALUES('Speed','Kmh',1,'Mph',0.621371);
		INSERT INTO zConversions VALUES('Speed','Mph',1,'Kmh',1.609344);
		INSERT INTO zConversions VALUES('Weight','Kg',1,'Lb',2.204622);
		INSERT INTO zConversions VALUES('Weight','Lb',1,'Kg',0.453592);
		INSERT INTO zConversions VALUES('Weight','G',1,'L',4.54609);
		INSERT INTO zConversions VALUES('Volume','USG',1,'L',3.785411784);
		INSERT INTO zConversions VALUES('Volume','G',1,'USG',1.200949);
		INSERT INTO zConversions VALUES('Volume','USG',1,'G',0.832674);
		INSERT INTO zConversions VALUES('Volume','L',1,'G',0.219969);
		INSERT INTO zConversions VALUES('Volume','L',1,'USG',0.264172)
	]]
	assert (db:exec( dbpopulateConv ), "Database inserts for Conversions Failed")
	print("Conversion updates completed")
end

--nwxWinds

function dbSetupNwxWinds(db)
	assert (db:exec([[DROP TABLE IF EXISTS nwxWinds]]), "Drop Table Failed")
	local dbcreatenwxW = [[CREATE TABLE IF NOT EXISTS nwxWinds ( 
    	waypnt_id INTEGER PRIMARY KEY UNIQUE , 
    	Waypnt_nam VARCHAR(10),
    	nwxReqTime VARCHAR(12),
    	waypntLatLon VARCHAR(12),
    	waypntalt TEXT(3),
    	waypntdir TEXT(3),
    	waypntspd INTEGER(3))
	]]
	assert (db:exec( dbcreatenwxW ),"Database Create for NWX Winds failed")
	local dbpopulatenwxW = [[INSERT INTO nwxWinds VALUES('1','1','1','1','1','1','1')]]
	assert (db:exec( dbpopulatenwxW ), "Database inserts for nwx Winds Failed")
	print("NWX updates completed")
end

-- Routes

function dbSetupgpxRoutes(db)
	assert (db:exec([[DROP TABLE IF EXISTS gpxRoutes]]), "Drop Table Failed")
	local dbcreategpxR = [[CREATE TABLE IF NOT EXISTS gpxRoutes ( 
    	Route_id INTEGER PRIMARY KEY UNIQUE , 
    	Route_name VARCHAR(10),
    	maxlat VARCHAR(12),
    	maxlon VARCHAR(12),
    	minlat VARCHAR(12),
    	minlon VARCHAR(12),
    	gpxXml BLOB )
	]]
	assert (db:exec( dbcreategpxR ),"Database Create for GPX Routes failed")
	print("GPX updates completed")
end

-- CurrentPlan

function dbSetupCurrentPlan(db)
	assert (db:exec([[DROP TABLE IF EXISTS CurrentPlan]]), "Drop Table Failed")
	local dbcreateCurrP = [[CREATE TABLE IF NOT EXISTS CurrentPlan (
    	RouteId TEXT(3) , 
    	RouteName TEXT(25) , 
    	RouteTime TEXT(20) ,  
    	LegId INTEGER(5)  , 
    	WaypointId TEXT(12)  , 
    	WaypointName TEXT(25) ,
    	WaypointLat NUMERIC(12) ,
    	WaypointLon NUMERIC(12) ,
    	WaypointLatLon TEXT(12) , 
    	WaypointDist NUMERIC(4) ,
    	WaypointAlt TEXT(3) , 
    	MSA NUMERIC(4) , 
    	TRK_T TEXT(3) ,
    	HDG_T TEXT(3) , 
    	M_Var INTEGER(4) , 
    	HDG_M TEXT(3) , 
    	HDG_C TEXT(3) ,  
    	TAS INTEGER(3) , 
    	GS INTEGER(3) , 
    	Leg_Time INTEGER(3) , 
    	WaypointTime TEXT(20) ,    
    	LegFuel INTEGER(3) ,   
    	Com1Id INTEGER(3)  , 
    	Com2Id INTEGER(3) , 
    	Nav1Id INTEGER(3) , 
    	Nav1Brg INTEGER(3) , 
    	Nav2Id INTEGER(3) , 
    	Nav2Brg INTEGER(3) ,  
    	Reccmd_Alt INTEGER(3) ,    
    	Remarks INTEGER(3) ,
    	Warnings TEXT(100) )
	]]
	assert (db:exec( dbcreateCurrP ),"Database Create for Current Plan failed")
	print("Current Plan updates completed")
end

-- App WIP Items

function dbSetupAppWIP(db)
	assert (db:exec([[DROP TABLE IF EXISTS AppWIP]]), "Drop Table Failed")
	local dbcreateApWip = [[CREATE TABLE IF NOT EXISTS AppWIP (
    	Item TEXT(10)  NOT NULL , 
    	Value BLOB )
	]]
	assert (db:exec( dbcreateApWip ),"Database Create for App WIP failed")
	local dbpopulateAppWip = [[INSERT INTO AppWIP VALUES('scratchPad','')]]
	assert (db:exec( dbpopulateAppWip ), "Database inserts for nwx Winds Failed")
	print("App WIP updates completed")
end

-- Aircraft types

function dbSetupAircraftTypes(db)
	assert (db:exec([[DROP TABLE IF EXISTS AircraftTypes]]), "Drop Table Failed")
	local dbcreateAcT = [[CREATE TABLE IF NOT EXISTS AircraftTypes (
    	AircraftTypeId INTEGER PRIMARY KEY AUTOINCREMENT ,
    	Type TEXT(10)  NOT NULL , 
    	TypeName TEXT(22)  NOT NULL , 
    	SpeedUnit TEXT(10) ,
    	VC NUMERIC(3) )
	]]
	assert (db:exec( dbcreateAcT ),"Database Create for Aircraft Types failed")
	print("Aircraft Types updates completed")
end

