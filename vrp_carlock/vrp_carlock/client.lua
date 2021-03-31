local keys = {
	["E"] = 206, 
	["F"] = 23,
}
local function notification(msg)													--draw text notification
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(false, false)
end

function dbl_press()
	if (IsControlJustReleased(0, keys["E"])) then
		local pressedAgain = false local timer = GetGameTimer()
		while true do
			Citizen.Wait(0)
			if (IsControlJustPressed(0, keys["E"])) then pressedAgain = true break end
			if (GetGameTimer() - timer >= 100) then break end
		end
		if (pressedAgain) then return true end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if dbl_press() then
			TriggerServerEvent('VehLock:remote_lock')
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local last_veh = GetVehiclePedIsIn(ped, true)
		local veh_dist = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(last_veh), 1)
		local lock_status = GetVehicleDoorLockStatus(last_veh)

		if IsControlJustReleased(0, keys["F"]) then
			Citizen.Wait(1000)
			if last_veh and GetLastPedInVehicleSeat(last_veh, -1) == ped then
				if lock_status <= 1 then
					TriggerServerEvent('VehLock:auto_lock')
				end
			end
		end
	end
end)
RegisterNetEvent('VehLock:forceClose')													--check vehicle condition
AddEventHandler('VehLock:forceClose', function(repair_threshold)
	local ped = GetPlayerPed(-1)
	local last_veh = GetVehiclePedIsIn(ped, true)
	local lock_status = GetVehicleDoorLockStatus(last_veh)
	
	if last_veh and GetLastPedInVehicleSeat(last_veh, -1) == ped then
		if lock_status >= 2 then
			--door close
			SetVehicleDoorShut(last_veh, 0, true)	SetVehicleDoorShut(last_veh, 1, true)
			SetVehicleDoorShut(last_veh, 2, true)	SetVehicleDoorShut(last_veh, 3, true)	
			SetVehicleDoorShut(last_veh, 4, true)	SetVehicleDoorShut(last_veh, 5, true)
			SetVehicleDoorShut(last_veh, 6, true)
		end
	end
end)
--[[
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local last_veh = GetVehiclePedIsIn(ped, true)
		local veh_dist = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(last_veh), 1)
		local lock_status = GetVehicleDoorLockStatus(last_veh)
		if last_veh and GetLastPedInVehicleSeat(last_veh, -1) == ped then
			if IsControlJustReleased(0, keys["F"]) then
				if veh_dist <= 5 then
					if lock_status == 1 then
						TriggerServerEvent('VehLock:auto_lock')
					end
				end
			end
		end
	end
end)
--]]