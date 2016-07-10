-- zSetup.lua
----------------------------------------------------------
-- Application: JAK
-- Resource: zSetup.lua
-- Version: 0.1
-- Last Edit: 06_10_12
----------------------------------------------------------

module(..., package.seeall);

----------------------------------------------------------

--Packages--

--dbSetupConfig
--dbSetupWeightBalance
--dbSetupAircraftTypes
--dbSetupWaypoints
--dbSetupAircraft
--dbSetupPerformance
--dbSetupzCalcs
--dbSetupReferenceData
--dbSetupNavAids
--dbSetupzConversions
--dbSetupCurrentPla
--dbSetupWxWinds
--dbSetupRoutes
--dbSetupAirports
--dbBuildIndexs

----------------------------------------------------------

function dbSetupConfig()
res = assert (con:execute("DROP TABLE IF EXISTS Config"))
res = assert (con:execute[[
  CREATE TABLE Config(
    Type TEXT(5)  NOT NULL , 
    Key TEXT(6)  NOT NULL UNIQUE , 
    Value TEXT(100)  NOT NULL
  )
]])
res = assert (con:execute([[
  INSERT INTO Config VALUES('App','State','Build')]]))
res = assert (con:execute([[
  INSERT INTO Config VALUES('Lang','En','English')]]))
res = assert (con:execute([[
  INSERT INTO Config VALUES('Units','Height','Ft')]]))
res = assert (con:execute([[
  INSERT INTO Config VALUES('Units','Distance','Nm')]]))
res = assert (con:execute([[
  INSERT INTO Config VALUES('Units','Pressure','hPa')]]))
res = assert (con:execute([[
  INSERT INTO Config VALUES('Units','Speed','Kts')]]))
res = assert (con:execute([[
  INSERT INTO Config VALUES('Units','Length','M')]]))
res = assert (con:execute([[
  INSERT INTO Config VALUES('Units','Temp','C')]]))
res = assert (con:execute([[
  INSERT INTO Config VALUES('Units','Weight','Lb')]]))
res = assert (con:execute([[
  INSERT INTO Config VALUES('Units','Volume','L')]]))
res = assert (con:execute([[
  INSERT INTO Config VALUES('Plan','Aircraft','1')]]))
res = assert (con:execute([[
  INSERT INTO Config VALUES('App','Test','True')]]))
res = assert (con:execute([[
  INSERT INTO Config VALUES('Route','Last','1')]]))
res = assert (con:execute([[
  INSERT INTO Config VALUES('App','Check','1')]]))
end

-- ReferenceData

