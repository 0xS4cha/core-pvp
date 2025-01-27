_DROP.Client = {}
_DROP.Client.blip = {}
local Token = nil

TriggerEvent("core:RequestTokenAcces", "core", function(t)
    Token = t
end)
function _DROP.Client:Blip(id,label,pos,sprite,color,scale) -- Create Normal Blip on Map
    --print(id,label,pos,sprite,color,scale)
    --print(pos.x)
    _DROP.Client.blip[id] = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite (_DROP.Client.blip[id], sprite)
    SetBlipDisplay(_DROP.Client.blip[id], 4)
    SetBlipScale  (_DROP.Client.blip[id], scale)
    SetBlipAsShortRange(_DROP.Client.blip[id], true)
    SetBlipColour(_DROP.Client.blip[id], color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(_DROP.Client.blip[id])
    return
end




RegisterNetEvent('core:airdrop:create:client',function(a,b)
    if not _DROP.Client.inbound then
        Utils.ShowNotification(GetPhrase('AirDrop'))
        _DROP.Client.inbound = true
        _DROP.Client.owner = true

        _DROP.Client.Reward = a
        --print(Main.Reward)
        local _pos =  b
        _DROP.Client:Blip('drop',_DROP.Blip.Label,_pos,_DROP.Blip.Sprite,_DROP.Blip.Color,_DROP.Blip.Scale)
        _DROP.Client.taken = false
        local radius = AddBlipForRadius(_pos.x, _pos.y, _pos.z, 100.0) 
        SetBlipColour(radius, 1)
        SetBlipAlpha(radius, 128)
        _DROP.Client:SpawnPlane(_pos)
    end
end)


RegisterNetEvent('core:airdrop:drop', function(a)
    if _DROP.Client.drop == nil then
        local offset = math.random(-100,100)
        local pos = a
        local ground = vector3(a.x,a.y,a.z - 100)
        if _DROP.Client.owner then 
            Utils.LoadModel(_DROP.Drop.Prop)
            _DROP.Client.drop = CreateObject(_DROP.Drop.Prop, pos.x, pos.y, pos.z + 150, true, true)
            SetObjectPhysicsParams(_DROP.Client.drop,99999.0, _DROP.Drop.Veolicty, 0.0, 0.0, 0.0, 700.0, 0.0, 0.0, 0.0, _DROP.Drop.Veolicty, 0.0)
			SetEntityLodDist(_DROP.Client.drop, 1000) 
			ActivatePhysics(_DROP.Client.drop)
			SetDamping(_DROP.Client.drop, 2, 0.1) 
			SetEntityVelocity(_DROP.Client.drop, 0.0, 0.0, math.random() + math.random(-21000, -5500))
            netid = ObjToNet(drop)
           -- TriggerServerEvent('bbv-drop:synctarget:server','drop',Config.Drop.Label,pos,'bbv-drop:pickup',1,1, netid)
        end
        
    end
end)