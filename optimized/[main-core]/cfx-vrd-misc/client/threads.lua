local Wait = Wait
local PlayerPedId = PlayerPedId
local PlayerId = PlayerId
local lastConfiguredPed = 0

local function configureCombatPed(ped)
    SetPedConfigFlag(ped, 2, false)
    SetPedConfigFlag(ped, 149, true)
    SetPedConfigFlag(ped, 438, true)
    SetPedSuffersCriticalHits(ped, true)
    SetPedCanRagdoll(ped, false)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetRagdollBlockingFlags(ped, 1)
    SetRagdollBlockingFlags(ped, 2)
    SetRagdollBlockingFlags(ped, 4)
    for _, flag in ipairs({89, 106, 107, 108, 109, 110, 164, 184, 306, 308}) do
        SetPedConfigFlag(ped, flag, true)
    end
end

CreateThread(function()
    local nextActivityCheck = 0
    local inTrapHouse, inARN = false, false
    while true do
        local playerId = PlayerId()
        local ped = PlayerPedId()
        local now = GetGameTimer()
        if ped ~= lastConfiguredPed then
            configureCombatPed(ped)
            lastConfiguredPed = ped
        end
        if now >= nextActivityCheck then
            inTrapHouse, inARN = false, false
            if VRDMisc.IsStarted("cfx-vrd-traphouse") then
                local ok, result = VRDMisc.SafeExport("cfx-vrd-traphouse", "inTrapHouse")
                inTrapHouse = ok and result == true
            end
            if VRDMisc.IsStarted("cfx-vrd-arena") then
                local ok, result = VRDMisc.SafeExport("cfx-vrd-arena", "inARN")
                inARN = ok and result == true
            end
            nextActivityCheck = now + 500
        end
        if pendingConfirmedDeath and IsPedGettingUp(ped) then
            SetEntityHealth(ped, 0)
        end
        if inTrapHouse or inARN then ResetPlayerStamina(playerId) end
        if GetEntityMaxHealth(ped) ~= 200 then
            SetEntityMaxHealth(ped, 200)
            SetEntityHealth(ped, 200)
        end
        Wait(50)
    end
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        for _, vehicle in ipairs(GetGamePool("CVehicle")) do
            SetEntityNoCollisionEntity(ped, vehicle, false)
            SetEntityNoCollisionEntity(vehicle, ped, false)
        end
        Wait(500)
    end
end)

CreateThread(function()
    for i = 1, #Config.RemoveHudCommonents do
        local component = Config.RemoveHudCommonents[i]
        if component then SetHudComponentPosition(i, 999999.0, 999999.0) end
    end
    for i = 1, #Config.WeaponPickups do
        ToggleUsePickupsForPlayer(PlayerId(), Config.WeaponPickups[i], false)
    end
    for _, scenario in pairs(Config.Scenarios) do SetScenarioTypeEnabled(scenario, false) end
    for i = 1, 15 do EnableDispatchService(i, false) end
    for _, ped in pairs(GetGamePool("CPed")) do SetPedDropsWeaponsWhenDead(ped, false) end
    SetPlayerCanUseCover(PlayerId(), false)
    SetPlayerCanDoDriveBy(PlayerId(), false)
    SetPedDropsWeaponsWhenDead(PlayerPedId(), false)
    DisableIdleCamera(true)
    SetDeepOceanScaler(0.0)
    SetRandomEventFlag(false)
    DistantCopCarSirens(false)
    DisableVehicleDistantlights(true)
    SetAudioFlag("DisableFlightMusic", true)
    SetAudioFlag("PoliceScannerDisabled", true)
    StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
    StartAudioScene("FBI_HEIST_H5_MUTE_AMBIENCE_SCENE")
    StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE")
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_01_STAGE", false)
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM", false)
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM", false)
    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones", true, true)
    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones", false, true)
end)
