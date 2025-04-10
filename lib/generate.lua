Generate = {};


---@param Settings table
function Generate.Code(Settings)
    -- Table des caractères possibles
    local charSets = {
        letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
        numbers = "0123456789",
        special = "!@#$%^&*()-_=+[]{}|;:',.<>?/`~"
    }


    local combinedChars = ""
    if Settings.includeLetters then
        combinedChars = combinedChars .. charSets.letters
    end
    if Settings.includeNumbers then
        combinedChars = combinedChars .. charSets.numbers
    end
    if Settings.includeSpecial then
        combinedChars = combinedChars .. charSets.special
    end


    if #combinedChars == 0 then
        Logger:warn('CORE', "No character sets selected for code generation.")
    end

    -- Génération du code
    local code = ""
    for _ = 1, Settings.length do
        local randomIndex = math.random(1, #combinedChars)
        code = code .. combinedChars:sub(randomIndex, randomIndex)
    end

    return code
end
