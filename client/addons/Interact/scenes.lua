local Token = nil
TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)

local sceneList = {}

function onSelectedScenesButtons(PMenu, tblData, tblButton, intButtonSelected, tbnButtons)

    if tblButton.name == 'create_new_scene' then
        if tblButton.slidenum == 1 then
            AskEntry(function(text)
                if text and string.len(text) ~= 0 then
                    local next = TriggerServerCallback('core:createScene', Token, text)
                    if next then
                        sceneList[next] = { id = next, label = text, props = {} }
                        PMenu.Data.temp = sceneList[next]
                        OpenMenu('scenes_manage')
                    end
                end
            end, "Nom de la scène")
        elseif tblButton.slidenum == 2 then
            print('Importer')
        end
    end
end

function getSceneManageButtons(PMenu)
    local data = PMenu.Data.temp
    return {
        { name = 'name',              ask = data.label, askX = true },
        { name = 'id',                ask = data.id,   askX = true },
        { name = 'totalprops',                ask = #data.props,   askX = true },
        { name = 'scene_props_list' },
        { name = 'props_list' },
        { name = 'scene_create_prop', colorFree = {45, 119, 205, 165} },
        { name = 'scene_save', colorFree = { 53, 146, 61, 165 } },
    }
end

function getScenesButtons(PMenu)
    local data = TriggerServerCallback('core:getScenesList', Token)
    local list = {
        [1] = { name = 'create_new_scene', colorFree = { 53, 146, 61, 165 }, slidemax = { 'Créer', 'Importer' } },
    }
    for k,v in pairs(data) do
        if sceneList[v.id] then
            list[#list + 1] = { name = ('%s - %s (LOADED)'):format(v.id, v.label), slidemax = { 'Charger', 'Decharger', 'Supprimer' }, data = v }
        else
            list[#list + 1] = { name = ('%s - %s'):format(v.id, v.label), slidemax = { 'Charger', 'Decharger', 'Supprimer' }, data = v }
        end
    end
    return list 
end
