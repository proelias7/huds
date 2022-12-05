local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
vAZserver = Tunnel.getInterface('hud')
vAZ = {}
Tunnel.bindInterface('athenas_hud', vAZ)

vAZ.ready = true

local Locales = module('athenas_hud', 'locales/languages')
local ind = {l = false, r = false}

function _U(entry)
	return Locales[ 'br' ][entry] 
end

Citizen.CreateThread(function()    
	while true do
        wait = 1000
        if vAZ.ready then
            local ply = PlayerPedId()            
            SendNUIMessage({
                action = 'player', 
                needs = {
                    health = math.ceil((100 * ((GetEntityHealth(ply) - 100) / (GetEntityMaxHealth(ply) - 100)))),
                    armor = GetPedArmour(ply),
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
		Citizen.Wait(wait)
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