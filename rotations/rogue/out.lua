local _, Rubim = ...

local exeOnLoad = function()
--	NePCR.Splash()
	Rubim.meleeSpell = 193315
	print("|cffFFFF00 ----------------------------------------------------------------------|r")
	print("|cffFFFF00 --- |rCLASS NAME: |cffFFF569Outlaw |r")
	print("|cffFFFF00 --- |rRecommended Talents: 1/1 - 2/3 - 3/1 - 4/0 - 5/1 - 6/2 - 7/2")
	print("|cffFFFF00 --- |rRead the Readme avaiable at github.")
	print("|cffFFFF00 ----------------------------------------------------------------------|r")

	NeP.Interface:AddToggle({
		key = 'stealth',
		icon = 'Interface\\Icons\\ability_vanish.png',
		name = 'Vanish to use Ambush in Combat',
		text = 'BOT will Vanish in combat to use Ambush'
	})

	
end

local Interrupts = {
	{'Kick'},	
}

local Survival = {
	{'Crimson Vial', 'player.health < 60'},	
	{'Feint', 'player.health < 30&!player.buff(Will of Valeera)'},
}

local bf = {
--# Blade Flurry
--actions.bf=cancel_buff,name=blade_flurry,if=equipped.shivarran_symmetry&cooldown.blade_flurry.up&buff.blade_flurry.up&spell_targets.blade_flurry>=2|spell_targets.blade_flurry<2&buff.blade_flurry.up
--	{'Blade Flurry', {'player.equipped()', 'player.area(7).enemies >= 2'}},
--actions.bf+=/blade_flurry,if=spell_targets.blade_flurry>=2&!buff.blade_flurry.up

}

local cds = {
--# Cooldowns
--actions.cds=potion,name=old_war,if=buff.bloodlust.react|target.time_to_die<=25|buff.adrenaline_rush.up
--actions.cds+=/use_item,slot=trinket2,if=buff.bloodlust.react|target.time_to_die<=20|combo_points.deficit<=2
--actions.cds+=/blood_fury
--actions.cds+=/berserking
--actions.cds+=/arcane_torrent,if=energy.deficit>40
--actions.cds+=/cannonball_barrage,if=spell_targets.cannonball_barrage>=1
	{'Cannonball Barrage', 'player.area(7).enemies <=2'},
--actions.cds+=/adrenaline_rush,if=!buff.adrenaline_rush.up&energy.deficit>0
	{'Adrenaline Rush', 'player.energydeficit >0'},
--actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit|((raid_event.adds.in>40|buff.true_bearing.remains>15)&combo_points.deficit>=4+talent.deeper_strategem.enabled+talent.anticipation.enabled)
	{'Marked for Death', 'player.combopoints <=5&player.energy >=26'},
--actions.cds+=/sprint,if=equipped.thraxis_tricksy_treads&!variable.ss_useable
--actions.cds+=/curse_of_the_dreadblades,if=combo_points.deficit>=4&(!talent.ghostly_strike.enabled|debuff.ghostly_strike.up)
	{'Curse of the Dreadblades', 'player.combodeficit >=4&target.debuff(Ghostly Strike)&toggle(cooldowns)||player.combodeficit >=4&!talent(1,1)'},

}

local stealth = {
	{'Vanish'},
	{'Shadowmeld', '!lastcast(Vanish)'},

}

