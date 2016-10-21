local _, Rubim = ...

local exeOnLoad = function()
--	NePCR.Splash()
	Rubim.meeleSpell = 1329
	print("|cffFFFF00 ----------------------------------------------------------------------|r")
	print("|cffFFFF00 --- |rCLASS NAME: |cffFFF569Assassination |r")
	print("|cffFFFF00 --- |rRecommended Talents: 1/2 - 2/1 - 3/1 - 4/ANY - 5/1 - 6/3 - 7/1")
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

local Shared = {
	{'Deadly Poison', '!player.buff(Deadly Poison)'},
	{'Crippling Poison', '!player.buff(Crippling Poison)'},
}

local Interrupts = {
	{'Kick'},
}

local build_ex = {
--# Builders Exsanguinate
--actions.build_ex=hemorrhage,cycle_targets=1,if=combo_points.deficit>=1&refreshable&dot.rupture.remains>6&spell_targets.fan_of_knives>1&spell_targets.fan_of_knives<=4
--actions.build_ex+=/hemorrhage,cycle_targets=1,max_cycle_targets=3,if=combo_points.deficit>=1&refreshable&dot.rupture.remains>6&spell_targets.fan_of_knives>1&spell_targets.fan_of_knives=5
--actions.build_ex+=/fan_of_knives,if=(spell_targets>=2+debuff.vendetta.up&(combo_points.deficit>=1|energy.deficit<=30))|(!artifact.bag_of_tricks.enabled&spell_targets>=7+2*debuff.vendetta.up)
	{'Fan of Knives', {'player.area(7).enemies >= 2', 'target.debuff(Vendetta)' }},
	{'Fan of Knives', {'player.area(7).enemies >= 7', 'target.debuff(Vendetta)', '!player.spell(Bag of Tricks).exists' }},
--actions.build_ex+=/fan_of_knives,if=equipped.the_dreadlords_deceit&((buff.the_dreadlords_deceit.stack>=29|buff.the_dreadlords_deceit.stack>=15&debuff.vendetta.remains<=3)&debuff.vendetta.up|buff.the_dreadlords_deceit.stack>=5&cooldown.vendetta.remains>60&cooldown.vendetta.remains<65)
--	{'Fan of Knives', {'player.equipped(137021)','player.buff(The Dreadlords Deceit).count >= 29' || 'player.buff(The Dreadlords Deceit).count >= 15', 'target.debuff(Vendetta)', }},
--actions.build_ex+=/hemorrhage,if=(combo_points.deficit>=1&refreshable)|(combo_points.deficit=1&(dot.rupture.exsanguinated&dot.rupture.remains<=2|cooldown.exsanguinate.remains<=2))
--actions.build_ex+=/mutilate,if=combo_points.deficit<=1&energy.deficit<=30
	--{'Mutilate', {'player.combodeficit <= 1','player.energydeficit <= 30'}},
	{'Mutilate', 'player.combopoints >= 4'},
--actions.build_ex+=/mutilate,if=combo_points.deficit>=2&cooldown.garrote.remains>2
--	{'Mutilate', 'player.combopoints >=4&player.spell(Garrote).cooldown > 2'},
}

--local build_noex = {
--# Builders no Exsanguinate
--actions.build_noex=hemorrhage,cycle_targets=1,if=combo_points.deficit>=1&refreshable&dot.rupture.remains>6&spell_targets.fan_of_knives>1&spell_targets.fan_of_knives<=4
--actions.build_noex+=/hemorrhage,cycle_targets=1,max_cycle_targets=3,if=combo_points.deficit>=1&refreshable&dot.rupture.remains>6&spell_targets.fan_of_knives>1&spell_targets.fan_of_knives=5
--actions.build_noex+=/fan_of_knives,if=(spell_targets>=2+debuff.vendetta.up&(combo_points.deficit>=1|energy.deficit<=30))|(!artifact.bag_of_tricks.enabled&spell_targets>=7+2*debuff.vendetta.up)
--actions.build_noex+=/fan_of_knives,if=equipped.the_dreadlords_deceit&((buff.the_dreadlords_deceit.stack>=29|buff.the_dreadlords_deceit.stack>=15&debuff.vendetta.remains<=3)&debuff.vendetta.up|buff.the_dreadlords_deceit.stack>=5&cooldown.vendetta.remains>60&cooldown.vendetta.remains<65)
--actions.build_noex+=/hemorrhage,if=combo_points.deficit>=1&refreshable
--actions.build_noex+=/mutilate,if=combo_points.deficit>=1&cooldown.garrote.remains>2	
--}



