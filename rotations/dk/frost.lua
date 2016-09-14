local exeOnLoad = function()
	meeleSpell = 49998
	print('Meele Spell: '.. GetSpellInfo(meeleSpell) .. '(' .. meeleSpell .. ')')
end

local Shared = {
	{'@Rubim.CastGroundSpell()'},
}

local Healing = {
	{ 'Death Strike' , { 'player.buff(101568)' , 'player.health <= 80' }},
	{ 'Death Strike', { 'player.buff(101568)' , 'player.buff(101568).duration < 2' }},
}

local Cooldowns = {
	{ 'Pillar of Frost' },
	{ 'Blood Fury' },
}

local Core = {
	{ 'Glacial Advance' , 'player.area(7).enemies >= 1' },
	--FROST STRIKE OLBITERATION
	--FROSTSCYTH
	{ 'Obliterate' , 'player.buff(Killing Machine)' },
	{ 'Remorseless Winter' , 'player.area(7).enemies >= 2' },
	{ 'Obliterate' }
	--Frost
	--Howling
}

local Survival = {
	-- healthstone
	{ '#5512', 'player.health < 70'},
}

local Interrupts = {
	-- Mind freeze
	{ '47528' },
}

local inCombat = {
	{ Healing },
	{ Cooldowns , 'player.area(7).enemies >= 1' },
	
	--Core
	{ 'Howling Blast' , 'target.debuff(Frost Fever).duration <= 3' },
	{ 'Howling Blast' , 'player.buff(Rime).duration > 0' },
	{ 'Frost Strike' , 'player.runicpower >= 80' },
	{ Core },
--Frost Strike
	{ 'Horn of Winter' , 'player.area(7).enemies >= 1' },
	{ 'Frost Strike' },
}

local outCombat = {
	{Shared}
}

NeP.Engine.registerRotation(251, '[|cff'..NeP.Interface.addonColor..'Rubim (WIP) Deathknight - Frost', {
		{Shared},
		{inCombat}
	}, outCombat, exeOnLoad)