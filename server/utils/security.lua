local PlayersToken = {}
PlayersLastTrigger = {}
substitutionTable = {          
    ["a"] = "8", ["b"] = "@", ["c"] = "#", ["d"] = "4",
    ["e"] = "1", ["f"] = "!", ["g"] = "9", ["h"] = "0",
    ["i"] = "2", ["j"] = "&", ["k"] = "3", ["l"] = "$",
    ["m"] = "5", ["n"] = "%", ["o"] = "7", ["p"] = "*",
    ["q"] = "6", ["r"] = "(", ["s"] = ")", ["t"] = "-",
    ["u"] = "_", ["v"] = "+", ["w"] = "=", ["x"] = "[",
    ["y"] = "]", ["z"] = "{",
    
    ["A"] = "Q", ["B"] = "W", ["C"] = "E", ["D"] = "R",
    ["E"] = "T", ["F"] = "Y", ["G"] = "U", ["H"] = "I",
    ["I"] = "O", ["J"] = "P", ["K"] = "A", ["L"] = "S",
    ["M"] = "D", ["N"] = "F", ["O"] = "G", ["P"] = "H",
    ["Q"] = "J", ["R"] = "K", ["S"] = "L", ["T"] = "Z",
    ["U"] = "X", ["V"] = "C", ["W"] = "V", ["X"] = "B",
    ["Y"] = "N", ["Z"] = "M",
    
    ["0"] = "t", ["1"] = "u", ["2"] = "v", ["3"] = "w",
    ["4"] = "x", ["5"] = "y", ["6"] = "z", ["7"] = "a",
    ["8"] = "b", ["9"] = "c",
    
    [" "] = " ", ["_"] = "?"
}
function _TRGSE(input)
    local encrypted = ""
    for i = 1, #input do
        local char = input:sub(i, i)
        local encryptedChar = substitutionTable[char] or char
        encrypted = encrypted .. encryptedChar
    end
    return encrypted
end
local function DoesPlayerHaveToken(source)
    if PlayersToken[source] == nil then
        return false
    else
        return true
    end
end

local function SetPlayerToken(source, token)
    if not DoesPlayerHaveToken(source) then
        PlayersToken[source] = token
        return true
    else
        return false
    end
end

function CheckPlayerToken(source, token)
    if DoesPlayerHaveToken(source) then
        if PlayersToken[source] == token then
            return true
        else
            return false
        end
    else
        return false
    end
end

function CheckLastTrigger(source, time)
    if PlayersLastTrigger[source] == nil then
        PlayersLastTrigger[source] = time
        return true
    else
        if PlayersLastTrigger[source] == time or tonumber(time) < tonumber(PlayersLastTrigger[source]) then
            return false
        else
            PlayersLastTrigger[source] = time
            return true
        end
    end
end

function CheckGiveTrigger(source, time, secu, item, count, ban)
    if CheckLastTrigger(source, time) then

        local crypte = _TRGSE(source..time..tostring(count)..item)
        if tostring(crypte) == tostring(secu) then
            return true
        else
            if count == nil then count = "0" end
            SunWiseKick(source, "(Give Trigger) : "..ban.." - Item : "..item.." x"..tostring(count))
            DropPlayer(source, "(Give Trigger) : "..ban.." - Item : "..item.." x"..tostring(count))
            return false
        end
    else
        PlayersLastTrigger[source] = nil
        SunWiseKick(source, "(Try a fake exec) : "..ban.." - Item : "..item.." x"..tostring(count))
        DropPlayer(source, "(Try a fake exec) : "..ban.." - Item : "..item.." x"..tostring(count))
    end
end

function CheckTrigger(source, time, secu, ban)
    if CheckLastTrigger(source, time) then

        local crypte = _TRGSE(time..source)
        if tostring(crypte) == tostring(secu) then
            return true
        else
            DropPlayer(source, "(Execute Trigger) : "..ban)
            return false
        end
    else
        PlayersLastTrigger[source] = nil
        DropPlayer(source, "(Try a fake exec) : "..ban)
    end
end

function CheckPlayerJob(source, jobNeeded)
    local player = GetPlayer(source)
    if player:getJob() ~= jobNeeded then
        -- ban ?
        return false
    else
        return true
    end
end



AddEventHandler("playerDropped", function()
    local src = source
    PlayersLastTrigger[src] = nil
end)


RegisterNetEvent("core:RegisterPlayerToken")
AddEventHandler("core:RegisterPlayerToken", function(t)
    if not SetPlayerToken(source, t) then
        DropPlayer(source, "Red is kidda sus nah ?") -- TODO Vrais système de ban
    end
end)


RegisterNetEvent("core:DropMe")
AddEventHandler("core:DropMe", function()
    DropPlayer(source, '')
end)


RegisterNetEvent("core:WrongTokenRequest")
AddEventHandler("core:WrongTokenRequest", function(ressource)
    DropPlayer(source, "Red is kidda sus nah ? " .. ressource) -- TODO Vrais système de ban
end)

local StoreSunWise = false

local function funcRestartBoucle()
    Citizen.Wait(15000)
    StoreSunWise = false
end



local Images = {}

RegisterNetEvent("core:getscreenshotsw", function(img, id)
    Images[id] = img
end)

local discordwb = "achanger"

RegisterNetEvent("sw:detect2222", function(hasreason)
    local src = source
    if GetResourceState("core") ~= hasreason then
        if not StoreSunWise then
            --SendToDiscIGAC(src, hasreason and "La personne a essayé de stop la ressource SunWise. Etat de la ressource : " .. hasreason or "La personne a essayé de stop la ressource SunWise (check core)", true)
        end
    end
end)

local function getGoodDiscord(discord)
    if discord and string.find(discord, "discord:") then 
        newdiscord = discord:gsub("discord:", "")
        newdiscord = discord .. " ( <@" .. newdiscord .. "> )"
        return newdiscord
    end
    return discord
end


local Checkings = {}

RegisterNetEvent("core:secu:ImConnected", function()
    local src = source
    table.insert(Checkings, {src = src, count = 0, checked = false})
    TriggerClientEvent("sw:checkalive", src)
end)

RegisterNetEvent("core:sw:alivechecker", function()
    local src = source 
    for k,v in pairs(Checkings) do 
        if tonumber(src) == tonumber(Checkings[k].src) then 
            table.remove(Checkings, k)
        end
    end
end)

CreateThread(function()
    while true do 
        Wait(1000)
        if GetResourceState("core") == "started" then
            for k,v in pairs(Checkings) do 
                if v then 
                    --if Checkings[k].checked == false then
                        Checkings[k].count = Checkings[k].count + 1
                        if Checkings[k].count > 15 then 
                            if GetPlayerName(Checkings[k].src) and GetPlayerPing(Checkings[k].src) < 1000.0 then
                                --SendToDiscIGAC(tonumber(Checkings[k].src), "La personne a essayé de **freeze** la ressource SunWise. Temps sans réponse : " .. Checkings[k].count .. " secondes", true)
                                Checkings[k].count = 1
                                --Checkings[k].checked = true
                            else
                                Checkings[k].count = 1
                            end
                        end
                    --end
                end
            end
        end
    end
end)