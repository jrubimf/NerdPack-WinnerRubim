local _, Rubim = ...

local exeOnLoad = function()
--	NePCR.Splash()
	Rubim.meleeSpell = 193315
	print("|cffFFFF00 ----------------------------------------------------------------------|r")
	print("|cffFFFF00 --- |rCLASS NAME: |cffADFF2FFrost |r")
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
	{'Time Warp', '!player.buff(Bloodlust)&toggle(Timewarp)'},
	{'Rune of Power', '!player.buff(Rune of Power)&{cooldown(Icy Veins).remains<cooldown(Rune of Power).cast_time||cooldown(Rune of Power).charges<1.9&cooldown(Icy Veins).remains>10||player.buff(Icy Veins)||{target.time_to_die+5<cooldown(Rune of Power).charges*10}}'},
	{'Icy Veins', '!player.buff(Icy Veins)'},
	{'Mirror Image'},
	{'Blood Fury'},
	{'Berserking'},
}

local xCombat = {
--8 	25.14 	ice_lance,if=variable.fof_react=0&prev_gcd.1.flurry
	{'Ice Lance', 'player.buff(Fingers of Frost)'},
	{'Ice Lance', 'player.moving'},
--H 	8.96 	frozen_orb,if=set_bonus.tier20_2pc
	{'Frozen Orb','player.mana>=10' ,'target'},
--I 	43.57 	flurry,if=prev_gcd.1.ebonbolt|buff.brain_freeze.react&(!talent.glacial_spike.enabled&prev_gcd.1.frostbolt|talent.glacial_spike.enabled&(prev_gcd.1.glacial_spike|prev_gcd.1.frostbolt&(buff.icicles.stack<=3|cooldown.frozen_orb.remains<=10&set_bonus.tier20_2pc)))
--	{'Flurry', '{player.spell(Ebonbolt).cooldown>0&player.buff(Brain Freeze)}||player.lastcast(Ebonbolt)'},
	{'Flurry', 'player.spell(Ebonbolt).cooldown >gcd & player.buff(Brain Freeze) || player.lastcast(Ebonbolt)'},
--J 	58.54 	ice_lance,if=variable.fof_react>0&cooldown.icy_veins.remains>10|variable.fof_react>2
	{'Ice Lance', 'player.buff(Fingers of Frost).stack>0&cooldown(Icy Veins).remains>10||player.buff(Fingers of Frost).stack>2'},
--K 	6.60 	ebonbolt,if=buff.brain_freeze.react=0
	{'Ebonbolt', 'player.buff(Brain Freeze)'},
--L 	134.99 	frostbolt
	{'Frostbolt'},

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
	{'Ice Barrier', 'player.health<=90'},
}

local inCombat = {
	{Keybinds},
	{Interrupts, 'target.interruptAt(50)&toggle(interrupts)&target.infront&target.range<40'},
	{Cooldowns, 'toggle(cooldowns)'},
	{Survival, 'player.health < 100'},
	{xCombat, 'target.range<40&target.infront'}
}

local outCombat = {
	{Keybinds},
	{PreCombat}
}

NeP.CR:Add(64, {
	name = 'WinnerRubim (WIP) Mage - Frost',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})