local cds = {
--# Cooldowns
--actions.cds=marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit|combo_points.deficit>=5
	{'Marked for Death', 'target.ttd > 5'},
--actions.cds+=/vendetta,if=target.time_to_die<20
	{'Vendetta', 'target.ttd > 5'},
--actions.cds+=/vendetta,if=artifact.urge_to_kill.enabled&dot.rupture.ticking&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains<5)&(energy<55|time<10|spell_targets.fan_of_knives>=2)
--actions.cds+=/vendetta,if=!artifact.urge_to_kill.enabled&dot.rupture.ticking&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains<1)
--actions.cds+=/vanish,if=talent.subterfuge.enabled&combo_points<=2&!dot.rupture.exsanguinated|talent.shadow_focus.enabled&!dot.rupture.exsanguinated&combo_points.deficit>=2
--actions.cds+=/vanish,if=!talent.exsanguinate.enabled&talent.nightstalker.enabled&combo_points>=5+talent.deeper_stratagem.enabled&energy>=25&gcd.remains=0	
}


local exsang = {
--# Exsanguinated Finishers
--actions.exsang=rupture,cycle_targets=1,max_cycle_targets=14-2*artifact.bag_of_tricks.enabled,if=!ticking&combo_points>=cp_max_spend-1&spell_targets.fan_of_knives>1&target.time_to_die-remains>6
--	{'Rupture', {''}},
--actions.exsang+=/rupture,if=combo_points>=cp_max_spend&ticks_remain<2
	{'Rupture', {'player.combopoints >= 6',	 'target.debuff(Rupture).duration < 2'}},
--actions.exsang+=/death_from_above,if=combo_points>=cp_max_spend-1&(dot.rupture.remains>3|dot.rupture.remains>2&spell_targets.fan_of_knives>=3)&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6+2*debuff.vendetta.up)
--actions.exsang+=/envenom,if=combo_points>=cp_max_spend-1&(dot.rupture.remains>3|dot.rupture.remains>2&spell_targets.fan_of_knives>=3)&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6+2*debuff.vendetta.up)
	{'Envenom', {'player.combopoints >= 4', 'target.debuff(Rupture).duration > 3'}},
}

local exsang_combo = {
--# Exsanguinate Combo
--actions.exsang_combo=vanish,if=talent.nightstalker.enabled&combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1&gcd.remains=0&energy>=25
--	{'Vanish', {'player.combopoints >= 5', 'player.talent(2,1)', 'player.spell(Exsanguinate).cooldown < 1', 'player.energy >= 25'}},
--actions.exsang_combo+=/rupture,if=combo_points>=cp_max_spend&(!talent.nightstalker.enabled|buff.vanish.up|cooldown.vanish.remains>15)&cooldown.exsanguinate.remains<1
--	{'Rupture', {'player.combopoints >= 6', '!player.talent(2,1)', 'player.buff(Vanish)', 'player.spell(Vanish).cooldown > 15', 'player.spell(Exsanguinate).cooldown < 1'}},
--actions.exsang_combo+=/exsanguinate,if=prev_gcd.rupture&dot.rupture.remains>22+4*talent.deeper_stratagem.enabled&cooldown.vanish.remains>10
	{'Exsanguinate', {'player.lastcast(Rupture)', 'target.debuff(Rupture).duration >= 20', 'player.talent(3,1)'}},
--actions.exsang_combo+=/call_action_list,name=garrote,if=spell_targets.fan_of_knives<=8-artifact.bag_of_tricks.enabled
--	{ garrote, 'player.area(7).enemies <= 8', 'player.spell(Bag of Tricks).exists' },
--actions.exsang_combo+=/hemorrhage,if=spell_targets.fan_of_knives>=2&!ticking
--actions.exsang_combo+=/call_action_list,name=build_ex
	{ build_ex }
}

