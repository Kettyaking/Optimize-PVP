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
    local nextPed, nextAim, nextVehicle, nextWeapon = 0, 0, 0, 0
    while true do
        local now = GetGameTimer()
        if now >= nextPed then
            globalPed = PlayerPedId()
            globalPlayerPedId = globalPed
            globalPlayerId = PlayerId()
            nextPed = now + 3000
        end
        if now >= nextAim then
            globalIsPedArmed = IsPedArmed(globalPlayerPedId, 6)
            globalIsPlayerFreeAiming = IsPlayerFreeAiming(globalPlayerId)
            nextAim = now + 250
        end
        if now >= nextVehicle then
            globalIsPedInAnyVehicle = IsPedInAnyVehicle(globalPed, false)
            nextVehicle = now + 1000
        end
        if now >= nextWeapon then
            _, globalGetCurrentWeapon = GetCurrentPedWeapon(globalPed, true)
            nextWeapon = now + 200
        end
        Wait(50)
    end
end)
