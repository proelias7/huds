local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
vAZ = {}
Tunnel.bindInterface('athenas_hud', vAZ)

function vAZ.fomesede()
	local source = source
	local user_id = vRP.getUserId(source)
	local convfome = 100 - vRP.getHunger(user_id)
	local convsede = 100 - vRP.getThirst(user_id)
    return convfome,convsede
end