local finish_ex ={
--	{ "@Rubim.SetText('finish_ex')" },
--# Finishers Exsanguinate
--actions.finish_ex=rupture,cycle_targets=1,max_cycle_targets=14-2*artifact.bag_of_tricks.enabled,if=!ticking&combo_points>=cp_max_spend-1&spell_targets.fan_of_knives>1&target.time_to_die-remains>6
	{'Rupture', {'player.combopoints >= 6', '!target.debuff(Rupture)', 'player.spell(Bag of Tricks).exists','!player.talent(2,1)', 'player.buff(Vanish)', 'player.spell(Vanish).cooldown > 15', 'player.spell(Exsanguinate).cooldown < 1'}},
--actions.finish_ex+=/rupture,if=combo_points>=cp_max_spend-1&refreshable&!exsanguinated
	{'Rupture', {'player.combopoints >= 6', '!target.debuff(Rupture)', 'player.spell(Exsanguinate).cooldown < 1'}},
	{'Rupture', {'player.combopoints >= 6', '!target.debuff(Rupture)', 'player.spell(Exsanguinate).cooldown > 1'}},
--actions.finish_ex+=/death_from_above,if=combo_points>=cp_max_spend-1&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6)
--actions.finish_ex+=/envenom,if=combo_points>=cp_max_spend-1&!dot.rupture.refreshable&buff.elaborate_planning.remains<2&energy.deficit<40&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6)
	{'Envenom', {'player.combopoints >= 6&target.debuff(Rupture).duration > 10&player.buff(Elaborate Planning).duration < 2&player.energydeficit < 40&{player.spell(Bag of Tricks).exists||player.area(7).enemies <= 6}'}},
--actions.finish_ex+=/envenom,if=combo_points>=cp_max_spend&!dot.rupture.refreshable&buff.elaborate_planning.remains<2&cooldown.garrote.remains<1&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6)
	{'Envenom', {'player.combopoints >= 6&target.debuff(Rupture).duration > 10&player.buff(Elaborate Planning).duration < 2&player.spell(Garrote).cooldown < 1&{player.spell(Bag of Tricks).exists||player.area(7).enemies <= 6}'}},
	--{'Envenom', {'player.combopoints >= 6', 'target.debuff(Rupture).duration > 10', 'player.buff(Elaborate Planning).duration < 2', 'player.spell(Garrote).cooldown < 1', 'player.spell(Bag of Tricks).exists', 'player.area(7).enemies <= 6'}},
}


local finish_noex = {
--# Finishers no Exsanguinate
--actions.finish_noex=variable,name=envenom_condition,value=!(dot.rupture.refreshable&dot.rupture.pmultiplier<1.5)&(!talent.nightstalker.enabled|cooldown.vanish.remains>=6)&dot.rupture.remains>=6&buff.elaborate_planning.remains<1.5&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6)
--actions.finish_noex+=/rupture,cycle_targets=1,max_cycle_targets=14-2*artifact.bag_of_tricks.enabled,if=!ticking&combo_points>=cp_max_spend&spell_targets.fan_of_knives>1&target.time_to_die-remains>6
	{'Rupture', {'player.combopoints >= 5', 'player.spell(Bag of Tricks).exists', '!target.debuff(Rupture)', 'target.ttd > 6'}},
--actions.finish_noex+=/rupture,if=combo_points>=cp_max_spend&(((dot.rupture.refreshable)|dot.rupture.ticks_remain<=1)|(talent.nightstalker.enabled&buff.vanish.up))
	{'Rupture', {'player.combopoints >= 5', 'player.spell(Bag of Tricks).exists', '!target.debuff(Rupture)', 'target.ttd > 6'}},
--actions.finish_noex+=/death_from_above,if=(combo_points>=5+talent.deeper_stratagem.enabled-2*talent.elaborate_planning.enabled)&variable.envenom_condition&(refreshable|talent.elaborate_planning.enabled&!buff.elaborate_planning.up|cooldown.garrote.remains<1)
--actions.finish_noex+=/envenom,if=(combo_points>=5+talent.deeper_stratagem.enabled-2*talent.elaborate_planning.enabled)&variable.envenom_condition&(refreshable|talent.elaborate_planning.enabled&!buff.elaborate_planning.up|cooldown.garrote.remains<1)	
	{'Envenom', {'player.combopoints >= 5', 'player.talent(3,1)', 'player.talent(1,2)', '!target.debuff(Envenom)', 'player.spell(Garrote).cooldown < 1'}},
}


