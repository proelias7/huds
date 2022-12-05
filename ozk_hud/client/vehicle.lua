
vAZ.vehicle = 0
vAZ.plyInAnyVehicl = false
local map = false
local hide = false
local seatbeltDisableExit = true            -- Disable vehicle exit when seatbelt is enabled
local seatbeltEjectSpeed = 45.0             -- Speed threshold to eject player (MPH)
local seatbeltEjectAccel = 100.0            -- Acceleration threshold to eject player (G's)
local currSpeed = 0.0
local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}
local seatbeltIsOn = false

RegisterNetEvent("hud:display")
AddEventHandler("hud:display", function(spaw)
	if not spaw then
		status = not status
		hide = not hide
		map = true
		TriggerEvent('hudon')
	end
end)


RegisterCommand("hud",function(source,args)
	status = not status
    hide = not hide
    map = true
	TriggerEvent('hudon')
end)
Citizen.CreateThread(function()
	while true do
		wait = 1000
        if vAZ.ready then
			SendNUIMessage({action = 'pause', status = status or IsPauseMenuActive()})
		end
		Citizen.Wait(wait)
   end
end)

Citizen.CreateThread(function()    
    while true do
        Citizen.Wait(1000)
        if vAZ.ready then
            local ply = PlayerPedId()
            if IsPedInAnyVehicle(ply, false) and not hide then
                vAZ.plyInAnyVehicl = true
                map = true
            else
                vAZ.plyInAnyVehicl = false
                map = false
                SendNUIMessage({action = 'vehicleReset'})
            end
        end
        DisplayRadar(map)
	end
end)

