

RegisterKeyMapping("+option", "Menu Option", "keyboard", "F1")
RegisterCommand("+option", function()
    CreateMenu(Preference)
end)

Citizen.CreateThread(function()
    ReplaceHudColourWithRgba(116, 0, 249, 185, 255)
    ReplaceHudColourWithRgba(117, 0, 0, 0, 0)
    ReplaceHudColourWithRgba(157, 0, 0, 0, 255)
  --  ReplaceHudColourWithRgba(158, 0, 0, 0, 10)
end)


local Weather = {"EXTRASUNNY", "CLEAR", "NEUTRAL", "SMOG", "FOGGY", "Overcast", "CLOUDS", "CLEARING", "RAIN", "THUNDER", "SNOW", "BLIZZARD", "SNOWLIGHT", "XMAS", "HALLOWEEN"}
local Time = {00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23}


Preference = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {255, 255, 255, 255}, Title = 'OPTION'},
    Data = { currentMenu = "Options" },
    Events = {

        onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)
            local pPed = PlayerPedId()
            local currentMenu = _.currentMenu
     
            if btn.name =='Lobby' then
                local zone = {}
                for k,v in pairs(_SAFEZONE.SafeZones) do
                    table.insert(zone, {
                        Name = v.Name,
                        Description = v.Description,
                        Image = v.Image,
                    })
                end
                SetNuiFocus(true, true)
                _NUI.SendNUIMessage('showSpawnSelector', {
                    show = true,
                    translation = {
                        select = GetPhrase('SELECT')
                    },
                    lobby = zone
                })
            end

        if btn.name == "Rockstar Editor" and btn.slidenum == 1 then  -- Lancer
                Utils.ShowNotification('Lancement du records')
                StartRecording(1)
            elseif btn.name == "Rockstar Editor" and btn.slidenum == 2 then  -- Stopper
                Utils.ShowNotification("~r~<C>Vous venez de coupé l'enregistrement</C>")
                StopRecordingAndSaveClip() 
            elseif btn.name == "Rockstar Editor" and btn.slidenum == 3 then  -- Abandonner
                Utils.ShowNotification("~r~<C>Vous venez d'abandonné l'enregistrement</C>")
                StopRecordingAndDiscardClip()
    
        elseif btn.name == "Weather" then
            local weather = btn.slidename
    
            SetWeatherTypeOverTime(weather, 15.0)
            ClearOverrideWeather()
            ClearWeatherTypePersist()
            SetWeatherTypePersist(weather)
            SetWeatherTypeNow(weather)
            SetWeatherTypeNowPersist(weather)
        elseif btn.name == "Time" then
            local time  = btn.slidename
            NetworkOverrideClockTime(tonumber(time), 00, 0)


        end



        
        end,
    },
    Menu = {
        ["Options"] = {
            refresh = true,
            b = function()
                return {
                {name = "World", ask = "→", askX = true},
                {name = "Settings", ask = "→", askX = true},
                {name = "Lobby", colorFree = {45, 119, 205, 165}, cantUse =  not _SAFEZONE.inSafeZone}
            }
        end
        },


        ["world"] = {
            b = {
                {name = "Time", slidemax = Time},
                {name = "Weather", slidemax = Weather},
            }
        },

  
  
        ["settings"] = {
            b = {
                {name = "Rockstar Editor", slidemax = {'Lancer', 'Stopper', 'Abandonné'}},
                {name = "RadioSquad", checkbox = true},
  
            }
        },


    
    }
     
}

