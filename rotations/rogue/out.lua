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
		key = 'saveDS',
		icon = 'Interface\\Icons\\spell_deathknight_butcher2.png',
		name = 'Save Death Strike',
		text = 'BOT will Only Death Strike when RP is Capped, useful on fights were you need to cast an active mitigation.'
	})
		
	NeP.Interface:AddToggle({
		key = 'bonestorm',
		icon = 'Interface\\Icons\\Ability_deathknight_boneshield.png',
		name = 'Use 194844',
		text = 'This will pool RP to use 194844.'
	})
	
	NeP.Interface:AddToggle({
		key = 'aoetaunt',
		icon = 'Interface\\Icons\\spell_nature_shamanrage.png',
		name = 'Aoe Taunt',
		text = 'Experimental AoE Taunt.'
	 })	
	
end

local Interrupts = {
	{'Kick'},	
}

local build = {
--# Builders
--actions.build=ghostly_strike,if=combo_points.deficit>=1+buff.broadsides.up&!buff.curse_of_the_dreadblades.up&(debuff.ghostly_strike.remains<debuff.ghostly_strike.duration*0.3|(cooldown.curse_of_the_dreadblades.remains<3&debuff.ghostly_strike.remains<14))&(combo_points>=3|(variable.rtb_reroll&time>=10))
--	{'Ghostly Strike', {'player.buff(Broadsides)', '!player.buff(Curse of the Dreadblades)', 'target.debuff(Ghostly Strike).duration < 2'}},
--	{'Ghostly Strike', {'player.spell(Curse of the Dreadblades).cooldown > 1', 'player.combodeficit >= 1',  'target.debuff{Ghostly Strike).duration < 2'}},
	{'Ghostly Strike', {'player.combodeficit >= 1',  'target.debuff(Ghostly Strike).duration < 2'}},
--actions.build+=/pistol_shot,if=combo_points.deficit>=1+buff.broadsides.up&buff.opportunity.up&energy.time_to_max>2-talent.quick_draw.enabled
	--{'Pistol Shot', {'player.buff(Opportunity)', 'player.combodeficit >= 1' }},	
	{'Pistol Shot', {'player.buff(Opportunity)', 'player.combopoints < 5' }},
--actions.build+=/saber_slash,if=variable.ss_useable
	--{'Saber Slash', 'player.combopoints < 5'},
	{'Saber Slash', 'player.combopoints < 5||player.combopoints <= 5&player.buff(Broadsides)'},
}

local finish = {
--# Finishers
--actions.finish=between_the_eyes,if=equipped.greenskins_waterlogged_wristcuffs&buff.shark_infested_waters.up
	{'Between the Eyes', {'player.combopoints >= 5', 'player.buff(Shark Infested Waters)'}},
--actions.finish+=/run_through,if=!talent.death_from_above.enabled|energy.time_to_max<cooldown.death_from_above.remains+3.5
	--{'Run Through', {'player.combopoints >= 5', '!player.talent(7,3)'}},
	{'Run Through', 'player.combopoints >= 5'},
}

local bf = {
--# Blade Flurry
--actions.bf=cancel_buff,name=blade_flurry,if=equipped.shivarran_symmetry&cooldown.blade_flurry.up&buff.blade_flurry.up&spell_targets.blade_flurry>=2|spell_targets.blade_flurry<2&buff.blade_flurry.up
--	{'Blade Flurry', {'player.equipped()', 'player.area(7).enemies >= 2'}},
--actions.bf+=/blade_flurry,if=spell_targets.blade_flurry>=2&!buff.blade_flurry.up
	{'Blade Flurry', {'player.area(7).enemies > 3', '!player.buff(Blade Flurry)'}},
	{'Blade Flurry', {'player.area(7).enemies < 2', 'player.buff(Blade Flurry)'}},
}

