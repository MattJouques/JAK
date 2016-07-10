-- weather.lua
----------------------------------------------------------
-- Application: JAK
-- Resource: weather.lua
-- Version: 0.1
-- Last Edit: 04_10_12
----------------------------------------------------------

module(..., package.seeall);

----------------------------------------------------------

-- Packages --
-- chkMet()      -- check the status of weather data
-- getMet()      -- Load curr plan waypoints and getmet
-- getWinds()    -- gets NWX Wind data


----------------------------------------------------------

function chkMet()
  --Winds Aloft
  local q = jak.dbQ("nwxReqTime","nwxWinds",[[waypnt_id = "1"]])
  if q == "1" then return "No Winds Data" end
  local age = os.time() - q
  local ageMins = age / 60
  if age > 1800 then
    print("Winds data needs updating " .. ageMins)
  else
    print("Winds data still current " .. ageMins)
  end

  --Metars

  --TAFs

return
end

----------------------------------------------------------

function getMet()
--load waypoints from current plan and request

  local WXn = jak.dbQ("WaypointId", "CurrentPlan")
  local WXp = jak.dbQ("WaypointLatLon", "CurrentPlan")
  local WXz = jak.dbQ("WaypointAlt", "CurrentPlan")
  local WXe = jak.dbQ("RouteTime", "CurrentPlan")
  getWinds(WXn, WXp, WXz, WXe)
  return
end

----------------------------------------------------------

function getWinds(WXn, WXp, WXz, WXe, WXu)

  local Wptn, Wptp, Wptz, Wptu, Wpte, WptR, i
  local WyPnts = {}

  --Check required inputs provided
  if WXn then Wptn = WXn else return false end
  if WXp then Wptp = WXp else return false end
  if WXz then Wptz = WXz else return false end
  if WXu then Wptu = WXu else Wptu = "F" end
  if WXe then Wpte = WXe[1] end

  --Construct Request Components
  for i=1,# Wptp do
    table.insert(WyPnts, [[<Wind id ="]] .. Wptn[i] .. [["
    p="]] .. Wptp[i] .. [[" z="]] .. Wptz[i] .. [[" u="]]
    .. Wptu .. [[" e="]] .. Wpte .. [["/>]])
  end

  --Construct XML request
  local wxWindRequest_body = [[
<nwx version="0.3.5">
<Request id="1">]]
  for i=1,# WyPnts do
    wxWindRequest_body = wxWindRequest_body .. WyPnts[i]
  end
  wxWindRequest_body = wxWindRequest_body .. [[
</Request>
</nwx>]]

  print("\n--- Winds Request ---\n")   -- temp
  print(wxWindRequest_body)            -- temp

  -- Winds Request
  local response_body = { }
  local res, code, response_headers = socket.http.request {
    url = "http://navlost.eu/nwxs/";
    method = "POST";
    headers = 
      {
       ["Content-Type"] = "application/xml";
      ["Content-Length"] = #wxWindRequest_body;
      };
    source = ltn12.source.string(wxWindRequest_body);
    sink = ltn12.sink.table(response_body);
   }

  -- Winds Server Response

  print("Status:", res and "OK" or "FAILED")
  print("HTTP code:", code)
  print("Response headers:")
  if type(response_headers) == "table" then
    for k, v in pairs(response_headers) do
      print(k, ":", v)
    end
  else
    -- Would be nil, if there is an error
    print("Not a table:", type(response_headers))
  end
  print("Response body:")
  if type(response_body) == "table" then
    print(table.concat(response_body))
  else
    -- Would be nil, if there is an error
    print("Not a table:", type(response_body))
  end
  
  -- Process Winds Response
  if not pcall(nwxWinds,response_body) then
    return "Unable to fetch Winds Data"
  else
    return "Fetch Winds Complete"
  end
end

----------------------------------------------------------

-- Process Winds Data --

function nwxWinds(s)

if not s then error("No Winds Data") end

local wx = {wpt={},latlon={},alt={},dir={},spd={}}
print(# s)
-- Get Waypoints from xml
for i, v in string.gmatch(s[1], [[(%w+%s%w+)="(%g+)"]]) do
  if i == "Wind id" then table.insert(wx.wpt, v) end
end

-- Get Waypoint Details from xml
for i, v in string.gmatch(s[1], [[(%w+)="(%g+)"]]) do
  if i == "p" then table.insert(wx.latlon, v) end
  if i == "z" then table.insert(wx.alt, v) end
end

-- Get Wind responses from xml
for k, v in string.gmatch(s[1], [[<(%w+)>(%w+)]])
do
  if k == "dir" then table.insert(wx.dir, v) end
  if k == "speed" then table.insert(wx.spd, v) end
end

-- Update Database

drop = assert (con:execute([[DELETE FROM CurrentPlan]]))

nwxReqTime = os.time()  --set the update time

for i=1,# wx.wpt do
  local query = [[INSERT INTO nwxWinds VALUES("]] .. i .. [[","]] .. wx.wpt[i] .. [[","]] .. nwxReqTime .. [[","]] .. wx.latlon[i] .. [[","]] .. wx.alt[i] .. [[","]] .. wx.dir[i] .. [[","]] .. wx.spd[i] .. [[")]]
  print(query)
  cur = assert (con:execute(query))
end
return 
end

----------------------------------------------------------



----------------------------------------------------------


function metarCheck()  --check status of METARs

return True

end

----------------------------------------------------------

function tafCheck()    --check status of TAFs

return True
  
end

----------------------------------------------------------





----------------------------------------------------------





