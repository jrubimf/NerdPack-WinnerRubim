--/dump NeP.DSL:Get['rpdeficiet']('player')
--/dump NeP.DSL:Get['rprint']('Hi')
--/dump NeP.DSL:Get['rubimarea']
--/dump NeP.DSL:Get('areattd')('player')
--/dump NeP.DSL:Get('area')('player')
--/dump NeP.DSL:Get('movingfor')('player')
--/dump NeP.DSL:Get('blood.rotation')('player')
--isin
--/dump NeP.DSL:Get('onmelee')('player')
----actions+=/hamstring,if=buff.battle_cry_deadly_calm.remains>cooldown.hamstring.remains


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

NeP.DSL:Register('rprint', function(text)
	print(text)
end)

NeP.DSL:Register("rubimarea.enemies", function(unit, distance)
	local total = 0
	local distance = tonumber(distance)
	if UnitExists(unit) then
		for GUID, Obj in pairs(NeP.OM:Get('Enemy')) do
			if UnitExists(Obj.key) and UnitHealth(Obj.key) > 0 and not UnitIsDeadOrGhost(Obj.key)
			and (UnitAffectingCombat(Obj.key) or NeP.DSL:Get('isdummy')(Obj.key))
			and (NeP.Protected.Distance(unit, Obj.key) <= tonumber(distance)) then
				total = total +1
			end
		end
	end
	if total == 0 and UnitExists('target') and UnitHealth('target') > 0 and IsSpellInRange(GetSpellInfo(meleeSpell), "target") == 1 then
		total = 1
	end
	return total
end)

NeP.DSL:Register("areattd", function(target)
	local ttd = 0
	local total = 0
	for GUID, Obj in pairs(NeP.OM:Get('Enemy')) do
		if NeP.Protected.Distance("player", Obj.key) <= tonumber(8) and (UnitAffectingCombat(Obj.key) or NeP.DSL:Get('isdummy')(Obj.key)) then
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
	for GUID, Obj in pairs(NeP.OM:Get('Enemy')) do
		if NeP.DSL:Get('combat')(Obj.key)
		and NeP.Protected.Distance("player", Obj.key) <= tonumber(30) then
			allenemies = allenemies +1
		end
		
		if NeP.DSL:Get('combat')(Obj.key)
		and NeP.Protected.Distance("player", Obj.key) <= tonumber(7) then
			closeenemies = closeenemies+1
		end
	end
	if allenemies > 0 and allenemies == closeenemies then arethey = true end
	return arethey
end)