local cds = {
--# Cooldowns
--actions.cds=potion,name=old_war,if=buff.bloodlust.react|target.time_to_die<=25|buff.adrenaline_rush.up
--actions.cds+=/use_item,slot=trinket2,if=buff.bloodlust.react|target.time_to_die<=20|combo_points.deficit<=2
--actions.cds+=/blood_fury
--actions.cds+=/berserking
--actions.cds+=/arcane_torrent,if=energy.deficit>40
--actions.cds+=/cannonball_barrage,if=spell_targets.cannonball_barrage>=1
	{'Cannonball Barrage', 'player.area(7).enemies <= 3'},
--actions.cds+=/adrenaline_rush,if=!buff.adrenaline_rush.up&energy.deficit>0
	{'Adrenaline Rush', 'player.energydeficit > 0'},
--actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit|((raid_event.adds.in>40|buff.true_bearing.remains>15)&combo_points.deficit>=4+talent.deeper_strategem.enabled+talent.anticipation.enabled)
	{'Marked for Death', {'player.combopoints <= 5', 'player.energy >= 26'}},
--actions.cds+=/sprint,if=equipped.thraxis_tricksy_treads&!variable.ss_useable
--actions.cds+=/curse_of_the_dreadblades,if=combo_points.deficit>=4&(!talent.ghostly_strike.enabled|debuff.ghostly_strike.up)
	{'Curse of the Dreadblades', {'player.combodeficit >= 4', 'target.debuff(Ghostly Strike)'}},

}

