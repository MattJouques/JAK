-- jak.lua
----------------------------------------------------------
-- Application: JAK
-- Resource: jak.lua
-- Version: 0.1
-- Last Edit: 06_10_12
----------------------------------------------------------

module(..., package.seeall);

----------------------------------------------------------
-- DbQuery
----------------------------------------------------------

function dbQ(c, t, p)
  local z = {}
  query = ("SELECT " .. c .. " FROM " .. t)
  --Check for request Pointer
  if p then query = query .. " WHERE " .. p end
    --print(query)
  --Create the Cursor
  cur = assert (con:execute(query))
  row = cur:fetch ({}, "n")
  while row do
    for i=1, # row do
      table.insert(z, row[i])
      --print(i, row[i])
    end
    row = (cur:fetch (row, "n"))
  end
  cur:close()
  if # z == 1 then return z[1]
  else return z
  end
end

----------------------------------------------------------
-- Database Update
----------------------------------------------------------

function dbUpdate(t, c, v, p)
  local qC, qT, qV, qP, query
  if t then qT = t else return false end
  if c then qC = c else return false end
  if v then qV = v else return false end
  query = ("UPDATE " .. qT .. " SET " .. qC .. " = " .. qV)
  --Check for request Pointer
  if p then query = query .. " WHERE " .. p end
  --print(query)
  cur = assert (con:execute(query))
  con:commit()
  --cur:close()
  return query
end

----------------------------------------------------------
-- Database Insert
----------------------------------------------------------

function dbInsert(t, v)
  if type(v) == "table" then
    for i=1, #v do
      print(v[i])
    end
  else
  if t then query = "INSERT INTO " .. t .. " VALUES(" .. v .. [[)]]
    print(query)
    res = assert (con:execute(query))
  end
  end
  con:commit()
return
end

----------------------------------------------------------
-- Database Close --
----------------------------------------------------------

function databaseClose()
  cur:close()
  con:close()
  env:close()
end

----------------------------------------------------------
-- Table extractor --
----------------------------------------------------------

function tableList(t)
  for i=1,# t do
    print(i,t[i])
  end
end

----------------------------------------------------------
-- Convert from CSV string to table 
-- (converts a single line of a CSV file)
----------------------------------------------------------

