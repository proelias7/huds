local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
vAZ = {}
Tunnel.bindInterface('ozk_hud', vAZ)

function vAZ.fomesede()
	local source = source
	local user_id = vRP.getUserId(source)
	local convfome = vRP.getHunger(user_id)
	local convsede = vRP.getThirst(user_id)
    return convfome,convsede
end

