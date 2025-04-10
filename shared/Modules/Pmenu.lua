-- CONFIG
local IS_SERVER = IsDuplicityVersion()
GM = GM or {}

DefaultWeight = 1.0
DefaultVolume = { 1, 1 }

PlyWeight = 40.0
PlayerMaxVolume = 30.0

-- END CONFIG
function tableHasValue(tbl, value, k)
	if not tbl or not value or type(tbl) ~= "table" then return end
	for _,v in pairs(tbl) do
		if k and v[k] == value or v == value then return true, _ end
	end
end

function TimeToStr( time )
	local tmp = time or 0
	local s = math.floor(tmp % 60)
	tmp = math.floor( tmp / 60 )
	local m = math.floor(tmp % 60)
	tmp = math.floor( tmp / 60 )
	local h = math.floor(tmp % 24)
	tmp = math.floor( tmp / 24 )
	local d = math.floor(tmp % 7)
	local w = math.floor( tmp / 7 )

	return string.format( "%02is %id %02ih %02im %02is", w, d, h, m, s )
end

function Lerp(a, b, t)
	return a + (b - a) * t
end

function VecLerp(pos1, pos2, l, clamp)
	if clamp then
		if l < 0.0 then l = 0.0 end
		if l > 1.0 then l = 1.0 end
	end
	local x = Lerp(pos1.x, pos2.x, l)
	local y = Lerp(pos1.y, pos2.y, l)
	local z = Lerp(pos1.z, pos2.z, l)
	return vector3(x, y, z)
end

function GetDistanceBetweenCoords(a, b, c, d, e, f)
	local v1, v2 = type(a) == "vector3" and a or vector3(a, b, c), type(b) == "vector3" and b or type(a) == "vector3" and vector3(b, c, d) or type(d) == "vector3" and d or vector3(d, e, f)
	return math.sqrt((v2.x - v1.x) * (v2.x - v1.x) + (v2.y - v1.y) * (v2.y - v1.y) + (v2.z - v1.z) * (v2.z - v1.z))
end

function GetDistanceBetweenPlayers(playerOne, playerTwo)
	local pedOne, pedTwo = GetPlayerPed(playerOne), GetPlayerPed(playerTwo)
	return DoesEntityExist(pedOne) and DoesEntityExist(pedTwo) and GetDistanceBetweenCoords(GetEntityCoords(pedOne), GetEntityCoords(pedTwo)) or 9999
end

function tableRemoveByValue(tbl, val, i)
	local ntbl = {}
	for k,v in pairs(tbl) do
		if v ~= val and (not i or v[i] ~= val) then ntbl[#ntbl + 1] = v end
	end
	return ntbl
end

function PrettyMoneyFormat(money, sep)
	money = money or 0

	local negative, sep = money < 0, sep or ","
	money = tostring(math.abs(math.floor(money)))

	local dp = string.find(money, "%.") or #money + 1
	for i = dp - 4, 1, -3 do
		money = money:sub(1, i) .. sep .. money:sub(i + 1)
	end

	return (negative and "-" or "") .. money
end

function MilliSecondsToClock(seconds)
	seconds = tonumber(seconds / 1000)

	if seconds <= 0 then
		return "00:00.00"
	else
		local mins = string.format("%02.f", math.floor(seconds / 60))
		local secs = string.format("%02.f", math.floor(seconds - mins * 60))
		local milli = string.format("%02.f", math.floor((seconds * 1000 - mins * 60000 - secs * 1000) / 10))
		return string.format("%s:%s.%s", mins, secs, milli)
	end
end

function SecondsToClock(seconds)
	seconds = tonumber(seconds)

	if seconds <= 0 then
		return "00:00"
	else
		local mins = string.format("%02.f", math.floor(seconds / 60))
		local secs = string.format("%02.f", math.floor(seconds - mins * 60))
		return string.format("%s:%s", mins, secs)
	end
end

function SecondsToClockWithHour(seconds)
	seconds = tonumber(seconds)

	if seconds <= 0 then
		return "00h00"
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))

		return string.format("%sh%s", hours, mins)
	end
end

function compare(a,b)
	a, b = a.name or a[1], b.name or b[1]
	return tostring(a) < tostring(b)
end

function compareName(a, b)
	return a.name < b.name
end

