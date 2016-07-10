--SQLed
--DDL script for Database AppData.db

--CREATE TABLE STATEMENTS--

--WeightBalance--
DROP TABLE IF EXISTS "WeightBalance";
CREATE TABLE "WeightBalance" ("TO_Weight" NUMERIC(4)  NOT NULL , "LDG_WeightDest" NUMERIC(4)  NOT NULL , "LDG_WeightAlt" NUMERIC(4)  NOT NULL , "Check" BOOL );


--AircraftTypes--
DROP TABLE IF EXISTS "AircraftTypes";
CREATE TABLE "AircraftTypes" ("AircraftTypeId" INTEGER PRIMARY KEY  AUTOINCREMENT UNIQUE , "Type" TEXT(10)  NOT NULL UNIQUE , "TypeName" TEXT(22)  NOT NULL , "SpeedUnit" TEXT(10) , "Vne" NUMERIC(3)  , "Vno" NUMERIC(3)  , "Vfe" NUMERIC(3)  , "VaMax" NUMERIC(3)  , "VaMin" NUMERIC(3)  , "FuelCapacity" NUMERIC(3)  ,  "Vx" NUMERIC(3)  , "Vy" NUMERIC(3)  , "Vref" NUMERIC(3)  , "Vra" NUMERIC(3)  , "Vxwind" NUMERIC(3)  , "Vs1Max" NUMERIC(3)  , "Vs1Min" NUMERIC(3)  , "Vs0Max" NUMERIC(3)  , "Vs0Min" NUMERIC(3)  , "Vbg" NUMERIC(3)  , "Vr" NUMERIC(3)  , "FuelUnit" TEXT(10) , "FuelUnusable" NUMERIC(3)  , "FuelUsable" NUMERIC(3)  , "MaxBaggageUtility" NUMERIC(5)  , "WeightUnit" TEXT(10) , "CofG_NormalMaxWeight" NUMERIC(5)  , "CofG_NormalMinWeight" NUMERIC(5)  , "CofG_NormalMaxForward" NUMERIC(5)  , "CofG_NormalMinForward" NUMERIC(5)  , "CofG_NormalMaxRearward" NUMERIC(5)  , "CofG_NormalMinRearward" NUMERIC(5)  , "MaxBaggageNormal" NUMERIC(5)  , "CofG_UtilityMaxForward" NUMERIC(5)  , "CofG_UtilityMaxWeight" NUMERIC(5)  , "CofG_UtilityMinForward" NUMERIC(5)  , "CofG_UtilityMaxRearward" NUMERIC(5)  , "CofG_UtilityMinRearward" NUMERIC(5)  , "MaxWeightNormal" NUMERIC(5)  , "MaxWeightUtility" NUMERIC(5)  , "CofG_UtilityMinWeight" NUMERIC(5) );

