local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

MAX_POLICE = 20


function StartService(player) -- To start the police service
    -- #1 Check for the police whitelist of the player
    if PlayerData[player].police ~= 1 then
        CallRemoteEvent(player, "MakeErrorNotification", _("not_whitelisted"))
        return
    end

    -- #2 Check if the player has a job vehicle spawned then destroy it
    if PlayerData[player].job_vehicle ~= nil then
        DestroyVehicle(PlayerData[player].job_vehicle)
        DestroyVehicleData(PlayerData[player].job_vehicle)
        PlayerData[player].job_vehicle = nil
    end

    -- #3 Check for the number of policemen in service
    local policemens = 0
    for k,v in pairs(PlayerData) do
        if v.job == "police" then policemens = policemens + 1 end
    end
    if policemens >= MAX_POLICE then
        CallRemoteEvent(player, "MakeErrorNotification", _("job_full"))
        return
    end
    
    PlayerData[player].job = "police"
    -- CLOTHINGS
    CallRemoteEvent(player, "MakeNotification", _("join_police"), "linear-gradient(to right, #00b09b, #96c93d)")

    return true
end

function EndService(player) -- To end the police service
end

function GivePoliceEquipementToPlayer(player)

    --SetPlayerWeapon(player, weapon_model, ammo, equip, weapon_slot [, bLoaded])
end

AddEvent("job:onspawn", function(player)
    
end)






-- DEV MODE
AddCommand("police", function(player)
    StartService(player)
end)