function stringsplit(inputstr, sep)
	if not inputstr then return end
	if sep == nil then
		sep = "%s"
	end

	local t = {}
	local i = 1

	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function tableCount(tbl, checkCount)
	if not tbl or type(tbl) ~= "table" then return not checkCount and 0 end
	local n = 0
	for k,v in pairs(tbl) do
		n = n + 1
		if checkCount and n >= checkCount then return true end
	end
	return not checkCount and n
end

table.Count = tableCount
table.HasValue = tableHasValue

function table.find(tbl, value, keyName)
	for k, v in pairs(tbl) do
		if (keyName and v[keyName] == value) or (not keyName and v == value) then return k, v end
	end
end

function firstToUpper(str)
	return str and str:gsub("^%l", string.upper) or str
end

function updateVar(varName, varValue, surValue)
	return exports["pichot_datahandler"]:updateVar(varName, varValue, surValue)
end

function getVar(varName)
	return exports["pichot_datahandler"]:getVar(varName)
end

function updateInVar(varName, tbl)
	return exports["pichot_datahandler"]:updateInVar(varName, tbl)
end

function round(num, numDecimalPlaces)
	if numDecimalPlaces and numDecimalPlaces > 0 then
		local mult = 10 ^ numDecimalPlaces
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end

function Deepcopy(orig)
	local orig_type, copy = type(orig)
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[Deepcopy(orig_key)] = Deepcopy(orig_value)
		end
		setmetatable(copy, Deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function GetItemPer(itemData, customTime)
	if GetConvarInt("sh_peremptionDisabled", 0) == 1 then return 99999999 end

	local time = customTime or IS_SERVER and os.time() or GetCloudTimeAsInt()
	return itemData and itemData.per and math.ceil((itemData.per - time) / 86400)
end

function TableToString(tbl)
	local result = "{ "
	local i = 0
	local lastKey

    for k, v in pairs(tbl) do
		-- Check the key type (ignore any numerical keys - assume its an array)
		i = i + 1
        if type(k) == "string" then
			if tonumber(k) then
				result = result.."[" .. k .. "] = "
			else
            	result = result.."" .. k .. " = "
			end
		elseif type(k) == "number" then
			if (lastKey and lastKey + 1 ~= k and lastKey ~= 1) or k == 0 then
				result = result.."[" .. k .. "] = "
			end

			if k == 0 then
				lastKey = nil
			else
				lastKey = k
			end
		end

        -- Check the value type
        if type(v) == "table" then
            result = result..TableToString(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
		elseif type(v) == "vector3" then
			result = result.."vector3("..v.x..", "..v.y..", "..v.z..")"
		else
			if type(v) == "number" then
            	result = result .. v
			else
				result = result.."\""..v.."\""
			end
        end

        result = result .. (tableCount(tbl) == i and " " or ", ")
    end

    -- Remove leading commas from the result
    if result ~= "" and result:len() > 1 then
        result = string.sub(result, 1, string.len(result) - 1)
    end

    return result.." }"
end

table.ToString = TableToString

function SQLStr( str_in, bNoQuotes )
	local str = tostring( str_in )

	str = str:gsub( "'", "''" )

	local null_chr = string.find( str, "\0" )
	if null_chr then
		str = string.sub( str, 1, null_chr - 1 )
	end

	if ( bNoQuotes ) then
		return str
	end

	return "'" .. str .. "'"
end

function table.GetKeys( tab, safeKeys )
	local keys = {}
	local id = 1

	for k, v in pairs( tab ) do
		keys[ id ] = safeKeys and SQLStr(k) or k
		id = id + 1
	end
	return keys
end

function PrintTable( t, indent, done )
	if t == nil then return Citizen.Trace("nil\n") end
	if (type(t) ~= "table") then return Citizen.Trace(t..'\n') end
	done = done or {}
	indent = indent or 0
	local keys = table.GetKeys( t )

	table.sort( keys, function( a, b )
		if ( type( a ) == "number" and type( b ) == "number" ) then return a < b end
		return tostring( a ) < tostring( b )
	end )

	done[ t ] = true

	for i = 1, #keys do
		local key = keys[ i ]
		local value = t[ key ]
		Citizen.Trace( "^4" .. string.rep( "\t", indent ) .. "^0" )

		if  ( type( value ) == "table" and not done[ value ] ) then
			done[ value ] = true
			Citizen.Trace( tostring( key ) .. ":" .. "\n" )
			PrintTable ( value, indent + 2, done )
			done[ value ] = nil
		else
			Citizen.Trace( "^4" .. tostring( key ) .. "\t=\t" .. tostring( value ) .. "\n^0" )
		end
	end
end

local i18n = exports["gtalife-i18n"];
local GetPhrase
function ChatNotif(a, b, c, ...)
	if IS_SERVER then
		TriggerClientEvent("pichot:chatMessage", a, GM and GM.ServerName or "GLife", c or {18, 197, 101}, b, ...)
	else
		if not GetPhrase then
			GetPhrase = GetPhrase or function(...)
				return i18n:GetPhrase(...)
			end
		end

		TriggerEvent("chatMessage", b and GetPhrase(b) or (GM and GM.ServerName or "GLife"), c or {18, 197, 101}, GetPhrase(a, ...) or "Position saved to file.")
	end
end

local m_tblConfigColorSupport = {
    ["0"] = "F0F0F0",
    ["1"] = "F44336",
    ["2"] = "4CAF50",
    ["3"] = "FFEB3B",
    ["4"] = "42A5F5",
    ["5"] = "03A9F4",
    ["6"] = "9C27B0",
    ["7"] = "F0F0F0",
    ["8"] = "FF5722",
    ["9"] = "9E9E9E",
}

function GetTextWithGameColors(strText)
	if not strText or not string.find(strText, "^") then return strText end

	local newText = ""
	local isFontTagOpen = false
	local i = 1

	while i <= strText:len() do
	    local character = strText:sub(i, i)

	    if character == "^" then
	        local color = strText:sub(i + 1, i + 1)
	        local fontColor

	        if color and color == "#" then
	            fontColor = strText:sub(i + 1, i + 7)
	            i = i + 8
	        elseif m_tblConfigColorSupport[color] then
	           fontColor = "#" .. m_tblConfigColorSupport[color]
	           i = i + 2
			else
				i = i + 1
			end

			if fontColor then
				newText = newText .. (isFontTagOpen and "</FONT>" or "") .. "<FONT color='" .. fontColor .. "'>"
				isFontTagOpen = true
			end
	    else
	        newText = newText .. character
	        i = i + 1
	    end
    end

    if isFontTagOpen then
        newText = newText .. "</FONT>"
    end

    return newText
end

function GetPlayerIdentifierFromType(identifierType, source)
	local identifiers = type(source) == "table" and source or GetPlayerIdentifiers(source)

	for b = 1, #identifiers do
		if string.find(identifiers[b], identifierType, 1) then
			return stringsplit(identifiers[b], ":")[2]
		end
	end

	return nil
end

function GetPlayerIdentifiersWithType(identifiers)
	local ids = {}

	for _,v in pairs(identifiers) do
		local ab = stringsplit(v, ":")
		ids[ab[1]] = ab[2]
	end

	return ids
end

function ToBool(value)
	if value == nil then return false end
	local t = type(value)
	local result = false
	if t == "number" then
		result = value >= 1 and true or false
	elseif t == "string" then
		value = value:lower()
		result = (value == "true" or value == "1") and true or false
	end
	return result
end

if not os then
	os = {}
	function os.time()
		return GetCloudTimeAsInt()
	end
end

local randomKeep = 0

-- TODO: improve
function Random(x, y)
	randomKeep = randomKeep + 1

    if x ~= nil and y ~= nil then
        return math.floor(x +(math.random(math.randomseed(os.time()+randomKeep))*999999 %y))
    else
        return math.floor((math.random(math.randomseed(os.time()+randomKeep))*100))
    end
end

local function sign(vec1, vec2, vec3)
    return (vec1.x - vec3.x) * (vec2.y - vec3.y) - (vec2.x - vec3.x) * (vec1.y - vec3.y)
end

function IsPointInTriangle2d(position, pointA, pointB, pointC)
    local dVec1 = sign(position, pointA, pointB)
    local dVec2 = sign(position, pointB, pointC)
    local dVec3 = sign(position, pointC, pointA)

    local hasNeg = dVec1 < 0 or dVec2 < 0 or dVec1 < 0
    local hasPos = dVec1 > 0 or dVec2 > 0 or dVec3 > 0

    return not (hasNeg and hasPos)
end

function GetForwardVector(rot)
	rot = rot * (math.pi / 180.0)
	return vec3(
		-math.sin(rot.z) * math.abs(math.cos(rot.x)),
		math.cos(rot.z) * math.abs(math.cos(rot.x)),
		math.sin(rot.x)
	)
end

function DegreeToRadian(degree)
	return degree * (math.pi / 180)
end

function GetUpVector(rot)
	rot = DegreeToRadian(rot)
	return vec3(0.0, 0.0, math.cos(rot.x))
end

function GetRightVector(rot)
	rot = DegreeToRadian(rot)
	return vec3(math.cos(rot.z), math.sin(rot.z), 0.0)
end

function RadianToDegree(radian)
    return radian * (180.0 / math.pi)
end

function GetUintHash(str)
	return GetHashKey(str) & 0xFFFFFFFF
end

function NumWithCommas(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,"):gsub(",(%-?)$","%1"):reverse()
end

function RotToQuat(rot)
	local pitch = math.rad(NormalizeEulerAngle(rot.x))
	local roll  = math.rad(NormalizeEulerAngle(rot.y))
	local yaw   = math.rad(NormalizeEulerAngle(rot.z))

    local cy = math.cos(yaw   * 0.5)
	local sy = math.sin(yaw   * 0.5)
	local cr = math.cos(roll  * 0.5)
	local sr = math.sin(roll  * 0.5)
	local cp = math.cos(pitch * 0.5)
	local sp = math.sin(pitch * 0.5)

	return vec4(cy * sp * cr - sy * cp * sr, cy * cp * sr + sy * sp * cr, sy * cr * cp - cy * sr * sp, cy * cr * cp + sy * sr * sp)
end

function QuatToRot(quat)
	local ysqr = quat.y * quat.y

	local t0 = 2.0 * (quat.w * quat.x + quat.y * quat.z)
	local t1 = 1.0 - 2.0 * (quat.x * quat.x + ysqr)

	local t2 = 2.0 * (quat.w * quat.y - quat.z * quat.x)
	local t2 = (t2 >  1.0) and  1.0 or t2
	local t2 = (t2 < -1.0) and -1.0 or t2

	local t3 = 2.0 * (quat.w * quat.z + quat.x * quat.y)
	local t4 = 1.0 - 2.0 * (ysqr + quat.z * quat.z)

	return vec3(math.deg(math.atan2(t1, t0)), math.deg(math.asin(t2)), math.deg(math.atan2(t4, t3)))
end

function math.atan2(x, y)
	if x > 0 then
		return math.atan(y / x)
	end

	if x < 0 and y >= 0 then
		return math.atan(y / x) + math.pi
	end

	if x < 0 and y < 0 then
		return math.atan(y / x) - math.pi
	end

	if x == 0 and y > 0 then
		return math.pi / 2
	end

	if x == 0 and y < 0 then
		return - (math.pi / 2)
	end

	if x == 0 and y == 0 then
		return nil
	end
end

function NormalizeEulerAngle(angle)
    while angle > 360 do
        angle = angle - 360
    end

    while angle < 0 do
        angle = angle + 360
    end

    return angle
end

function ConvertClothStructFromString(t)
	local newtblClothes = { c = {}, p = {}, h = {}, e = {}, f = t.f or {} }

	if t.c then
		for i = 0, 12 do
			newtblClothes.c[i] = t.c[tostring(i)] or t.c[i] or {0, 0}
		end
	end

	if t.p then
		for _, i in pairs({0, 1, 2, 6, 7}) do
			newtblClothes.p[i] = t.p[tostring(i)] or t.p[i] or {-1, 0}
		end
	end

	if t.h then
		for i = 0, 12 do
			newtblClothes.h[i] = t.h[tostring(i)] or t.h[i] or {-1, 1.0, 0}
		end
	end

	if t.e then
		newtblClothes.e = t.e or {}
		newtblClothes.e[2] = t.e and t.e[2] or {}

		local ta, a = t.e[2], {}
		for k,v in pairs(ta) do
			a[tonumber(k)] = v
		end
		newtblClothes.e[2] = a
	end

	return newtblClothes
end



local function distance(v1, v2)
    local dx = v1.x - v2.x
    local dy = v1.y - v2.y
    local dz = v1.z - v2.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

function IsPointBetweenWithRadius(p, a, b, radius)
    local ab = distance(a, b)
    local ap = distance(a, p)
    local bp = distance(b, p)

    if ap + bp - ab < radius then
        return true
    else
        return false
    end
end

function AddLongString(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentSubstringPlayerName(sub)
	end
end