--local garrote = {
--# Garrote
--actions.garrote=pool_resource,for_next=1
--actions.garrote+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&!ticking&combo_points.deficit>=1&spell_targets.fan_of_knives>=2
--actions.garrote+=/pool_resource,for_next=1
--actions.garrote+=/garrote,if=combo_points.deficit>=1&!exsanguinated	
--	{'Garrote' },
--}


local inCombat = {
	{'Vendetta'},
	{'Marked for Death'},
	{'Garrote', '!target.debuff(Garrote)||player.spell(Exsanguinate).cooldown <= 1'},
	{'Rupture', 'player.combopoints >= 6&!target.debuff(Rupture)'},
	{'Exsanguinate', 'player.lastcast(Rupture)'},
	{'Kingsbane'},
	{'Envenom', 'player.combopoints >= 5&target.debuff(Rupture).duration > 7'},
	{'Mutilate', 'player.combopoints <= 6'},
--# Executed every time the actor is available.
--actions=potion,name=old_war,if=buff.bloodlust.react|target.time_to_die<=25|debuff.vendetta.up
--actions+=/use_item,slot=trinket2,if=buff.bloodlust.react|target.time_to_die<=20|debuff.vendetta.up
--actions+=/blood_fury,if=debuff.vendetta.up
--actions+=/berserking,if=debuff.vendetta.up
--actions+=/arcane_torrent,if=debuff.vendetta.up&energy.deficit>50
--actions+=/call_action_list,name=cds
	{ cds },
--actions+=/rupture,if=talent.exsanguinate.enabled&combo_points>=2+artifact.urge_to_kill.enabled*2&!ticking&(artifact.urge_to_kill.enabled|time<10)
--	{'Rupture', {'player.combopoints >= 5', '!target.debuff(Rupture)', 'player.spell(Urge to Kill)', 'player.talent(6,3)'}},
--actions+=/pool_resource,for_next=1
--actions+=/kingsbane,if=(!talent.exsanguinate.enabled&(debuff.vendetta.up|cooldown.vendetta.remains>10))|(talent.exsanguinate.enabled&dot.rupture.exsanguinated)
--	{'Kingsbane', {'player.talent(6,3)', 'target.debuff(Rupture).duration > 10', 'player.lastcast(Exsanguinate)'}},
--	{'Kingsbane', {'!player.talent(6,3)'}, {'player.buff(Vendetta).duration > 10'}},
--actions+=/run_action_list,name=exsang_combo,if=talent.exsanguinate.enabled&cooldown.exsanguinate.remains<3&(debuff.vendetta.up|cooldown.vendetta.remains>25)
--	{ exsang_combo, 'player.talent(6,3)&player.spell(Exsanguinate).cooldown < 3&{player.buff(Vendetta)||player.buff(Vendetta).cooldown > 25}'},
	--{ exsang_combo },
--actions+=/call_action_list,name=garrote,if=spell_targets.fan_of_knives<=8-artifact.bag_of_tricks.enabled
--	{'Garrote', '!target.debuff(Garrote)'},
--actions+=/call_action_list,name=exsang,if=dot.rupture.exsanguinated
--	{ exsang, 'player.spell(Exsanguinate).cooldown > 32'},
--actions+=/rupture,if=talent.exsanguinate.enabled&remains-cooldown.exsanguinate.remains<(4+cp_max_spend*4)*0.3&new_duration-cooldown.exsanguinate.remains>=(4+cp_max_spend*4)*0.3+3
--	{'Rupture', {'player.combopoints >= 6', '!target.debuff(Rupture)', 'player.spell(Urge to Kill)', 'player.talent(6,3)'}},
--actions+=/call_action_list,name=finish_ex,if=talent.exsanguinate.enabled
--	{ finish_ex },
--actions+=/call_action_list,name=finish_noex,if=!talent.exsanguinate.enabled
--	{ finish_noex, '!player.talent(6,3)'},
--actions+=/call_action_list,name=build_ex,if=talent.exsanguinate.enabled
--	{ build_ex },
--actions+=/call_action_list,name=build_noex,if=!talent.exsanguinate.enabled
--	{ build_noex, '!player.talent(6,3)'},
}

local outCombat = {
	{Shared}
}

NeP.CR:Add(259, 'WinnerRubim (WIP) Rogue - Assassination', {
		{'%pause', 'player.channeling'},
		{Shared},
		{Interrupts, 'target.interruptAt(24)'},
		{inCombat}
	}, outCombat, exeOnLoad)