Citizen.CreateThread(function()
	while true do
        wait = 1000
        if vAZ.ready then
            if vAZ.plyInAnyVehicl then
                local ply = PlayerPedId()
                vAZ.vehicle = GetVehiclePedIsIn(ply, false)
                if vAZ.vehicle ~= 0 then
                    local vehicleHealth = GetVehicleEngineHealth(vAZ.vehicle)
                    local vehicleFuel = GetVehicleFuelLevel(vAZ.vehicle)
                    local vehicleSpeed = math.ceil(GetEntitySpeed(vAZ.vehicle) * 3.605936)
					local vehicle = GetVehiclePedIsIn(ply, false)
					local vehicleClass = GetVehicleClass(vehicle)
                    local vehicleMaxSpeed = math.ceil(GetVehicleModelEstimatedMaxSpeed(GetEntityModel(vAZ.vehicle)) * 3.605936)

                    local vehicleGear = GetVehicleCurrentGear(vAZ.vehicle)
                    if (vehicleSpeed == 0 and vehicleGear == 0) or (vehicleSpeed == 0 and vehicleGear == 1) then
                        vehicleGear = 'N'
                    elseif vehicleSpeed > 0 and vehicleGear == 0 then
                        vehicleGear = 'R'
                    end

                    local vehicleVal,vehicleLights,vehicleHighlights  = GetVehicleLightsState(vAZ.vehicle)
                    local vehicleLight
                    if vehicleLights == 1 and vehicleHighlights == 0 then
                        vehicleLight = 'normal'
                    elseif (vehicleLights == 1 and vehicleHighlights == 1) or (vehicleLights == 0 and vehicleHighlights == 1) then
                        vehicleLight = 'high'
                    else
                        vehicleLight = 'off'
                    end
                    if vehicleSpeed >= 80 then 
						if GetPedInVehicleSeat(vAZ.vehicle,-1) == ply then
							wait = 10
							DisablePlayerFiring(ply, true) 
						end
					end
                    SendNUIMessage({
                        action = 'vehicle',
                        vClass = vehicleClass,
                        health = vehicleHealth,
                        gear = vehicleGear,
                        gearn = GetVehicleHighGear(vAZ.vehicle),
                        fuel = vehicleFuel,
                        lights = vehicleLight,
                        speed = vehicleSpeed,
                        max = vehicleMaxSpeed,
                        engine = not GetIsVehicleEngineRunning(vAZ.vehicle)
                    })
                end
            end
        end
        Citizen.Wait(wait)
    end
end)
--local outroveiculo = false
local isBlackout = false
local oldSpeed = 0
Citizen.CreateThread(function()
    while true do
        wait = 1000
		local ply = PlayerPedId()
		if IsPedInAnyVehicle(ply, false) then  
			wait = 10             
			local vehicle = GetVehiclePedIsIn(ply, false)
			local vehicleClass = GetVehicleClass(vehicle)
			if GetIsVehicleEngineRunning(vehicle) and vehicleClass ~= 13 and vehicleClass ~= 8 then
				local prevSpeed = currSpeed
				currSpeed = GetEntitySpeed(vehicle)
				SetPedConfigFlag(ply, 32, true)
				if IsControlJustReleased(0, 47) and GetLastInputMethod(0) then                    
					if seatbeltIsOn then
						TriggerEvent("vrp_sound:source", 'unbelt', 0.5)
						SetTimeout(1400, function()
							SendNUIMessage({action = "belt", status = false})
							SeatBelt = false
						end)
					elseif not seatbeltIsOn then
						vRP._playAnim(true, {{"oddjobs@taxi@cyi", "std_hand_off_ps_passenger"}}, false)
						TriggerEvent("vrp_sound:source", 'belt', 0.5)
						SetTimeout(1400, function()
							SendNUIMessage({action = "belt", status = true})
							SeatBelt = true
						end)
					end
					seatbeltIsOn = not seatbeltIsOn
				end
				if not seatbeltIsOn then
					local plyCoords = GetEntityCoords(ply)
					local vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
					local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
					if (vehIsMovingFwd and (prevSpeed > (seatbeltEjectSpeed/2.237)) and (vehAcc > (seatbeltEjectAccel*9.81))) then
						SetEntityCoords(ply, plyCoords.x, plyCoords.y, plyCoords.z - 0.47, true, true, true)
						SetEntityVelocity(ply, prevVelocity.x, prevVelocity.y, prevVelocity.z)
						Citizen.Wait(100)
						SetPedToRagdoll(ply, 1000, 1000, 0, 0, 0, 0)
						currSpeed = 0.0
						prevVelocity = {x = 0.0, y = 0.0, z = 0.0}
						seatbeltIsOn = false
					else
						prevVelocity = GetEntityVelocity(vehicle)
					end
				 elseif seatbeltDisableExit then
					-- if GetPedInVehicleSeat(vehicle,-1) == PlayerPedId() then
						-- local currentSpeed = GetEntitySpeed(vehicle)*2.236936
						-- if currentSpeed ~= oldSpeed then
							-- if not isBlackout and (currentSpeed < oldSpeed) and ((oldSpeed - currentSpeed) >= 50) then
								-- blackout()
							-- end
							-- oldSpeed = currentSpeed
						-- end
					-- else
						-- if oldSpeed ~= 0 then
							-- oldSpeed = 0
						-- end
					-- end
					 DisableControlAction(0, 75)
				end
			end
		end
        Citizen.Wait(wait)
    end
end)

-- function blackout()
	-- TriggerEvent("vrp_sound:source",'heartbeat',0.5)
	-- if not isBlackout then
		-- isBlackout = true
		-- --SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())-100)
		-- Citizen.CreateThread(function()
			-- DoScreenFadeOut(500)
			-- while not IsScreenFadedOut() do
				-- Citizen.Wait(10)
				-- DisableControlAction(0,71,true)
				-- DisableControlAction(0,72,true)
				-- DisableControlAction(0,63,true)
				-- DisableControlAction(0,64,true)
				-- DisableControlAction(0,75,true)
			-- end
			-- Citizen.Wait(5000)
			-- DoScreenFadeIn(5000)
			-- isBlackout = false
		-- end)
	-- end
-- end