local build = {
--# Builders
--actions.build=ghostly_strike,if=combo_points.deficit>=1+buff.broadsides.up&!buff.curse_of_the_dreadblades.up&(debuff.ghostly_strike.remains<debuff.ghostly_strike.duration*0.3|(cooldown.curse_of_the_dreadblades.remains<3&debuff.ghostly_strike.remains<14))&(combo_points>=3|(variable.rtb_reroll&time>=10))
	{'Ghostly Strike', 'player.combodeficit >= 1&!player.buff(Curse of the Dreadblades)&target.debuff(Ghostly Strike).duration <= 4.5||player.spell(Curse of the Dreadblades).cooldown < 3&target.debuff(Ghostly Strike).duration < 14&player.combopoints >= 3'},
--actions.build+=/pistol_shot,if=combo_points.deficit>=1+buff.broadsides.up&buff.opportunity.up&energy.time_to_max>2-talent.quick_draw.enabled
	{'Pistol Shot', 'player.buff(Opportunity)&player.combodeficit >= 1' },
--actions.build+=/saber_slash,if=variable.ss_useable
	{'Saber Slash', 'player.combopoints <= 5||player.combopoints <= 5&player.buff(Broadsides)'},
	{ 'Tricks of the Trade', '!focus.buff', 'focus'},
	{ 'Tricks of the Trade', '!tank.buff', 'tank'},

}

local finish = {
--# Finishers
--actions.finish=between_the_eyes,if=equipped.greenskins_waterlogged_wristcuffs&buff.shark_infested_waters.up
	{'Between the Eyes', 'player.combopoints >= 6&player.buff(Shark Infested Waters)||IsEquippedItem(137099)&player.buff(Shark Infested Waters)'},
--actions.finish+=/run_through,if=!talent.death_from_above.enabled|energy.time_to_max<cooldown.death_from_above.remains+3.5
	{'Run Through', 'player.combopoints >= 5'},
}





local inCombat = {
	{'Roll the Bones', 'player.combopoints >= 5&!RtB'},
--call_action_list,name=bf
	{'Blade Flurry', 'player.area(7).enemies == 1&player.buff(Blade Flurry)&toggle(aoe)'},
	{'Blade Flurry', 'player.area(7).enemies >= 3&!player.buff(Blade Flurry&toggle(aoe)'},
--	{ bf, 'toggle(aoe)' },
--call_action_list,name=cds
	{ cds, 'toggle(cooldowns)'},
--call_action_list,name=stealth,if=stealthed|cooldown.vanish.up|cooldown.shadowmeld.up
	{ stealth, 'toggle(stealth)&player.combodeficit >=2&target.debuff(Ghostly Strike)&player.energy >60&!player.buff(Curse of the Dreadblades)'},
--death_from_above,if=energy.time_to_max>2&!variable.ss_useable_noreroll
--slice_and_dice,if=!variable.ss_useable&buff.slice_and_dice.remains<target.time_to_die&buff.slice_and_dice.remains<(1+combo_points)*1.8
--roll_the_bones,if=!variable.ss_useable&buff.roll_the_bones.remains<target.time_to_die&(buff.roll_the_bones.remains<=3|variable.rtb_reroll)
--killing_spree,if=energy.time_to_max>5|energy<15
--call_action_list,name=finish,if=!variable.ss_useable
	{ finish },
--call_action_list,name=build
	{ build },
--# Gouge is used as a CP Generator while nothing else is available and you have Dirty Tricks talent. It's unlikely that you'll be able to do this optimally in-game since it requires to move in front of the target, but it's here so you can quantifiy its value.
--actions+=/gouge,if=talent.dirty_tricks.enabled&combo_points.deficit>=1
--{'Gouge', 'player.combodeficit >= 1&player.energy < 40&'},


}

local Shared = {
	
}

local outCombat = {
	--{'Ambush', 'target.combat&target.range<5&target.infront&player.buff(Stealth)'},
	{'Ambush', 'lastcast(Vanish)&target.range<5&target.infront&player.buff(Stealth)||target.range<5&target.infront&player.buff(Shadowmeld)'},
}

local inCombat = {
	{'%pause', 'player.channeling'},
	{Survival},
	{Interrupts, 'target.interruptAt(64)'},
	{inCombat, 'target.range < 11&target.infront'}
}

NeP.CR:Add(260, {
	name = 'WinnerRubim (WIP) Rogue - Outlaw',
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad
}) 