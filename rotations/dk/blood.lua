local exeOnLoad = function()
--	NePCR.Splash()
--m	meeleSpell = 49998
	print("|cffFFFF00 ----------------------------------------------------------------------|r")
	print("|cffFFFF00 --- |rDeath Knight |cffC41F3BBlood |r")
	print("|cffFFFF00 --- |rRecommended Talents: 1/2 - 2/1 - 3/1 - 4/2 - 5/1 - 6/3 - 7/1")
	print("|cffFFFF00 --- |rDnD usage is not optimal.")
	print("|cffFFFF00 --- |rRead the Readme avaiable at github.")
	print("|cffFFFF00 ----------------------------------------------------------------------|r")

	NeP.Interface.CreateToggle(
		'saveDS',
		'Interface\\Icons\\spell_deathknight_butcher2.png',
		'Save Death Strike',
		'BOT will Only Death Strike when RP is Capped, useful on fights were you need to cast an active mitigation.')
		
	NeP.Interface.CreateToggle(
		'bonestorm',
		'Interface\\Icons\\Ability_deathknight_boneshield.png',
		'Use 194844',
		'This will pool RP to use 194844.')
	
	NeP.Interface.CreateToggle(
		'aoetaunt',
		'Interface\\Icons\\spell_nature_shamanrage.png',
		'Aoe Taunt',
		'Experimental AoE Taunt.')	
	
end

local DeathStrikeHELL = {
	{ "49998" , { "player.health <= 65" , "!toggle(saveDS)" }}, --DS Emergency		
	{{ --Bonestormless
		{ "49998" , { "player.health <= 85" , "!toggle(saveDS)" }}, --DS to Heal
		{ "49998" , "player.runicpower >= 90" }, --DS for RP Dump		
	}, "!talent(7, 1)"},
	{{ --Bonestorme
		{ "49998" , { "player.health <= 85" , "!toggle(saveDS)" , "!toggle(bonestorm)" }}, --DS to Heal
		{ "49998" , { "player.health <= 85" , "!toggle(saveDS)" , "toggle(bonestorm)" , "player.spell(194844).cooldown >= 2" }}, --DS to Heal
		{ "49998" , { "player.runicpower >= 90" , "!toggle(bonestorm)" }}, --DS for RP Dump
		{ "49998" , { "player.spell(194844).cooldown >= 2" , "player.runicpower >= 90" , "toggle(bonestorm)" }}, --DS for RP Dump if 194844 is out of CD
	}, "talent(7, 1)"},
}

local Shared = {
--	{'@Rubim.CastGroundSpell()'},
}

local Survival = {
	{ "55233" , { "player.runicpower >= 35" , "player.health <= 85" , "player.area(7).enemies >= 1" }}, --VP with enough RP for a DS
}

local Interrupts = {
	-- Mind freeze
	{ '47528' },
}

local Cooldowns = {
	{ "Blood Fury" },
}

local Burst = {
	{"195182" , "player.buff(Bone Shield).count <= 2" },
	{{
		{'49998' , 'player.health <= 70' },
		{'49998' , 'player.runicpower >= 75'},
		{'50842'},
		{'206930' },	
	}, 'player.area(7).enemies >= 2'},
	
	{{
		{'49998' , 'player.runicpower >= 75'},
		{'195182'},
		{'49998'},
		{'50842'},
	}, 'player.area(7).enemies <= 1'},
}

local Util = {
	--AUTOTARGET
	{ '@Rubim.Targeting()' , '!target.alive' },
	{ "@Rubim.AoETaunt()" , "toggle(aoetaunt)" },
}

local General = {
	{{
	{"195182" , "player.buff(Bone Shield).count <= 5" },
	{"206930" , "player.buff(Bone Shield).count >= 6"},
	{"50842" , { "player.spell(50842).charges >= 2" , "player.area(8).enemies >= 1" }},
	}, "player.area(10).enemies <= 2" },
	
	{{
	{"195182" , "player.buff(195181).count <= 2" },
	{"50842" , "player.area(8).enemies >= 1"},
	{"206930" },
	}, "player.area(10).enemies >= 3" },
}


local inCombat = {
	{ Util },
	{ Interrupts, "target.interruptAt(10)" }, -- Interrupt when 40% into the cast time
	{ Cooldowns , "player.area(8).enemies >= 1" },
	{"50842", { "target.debuff(55078).duration < 1.5" , "player.area(8).enemies >= 1" }},
	{ Survival },
	{ Burst , "player.areattd <= 5"},
	{ "194844" , { "player.runicpower >= 90" , "toggle(bonestorm)" , "player.areattd >= 10" }}, --194844 with enough RP
	{ DeathStrikeHELL },
	{ "43265"},
	{ General },
}

local outCombat = {
	{Shared}
}

NeP.Engine.registerRotation(250, '[|cff'..NeP.Interface.addonColor..'Rubim (WIP) Deathknight - Blood', {
		{'%pause', 'player.channeling'},
		{Shared},
		{inCombat}
	}, outCombat, exeOnLoad)
