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

NeP.DSL:Register('energydeficit', function(target)
	return (UnitPowerMax(target, SPELL_POWER_ENERGY)) - (UnitPower(target, SPELL_POWER_ENERGY))
end)

NeP.DSL:Register('combodeficit', function(target)
	return (UnitPowerMax(target, SPELL_POWER_COMBO_POINTS)) - (UnitPower(target, SPELL_POWER_COMBO_POINTS))
end)

NeP.DSL:Register('rpdeficit', function(target)
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

NeP.DSL:Register('RtB', function() --Credit to Xeer!
  local int = 0
  local bearing = false
  local shark = false

  -- Shark Infested Waters
-- Shark Infested Waters
  if UnitBuff('player', GetSpellInfo(193357)) then
    if NeP.DSL:Get('buff.duration')('player', GetSpellInfo(193357)) > 3 then
        shark = true
        int = int + 1
    end
  end

  -- True Bearing
  if UnitBuff('player', GetSpellInfo(193359)) then
    if NeP.DSL:Get('buff.duration')('player', GetSpellInfo(193359)) > 3 then
        bearing = true
        int = int + 1
    end
  end

  -- Jolly Roger
  if UnitBuff('player', GetSpellInfo(199603)) then
    if NeP.DSL:Get('buff.duration')('player', GetSpellInfo(199603)) > 3 then
        int = int + 1
    end
  end

  -- Grand Melee
  if UnitBuff('player', GetSpellInfo(193358)) then
    if NeP.DSL:Get('buff.duration')('player', GetSpellInfo(193358)) > 3 then
        int = int + 1
    end
  end

  -- Buried Treasure
  if UnitBuff('player', GetSpellInfo(199600)) then
    if NeP.DSL:Get('buff.duration')('player', GetSpellInfo(199600)) > 3 then
        int = int + 1
    end
  end

  -- Broadsides
  if UnitBuff('player', GetSpellInfo(193356)) then
    if NeP.DSL:Get('buff.duration')('player', GetSpellInfo(193356)) > 3 then
        int = int + 1
    end
  end

  -- If all six buffs are active:
  if int == 6 then
      return true --"LEEEROY JENKINS!"

      -- If two or Shark/Bearing and AR/Curse active:
  elseif int == 2 or int == 3 or ((bearing or shark) and ((UnitBuff("player", GetSpellInfo(13750)) or UnitDebuff("player", GetSpellInfo(202665))))) then
      return true --"Keep."

      -- If only True Bearing
  elseif bearing then
      return true --"Keep. AR/Curse if ready."

      -- If only Shark or True Bearing and CDs ready
  elseif (bearing or shark)  and ((GetSpellCooldown(13750) == 0) or (GetSpellCooldown(202665) == 0)) then
      return true --"AR/Curse NOW and keep!"

        --if we have only ONE bad buff BUT AR/curse is active:
    elseif int ==1 and ((UnitBuff("player", GetSpellInfo(13750)) or UnitDebuff("player", GetSpellInfo(202665)))) then
        return true
    
      -- If only one bad buff:
  else return false --"Reroll now!"
  end
end)