INSERT INTO "AircraftTypes" VALUES(1,'PA28-161','Piper Warrior / Cherokee','Knots',161,111,101,222,NULL,NULL,666,555,63,333,17,NULL,NULL,NULL,NULL,73,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

--Waypoints--
DROP TABLE IF EXISTS "Waypoints";
CREATE TABLE "Waypoints" ("waypoint_id" TEXT(6) NOT NULL UNIQUE, "waypoint_name" TEXT(20) , "waypoint_type" INTEGER(5) , "waypoint_longitude" TEXT(20) , "waypoint_latitude" TEXT(20) , "waypoint_elevation" INTEGER(5) , "waypoint_country" TEXT(2) , "waypoint_state" VARCHAR(5) , "waypoint_channel" VARCHAR(10) , "waypoint_frequency" NUMERIC(7), "main_runway_orientation" INTEGER(3) , "country" TEXT(2) , "weight" INTEGER(6) );


--Config--
DROP TABLE IF EXISTS "Config";
CREATE TABLE "Config" ("Type" TEXT(5)  NOT NULL , "Key" TEXT(6)  NOT NULL UNIQUE , "Value" TEXT(100)  NOT NULL);

INSERT INTO "Config" VALUES('Lang','En','English');
INSERT INTO "Config" VALUES('Units','Height','Ft');
INSERT INTO "Config" VALUES('Units','Distance','Nm');
INSERT INTO "Config" VALUES('Units','Pressure','hPa');
INSERT INTO "Config" VALUES('Units','Speed','Kts');
INSERT INTO "Config" VALUES('Units','Length','Metres');
INSERT INTO "Config" VALUES('Units','Temp','C');
INSERT INTO "Config" VALUES('Units','Weight','Lbs');
INSERT INTO "Config" VALUES('Units','Volume','L');
INSERT INTO "Config" VALUES('Plan','Aircraft','1');

--Aircraft--
DROP TABLE IF EXISTS "Aircraft";
CREATE TABLE "Aircraft" ("AircraftId" INTEGER PRIMARY KEY  AUTOINCREMENT NOT NULL UNIQUE , "AircraftTypeId" INTEGER(5)  , "TailNum" TEXT(8)  , "EmptyWeight" INTEGER(5)  , "EmptyArm" NUMERIC(6)  , "EmptyMoment" NUMERIC(12)  , "FrontSeatArm" NUMERIC(6)  , "FrontSeatMoment" NUMERIC(12)  , "RearSeatArm" NUMERIC(6)  , "RearSeatMoment" NUMERIC(12)  , "FuelArm" NUMERIC(6)  , "FuelMoment" NUMERIC(12)  , "BaggageArm" NUMERIC(6)  , "BaggageMoment" NUMERIC(12)  , "MaxBaggage" INTEGER(4)  , "FuelConsumption" NUMERIC(3) ,FOREIGN KEY("AircraftTypeId") REFERENCES "AircraftTypes"("AircraftTypeId"));

INSERT INTO "Aircraft" VALUES(1,1,'G-BSJX',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO "Aircraft" VALUES(2,1,'test2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

--Performance--
DROP TABLE IF EXISTS "Performance";
CREATE TABLE "Performance" ("Check" INTEGER(1) , "Warnings" TEXT(100) ,  "Vne" NUMERIC(3)  , "Vno" NUMERIC(3)  , "Vfe" NUMERIC(3)  , "Vra" NUMERIC(3) , "VaMax" NUMERIC(3)  , "VaMin" NUMERIC(3)  , "VaPerLb" NUMERIC(3)  , "VaForWeight" NUMERIC(3) , "Vs1Max" NUMERIC(3)  , "Vs1Min" NUMERIC(3) , "Vs1-30" NUMERIC(3) , "Vs1-45" NUMERIC(3) , "Vs1-60" NUMERIC(3) , "Vs0Max" NUMERIC(3)  , "Vs0Min" NUMERIC(3) , "Vs0-30" NUMERIC(3) , "Vs0-45" NUMERIC(3) , "Vs0-60" NUMERIC(3) , "Vbg" NUMERIC(3)  , "Vr" NUMERIC(3) , "Vx" NUMERIC(3)  , "Vy" NUMERIC(3)  , "Vref" NUMERIC(3)  , "Vxwind" NUMERIC(3) );


--zCalcs--
DROP TABLE IF EXISTS "zCalcs";
CREATE TABLE "zCalcs" ("Key" TEXT(50) PRIMARY KEY  NOT NULL UNIQUE , "Value" NUMERIC(25) , "Check" INTEGER(1)  NOT NULL DEFAULT '0' , "Label" TEXT(50) );

INSERT INTO "zCalcs" VALUES('RWY1D1_LDG_SFC_FTR',NULL,0,'Landing Surface Safety Factor');
INSERT INTO "zCalcs" VALUES('RWY1D2_LDG_SFC_FTR',NULL,0,'Landing Surface Safety Factor');
INSERT INTO "zCalcs" VALUES('RWY2D1_LDG_SFC_FTR',NULL,0,'Landing Surface Safety Factor');
INSERT INTO "zCalcs" VALUES('RWY2D2_LDG_SFC_FTR',NULL,0,'Landing Surface Safety Factor');
INSERT INTO "zCalcs" VALUES('RWY3D1_LDG_SFC_FTR',NULL,0,'Landing Surface Safety Factor');
INSERT INTO "zCalcs" VALUES('RWY3D2_LDG_SFC_FTR',NULL,0,'Landing Surface Safety Factor');
INSERT INTO "zCalcs" VALUES('RWY4D1_LDG_SFC_FTR',NULL,0,'Landing Surface Safety Factor');
INSERT INTO "zCalcs" VALUES('RWY4D2_LDG_SFC_FTR',NULL,0,'Landing Surface Safety Factor');

--ReferenceData--
DROP TABLE IF EXISTS "ReferenceData";
CREATE TABLE "ReferenceData" ("Key" INTEGER(4) NOT NULL , "Value" VARCHAR(25)  NOT NULL , "Label" TEXT(25)  NOT NULL , "Type" TEXT(6)  NOT NULL , "Lang" TEXT(2)  DEFAULT 'En');

INSERT INTO "ReferenceData" VALUES(1,'Grass','Grass','RWYSFC','En');
INSERT INTO "ReferenceData" VALUES(2,'Concrete','Concrete','RWYSFC','En');
INSERT INTO "ReferenceData" VALUES(3,'Asphalt','Asphalt','RWYSFC','En');
INSERT INTO "ReferenceData" VALUES(4,'Grass / Asphalt','Grass / Asphalt','RWYSFC','En');
INSERT INTO "ReferenceData" VALUES(1,'VOR','VOR','NavAid','En');
INSERT INTO "ReferenceData" VALUES(2,'VOR/DME','DME','NavAid','En');
INSERT INTO "ReferenceData" VALUES(3,'TACAN','TACAN','NavAid','En');
INSERT INTO "ReferenceData" VALUES(4,'VORTAC','VORTAC','NavAid','En');
INSERT INTO "ReferenceData" VALUES(5,'NDB','NDB','NavAid','En');
INSERT INTO "ReferenceData" VALUES(1,'AIRPORT','Airport','WaypointType','En');
INSERT INTO "ReferenceData" VALUES(2,'FIX','Fix','WaypointType','En');
INSERT INTO "ReferenceData" VALUES(3,'WAYPOINT','Waypoint','WaypointType','En');
INSERT INTO "ReferenceData" VALUES(4,'HELIPORT','Heliport','WaypointType','En');
INSERT INTO "ReferenceData" VALUES(5,'SEAPLANEBASE','Seaplane base','WaypointType','En');
INSERT INTO "ReferenceData" VALUES(8,'IFRWAYPOINT','IFR Waypoint','WaypointType','En');
INSERT INTO "ReferenceData" VALUES(10,'DME','DME','WaypointType','En');
INSERT INTO "ReferenceData" VALUES(11,'NDB','NDB','WaypointType','En');
INSERT INTO "ReferenceData" VALUES(12,'VOR','VOR','WaypointType','En');
INSERT INTO "ReferenceData" VALUES(13,'NDB/DME','NDB/DME','WaypointType','En');
INSERT INTO "ReferenceData" VALUES(14,'VOR/DME','VOR/DME','WaypointType','En');
INSERT INTO "ReferenceData" VALUES(15,'TACAN','TACAN','WaypointType','En');
INSERT INTO "ReferenceData" VALUES(16,'VORTAC','VORTAC','WaypointType','En');
INSERT INTO "ReferenceData" VALUES('En','English','English','Lang','En');

--NavAids--
DROP TABLE IF EXISTS "NavAids";
CREATE TABLE "NavAids" ("NavId" TEXT(4)  NOT NULL , "NavName" TEXT(25) , "NavTypeId" INTEGER(2)  NOT NULL , "NavFreq" NUMERIC(7)  NOT NULL);

INSERT INTO "NavAids" VALUES('BIG','Biggin',1,115.1);
INSERT INTO "NavAids" VALUES('CLN','Clacton',1,114.55);
INSERT INTO "NavAids" VALUES('BKY','Barkway',1,116.25);
INSERT INTO "NavAids" VALUES('GAM','Gamston',1,112.8);
INSERT INTO "NavAids" VALUES('LAM','Lambourne',1,115.6);
INSERT INTO "NavAids" VALUES('BPK','Brookmans Pk',1,117.5);
INSERT INTO "NavAids" VALUES('LON','London',1,113.6);
INSERT INTO "NavAids" VALUES('DVR','Dover',1,114.95);
INSERT INTO "NavAids" VALUES('DTY','Daventry',1,116.4);
INSERT INTO "NavAids" VALUES('SAM','Southampton',1,113.35);
INSERT INTO "NavAids" VALUES('MAY','Mayfield',1,117.9);
INSERT INTO "NavAids" VALUES('MID','Midhurst',1,114);
INSERT INTO "NavAids" VALUES('SFD','Seaford',1,117);
INSERT INTO "NavAids" VALUES('LYD','Lydd',1,114.05);
INSERT INTO "NavAids" VALUES('WTZ','Wattisham',3,109.3);
INSERT INTO "NavAids" VALUES('MAM','Marham',3,108.7);
INSERT INTO "NavAids" VALUES('HON','Honiton',1,113.65);
INSERT INTO "NavAids" VALUES('MLD','Mildenhall',3,115.9);
INSERT INTO "NavAids" VALUES('LKH','Lakenheath',3,110.2);
INSERT INTO "NavAids" VALUES('BZN','Brize Norton',3,111.9);
INSERT INTO "NavAids" VALUES('LYE','Lyneham',3,109.8);

--zConversions--
DROP TABLE IF EXISTS "zConversions";
CREATE TABLE "zConversions" ("BaseUnit" TEXT(10)  NOT NULL , "BaseValue" INTEGER(10)  DEFAULT '1' , "ConvUnit" TEXT(10)  NOT NULL , "ConvValue" NUMERIC(10)  NOT NULL);

INSERT INTO "zConversions" VALUES('Nm',1,'Km',1.853184);
INSERT INTO "zConversions" VALUES('Nm',1,'Sm',1.151515);
INSERT INTO "zConversions" VALUES('Sm',1,'Nm',0.868);
INSERT INTO "zConversions" VALUES('Sm',1,'Km',1.609344);
INSERT INTO "zConversions" VALUES('Km',1,'Sm',0.621371);
INSERT INTO "zConversions" VALUES('Km',1,'Nm',0.539956);
INSERT INTO "zConversions" VALUES('Ft',1,'Metre',0.3048);
INSERT INTO "zConversions" VALUES('Metre',1,'Ft',3.280839);
INSERT INTO "zConversions" VALUES('hPa',1,'Hg',0.029529983);
INSERT INTO "zConversions" VALUES('Hg',1,'hPa',33.863886);
INSERT INTO "zConversions" VALUES('Fpm',1,'Mpm',0.304799);
INSERT INTO "zConversions" VALUES('Mpm',1,'Fpm',3.280839);
INSERT INTO "zConversions" VALUES('Kts',1,'Kmh',1.852);
INSERT INTO "zConversions" VALUES('Kmh',1,'Kts',0.539956);
INSERT INTO "zConversions" VALUES('Kts',1,'Mph',1.150779);
INSERT INTO "zConversions" VALUES('Mph',1,'Kts',0.868976);
INSERT INTO "zConversions" VALUES('Kmh',1,'Mph',0.621371);
INSERT INTO "zConversions" VALUES('Mph',1,'Kmh',1.609344);
INSERT INTO "zConversions" VALUES('Kg',1,'Lbs',2.204622);
INSERT INTO "zConversions" VALUES('Lbs',1,'Kgs',0.453592);
INSERT INTO "zConversions" VALUES('G',1,'L',4.54609);
INSERT INTO "zConversions" VALUES('USG',1,'L',3.785411784);
INSERT INTO "zConversions" VALUES('G',1,'USG',1.200949);
INSERT INTO "zConversions" VALUES('USG',1,'G',0.832674);
INSERT INTO "zConversions" VALUES('L',1,'G',0.219969);
INSERT INTO "zConversions" VALUES('L',1,'USG',0.264172);

--CurrentPlan--
DROP TABLE IF EXISTS "CurrentPlan";
CREATE TABLE "CurrentPlan" ("RouteId" TEXT(3) , "RouteName" TEXT(25) , "Phase" TEXT(3)  , "LegId" INTEGER(5)  , "WaypointType" TEXT(5)  , "WaypointId" INTEGER(5)  , "WaypointName" TEXT(20) ,   "MSA" NUMERIC(4) , "AreaTRA" NUMERIC(5) , "PlannedAlt" NUMERIC(5) ,  "Leg-QNH" INTEGER(4) , "TRL" INTEGER(3) , "TRA" INTEGER(3) , "MinFL" INTEGER(3) , "FL_Ref" INTEGER(3) , "QuadAlt" INTEGER(3) , "Reccmd_Alt" INTEGER(3) ,  "WX-Zone" INTEGER , "W-Dir" INTEGER(3) , "W-Speed" INTEGER(3) ,   "TrackT" INTEGER(3) , "Drift" INTEGER(4)  , "HDG-T" INTEGER(3) , "MagVar" INTEGER(4) , "HDG-M" INTEGER(3) , "CompassDeviation" INTEGER(4) , "HDG-C" INTEGER(3) ,  "LegDist" INTEGER(3) , "TAS" INTEGER(3) , "G/S" INTEGER(3) , "Leg-Time" INTEGER(3) , "LegFuel" INTEGER(3) ,   "Com1Id" INTEGER(3)  , "Com2Id" INTEGER(3) , "Nav1Id" INTEGER(3) , "Nav1Brg" INTEGER(3) , "Nav2Id" INTEGER(3) , "Nav2Brg" INTEGER(3) ,   "Remarks" INTEGER(3) , "Check" INTEGER(1) , "Warnings" TEXT(100) );


--Weather--
DROP TABLE IF EXISTS "Weather";
CREATE TABLE "Weather" ("Zone" INTEGER PRIMARY KEY  AUTOINCREMENT UNIQUE , "Latitude" VARCHAR(10) , "Longitude" VARCHAR(10) , "QNH" INTEGER(4) ,   "000_W-Dir" INTEGER(3), "000_W-Speed" INTEGER(3), "000_PAlt" INTEGER(3), "000_Tmp" INTEGER(3), "005_W-Dir" INTEGER(3), "005_W-Speed" INTEGER(3), "005_PAlt" INTEGER(3), "005_Tmp" INTEGER(3), "010_W-Dir" INTEGER(3), "010_W-Speed" INTEGER(3), "010_PAlt" INTEGER(3), "010_Tmp" INTEGER(3), "015_W-Dir" INTEGER(3), "015_W-Speed" INTEGER(3), "015_PAlt" INTEGER(3), "015_Tmp" INTEGER(3), "020_W-Dir" INTEGER(3), "020_W-Speed" INTEGER(3), "020_PAlt" INTEGER(3), "020_Tmp" INTEGER(3), "025_W-Dir" INTEGER(3), "025_W-Speed" INTEGER(3), "025_PAlt" INTEGER(3), "025_Tmp" INTEGER(3), "030_W-Dir" INTEGER(3), "030_W-Speed" INTEGER(3), "030_PAlt" INTEGER(3), "030_Tmp" INTEGER(3), "035_W-Dir" INTEGER(3), "035_W-Speed" INTEGER(3), "035_PAlt" INTEGER(3), "035_Tmp" INTEGER(3), "040_W-Dir" INTEGER(3), "040_W-Speed" INTEGER(3), "040_PAlt" INTEGER(3), "040_Tmp" INTEGER(3), "045_W-Dir" INTEGER(3), "045_W-Speed" INTEGER(3), "045_PAlt" INTEGER(3), "045_Tmp" INTEGER(3), "050_W-Dir" INTEGER(3), "050_W-Speed" INTEGER(3), "050_PAlt" INTEGER(3), "050_Tmp" INTEGER(3), "055_W-Dir" INTEGER(3), "055_W-Speed" INTEGER(3), "055_PAlt" INTEGER(3), "055_Tmp" INTEGER(3), "060_W-Dir" INTEGER(3), "060_W-Speed" INTEGER(3), "060_PAlt" INTEGER(3), "060_Tmp" INTEGER(3), "065_W-Dir" INTEGER(3), "065_W-Speed" INTEGER(3), "065_PAlt" INTEGER(3), "065_Tmp" INTEGER(3), "070_W-Dir" INTEGER(3), "070_W-Speed" INTEGER(3), "070_PAlt" INTEGER(3), "070_Tmp" INTEGER(3), "075_W-Dir" INTEGER(3), "075_W-Speed" INTEGER(3), "075_PAlt" INTEGER(3), "075_Tmp" INTEGER(3), "080_W-Dir" INTEGER(3), "080_W-Speed" INTEGER(3), "080_PAlt" INTEGER(3), "080_Tmp" INTEGER(3), "085_W-Dir" INTEGER(3), "085_W-Speed" INTEGER(3), "085_PAlt" INTEGER(3), "085_Tmp" INTEGER(3), "090_W-Dir" INTEGER(3), "090_W-Speed" INTEGER(3), "090_PAlt" INTEGER(3), "090_Tmp" INTEGER(3), "095_W-Dir" INTEGER(3), "095_W-Speed" INTEGER(3), "095_PAlt" INTEGER(3), "095_Tmp" INTEGER(3), "100_W-Dir" INTEGER(3), "100_W-Speed" INTEGER(3), "100_PAlt" INTEGER(3), "100_Tmp" INTEGER(3) );


--Routes--
DROP TABLE IF EXISTS "Routes";
CREATE TABLE "Routes" ("RouteId" TEXT(3) , "RouteName" TEXT(25) , "Phase" TEXT(3)  , "LegId" INTEGER(5)  , "WaypointType" TEXT(5)  , "WaypointId" INTEGER(5)  , "WaypointName" TEXT(20) ,   "MSA" NUMERIC(4) , "AreaTRA" NUMERIC(5) , "PlannedAlt" NUMERIC(5) ,  "Leg-QNH" INTEGER(4) , "TRL" INTEGER(3) , "TRA" INTEGER(3) , "MinFL" INTEGER(3) , "FL_Ref" INTEGER(3) , "QuadAlt" INTEGER(3) , "Reccmd_Alt" INTEGER(3) ,  "WX-Zone" INTEGER , "W-Dir" INTEGER(3) , "W-Speed" INTEGER(3) ,   "TrackT" INTEGER(3) , "Drift" INTEGER(4)  , "HDG-T" INTEGER(3) , "MagVar" INTEGER(4) , "HDG-M" INTEGER(3) , "CompassDeviation" INTEGER(4) , "HDG-C" INTEGER(3) ,  "LegDist" INTEGER(3) , "TAS" INTEGER(3) , "G/S" INTEGER(3) , "Leg-Time" INTEGER(3) , "LegFuel" INTEGER(3) ,   "Com1Id" INTEGER(3)  , "Com2Id" INTEGER(3) , "Nav1Id" INTEGER(3) , "Nav1Brg" INTEGER(3) , "Nav2Id" INTEGER(3) , "Nav2Brg" INTEGER(3) ,   "Remarks" INTEGER(3) , "Check" INTEGER(1) , "Warnings" TEXT(100) );


--Airports--
DROP TABLE IF EXISTS "Airports";
CREATE TABLE "Airports" ("AirportId" TEXT(5)  NOT NULL , "AirportName" TEXT(25)  NOT NULL , "PlateDate" TEXT(10)  NOT NULL , "Latitude" VARCHAR(10) , "Longitude" VARCHAR(10) , "AirportElevation" INTEGER(4) , "Localle1" TEXT(25) , "Localle2" TEXT(25) ,   "Nav1Id" TEXT(3) , "Nav1Brg" INTEGER(3) , "Nav1Dist" NUMERIC(5) , "Nav2Id" TEXT(3) , "Nav2Brg" INTEGER(3) , "Nav2Dist" NUMERIC(5)  ,    "Comm_Callsign" TEXT(25) , "Comm_APP" NUMERIC(7) , "Comm_RAD" NUMERIC(7) , "Comm_TWR" NUMERIC(7) , "Comm_GND" INTEGER(7) , "Comm_ATIS" INTEGER(7) , "Comm_DEP" INTEGER(7) , "Comm_VDF" INTEGER(7) , "Comm_DEL" INTEGER(7) ,  "Rwy1D1_DES" VARCHAR(3) , "Rwy1D1_SFC" INTEGER(1) , "Rwy1D1_TORA" INTEGER(5) , "Rwy1D1_LDA" INTEGER(5) , "Rwy1D1_ILS" NUMERIC(7) , "Rwy1D1_RMK" TEXT(25) , "Rwy1D1_LGT" TEXT(25) , "Rwy1D1_CCTD" TEXT(2) , "Rwy1D1_CCTH" INTEGER(4) , "Rwy1D1_THE" INTEGER(5) ,   "Rwy1D2_DES" VARCHAR(3) , "Rwy1D2_SFC" INTEGER(1) , "Rwy1D2_TORA" INTEGER(5) , "Rwy1D2_LDA" INTEGER(5) , "Rwy1D2_ILS" NUMERIC(7) , "Rwy1D2_RMK" TEXT(25) , "Rwy1D2_LGT" TEXT(25) , "Rwy1D2_CCTD" TEXT(2) , "Rwy1D2_CCTH" INTEGER(4) , "Rwy1D2_THE" INTEGER(5) ,   "Rwy2D1_DES" VARCHAR(3) , "Rwy2D1_SFC" INTEGER(1) , "Rwy2D1_TORA" INTEGER(5) , "Rwy2D1_LDA" INTEGER(5) , "Rwy2D1_ILS" NUMERIC(7) , "Rwy2D1_RMK" TEXT(25) , "Rwy2D1_LGT" TEXT(25) , "Rwy2D1_CCTD" TEXT(2) , "Rwy2D1_CCTH" INTEGER(4) , "Rwy2D1_THE" INTEGER(5) ,   "Rwy2D2_DES" VARCHAR(3) , "Rwy2D2_SFC" INTEGER(1) , "Rwy2D2_TORA" INTEGER(5) , "Rwy2D2_LDA" INTEGER(5) , "Rwy2D2_ILS" NUMERIC(7) , "Rwy2D2_RMK" TEXT(25) , "Rwy2D2_LGT" TEXT(25) , "Rwy2D2_CCTD" TEXT(2) , "Rwy2D2_CCTH" INTEGER(4) , "Rwy2D2_THE" INTEGER(5) ,   "Rwy3D1_DES" VARCHAR(3) , "Rwy3D1_SFC" INTEGER(1) , "Rwy3D1_TORA" INTEGER(5) , "Rwy3D1_LDA" INTEGER(5) , "Rwy3D1_ILS" NUMERIC(7) , "Rwy3D1_RMK" TEXT(25) , "Rwy3D1_LGT" TEXT(25) , "Rwy3D1_CCTD" TEXT(2) , "Rwy3D1_CCTH" INTEGER(4) , "Rwy3D1_THE" INTEGER(5) ,   "Rwy3D2_DES" VARCHAR(3) , "Rwy3D2_SFC" INTEGER(1) , "Rwy3D2_TORA" INTEGER(5) , "Rwy3D2_LDA" INTEGER(5) , "Rwy3D2_ILS" NUMERIC(7) , "Rwy3D2_RMK" TEXT(25) , "Rwy3D2_LGT" TEXT(25) , "Rwy3D2_CCTD" TEXT(2) , "Rwy3D2_CCTH" INTEGER(4) , "Rwy3D2_THE" INTEGER(5) ,   "Rwy4D1_DES" VARCHAR(3) , "Rwy4D1_SFC" INTEGER(1) , "Rwy4D1_TORA" INTEGER(5) , "Rwy4D1_LDA" INTEGER(5) , "Rwy4D1_ILS" NUMERIC(7) , "Rwy4D1_RMK" TEXT(25) , "Rwy4D1_LGT" TEXT(25) , "Rwy4D1_CCTD" TEXT(2) , "Rwy4D1_CCTH" INTEGER(4) , "Rwy4D1_THE" INTEGER(5) ,   "Rwy4D2_DES" VARCHAR(3) , "Rwy4D2_SFC" INTEGER(1) , "Rwy4D2_TORA" INTEGER(5) , "Rwy4D2_LDA" INTEGER(5) , "Rwy4D2_ILS" NUMERIC(7) , "Rwy4D2_RMK" TEXT(25) , "Rwy4D2_LGT" TEXT(25) , "Rwy4D2_CCTD" TEXT(2) , "Rwy4D2_CCTH" INTEGER(4) , "Rwy4D2_THE" INTEGER(5)    );

INSERT INTO "Airports" VALUES('EGCL','Fenland','2012','N52 44.37','W000 01.80',6,'6 Nm SE of Spalding',NULL,'BKY',358,45.1,'GAM',137,46.4,'Fenland Radio',NULL,NULL,122.925,NULL,NULL,NULL,NULL,NULL,'18',1,600,518,NULL,NULL,'Thr Rwy LITAS','RH',1000,NULL,'36',1,600,600,NULL,NULL,NULL,'LH',1000,NULL,'08',1,670,670,NULL,'unlicensed - Displaced Thr',NULL,'RH',1000,NULL,'26',1,670,670,NULL,'Unlicensed - Displaced Thr',NULL,'LH',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

--CREATE INDEX STATEMENTS--

--iWaypoints--
DROP INDEX IF EXISTS "iWaypoints";
CREATE INDEX "iWaypoints" ON "Waypoints" ("waypoint_id" ASC ,"waypoint_name" ASC ,"waypoint_type" ASC );

--iAircraftTypes--
DROP INDEX IF EXISTS "iAircraftTypes";
CREATE INDEX "iAircraftTypes" ON "AircraftTypes" ("AircraftTypeId" ASC ,"Type" ASC );

--iConfig--
DROP INDEX IF EXISTS "iConfig";
CREATE INDEX "iConfig" ON "Config" ("Type" ASC ,"Key" ASC );

--iCalcs--
DROP INDEX IF EXISTS "iCalcs";
CREATE INDEX "iCalcs" ON "zCalcs" ("Key" ASC );

--iRefData--
DROP INDEX IF EXISTS "iRefData";
CREATE INDEX "iRefData" ON "ReferenceData" ("Key" ASC ,"Type" ASC );

--iNavAids--
DROP INDEX IF EXISTS "iNavAids";
CREATE INDEX "iNavAids" ON "NavAids" ("NavId" ASC );

--iConversions--
DROP INDEX IF EXISTS "iConversions";
CREATE INDEX "iConversions" ON "zConversions" ("BaseUnit" ASC ,"ConvUnit" ASC );

--iWeather--
DROP INDEX IF EXISTS "iWeather";
CREATE INDEX "iWeather" ON "Weather" ("Zone" ASC ,"Latitude" ASC ,"Longitude" ASC );

--iRoutes--
DROP INDEX IF EXISTS "iRoutes";
CREATE INDEX "iRoutes" ON "Routes" ("RouteId" ASC ,"Phase" ASC ,"LegId" ASC ,"WaypointId" ASC );

--iAirports--
DROP INDEX IF EXISTS "iAirports";
CREATE INDEX "iAirports" ON "Airports" ("AirportId" ASC );

