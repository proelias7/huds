local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
vAZserver = Tunnel.getInterface('ozk_hud')
vAZ = {}
Tunnel.bindInterface('ozk_hud', vAZ)

vAZ.ready = true
local Locales = module('ozk_hud', 'locales/languages')
local ind = {l = false, r = false}

local voz = 3
RegisterKeyMapping("vozbind","hud bind","keyboard","HOME")
RegisterCommand("vozbind",function(source,args)
	voz = voz - 1
	if voz == 0 then
		voz = 3
	end
end)



function _U(entry)
	return Locales[ 'br' ][entry] 
end
Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(1000)
		local ply = PlayerPedId() 
		fome,sede = vAZserver.fomesede(fome,sede)
		SendNUIMessage({
			action = 'player', 
			needs = {
				health = math.ceil((100 * ((GetEntityHealth(ply) - 100) / (GetEntityMaxHealth(ply) - 100)))),
				armor = GetPedArmour(ply),
				fome = parseInt(fome),
				sede = parseInt(sede),	
				voz = voz,	
			},
			date = {
				day = GetClockDayOfMonth(),
				month = GetClockMonth(),
				hour = GetClockHours(),
				minute = GetClockMinutes()
			}
		})
		SendNUIMessage({ 
			hora = 'setText', 
			id = 'day', 
			value = gameData() 
		})
    end
end)

Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(15000)
		local ped = PlayerPedId()
		local health = GetEntityHealth(ped)
		local taxadedano = 1
		if fome >= 100 or sede >= 100 then
			SetEntityHealth(ped,health-taxadedano)
		end
    end
end)


function gameData()
	local timeString = nil
	local rola = "withHours"
	local day = _U('day_' .. GetClockDayOfMonth())
	local weekDay = _U('weekDay_' .. GetClockDayOfWeek())
	local month = _U('month_' .. GetClockMonth())
	local day = _U('day_' .. GetClockDayOfMonth())
	local year = GetClockYear()
	local hour = GetClockHours()
	local minutes = GetClockMinutes()
	local time = nil
	local AmPm = ''

	if hour <= 9 then
		hour = '0' .. hour
	end

	if minutes <= 9 then
		minutes = '0' .. minutes
	end

	time = hour .. ':' .. minutes .. ' ' .. AmPm

	local date_format = Locales['br']['date_format'][rola]

	if rola == 'default' then
		timeString = string.format(date_format, day, month, year)
	elseif rola == 'simple' then
		timeString = string.format(date_format, day, month)
	elseif rola == 'simpleWithHours' then
		timeString = string.format(date_format, time, day, month)	
	elseif rola == 'withWeekday' then
		timeString = string.format(date_format, weekDay, day, month, year)
	elseif rola == 'withHours' then
		timeString = string.format(date_format, day, month, time)
	elseif rola == 'withWeekdayAndHours' then
		timeString = string.format(date_format, time, weekDay, day, month, year)
	end

	return timeString
end

RegisterNetEvent("apz-hud:display")
AddEventHandler("apz-hud:display", function(boolean)
    vAZ.ready = boolean
end)