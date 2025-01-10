_PROMPT = _PROMPT or {}
local response
_PROMPT.Create = function(title, description, description2, cb)

    _NUI.SetVisible('Prompt', true, {mouse = true})
    _NUI.SendNUIMessage('PROMPT_CREATE', {
        show = true,
        title = title,
        description = description,
        description2 = description2
    })
    if cb == nil then return end
    while response == nil do
        Wait(0)
    end
    cb(response)
    response = nil
end


RegisterNUICallback('PROMPT_ACCEPT', function(_, cb)
    _NUI.SetVisible('Prompt', false, {mouse = false})
    response = true
    cb('ok')
end)

RegisterNUICallback('PROMPT_REFUSE', function(_, cb)
    _NUI.SetVisible('Prompt', false, {mouse = false})
    response = false
    cb('ok')
end)

---@field title? string
---@field subtitle? string
---@field maxNumbers? number
---@field canClose? boolean
---@field useSfx? boolean
---@field hidden? boolean
---@field reactiveUI? { correctPin: number, closeOnWrong?: boolean }
RegisterCommand('test_pin', function()
    PIN.open({
        title = 'Test',
        subtitle = 'Test',
        maxNumbers = 4,
        canClose = true,
        useSfx = true,
        hidden = false,
        reactiveUI = {
            correctPin = 1234,
            closeOnWrong = false
        },
    }
        
    )
end, false)


RegisterCommand('test_prompt', function()
    _PROMPT.Create('title', 'description', 'description2')
end, false)



