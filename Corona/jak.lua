----------------------------------------------------------
-- Application: JAK
-- Resource: jak.lua
-- Version: 0.1
-- Last Edit: 24_10_12
----------------------------------------------------------
module(..., package.seeall)
local jakM = {}

----------------------------------------------------------
-- Conversions
----------------------------------------------------------

local function conversion(cFrom, cTo, cVal)
	local cRes
	if cFrom == [["C"]] then 				-- Centigrade conversion
    	cRes = round( (((9 / 5) * cVal ) + 32), 1) 
    	return cRes 
	end
	if cFrom == [["F"]] then 				-- Farenheit conversion
    	cRes = round((5 / 9) * (cVal - 32), 1)
    return cRes 
  end	
	local query = [[SELECT ConvValue FROM zConversions WHERE BaseUnit = "]] .. cFrom .. [[" and ConvUnit = "]] .. cTo .. [["]]
	for row in db:nrows(query) do 						--TODO : Make this a protected call
		cRes = round (cVal * row.ConvValue, 2) 
	end
	print("Conversion result is ", cRes)
	return cRes
end

jakM.conversion = conversion

----------------------------------------------------------
-- Rounding function
----------------------------------------------------------

function round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

jakM.round = round



-- Keep at the bottom
return jakM