local VehLock = class("VehLock", vRP.Extension)

RegisterServerEvent('VehLock:remote_lock')			
AddEventHandler('VehLock:remote_lock', function(source)				
	vRP:triggerEvent("remote_lock", source) 					
end)

RegisterServerEvent('VehLock:auto_lock')			
AddEventHandler('VehLock:auto_lock', function(source)				
	vRP:triggerEvent("auto_lock", source) 					
end)

function VehLock:__construct()
	vRP.Extension.__construct(self) 
	
	self.cfg = module("vrp_carlock", "cfg/cfg")
end

VehLock.event = {}

function VehLock.event:auto_lock()		
	local user = vRP.users_by_source[source]
	local model = vRP.EXT.Garage.remote.getNearestOwnedVehicle(user.source, 10)
    local isLocked = vRP.EXT.Garage.remote.vc_toggleLock(user.source, model)
	
	if user:hasPermission("!group.emergency") then
		--vRP.EXT.Base.remote._notify(user.source, "~y~keys F has been pushed")
		if isLocked then -- lock Vehicle
			vRP.EXT.Base.remote._notify(user.source, ({isLocked = true} and self.cfg.lang.autoLock))
			vRP.EXT.Audio.remote._playAudioSource(-1,self.cfg.lock_sound, 1, 0,0,0, 30, user.source)
			
			TriggerClientEvent('VehLock:forceClose', source)
		end
	end	
end

function VehLock.event:remote_lock()

    local keyfab = {{"anim@mp_player_intmenu@key_fob@","fob_click_fp",1},}
	
    local user = vRP.users_by_source[source]
    local model = vRP.EXT.Garage.remote.getNearestOwnedVehicle(user.source, 10)
    local isLocked = vRP.EXT.Garage.remote.vc_toggleLock(user.source, model)
	local in_vehicle = vRP.EXT.Garage.remote.isInVehicle(user.source)
	
	if not in_vehicle then
		if model then
			if isLocked then -- lock Vehicle
				vRP.EXT.Base.remote._notify(user.source, ({isLocked = true} and self.cfg.lang.locked))
				vRP.EXT.Base.remote._playAnim(user.source,true, keyfab ,false)
				vRP.EXT.Audio.remote._playAudioSource(-1,self.cfg.lock_sound, 1, 0,0,0, 30, user.source)
				
				TriggerClientEvent('VehLock:forceClose', source)
				
			else -- unlock vehicle
				vRP.EXT.Base.remote._notify(user.source, ({isLocked = false} and self.cfg.lang.unlocked))
				vRP.EXT.Base.remote._playAnim(user.source,true, keyfab ,false)
				vRP.EXT.Audio.remote._playAudioSource(-1,self.cfg.unlock_sound, 1, x,y,z, 30, user.source)
			end
		else
			vRP.EXT.Base.remote._notify(user.source, (self.cfg.lang.no_veh))
		end
	end			
end

vRP:registerExtension(VehLock)