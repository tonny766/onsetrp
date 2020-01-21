local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

MAX_POLICE = 20


function StartService(player)-- To start the police service
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
    for k, v in pairs(PlayerData) do
        if v.job == "police" then policemens = policemens + 1 end
    end
    if policemens >= MAX_POLICE then
        CallRemoteEvent(player, "MakeErrorNotification", _("job_full"))
        return
    end
    
    -- #4 Set the player job to police, update the cloths, give equipment
    PlayerData[player].job = "police"
    -- CLOTHINGS
    GivePoliceEquipmentToPlayer(player)
    SetPlayerArmor(player, 100)-- Set the armor of player
    UpdateClothes(player)

    CallRemoteEvent(player, "MakeNotification", _("join_police"), "linear-gradient(to right, #00b09b, #96c93d)")
    
    return true
end

function EndService(player)-- To end the police service
    -- #1 Remove police equipment
    RemovePoliceEquipmentFromPlayer(player)
    -- #2 Set player job
    PlayerData[player].job = ""
    -- #3 Reset player armor
    SetPlayerArmor(player, 0)-- Reset the armor of player
    -- #4 Trigger update of cloths
    UpdateClothes(player)

    CallRemoteEvent(player, "MakeNotification", _("quit_police"), "linear-gradient(to right, #00b09b, #96c93d)")

    return true
end

function GivePoliceEquipmentToPlayer(player)-- To give police equipment to policemen
    if PlayerData[player].job == "police" and PlayerData[player].police == 1 then -- Fail check
        if GetNumberOfItem(player, "weapon_4") < 1 then -- If the player doesnt have the gun we give it to him
            AddInventory(player, "weapon_4", 1)
            SetPlayerWeapon(player, 4, 70, false, 2, true)
        end
        if GetNumberOfItem(player, "weapon_21") < 1 then -- If the player doesnt have the gun we give it to him
            AddInventory(player, "weapon_21", 1)
            SetPlayerWeapon(player, 4, 100, false, 2, true)
        end
    end
end

function RemovePoliceEquipmentFromPlayer(player)-- To remove police equipment from policemen
    if GetNumberOfItem(player, "weapon_4") > 0 then -- If the player have the gun we remove it
        RemoveInventory(player, "weapon_4", 1)
        SetPlayerWeapon(player, 1, 0, true, 2, false)
    end
    if GetNumberOfItem(player, "weapon_21") > 0 then -- If the player have the gun we remove it
        RemoveInventory(player, "weapon_21", 1)
        SetPlayerWeapon(player, 1, 0, true, 3, false)
    end
end


AddEvent("job:onspawn", function(player)
    if PlayerData[player].job == "police" and PlayerData[player].police == 1 then -- Anti glitch
        GivePoliceEquipmentToPlayer(player)
    end    
end)

-- DEV MODE
AddCommand("police", function(player)
    StartService(player)
end)

AddCommand("policestop", function(player)
    EndService(player)
end)
