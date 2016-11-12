local _, Rubim = ...

local exeOnLoad = function()
--	NePCR.Splash()
	Rubim.meeleSpell = 1329
	print("|cffFFFF00 ----------------------------------------------------------------------|r")
	print("|cffFFFF00 --- |rCLASS NAME: |cffFFF569Assassination |r")
	print("|cffFFFF00 --- |rRecommended Talents: 1/2 - 2/1 - 3/1 - 4/ANY - 5/1 - 6/3 - 7/1")
	print("|cffFFFF00 --- |rRead the Readme avaiable at github.")
	print("|cffFFFF00 ----------------------------------------------------------------------|r")

--	NeP.Interface:AddToggle({
--		key = 'saveDS',
--		icon = 'Interface\\Icons\\spell_deathknight_butcher2.png',
--		name = 'Save Death Strike',
--		text = 'BOT will Only Death Strike when RP is Capped, useful on fights were you need to cast an active mitigation.'
--	})
--		
--	NeP.Interface:AddToggle({
--		key = 'bonestorm',
--		icon = 'Interface\\Icons\\Ability_deathknight_boneshield.png',
--		name = 'Use 194844',
--		text = 'This will pool RP to use 194844.'
--	})
--	
--	NeP.Interface:AddToggle({
--		key = 'aoetaunt',
--		icon = 'Interface\\Icons\\spell_nature_shamanrage.png',
--		name = 'Aoe Taunt',
--		text = 'Experimental AoE Taunt.'
--	 })	
--	
end

local Shared = {
	{'Rupture', 'player.lastcast(Vanish)'},
	{'Deadly Poison', {'!player.buff(Deadly Poison)', '!player.talent(6,1)'}},
	{'Agonizing Poison', {'!player.buff(Agonizing Poison)', 'player.talent(6,1)'}},
	{'Crippling Poison', '!player.buff(Crippling Poison)'},
}

local Interrupts = {
	{'Kick'},
}

local cds = {
--# Cooldowns
--actions.cds=potion,name=old_war,if=buff.bloodlust.react|target.time_to_die<=25|debuff.vendetta.up
--actions.cds+=/use_item,slot=trinket2,if=buff.bloodlust.react|target.time_to_die<=20|debuff.vendetta.up
--actions.cds+=/blood_fury,if=debuff.vendetta.up
--actions.cds+=/berserking,if=debuff.vendetta.up
--actions.cds+=/arcane_torrent,if=debuff.vendetta.up&energy.deficit>50
--actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit|combo_points.deficit>=5
	{'Marked for Death', 'player.combopoints <= 2&player.energy >= 26'},
--actions.cds+=/vendetta,if=talent.exsanguinate.enabled&cooldown.exsanguinate.remains<5&dot.rupture.ticking
	{'Vendetta', 'player.lastcast(Kingsbane)player.talent(6,3)&spell.cooldown(Exsanguinate)<5&target.debuff(Rupture)&player.spell(Vanish).cooldown>=110'},
--actions.cds+=/vendetta,if=!talent.exsanguinate.enabled&(!artifact.urge_to_kill.enabled|energy.deficit>=70)
	{'Vendetta', '!player.talent(6,3)&player.energydeficit>=70'},
--actions.cds+=/vanish,if=talent.nightstalker.enabled&combo_points>=cp_max_spend&((talent.exsanguinate.enabled&cooldown.exsanguinate.remains<1&(dot.rupture.ticking|time>10))|(!talent.exsanguinate.enabled&dot.rupture.refreshable))
	{'Vanish', 'player.talent(2,1)&player.combopoints>=6&player.spell(Exsanguinate).cooldown<=1&player.lastcast(Mutilate)&player.spell(Vendetta).cooldown<1'},
--actions.cds+=/vanish,if=talent.subterfuge.enabled&dot.garrote.refreshable&((spell_targets.fan_of_knives<=3&combo_points.deficit>=1+spell_targets.fan_of_knives)|(spell_targets.fan_of_knives>=4&combo_points.deficit>=4))
--actions.cds+=/vanish,if=talent.shadow_focus.enabled&energy.time_to_max>=2&combo_points.deficit>=4
--actions.cds+=/exsanguinate,if=prev_gcd.rupture&dot.rupture.remains>4+4*cp_max_spend
	{'Exsanguinate', 'player.lastcast(Rupture)'},
}

