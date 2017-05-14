local _, Rubim = ...

local exeOnLoad = function()
	Rubim.meeleSpell = 49998
		print("|cffFFFF00 ----------------------------------------------------------------------|r")
	print("|cffFFFF00 --- |rCLASS NAME: |cffC41F3BFROSTY |r")
	print("|cffFFFF00 --- |rRecommended Talents: 1/3 - 2/3 - 3/2 - 4/X - 5/2 - 6/3 - 7/2")
	print("|cffFFFF00 --- |rRead the Readme avaiable at github.")
	print("|cffFFFF00 ----------------------------------------------------------------------|r")
	print('Meele Spell: '.. GetSpellInfo(Rubim.meeleSpell) .. '(' .. Rubim.meeleSpell .. ')')
	NeP.Interface:AddToggle({
		key = 'useDS',
		icon = 'Interface\\Icons\\spell_deathknight_butcher2.png',
		name = 'Use Dark Succor',
		text = 'Using Dark Scuccor ot heal.'
	})
end

local Cooldowns = {
--	Pillar_of_frost,if=!equipped.140806|!talent.breath_of_sindragosa.enabled
	{ 'Pillar of Frost', '!equipped(Convergence of Fates)||!talent(7,2)'},
--	pillar_of_frost,if=equipped.140806&talent.breath_of_sindragosa.enabled&((runic_power>=50&cooldown.hungering_rune_weapon.remains<10)|(cooldown.breath_of_sindragosa.remains>20))
	{ 'Pillar of Frost', 'equipped(Convergence of Fates)&talent(7,2)&player.runicpower >=50&player.spell(Hungering Rune Weapon).cooldown <10||player.spell(Breath of Sindragosa).cooldown >20'},
--	{ 'Pillar of Frost', 'talent(7,2)&((player.runicpower >=50&player.spell(Hungering Rune Weapon).cooldown <10)||(player.spell(Breath of Sindragosa).cooldown >= 20))'},
	{ 'Blood Fury' },
}

local Survival = {
	-- healthstone
	{ '#5512', 'player.health < 70'},
	{ 'Death Strike' , 'player.health <=40' },
}

local Interrupts = {
	-- Mind freeze
	{ '47528' },
}

local bos = {
	{'Sindragosa\'s Fury', 'buff(Pillar of Frost)&target.debuff(Razorice).count>=5'},

--	0.00 	frost_strike,if=talent.icy_talons.enabled&buff.icy_talons.remains<1.5&cooldown.breath_of_sindragosa.remains>6
	{ 'Frost Strike', 'talent(1,2)&buff(Icy Talons)&spell(Breath of Sindragosa).cooldown >6'},
--E 	8.44 	remorseless_winter,if=talent.gathering_storm.enabled
	{ 'Remorseless Winter', 'talent(6,3)'},
--F 	1.01 	howling_blast,target_if=!dot.frost_fever.ticking
	{ 'Howling Blast', '!target.debuff(Frost Fever)'},
--G 	2.72 	breath_of_sindragosa,if=runic_power>=50&(!equipped.140806|cooldown.hungering_rune_weapon.remains<10)
	{ 'Breath of Sindragosa', 'runicpower >=50&{!equipped(Convergence of Fates)||spell(Hungering Rune Weapon).cooldown <10)}'},
--	{ 'Breath of Sindragosa', 'player.runicpower >=50'},
--H 	8.03 	frost_strike,if=runic_power>=90&set_bonus.tier19_4pc
--	{ 'Frost Strike' , 'player.runicpower >=90&' },
--	0.00 	remorseless_winter,if=buff.rime.react&equipped.132459
	{ 'Remorseless Winter', 'buff(Rime)&equipped(Perseverance of the Ebon Martyr)'},
--I 	24.63 	howling_blast,if=buff.rime.react&(dot.remorseless_winter.ticking|cooldown.remorseless_winter.remains>1.5|(!equipped.132459&!talent.gathering_storm.enabled))
	{ 'Howling Blast' , 'buff(Rime)&(target.debuff(Remorseless Winter)||spell(Remorselss Winter).cooldown >1.5)||!equipped(Perseverance of the Ebon Martyr)&!talent(6,3)'},
--	{ 'Howling Blast' , 'player.buff(Rime)&target.debuff(Remorseless Winter)||player.spell(Remorselss Winter).cooldown > 1.5)'},
--J 	10.33 	obliterate,if=!buff.rime.react&!(talent.gathering_storm.enabled&!(cooldown.remorseless_winter.remains>2|rune>4))&rune>3
	{ 'Obliterate', '!buff(Rime)&!(talent(6,3)&!(spell(Remorseless Winter).cooldown >2||runes>4))&runes>3'},
--K 	26.17 	frost_strike,if=runic_power>=70|((talent.gathering_storm.enabled&cooldown.remorseless_winter.remains<3&cooldown.breath_of_sindragosa.remains>10)&rune<5)|(buff.gathering_storm.stack=10&cooldown.breath_of_sindragosa.remains>15)
	{ 'Frost Strike', 'runicpower >=70|((talent(6,3)&spell(Remorselss Winter).cooldown <3&spell(Breath of Sindragosa).cooldown >10)&runes <5)|buff(Gathering Storm).stacks =10&player.spell(Breath of Sindragosa).cooldown >15'},
--L 	29.64 	obliterate,if=!buff.rime.react&(!talent.gathering_storm.enabled|(cooldown.remorseless_winter.remains>2|rune>4))
	{ 'Obliterate', '!buff(Rime)&(!talent(6,3)||(spell(Remorseless Winter).cooldown >2||runes>2||rune>4))'},
--M 	2.82 	horn_of_winter,if=cooldown.breath_of_sindragosa.remains>15&runic_power<=70&rune<4
	{ 'Horn of Winter', 'spell(Breath of Sindragosa).cooldown >15&runicpower <=70&runes <4'},
--N 	6.21 	frost_strike,if=cooldown.breath_of_sindragosa.remains>15
	{ 'Frost Strike', 'spell(Breath of Sindragosa).cooldown >15'},
--	0.00 	remorseless_winter,if=cooldown.breath_of_sindragosa.remains>10
	{ 'Remorseless Winter', 'spell(Breath of Sindragosa).cooldown >10'},

}