local inCombat = {
--variable,name=rtb_reroll,value=!talent.slice_and_dice.enabled&(rtb_buffs<=1&!rtb_list.any.6&((!buff.curse_of_the_dreadblades.up&!buff.adrenaline_rush.up)|!rtb_list.any.5))
--{'Roll the Bones', {'!player.talent(7,1)', '!player.buff(Broadsides)', '!player.buff(Jolly Roger)', '!player.buff(Grand Melee)', '!player.buff(Shark Infested Waters)', '!player.buff(True Bearing)', '!player.buff(Buried Treasure)', 'or', '!player.buff(Adrenaline Rush)', '!player.buff(Curse of the Dreadblades)', '!player.talent(7,1)', 'player.buff(Broadsides)', '!player.buff(Jolly Roger)', '!player.buff(Grand Melee)', '!player.buff(Shark Infested Waters)', '!player.buff(True Bearing)', '!player.buff(Buried Treasure)', 'or', '!player.buff(Adrenaline Rush)', '!player.buff(Curse of the Dreadblades)', '!player.talent(7,1)', '!player.buff(Broadsides)', 'player.buff(Jolly Roger)', '!player.buff(Grand Melee)', '!player.buff(Shark Infested Waters)', '!player.buff(True Bearing)', '!player.buff(Buried Treasure)', 'or', '!player.buff(Adrenaline Rush)', '!player.buff(Curse of the Dreadblades)', '!player.talent(7,1)', '!player.buff(Broadsides)', '!player.buff(Jolly Roger)', 'player.buff(Grand Melee)', '!player.buff(Shark Infested Waters)', '!player.buff(True Bearing)', '!player.buff(Buried Treasure)', 'or', '!player.buff(Adrenaline Rush)', '!player.buff(Curse of the Dreadblades)', '!player.talent(7,1)', '!player.buff(Broadsides)', '!player.buff(Jolly Roger)', '!player.buff(Grand Melee)', 'player.buff(Shark Infested Waters)', '!player.buff(True Bearing)', '!player.buff(Buried Treasure)', 'or', '!player.buff(Adrenaline Rush)', '!player.buff(Curse of the Dreadblades)', '!player.talent(7,1)', '!player.buff(Broadsides)', '!player.buff(Jolly Roger)', '!player.buff(Grand Melee)', '!player.buff(Shark Infested Waters)', 'player.buff(True Bearing)', '!player.buff(Buried Treasure)', 'or', '!player.buff(Adrenaline Rush)', '!player.buff(Curse of the Dreadblades)', '!player.talent(7,1)', '!player.buff(Broadsides)', '!player.buff(Jolly Roger)', '!player.buff(Grand Melee)', '!player.buff(Shark Infested Waters)', '!player.buff(True Bearing)', 'player.buff(Buried Treasure)'}},
	--{'Roll the Bones', '!player.talent(7,1)&!player.buff(Broadsides)&!player.buff(Jolly Roger)&!player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&!player.buff(Buried Treasure)||!player.buff(Adrenaline Rush)&!player.buff(Curse of the Dreadblades)&!player.talent(7,1)&player.buff(Broadsides)&!player.buff(Jolly Roger)&!player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&!player.buff(Buried Treasure)||!player.buff(Adrenaline Rush)&!player.buff(Curse of the Dreadblades)&!player.talent(7,1)&!player.buff(Broadsides)&player.buff(Jolly Roger)&!player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&!player.buff(Buried Treasure)||!player.buff(Adrenaline Rush)&!player.buff(Curse of the Dreadblades)&!player.talent(7,1)&!player.buff(Broadsides)&!player.buff(Jolly Roger)&player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&!player.buff(Buried Treasure)||!player.buff(Adrenaline Rush)&!player.buff(Curse of the Dreadblades)&!player.talent(7,1)&!player.buff(Broadsides)&!player.buff(Jolly Roger)&!player.buff(Grand Melee)&player.buff(Shark Infested Waters)&!player.buff(True Bearing)&!player.buff(Buried Treasure)||!player.buff(Adrenaline Rush)&!player.buff(Curse of the Dreadblades)&!player.talent(7,1)&!player.buff(Broadsides)&!player.buff(Jolly Roger)&!player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&player.buff(True Bearing)&!player.buff(Buried Treasure)||!player.buff(Adrenaline Rush)&!player.buff(Curse of the Dreadblades)&!player.talent(7,1)&!player.buff(Broadsides)&!player.buff(Jolly Roger)&!player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&player.buff(Buried Treasure)'},
	{'Roll the Bones', {'player.combopoints >= 5', '!player.talent(7,1)', '!player.buff(Broadsides)', '!player.buff(Jolly Roger)', '!player.buff(Grand Melee)', '!player.buff(Shark Infested Waters)', '!player.buff(True Bearing)', '!player.buff(Buried Treasure)'}},
--	{'Roll the Bones', 'toggle(cooldowns)&player.combopoints >= 5&!player.talent(7,1)&player.spell(Adrenaline Rush).cooldown < 15&!player.buff(Shark Infested Waters)||toggle(Cooldowns)&player.combopoints >= 5&!player.talent(7,1)&player.spell(Curse of the Dreadblades).cooldown < 15&!player.buff(Shark Infested Waters)'},
	--(This one is with the 2 buff combinations - Not sure its wrong yet) {'Roll the Bones', 'player.combopoints >= 5&!player.talent(7,1)&player.spell(Adrenaline Rush).cooldown > 15&player.spell(Curse of the Dreadblades).cooldown > 15&!player.talent(7,1)&player.buff(Broadsides)&!player.buff(Jolly Roger)&!player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&!player.buff(Buried Treasure)||player.combopoints >= 5&!player.talent(7,1)&player.spell(Adrenaline Rush).cooldown > 15&player.spell(Curse of the Dreadblades).cooldown > 15&!player.buff(Broadsides)&player.buff(Jolly Roger)&!player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&!player.buff(Buried Treasure)||player.combopoints >= 5&!player.talent(7,1)&player.spell(Adrenaline Rush).cooldown > 15&player.spell(Curse of the Dreadblades).cooldown > 15&!player.buff(Broadsides)&!player.buff(Jolly Roger)&player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&!player.buff(Buried Treasure)||player.combopoints >= 5&!player.talent(7,1)&player.spell(Adrenaline Rush).cooldown > 15&player.spell(Curse of the Dreadblades).cooldown > 15&!player.buff(Broadsides)&!player.buff(Jolly Roger)&!player.buff(Grand Melee)&player.buff(Shark Infested Waters)&!player.buff(True Bearing)&!player.buff(Buried Treasure)||player.combopoints >= 5&!player.talent(7,1)&player.spell(Adrenaline Rush).cooldown > 15&player.spell(Curse of the Dreadblades).cooldown > 15&!player.buff(Broadsides)&!player.buff(Jolly Roger)&!player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&player.buff(Buried Treasure)||player.combopoints >= 5&!player.talent(7,1)&player.spell(Adrenaline Rush).cooldown > 15&player.spell(Curse of the Dreadblades).cooldown > 15&player.buff(Broadsides)&player.buff(Jolly Roger)&!player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&!player.buff(Buried Treasure)||player.combopoints >= 5&!player.talent(7,1)&player.spell(Adrenaline Rush).cooldown > 15&player.spell(Curse of the Dreadblades).cooldown > 15&!player.buff(Broadsides)&player.buff(Jolly Roger)&player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&!player.buff(Buried Treasure)||player.combopoints >= 5&!player.talent(7,1)&player.spell(Adrenaline Rush).cooldown > 15&player.spell(Curse of the Dreadblades).cooldown > 15&!player.buff(Broadsides)&player.buff(Jolly Roger)&!player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&player.buff(Buried Treasure)||player.combopoints >= 5&!player.talent(7,1)&player.spell(Adrenaline Rush).cooldown > 15&player.spell(Curse of the Dreadblades).cooldown > 15&!player.buff(Broadsides)&!player.buff(Jolly Roger)&player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&player.buff(Buried Treasure)'},
	{'Roll the Bones', 'player.combopoints >= 5&!player.talent(7,1)&player.spell(Adrenaline Rush).cooldown > 15&player.spell(Curse of the Dreadblades).cooldown > 15&!player.talent(7,1)&player.buff(Broadsides)&!player.buff(Jolly Roger)&!player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&!player.buff(Buried Treasure)||player.combopoints >= 5&!player.talent(7,1)&player.spell(Adrenaline Rush).cooldown > 15&player.spell(Curse of the Dreadblades).cooldown > 15&!player.buff(Broadsides)&player.buff(Jolly Roger)&!player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&!player.buff(Buried Treasure)||player.combopoints >= 5&!player.talent(7,1)&player.spell(Adrenaline Rush).cooldown > 15&player.spell(Curse of the Dreadblades).cooldown > 15&!player.buff(Broadsides)&!player.buff(Jolly Roger)&player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&!player.buff(Buried Treasure)||player.combopoints >= 5&!player.talent(7,1)&player.spell(Adrenaline Rush).cooldown > 15&player.spell(Curse of the Dreadblades).cooldown > 15&!player.buff(Broadsides)&!player.buff(Jolly Roger)&!player.buff(Grand Melee)&player.buff(Shark Infested Waters)&!player.buff(True Bearing)&!player.buff(Buried Treasure)||player.combopoints >= 5&!player.talent(7,1)&player.spell(Adrenaline Rush).cooldown > 15&player.spell(Curse of the Dreadblades).cooldown > 15&!player.buff(Broadsides)&!player.buff(Jolly Roger)&!player.buff(Grand Melee)&!player.buff(Shark Infested Waters)&!player.buff(True Bearing)&player.buff(Buried Treasure)'},
--variable,name=ss_useable_noreroll,value=(combo_points<5+talent.deeper_stratagem.enabled-(buff.broadsides.up|buff.jolly_roger.up)-(talent.alacrity.enabled&buff.alacrity.stack<=4))
--variable,name=ss_useable,value=(talent.anticipation.enabled&combo_points<4)|(!talent.anticipation.enabled&((variable.rtb_reroll&combo_points<4+talent.deeper_stratagem.enabled)|(!variable.rtb_reroll&variable.ss_useable_noreroll)))
--call_action_list,name=bf
	{ bf },
--call_action_list,name=cds
	{ cds, 'toggle(cooldowns)'},
--call_action_list,name=stealth,if=stealthed|cooldown.vanish.up|cooldown.shadowmeld.up
--death_from_above,if=energy.time_to_max>2&!variable.ss_useable_noreroll
--slice_and_dice,if=!variable.ss_useable&buff.slice_and_dice.remains<target.time_to_die&buff.slice_and_dice.remains<(1+combo_points)*1.8
--roll_the_bones,if=!variable.ss_useable&buff.roll_the_bones.remains<target.time_to_die&(buff.roll_the_bones.remains<=3|variable.rtb_reroll)
--killing_spree,if=energy.time_to_max>5|energy<15
--call_action_list,name=build
	{ build },
--call_action_list,name=finish,if=!variable.ss_useable
	{ finish },
--gouge,if=talent.dirty_tricks.enabled&combo_points.deficit>=1


}

local Shared = {
	
}

local outCombat = {
	{Shared}
}

NeP.CR:Add(260, 'WinnerRubim (WIP) Rogue - Outlaw', {
		{'%pause', 'player.channeling'},
		{Shared},
		{Interrupts, 'target.interruptAt(24)'},
		{inCombat, 'player.onmelee'}
	}, outCombat, exeOnLoad)
