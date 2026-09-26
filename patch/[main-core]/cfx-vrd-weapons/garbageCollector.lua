-- VRD optimized runtime cache
local Wait = Wait
local PlayerPedId = PlayerPedId
local PlayerId = PlayerId
local IsPedArmed = IsPedArmed
local IsPlayerFreeAiming = IsPlayerFreeAiming
local IsPedInAnyVehicle = IsPedInAnyVehicle
local GetCurrentPedWeapon = GetCurrentPedWeapon
local GetGameTimer = GetGameTimer

CreateThread(function()
    while true do
        Wait(60000)
        collectgarbage("collect")
    end
end)

CreateThread(function()
    local nextPedRefresh, nextAimRefresh, nextVehicleRefresh, nextWeaponRefresh = 0, 0, 0, 0
    while true do
        local now = GetGameTimer()
        if now >= nextPedRefresh then
            globalPlayerPedId = PlayerPedId()
            globalPed = globalPlayerPedId
            globalPlayerId = PlayerId()
            nextPedRefresh = now + 3000
        end
        if now >= nextAimRefresh then
            globalIsPedArmed = IsPedArmed(globalPlayerPedId, 6)
            globalIsPlayerFreeAiming = IsPlayerFreeAiming(globalPlayerId)
            nextAimRefresh = now + 250
        end
        if now >= nextVehicleRefresh then
            globalIsPedInAnyVehicle = IsPedInAnyVehicle(globalPed, false)
            nextVehicleRefresh = now + 1000
        end
        if now >= nextWeaponRefresh then
            _, globalGetCurrentWeapon = GetCurrentPedWeapon(globalPed, true)
            nextWeaponRefresh = now + 200
        end
        Wait(100)
    end
end)
