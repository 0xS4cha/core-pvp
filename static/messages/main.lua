local registeredLanguages = {}
local defaultPhrases = {}
local mainLanguage = "en"

local langToId = {"en", "fr", "de", "it", "es", "pt", "pl", "ru", "ko", "zh", "ja", "me", "fa", "br", "sv", "ar", "tr"}

if not GetCurrentLanguage then
	function GetCurrentLanguage()
		return  0
	end

	function GetLabelText(label)
		return label
	end
end

local autoLanguage = langToId[GetCurrentLanguage() + 1]
local selectedLanguage = autoLanguage

function RegisterDefaultPhrases(phrases)
	defaultPhrases = phrases
end

function UpdateDefaultPhrase(key, name)
    defaultPhrases[key] = name
end
exports("UpdateDefaultPhrase", UpdateDefaultPhrase)

function AddLanguage(name, tbl)
    local old = registeredLanguages[name] or {}
    registeredLanguages[name] = tbl
    -- Merge the language with the translations added by AddPhrase
    for k, v in pairs(old) do
        if not registeredLanguages[name][k] then
			registeredLanguages[name][k] = v
		end
    end
	Console.Success("Language " .. name .. " added")
end

function AddPhrase(lang, name, phrase)
    registeredLanguages[lang] = registeredLanguages[lang] or {}
    registeredLanguages[lang][name] = phrase
end


function GetPreferredLanguageId()
	return selectedLanguage or mainLanguage
end


function GetPhrase(name, ...)
	if not name then return end

	local langTable = registeredLanguages[selectedLanguage] or registeredLanguages[mainLanguage]
	
	local arguments = {...}
	for k,v in pairs(arguments) do
		if type(v) == "string" then
			arguments[k] = GetPhrase(v)
		end
	end
	if defaultPhrases[name] then
		return defaultPhrases[name] and string.format(defaultPhrases[name], table.unpack(arguments)) or (#arguments > 0 and string.format(name, table.unpack(arguments)) or name) or nil
	end
	
    return (langTable[name] or registeredLanguages[mainLanguage][name]) and string.format(langTable[name] or registeredLanguages[mainLanguage][name], table.unpack(arguments)) or (#arguments > 0 and string.format(name, table.unpack(arguments)) or name) or nil
end

function IsPhraseRegistered(name)
	return registeredLanguages[mainLanguage][name] and true or false
end


function GetMissingPhrases(lang)
    lang = lang or selectedLanguage
    local res = {}
    local format = "%s = \"%s\","

    for k, v in pairs(registeredLanguages[mainLanguage]) do
        if not registeredLanguages[lang][k] then
			table.insert(res, string.format(format, k, v))
		end
    end

    return #res == 0 and "No language strings missing!" or table.concat(res, "\n")
end



local function getMissingPhrases(ply, args, cmd)
    if not args[1] then print("Please run the command with a language code e.g. darkrp_getphrases \"" .. mainLanguage .. "\"") return end
    local lang = registeredLanguages[args[1]]
    if not lang then print("This language does not exist! Make sure the casing is right.")
        print("Available languages:")
        for k in pairs(registeredLanguages) do print(k) end
        return
    end

    print(GetMissingPhrases(args[1]))
end


if not SendNUIMessage then return end

-- Utils
function GetVehicleNameFromModel(modelHash)
	local displayName = GetDisplayNameFromVehicleModel(modelHash)
	local labelName = GetLabelText(displayName)
	if labelName ~= "NULL" then
		return labelName
	end

	if displayName ~= "CARNOTFOUND" then
		return displayName
	end

	return modelHash
end

-- Get system languages
CreateThread(function()

	SetTimeout(1000, function() 
		SendNUIMessage({ type = "getSystemLanguages" })
	end)
end)

local langMappingLanguageRequired = {
	["ko"] = { [8] = true },
	["zh"] = { [9] = true, [12] = true },
	["jo"] = { [10] = true },
}


function SetGameLanguage(language)
	if not language or language == "auto" then
		language = autoLanguage
	end

	selectedLanguage = language
	TriggerEvent("setGameMenuLanguage", selectedLanguage)
end
exports("SetGameLanguage", SetGameLanguage)