local bos_ticking = {
--O 	0.00 	howling_blast,target_if=!dot.frost_fever.ticking
	{ 'Howling Blast' , '!target.debuff(Frost Fever)' },
--P 	6.25 	remorseless_winter,if=runic_power>=30&((buff.rime.react&equipped.132459)|(talent.gathering_storm.enabled&(dot.remorseless_winter.remains<=gcd|!dot.remorseless_winter.ticking)))
	{ 'Remorseless Winter', 'runicpower >=30&((buff(Rime)&equipped(Perseverance of the Ebon Martyr)||(talent(6,3)&target.debuff(Remorseless Winter).duration <=1.5||!target.debuff(Remorseless Winter)))'},
--	{ 'Remorseless Winter', 'player.runicpower >=30&talent(6,3)&target.debuff(Remorseless Winter).duration <=1.5||!target.debuff(Remorseless Winter)'},
--Q 	40.80 	howling_blast,if=((runic_power>=20&set_bonus.tier19_4pc)|runic_power>=30)&buff.rime.react
	{ 'Howling Blast' , '((runicpower >=20&)||runicpower >=30)&buff(Rime)'},
--R 	65.05 	obliterate,if=runic_power<=75|rune>3
	{ 'Obliterate', {'runicpower <=75||runes > 3'}},
--S 	0.54 	remorseless_winter,if=(buff.rime.react&equipped.132459)|(talent.gathering_storm.enabled&(dot.remorseless_winter.remains<=gcd|!dot.remorseless_winter.ticking))
	{ 'Remorseless Winter', 'buff(Rime)&equipped(Perseverance of the Ebon Martyr)||talent(6,3)&(target.debuff(Remorseless Winter).duration <=1.5||!target.debuff(Remorseless Winter))'},
--	{ 'Remorseless Winter', 'talent(6,3)&target.debuff(Remorseless Winter).duration <=1.5||!target.debuff(Remorseless Winter)'},
--T 	0.92 	howling_blast,if=buff.rime.react
	{ 'Howling Blast' , 'buff(Rime)'},
--U 	5.06 	horn_of_winter,if=runic_power<70&!buff.hungering_rune_weapon.up&rune<5
	{ 'Horn of Winter' , 'runicpower < 70&!buff(Hungering Rune Weapon)&runes <5'},
--V 	2.60 	hungering_rune_weapon,if=equipped.140806&(runic_power<30|(runic_power<70&talent.gathering_storm.enabled)|(talent.horn_of_winter.enabled&talent.gathering_storm.enabled&runic_power<55))&!buff.hungering_rune_weapon.up&rune<2
--	{ 'Hungering Rune Weapon', 'equipped(Convergence of Fates)&(player.runicpower <30||player.runicpower <70&talent(6,3))||talent(2,3)&talent(6,3)&player.runicpower<55&!player.buff(Huntering Rune Weapon)&player.runes <2'},
	{'Hungering Rune Weapon', '{equipped(Convergence of Fates)&{runicpower <30||runicpower <70&talent(6,3)}}||{talent(2,3)&talent(6,3)&runicpower<55&!buff(Huntering Rune Weapon)&runes <2}'},
--	{ 'Hungering Rune Weapon', 'talent(2,3)&talent(6,3)&player.runicpower <55&player.runes <2'},	
--	0.00 	hungering_rune_weapon,if=talent.runic_attenuation.enabled&runic_power<30&!buff.hungering_rune_weapon.up&rune<2
--	0.00 	hungering_rune_weapon,if=runic_power<35&!buff.hungering_rune_weapon.up&rune<1
--	0.00 	hungering_rune_weapon,if=runic_power<25&!buff.hungering_rune_weapon.up&rune<2
--	0.00 	empower_rune_weapon,if=runic_power<20
	{ 'Empower Rune Weapon', 'runicpower < 20'},
--	0.00 	remorseless_winter,if=talent.gathering_storm.enabled|!set_bonus.tier19_4pc|runic_power<30

}

local inCombat = {
	{'%pause', 'player.channeling'},
	{Survival},
	{Interrupts, 'target.interruptAt(64)'},
	{Cooldowns},
--sindragosas_fury,if=!equipped.144293&buff.pillar_of_frost.up&(buff.unholy_strength.up|(buff.pillar_of_frost.remains<3&target.time_to_die<60))&debuff.razorice.stack=5&!buff.obliteration.up
	{'Sindragosa\'s Fury', {'buff(Pillar of Frost).duration < 3', 'target.debuff(Razorice).stacks = 5' }},
--call_action_list,name=bos,if=talent.breath_of_sindragosa.enabled&!dot.breath_of_sindragosa.ticking
	{ bos, 'target.range < 7&target.infront&talent(7,2)&!buff(Breath of Sindragosa)' },
--call_action_list,name=bos_ticking,if=talent.breath_of_sindragosa.enabled&dot.breath_of_sindragosa.ticking
	{ bos_ticking, 'buff(Breath of Sindragosa)' },

}

local outCombat = {
	{Shared}
}

NeP.CR:Add(251, {
	name = 'WinnerRubim Deathknight - Frost',
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad
}) 