function fromCSV(s)
  s = s .. ','        -- ending comma
  local t = {}        -- table to collect fields
  local fieldstart = 1
  repeat
    -- next field is quoted? (start with `"'?)
    if string.find(s, '^"', fieldstart) then
      local a, c
      local i  = fieldstart
      repeat
        -- find closing quote
        a, i, c = string.find(s, '"("?)', i+1)
      until c ~= '"'    -- quote not followed by quote?
      if not i then error('unmatched "') end
      local f = string.sub(s, fieldstart+1, i-1)
      table.insert(t, (string.gsub(f, '""', '"')))
      fieldstart = string.find(s, ',', i) + 1
    else                -- unquoted; find next comma
      local nexti = string.find(s, ',', fieldstart)
      table.insert(t, string.sub(s, fieldstart, nexti-1))
      fieldstart = nexti + 1
    end
  until fieldstart > string.len(s)
  return t
end

----------------------------------------------------------
-- Convert from table to CSV string
----------------------------------------------------------

function toCSV(tt)
  local s = ""
  for _,p in pairs(tt) do
    s = s .. "," .. escapeCSV(p)
  end
  return string.sub(s, 2)      -- remove first comma
end

----------------------------------------------------------
-- Trim whitespace --
----------------------------------------------------------

function trim(s)
  return s:match "^%s*(.-)%s*$"
end

----------------------------------------------------------
-- Unit Conversion
----------------------------------------------------------

function unitConv(bU, bV, cU, cV)
  local Res
  if bU == [["C"]] then 
    Res = round( (((9 / 5) * bV ) + 32), 1) 
    return Res 
  end
  if bU == [["F"]] then 
    Res = round((5 / 9) * (bV - 32), 1)
    return Res 
  end
  local cF = (dbQ("ConvValue", "zConversions", "BaseUnit = " .. bU .. " AND ConvUnit = " .. cU))
  local nT = tonumber(cF)
  Res = round(bV * nT, 2)
  return Res
end

----------------------------------------------------------
-- Rounding function
----------------------------------------------------------

function round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

----------------------------------------------------------
-- Heading Calculator
----------------------------------------------------------

function heading(t, s, d, v)
  local tt, tas, wd, ws, res
  if t then tt = tonumber(t) else return false end
  if s then tas = tonumber(s) else return false end
  if d then wd = tonumber(d) else return false end
  if v then ws = tonumber(v) else return false end

  --the Maths

if tt + math.deg(math.asin(ws * math.sin(math.rad(tt - wd + 180)) / tas)) > 359.5 then 
  res = (tt - 360) + (math.deg(math.asin(ws * math.sin(math.rad(tt - wd + 180)) / tas)))
else
  if tt + math.deg(math.asin(ws * math.sin(math.rad(tt - wd + 180)) / tas)) < 0 then
    res = tt + 360 + math.deg(math.asin(ws * math.sin(math.rad(tt - wd + 180)) / tas))
  else
    res = tt + math.deg(math.asin(ws * math.sin(math.rad(tt - wd + 180)) / tas))
  end
end
  return res
end

----------------------------------------------------------
-- Rhumb bearing
----------------------------------------------------------

function rhumb(lat1, lon1, lat2, lon2)
  if not lat1 then return end
  if not lon1 then return end
  if not lat2 then return end
  if not lon2 then return end
  --difference in longitudinal coordinates
  local dLon = math.rad(lon2) - math.rad(lon1)
  --difference in the phi of latitudinal coordinates
  local dPhi = math.log(math.tan(math.rad(lat2) / 2 + math.pi / 4) / math.tan(math.rad(lat1) / 2 + math.pi / 4))
  --recalculate $dLon if it is greater than pi
  if (math.abs(dLon) > math.pi) then
    if(dLon > 0) then
      dLon = (2 * math.pi - dLon) * - 1
    else
      dLon = 2 * math.pi + dLon
    end
  end
  --return the angle, normalized
  local t = degPad(round((math.deg(math.atan2(dLon, dPhi)) + 360) % 360))

  -- Distance Calcs
  local dst = dist(lat1, lon1, lat2, lon2)
  
return t, dst
end

----------------------------------------------------------
-- distance Calc
----------------------------------------------------------

function dist(lt1, ln1, lt2, ln2)
  local lat1 = math.rad(lt1)
  local lon1 = math.rad(ln1)
  local lat2 = math.rad(lt2)
  local lon2 = math.rad(ln2)
  
  local d
  local dlon_W = math.fmod((lon2 - lon1), (2 * math.pi))
  local dlon_E = math.fmod(lon1 - lon2, 2 * math.pi)
  local distphi = math.log(math.tan(lat2 / 2 + math.pi / 4) / math.tan(lat1 / 2 + math.pi / 4 ))
  if (math.abs(lat2 - lat1) < math.sqrt(1e-15)) then
     q = math.cos(lat1)
   else
     q = (lat2 - lat1) / distphi
  end
  if (dlon_W < dlon_E) then --Westerly rhumb line is the shortest
    d = math.sqrt((q^2 * dlon_W^2) + ((lat2-lat1)^2))
  else
    d = math.sqrt((q^2 * dlon_E^2) + ((lat2-lat1)^2))
  end
  local dst = round(((180*60) / math.pi) * d)
return dst
end

----------------------------------------------------------
-- degree padding
----------------------------------------------------------

function degPad(i)
  if not i then return end
  local len = string.len(i)
  local z, o 
  z = tostring(i)
  if len == 3 then o = z end
  if len == 2 then o = "0" .. z end
  if len == 1 then o = "00" .. z end
  return o
end

----------------------------------------------------------
-- load gpx
----------------------------------------------------------

function loadGPX(route_id)
  if not route_id then return end
  -- define vars
  local b, i, v, gpxWpts, d, t
  local plan = {lat={}, lon={}, latlon={}, wptid={}, wptnm={}, brg={}, dist={}}

  -- Assign Route id
  local pointer = [[Route_id = "]] .. route_id .. [["]]
  --Load Route from db
  ok, gpxWpts = pcall(dbQ, "gpxXml","gpxRoutes", pointer)
  if type(gpxWpts) == "table" then return end
  print(gpxWpts)

-- Read gpx xml --
  
-- Get Waypoint lat
for i, v in string.gmatch(gpxWpts, [[(%w+%s%w+)="(%g+)"]]) do
if i == "wpt lat" then table.insert(plan.lat, v) end
end

-- Get Waypoint lon
for i, v in string.gmatch(gpxWpts, [[(%w+)="(%g+)"]]) do
  if i == "lon" then table.insert(plan.lon, v) end
end

-- Get Waypoint id
for i, v in string.gmatch(gpxWpts, [[<(%w+)>(%w+(.%w+))<]]) do
  if i == "name" then table.insert(plan.wptid, v) end
  if i == "cmt" then table.insert(plan.wptnm, v) end
end

-- process tables
for i=1, #plan.lat do
  
  -- Shorten & concat latlon for wx
  local conclat = jak.round(plan.lat[i], 2)
  local conclon = jak.round(plan.lon[i], 2)
  table.insert(plan.latlon, conclat .. "," .. conclon)
  
  -- Clean up tables for double count rtept
  table.remove(plan.lon)
  table.remove(plan.wptid)
  
  -- Calculate Rhumb bearing
  if i == 1 then t = 0 d = 0 else
    a = i - 1
    b = a + 1
    t, d = rhumb(plan.lat[a], plan.lon[a], plan.lat[b], plan.lon[b])
  end
  table.insert(plan.brg, t)
  table.insert(plan.dist, d)
end

  -- Get route name
  route_name = plan.wptid[# plan.wptid]
  -- Clean up route Name from table
  table.remove(plan.wptid)

-- Update Current Plan
  -- Drop current plan table
  drop = assert (con:execute([[DELETE FROM CurrentPlan]]))

  --Build nulls
  local addNulls = [[null']]
  for i=1, 17 do
    addNulls = addNulls ..[[,'null']]
  end

  -- Insert plan
  for i=1, #plan.lat do
    local gfd = ([[']] ..
    route_id ..[[',']].. 
    route_name ..[[',']]..
    [[null',']]..  
    i ..[[',']].. 
    plan.wptid[i] ..[[',']]..  
    plan.wptnm[i] ..[[',']].. 
    plan.lat[i] ..[[',']].. 
    plan.lon[i] ..[[',']].. 
    plan.latlon[i] ..[[',']].. 
    plan.dist[i] ..[[',']].. 
    [[null',']]..  
    [[null',']]..  
    plan.brg[i] ..[[',']].. 
    addNulls)
    dbInsert("CurrentPlan", gfd)
  end
end

----------------------------------------------------------
-- Set Route Date / Time
----------------------------------------------------------

function routeTime(Time)
  if not Time then return end
  dbUpdate("CurrentPlan", "RouteTime", Time) 
end

----------------------------------------------------------
-- Set Route Altitudes
----------------------------------------------------------

function routeAlts(usrWptAlts)
  if not usrWptAlts then return end
  if type(usrWptAlts) ~= "table" then return end
  for i=1, # usrWptAlts do
    jak.dbUpdate("CurrentPlan", "WaypointAlt", usrWptAlts[i], [[LegId = "]] .. i ..[["]])
  --print(usrWptAlts[i])
  end
end

----------------------------------------------------------
-- Null Generator
----------------------------------------------------------

function NullPad(num)
  local addNulls = [['null']]
  for i=1, num -1 do
    addNulls = addNulls ..[[,'null']]
  end
  return addNulls
end

----------------------------------------------------------
-- apply TAS to plan
----------------------------------------------------------

function acTAS(id)
  local aircraft, acTAS
  if id then aircraft = id
  else
    ok, aircraft = pcall(jak.dbQ, "Value", "Config", [[Key = "Aircraft"]])
    print(aircraft)
  end
  if aircraft == nil then return end
  acTAS = jak.dbQ("VC", "AircraftTypes", [[AircraftTypeId = ]] .. aircraft)
  if type(acTAS) == "table" then return end
  jak.dbUpdate("CurrentPlan", "TAS", acTAS) 
return
end

----------------------------------------------------------
-- HDG_T and GS calculations
----------------------------------------------------------

function calcHeading()
  local t, s, d, v, HDG, dist
  local Wpts = {}
  Wpts = dbQ( "WaypointId", "CurrentPlan")
  if type(Wpts) == "table" then 
  for i=1, # Wpts do
    t = dbQ("TRK_T", "CurrentPlan", [[WaypointId = "]] .. Wpts[i] ..[["]])
    s = dbQ("TAS", "CurrentPlan", [[WaypointId = "]] .. Wpts[i] ..[["]])
    d = dbQ("waypntdir", "nwxWinds", [[waypnt_nam = "]] .. Wpts[i] ..[["]])
    v = dbQ("waypntspd", "nwxWinds", [[waypnt_nam = "]] .. Wpts[i] ..[["]])
    h = heading(t, s, d, v)
    HDG =  [[']] .. degPad(round(h)) .. [[']]
    jak.dbUpdate("CurrentPlan", "HDG_T", HDG , [[WaypointId = "]] .. Wpts[i] ..[[" AND TRK_T = "]] .. t .. [["]])
  -- GroundSpeed
    GS = round((s * math.cos(math.rad(t - h)))+(v * math.cos(math.rad(t - d + 180))))
  jak.dbUpdate("CurrentPlan", "GS", GS , [[WaypointId = "]] .. Wpts[i] ..[[" AND TRK_T = "]] .. t .. [["]])
  -- Leg Time
  dist = dbQ("WaypointDist", "CurrentPlan", [[WaypointId = "]] .. Wpts[i] ..[["]])
  leg = round(60 / (GS / dist))
  jak.dbUpdate("CurrentPlan", "Leg_Time", leg , [[WaypointId = "]] .. Wpts[i] ..[[" AND TRK_T = "]] .. t .. [["]])
  end
  end
return
end

