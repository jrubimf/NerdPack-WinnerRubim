local _, Rubim = ...

local exeOnLoad = function()
--	NePCR.Splash()
	Rubim.meleeSpell = 193315
	print("|cffFFFF00 ----------------------------------------------------------------------|r")
	print("|cffFFFF00 --- |rCLASS NAME: |cffADFF2FArcane |r")
	print("|cffFFFF00 --- |rRecommended Talents: 1/2 - 2/X - 3/3 - 4/3 - 5/X - 6/2 - 7/1")
	print("|cffFFFF00 --- |rRead the Readme avaiable at github.")
	print("|cffFFFF00 ----------------------------------------------------------------------|r")

	NeP.Interface:AddToggle({
		key = 'TimeWarp',
		icon = 'Interface\\Icons\\ability_vanish.png',
		name = 'use TimeWarp',
		text = 'BOT will Timewarp'
	})

	
end

local PreCombat = {
	{'Summon Water Elemental', '!talent(1,2)&!pet.exists'},
}

local Cooldowns = {
--	{'Time Warp', 'UI(kTW)&{xtime=0&!player.buff(Bloodlust)}||{!player.buff(Bloodlust)&xequipped(132410)}'},
--	{'Time Warp', '!player.buff(Bloodlust)&toggle(Timewarp)'},
--	{'Rune of Power', '!player.buff(Rune of Power)&{cooldown(Icy Veins).remains<cooldown(Rune of Power).cast_time||cooldown(Rune of Power).charges<1.9&cooldown(Icy Veins).remains>10||player.buff(Icy Veins)||{target.time_to_die+5<cooldown(Rune of Power).charges*10}}'},
	{'/cast [@player] Rune of Power', '!player.buff(Rune of Power)', 'player'},
	{'Mirror Image'},
	{'Blood Fury'},
	{'Berserking'},
}

local burn = {
	{'Mark of Aluneth'},
	{'Arcane Power'},
	{'Presence of Mind'},
	{'Arcane Barrage', 'player.spell(Evocation).cooldown>gcd&player.mana<85'},
	{'Evocation', 'player.mana<85'},
	{'Arcane Missiles', 'player.buff(Arcane Misiles!).stack>=1'},
	{'Arcane Blast'},

}

local conserve = {
	
}

local xCombat = {
	{burn, 'player.mana>85&player.arcanecharges=4&player.spell(Evocation).cooldown<gcd&player.spell(Arcane Power).cooldown<gcd&player.spell(Presence of Mind).cooldown<gcd'},
	{conserve, 'player.spell(Evocation).cooldown>gcd'},
--D 	1.19 	arcane_missiles,if=variable.arcane_missiles_procs=buff.arcane_missiles.max_stack&active_enemies<3
	{'Arcane Missiles', 'player.buff(Arcane Misiles!).stack=3'},
--E 	65.05 	arcane_blast
	{'Arcane Blast', 'player.arcanecharges<5'},

}

local Keybinds = {
	-- Pause
	{'%pause', 'keybind(alt)'}
}

local Interrupts = {
	{'Counterspell'},
	{'Arcane Torrent', 'target.range<=8&spell(Counterspell).cooldown>gcd&!prev_gcd(Counterspell)'},
}

local Survival = {
	{'Prismatic Barrier', 'player.health<=90'},
}

local inCombat = {
	{Keybinds},
	{Interrupts, 'target.interruptAt(50)&toggle(interrupts)&target.infront&target.range<40'},
	{Survival, 'player.health < 100'},
	{xCombat, 'target.range<40&target.infront'}
}

local outCombat = {
	{Keybinds},
	{PreCombat}
}

NeP.CR:Add(62, {
	name = 'WinnerRubim (WIP) Mage - Arcane',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})