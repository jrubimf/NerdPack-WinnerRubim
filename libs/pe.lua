--/dump NeP.DSL:Get['rpdeficiet']('player')
--/dump NeP.DSL:Get['rprint']('Hi')
--/dump NeP.DSL:Get['rubimarea']
--/dump NeP.DSL:Get('areattd')('player')
--/dump NeP.DSL:Get('area')('player')
--/dump NeP.DSL:Get('movingfor')('player')
--/dump NeP.DSL:Get('blood.rotation')('player')
--incdmg
--/dump NeP.DSL:Get('incdmg')('player')
--/dump NeP.DSL:Get('onmelee')('player')
----actions+=/hamstring,if=buff.battle_cry_deadly_calm.remains>cooldown.hamstring.remains


--COPYPASTE from Xeer
--/dump NeP.DSL:Get('prev_gcd')('player', 'Thrash')
NeP.DSL:Register('prev_gcd', function(_, Spell)
	return NeP.DSL:Get('lastcast')('player', Spell)
end)

--FUCK YEAH Gabbzz!
NeP.DSL:Register('rotation', function(rotation)
	if rotation == NeP.Library:Fetch('Rubim').BloodMaster() then return true end
	return false
end)

NeP.DSL:Register('onmelee', function(rotation)
	local isitokay = NeP.Library:Fetch('Rubim').meleeRange()
	return isitokay
end)

NeP.DSL:Register('blood.rotation', function(target, rotation)
	if rotation == NeP.Library:Fetch('Rubim').BloodMaster() then return true end
	return false
end)

NeP.DSL:Register('rpdeficiet', function(target)
	return (UnitPowerMax(target, SPELL_POWER_RUNIC_POWER)) - (UnitPower(target, SPELL_POWER_RUNIC_POWER))
end)

--/dump NeP.DSL:Get('rage.deficit')()
NeP.DSL:Register('rage.deficit', function()
	return (UnitPowerMax('player')) - (UnitPower('player'))
end)

NeP.DSL:Register('rprint', function(text)
	print(text)
end)

NeP.DSL:Register("areattd", function(target)
	local ttd = 0
	local total = 0
	for _, Obj in pairs(NeP.OM:Get('Enemy')) do
		if NeP.DSL:Get('combat')(Obj.key) and NeP.DSL:Get("distance")(Obj.key) <= tonumber(8) then
			if NeP.DSL:Get("deathin")(Obj.key) < 8 then
				total = total+1
				ttd = NeP.DSL:Get("deathin")(Obj.key) + ttd
			end
		end
	end
	if ttd > 0 then
		return ttd/total
	else
		return 9999999999
	end
end)

NeP.DSL:Register("allstacked", function(target)
	local arethey = false
	local allenemies = 0
	local closeenemies = 0
	local total = 0
	for _, Obj in pairs(NeP.OM:Get('Enemy')) do
		if NeP.DSL:Get('combat')(Obj.key) and NeP.Protected.Distance("player", Obj.key) <= tonumber(30) then
			allenemies = allenemies +1
		end
		
		if NeP.DSL:Get('combat')(Obj.key) and NeP.Protected.Distance("player", Obj.key) <= tonumber(8) then
			closeenemies = closeenemies+1
		end
	end
	if allenemies > 0 and allenemies == closeenemies then arethey = true end
	return arethey
end)
