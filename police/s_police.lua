local _ = function(k, ...) return ImportPackage("i18n").t(GetPackageName(), k, ...) end

MAX_POLICE = 20 -- Number of policemens at the same time
ALLOW_RESPAWN_VEHICLE = true -- Allow the respawn of the vehicle by destroying the previously spawned one. (Can break RP if the car is stolen or need repairs or fuel)

VEHICLE_SPAWN_LOCATION = {x = 168382, y = 190227, z = 1307, h = 35}


--------- SERVICE AND EQUIPMENT
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
--------- SERVICE AND EQUIPMENT END

--------- POLICE VEHICLE
function SpawnPoliceCar(player)
    -- #1 Check for the police whitelist of the player
    if PlayerData[player].police == 0 then
        CallRemoteEvent(player, "MakeErrorNotification", _("not_whitelisted"))
        return
    end
    if PlayerData[player].job ~= "police" then
        CallRemoteEvent(player, "MakeErrorNotification", _("not_police"))
        return
    end
    
    -- #2 Check if the player has a job vehicle spawned then destroy it
    if PlayerData[player].job_vehicle ~= nil and ALLOW_RESPAWN_VEHICLE then
        DestroyVehicle(PlayerData[player].job_vehicle)
        DestroyVehicleData(PlayerData[player].job_vehicle)
        PlayerData[player].job_vehicle = nil
    end
    
    -- #3 Try to spawn the vehicle
    if PlayerData[player].job_vehicle == nil then
        for k, v in pairs(GetStreamedVehiclesForPlayer(player)) do
            local x, y, z = GetVehicleLocation(v)
            if x == nil or y == nil or z == nil then break end
            local dist2 = GetDistance3D(VEHICLE_SPAWN_LOCATION.x, VEHICLE_SPAWN_LOCATION.y, VEHICLE_SPAWN_LOCATION.z, x, y, z)
            if dist2 < 500.0 then
                CallRemoteEvent(player, "MakeErrorNotification", _("cannot_spawn_vehicle"))
                return
            end
        end
        
        local vehicle = CreateVehicle(3, VEHICLE_SPAWN_LOCATION.x, VEHICLE_SPAWN_LOCATION.y, VEHICLE_SPAWN_LOCATION.z, VEHICLE_SPAWN_LOCATION.h)
        PlayerData[player].job_vehicle = vehicle
        CreateVehicleData(player, vehicle, 3)
        SetVehiclePropertyValue(vehicle, "locked", true, true)
        CallRemoteEvent(player, "MakeNotification", _("spawn_vehicle_success", " patrol car"), "linear-gradient(to right, #00b09b, #96c93d)")
    else
        CallRemoteEvent(player, "MakeErrorNotification", _("cannot_spawn_vehicle"))
    end
end

function DespawnPoliceCar(player)
    -- #2 Check if the player has a job vehicle spawned then destroy it
    if PlayerData[player].job_vehicle ~= nil then
        DestroyVehicle(PlayerData[player].job_vehicle)
        DestroyVehicleData(PlayerData[player].job_vehicle)
        PlayerData[player].job_vehicle = nil
        CallRemoteEvent(player, "MakeNotification", _("vehicle_stored"), "linear-gradient(to right, #00b09b, #96c93d)")
        return
    end
    -- TODO : use garage
end
--------- POLICE VEHICLE
-- DEV MODE
AddCommand("pol", function(player)
    StartService(player)
end)

AddCommand("pols", function(player)
    EndService(player)
end)

AddCommand("polcar", function(player)
    SpawnPoliceCar(player)
end)

AddCommand("polscar", function(player)
    DespawnPoliceCar(player)
end)