function dbSetupReferenceData()
res = con:execute"DROP TABLE IF EXISTS ReferenceData"
res = assert (con:execute[[
  CREATE TABLE ReferenceData (
    Key INTEGER(4) NOT NULL , 
    Value VARCHAR(25)  NOT NULL , 
    Label TEXT(25)  NOT NULL , 
    Type TEXT(6)  NOT NULL , 
    Lang TEXT(2)  DEFAULT 'En'
  )
]])

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(1,'Grass','Grass','RWYSFC','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData
VALUES(2,'Concrete','Concrete','RWYSFC','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(3,'Asphalt','Asphalt','RWYSFC','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(4,'Grass / Asphalt','Grass / Asphalt','RWYSFC','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(1,'VOR','VOR','NavAid','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(2,'VOR/DME','DME','NavAid','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(3,'TACAN','TACAN','NavAid','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(4,'VORTAC','VORTAC','NavAid','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(5,'NDB','NDB','NavAid','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(1,'AIRPORT','Airport','WaypointType','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(2,'FIX','Fix','WaypointType','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(3,'WAYPOINT','Waypoint','WaypointType','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(4,'HELIPORT','Heliport','WaypointType','En')]]))

res = assert (con:execute([[
INSERT INTO ReferenceData VALUES(5,'SEAPLANEBASE','Seaplane base','WaypointType','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(8,'IFRWAYPOINT','IFR Waypoint','WaypointType','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(10,'DME','DME','WaypointType','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(11,'NDB','NDB','WaypointType','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(12,'VOR','VOR','WaypointType','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(13,'NDB/DME','NDB/DME','WaypointType','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(14,'VOR/DME','VOR/DME','WaypointType','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(15,'TACAN','TACAN','WaypointType','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES(16,'VORTAC','VORTAC','WaypointType','En')]]))

res = assert (con:execute([[
  INSERT INTO ReferenceData VALUES('En','English','English','Lang','En')]]))
end

-- zConversions

function dbSetupzConversions()
res = con:execute"DROP TABLE IF EXISTS zConversions"
res = assert (con:execute[[   
  CREATE TABLE zConversions (
    BaseUnit TEXT(10)  NOT NULL , 
    BaseValue INTEGER(10)  DEFAULT '1' , 
    ConvUnit TEXT(10)  NOT NULL , 
    ConvValue NUMERIC(10)  NOT NULL
  )
]])

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Nm',1,'Km',1.852)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Nm',1,'Sm',1.150779)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Sm',1,'Nm',0.868976)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Sm',1,'Km',1.609344)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Km',1,'Sm',0.621371)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Km',1,'Nm',0.539956)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Ft',1,'M',0.3048)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('M',1,'Ft',3.280839)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('hPa',1,'Hg',0.029529983)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Hg',1,'hPa',33.863886)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Fpm',1,'Mpm',0.304799)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Mpm',1,'Fpm',3.280839)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Kts',1,'Kmh',1.852)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Kmh',1,'Kts',0.539956)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Kts',1,'Mph',1.150779)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Mph',1,'Kts',0.868976)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Kmh',1,'Mph',0.621371)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Mph',1,'Kmh',1.609344)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Kg',1,'Lb',2.204622)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('Lb',1,'Kg',0.453592)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('G',1,'L',4.54609)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('USG',1,'L',3.785411784)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('G',1,'USG',1.200949)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('USG',1,'G',0.832674)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('L',1,'G',0.219969)]]))

res = assert (con:execute([[
INSERT INTO zConversions VALUES('L',1,'USG',0.264172)]]))

end

--nwxWinds

function dbSetupNwxWinds()
res = con:execute"DROP TABLE IF EXISTS nwxWinds"
res = assert (con:execute[[   
  CREATE TABLE nwxWinds (
    waypnt_id INTEGER PRIMARY KEY UNIQUE , 
    Waypnt_nam VARCHAR(10),
    nwxReqTime VARCHAR(12),
    waypntLatLon VARCHAR(12),
    waypntalt TEXT(3),
    waypntdir TEXT(3),
    waypntspd INTEGER(3)
  )
]])
res = assert (con:execute([[
INSERT INTO nwxWinds VALUES('1','1','1','1','1','1','1')]]))
end

-- Routes

function dbSetupgpxRoutes()
res = con:execute"DROP TABLE IF EXISTS gpxRoutes"
res = assert (con:execute[[   
  CREATE TABLE gpxRoutes (
    Route_id INTEGER PRIMARY KEY UNIQUE , 
    Route_name VARCHAR(10),
    maxlat VARCHAR(12),
    maxlon VARCHAR(12),
    minlat VARCHAR(12),
    minlon VARCHAR(12),
    gpxXml BLOB
  )
]])
end

-- CurrentPlan

function dbSetupCurrentPlan()
res = con:execute"DROP TABLE IF EXISTS CurrentPlan"
res = assert (con:execute[[   
  CREATE TABLE CurrentPlan (
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
    Warnings TEXT(100)
  )
]])
end

-- Aircraft types
function dbSetupAircraftTypes()
res = con:execute"DROP TABLE IF EXISTS AircraftTypes"
res = assert (con:execute[[
  CREATE TABLE AircraftTypes (
    AircraftTypeId INTEGER PRIMARY KEY AUTOINCREMENT ,
    Type TEXT(10)  NOT NULL , 
    TypeName TEXT(22)  NOT NULL , 
    SpeedUnit TEXT(10) ,
    VC NUMERIC(3)  ,
    Vne NUMERIC(3)  , 
    Vno NUMERIC(3)  , 
    Vfe NUMERIC(3)  , 
    VaMax NUMERIC(3)  , 
    VaMin NUMERIC(3)  , 
    FuelCapacity NUMERIC(3)  ,  
    Vx NUMERIC(3)  , 
    Vy NUMERIC(3)  , 
    Vref NUMERIC(3)  , 
    Vra NUMERIC(3)  , 
    Vxwind NUMERIC(3)  , 
    Vs1Max NUMERIC(3)  , 
    Vs1Min NUMERIC(3)  , 
    Vs0Max NUMERIC(3)  , 
    Vs0Min NUMERIC(3)  , 
    Vbg NUMERIC(3)  , 
    Vr NUMERIC(3)  , 
    FuelUnit TEXT(10) , 
    FuelUnusable NUMERIC(3)  , 
    FuelUsable NUMERIC(3)  , 
    MaxBaggageUtility NUMERIC(5)  , 
    WeightUnit TEXT(10) , 
    CofG_NormalMaxWeight NUMERIC(5) ,
    CofG_NormalMinWeight NUMERIC(5) ,
    CofG_NormalMaxForward NUMERIC(5)  ,
    CofG_NormalMinForward NUMERIC(5)  , 
    CofG_NormalMaxRearward NUMERIC(5)  ,
    CofG_NormalMinRearward NUMERIC(5)  , 
    MaxBaggageNormal NUMERIC(5)  ,
    CofG_UtilityMaxForward NUMERIC(5)  , 
    CofG_UtilityMaxWeight NUMERIC(5)  , 
    CofG_UtilityMinForward NUMERIC(5)  , 
    CofG_UtilityMaxRearward NUMERIC(5)  , 
    CofG_UtilityMinRearward NUMERIC(5)  , 
    MaxWeightNormal NUMERIC(5)  , 
    MaxWeightUtility NUMERIC(5)  , 
    CofG_UtilityMinWeight NUMERIC(5) 
  )
]])
end