local maintain = {
--# Maintain
--actions.maintain=rupture,if=(talent.nightstalker.enabled&stealthed.rogue)|(talent.exsanguinate.enabled&((combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1)|(!ticking&(time>10|combo_points>=2+artifact.urge_to_kill.enabled))))
	{'Rupture', 'player.talent(6,3)&player.combopoints>=6&player.spell(Exsanguinate).cooldown<1||!target.debuff(Rupture)&player.combopoints>=6||player.combopoints>=6&target.debuff(Rupture).duration < 2'},
--actions.maintain+=/rupture,cycle_targets=1,if=combo_points>=cp_max_spend-talent.exsanguinate.enabled&refreshable&(!exsanguinated|remains<=1.5)&target.time_to_die-remains>4
--actions.maintain+=/kingsbane,if=(talent.exsanguinate.enabled&dot.rupture.exsanguinated)|(!talent.exsanguinate.enabled&(debuff.vendetta.up|cooldown.vendetta.remains>10))
	{'Kingsbane', 'player.talent(6,3)&player.lastcast(Exsanguinate)||!player.talent(6,3)&player.buff(Vendetta)||!player.talent(6,3)&player.spell.cooldown(Vendetta)>10'},
--actions.maintain+=/pool_resource,for_next=1
--actions.maintain+=/garrote,cycle_targets=1,if=refreshable&(!exsanguinated|remains<=1.5)&target.time_to_die-remains>4
	{'Garrote', '!target.debuff(Garrote)||player.spell(Exsanguinate).cooldown <= 1'},
}

local finishers = {
--# Finishers
--actions.finish=death_from_above,if=combo_points>=cp_max_spend
--actions.finish+=/envenom,if=combo_points>=cp_max_spend-talent.master_poisoner.enabled|(talent.elaborate_planning.enabled&combo_points>=3+!talent.exsanguinate.enabled&buff.elaborate_planning.remains<2)
	{'Envenom', 'player.combopoints>=6&target.debuff(Rupture).duration>10||player.talent(1,2)&player.combopoints>=6&player.buff(Elaborate Planning).duration<2'},
}

local builders = {
--# Builders
--actions.build=hemorrhage,if=refreshable
--actions.build+=/hemorrhage,cycle_targets=1,if=refreshable&dot.rupture.ticking&spell_targets.fan_of_knives<=3
--actions.build+=/fan_of_knives,if=spell_targets>=3|buff.the_dreadlords_deceit.stack>=29
	{'Fan of Knives', 'player.area(7).enemies>=3&player.buff(Dreadlords Deceit).count>=29'},
--actions.build+=/mutilate,cycle_targets=1,if=(!talent.agonizing_poison.enabled&dot.deadly_poison_dot.refreshable)|(talent.agonizing_poison.enabled&debuff.agonizing_poison.remains<debuff.agonizing_poison.duration*0.3)|(set_bonus.tier19_2pc=1&dot.mutilated_flesh.refreshable)
--	{'Mutilate', 'player.combopoints >= 4'},
--actions.build+=/mutilate
	{'Mutilate'},
}

local inCombat = {
--# Executed every time the actor is available.
--actions=call_action_list,name=cds
	{cds, 'toggle(cooldowns)'},
--actions+=/call_action_list,name=maintain
	{maintain},
--# The 'active_dot.rupture>=spell_targets.rupture' means that we don't want to envenom as long as we can multi-rupture (i.e. units that don't have rupture yet).

--actions+=/call_action_list,name=finish,if=(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)&(!dot.rupture.refreshable|(dot.rupture.exsanguinated&dot.rupture.remains>=3.5)|target.time_to_die-dot.rupture.remains<=4)&active_dot.rupture>=spell_targets.rupture
	{finishers, '!player.talent(6,3)||player.spell.cooldown(Exsanguinate)>2&'},
--actions+=/call_action_list,name=build,if=(combo_points.deficit>0|energy.time_to_max<1)	
	{builders, 'player.combodeficit>0&player.energydiff<1'},
}

local outCombat = {
	{Shared}
}

NeP.CR:Add(259, 'WinnerRubim (WIP) Rogue - Assassination', {
		{'%pause', 'player.channeling'},
		{Shared},
		{Interrupts, 'target.interruptAt(44)'},
		{inCombat}
	}, outCombat, exeOnLoad)
