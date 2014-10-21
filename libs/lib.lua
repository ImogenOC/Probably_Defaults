--[[ ///---INFO---////
//General Lib//
Thank You For Using My ProFiles
I Hope Your Enjoy Them
MTS
]]

local mtsLib = {}
local _media = "Interface\\AddOns\\Probably_MrTheSoulz\\media\\"
local mts_Dummies = {31146,67127,46647,32546,31144,32667,32542,32666,32545,32541}
local _cc = {49203,6770,1776,51514,9484,118,28272,28271,61305,61025,61721,61780,3355,19386,20066,90337,2637,82676,115078,76780,9484,1513,115268}
local ignoreDebuffs = {'Mark of Arrogance','Displaced Energy'}

--[[   !!!Dispell function!!!   ]]
function mtsLib.Dispell(text)
local prefix = (IsInRaid() and 'raid') or 'party'
	for i = -1, GetNumGroupMembers() - 1 do
	local unit = (i == -1 and 'target') or (i == 0 and 'player') or prefix .. i
		if IsSpellInRange(text, unit) then
			for j = 1, 40 do
			local debuffName, _, _, _, dispelType, duration, expires, _, _, _, spellID, _, isBossDebuff, _, _, _ = UnitDebuff(unit, j)
				if dispelType and dispelType == 'Magic' or dispelType == 'Poison' or dispelType == 'Disease' then
				local ignore = false
				for k = 1, #ignoreDebuffs do
					if debuffName == ignoreDebuffs[k] then
						ignore = true
						break
					end
				end
					if not ignore then
						ProbablyEngine.dsl.parsedTarget = unit
						return true
					end
				end
				if not debuffName then
					break
				end
			end
		end
	end
		return false
end

--[[   !!!Check if should taunt!!!   ]]
function mtsLib.ShouldTaunt()
	if UnitIsTappedByPlayer("target") 
	and mtsLib.config:get(key) == true
	and mtsLib.dummy() then
		return true
	else
		return false
	end
end

function mtsLib.getSetting(txt1, txt2)
	if mtsLib.getConfig(txt1) == txt2 then
		return true
	else
		return false
	end
end

function mtsLib.getConfig(key)
	return mtsLib.config:get(key)
end

function mtsLib.ConfigUnitMana(key, unit)
	if ProbablyEngine.condition["mana"](unit) <= mtsLib.config:get(key) then
		return true
	else
		return false
	end
end

function mtsLib.ConfigUnitHp(key, unit)
	if ProbablyEngine.condition["health"](unit) <= mtsLib.config:get(key) then
		return true
	else
		return false
	end
end

function mtsLib.modifierActionForSpellIsAlt(name)
	return IsAltKeyDown() and not GetCurrentKeyBoardFocus() and mtsLib.getConfig("altKeyAction") == name
end

function mtsLib.modifierActionForSpellIsShift(name)
	return IsShiftKeyDown() and not GetCurrentKeyBoardFocus() and mtsLib.getConfig("shiftKeyAction") == name
end

function mtsLib.modifierActionForSpellIsControl(name)
	return IsControlKeyDown() and not GetCurrentKeyBoardFocus() and mtsLib.getConfig("controlKeyAction") == name
end

--[[   !!!Check if can whisper!!!   ]]
function mtsLib.ConfigWhisper(txt)
	if mtsLib.getConfig('getWhispers') then
		return RunMacroText("/w "..txt)
	end
	return false
end

--[[   !!!Check if can use sounds!!!   ]]
function mtsLib.ConfigAlertSound()
	if mtsLib.getConfig('getSounds') then
		PlaySoundFile(_media .. "beep.mp3", "master")
	end
end

--[[   !!!Check if can use Alerts!!!   ]]
function mtsLib.ConfigAlert(txt)
	if mtsLib.getConfig('getAlerts') then
		return mtsAlert:message(txt)
	end
end

--[[   !!!Check should stop when a boss...!!!   ]]
function mtsLib.StopIfBoss()
if UnitExists("boss1") then
local npcId = tonumber(UnitGUID("target"):sub(6,10), 16)
	if npcId == 71543 -- Immersus
	or npcId == 72276 -- Norushen
	or npcId == 71734 -- Sha of Pride
	or npcId == 72249 -- Galakras
	or npcId == 71466 -- Iron Juggernaut
	or npcId == 71859 -- Kor'kron Dark Shaman
	or npcId == 71515 -- General Nazgrim
	or npcId == 71454 -- Malkorok
	or npcId == 71529 -- Thok the Bloodsthirsty
	or npcId == 71504 -- Siegecrafter Blackfuse
	or npcId == 71865 -- Garrosh Hellscream
	then return false end
end
	return true 
end

--[[   !!!Check should stop when a boss...!!!   ]]
function mtsLib.shouldStop(unit)
	if not UnitAffectingCombat(unit) then return false end
	if mtsLib.hasDebuffTable(unit, _cc) then return false end
	if UnitAura(unit,GetSpellInfo(116994))
		or UnitAura(unit,GetSpellInfo(122540))
		or UnitAura(unit,GetSpellInfo(123250))
		or UnitAura(unit,GetSpellInfo(106062))
		or UnitAura(unit,GetSpellInfo(110945))
		or UnitAura(unit,GetSpellInfo(143593)) -- General Nazgrim: Defensive Stance
		or UnitAura(unit,GetSpellInfo(143574)) -- Heroic Immerseus: Swelling Corruption
		then return false 
	end
		return true
end

--[[   !!!Check can use item!!!   ]]
function mtsLib.checkItem(key)
	if GetItemCount(key) > 1
	and GetItemCooldown(key) == 0 then 
		return true
	end
	return false
end

--[[   !!!Check if it is a dummy!!!   ]]
function mtsLib.dummy()	
	for i=1, #mts_Dummies do
		if UnitExists("target") then
			mts_Dummies_ID = tonumber(UnitGUID("target"):sub(-13, -9), 16)
		else
			mts_Dummies_ID = 0
		end
		if mts_Dummies_ID == mts_Dummies[i] then
			return false
		else
			return true
		end	
	end
end


ProbablyEngine.library.register('mtsLib', mtsLib)

--[[   !!!Create Menu Entrys!!!   ]]
mtsLib.config = {}
function mtsLib.initConfig()
	--[[[mConfig copyright & thanks to https://github.com/kirk24788/mConfig , if u use this , please keep his copyright ;) ]]--
	mtsLib.config = mConfig:createConfig("\124cff9482C9MrTheSoulz Profiles Settings","mtsConfig_1.0.0","Default",{"/mts"})
	
	-- Settings
		mtsLib.config:addTitle("---> General Settings: <---")
		mtsLib.config:addText("Everything in here is shared cross all of the profiles.")
		mtsLib.config:addCheckBox("getAlerts", "Show Notifications", "Shows notification on top when used certain spells", true)
		mtsLib.config:addCheckBox("getSounds", "Notifications Sounds", "Plays a sound when a notification is shown.", true)
		mtsLib.config:addCheckBox("getWhispers", "Allow Whispers", "Whispers people after using certain spells", false)

	-- Paladin Protection
		mtsLib.config:addTitle("\124cffF58CBA---> Paladin Protection: <---")
		mtsLib.config:addText("Everything in here only affects the Paladin Protection profile.")
		mtsLib.config:addCheckBox("PalaProtItems", "Use items", "Allows usage of items", true)
		mtsLib.config:addCheckBox("PalaProtTaunts", "Auto Taunting", "Allows Auto Taunts", true)
		mtsLib.config:addCheckBox("PalaProtConsecration", "Consecration", "Use Consecration", true)
		mtsLib.config:addCheckBox("PalaProtChangeSeals", "Change Seals", "Allow the rotation to change Seals suto", true)
		mtsLib.config:addCheckBox("PalaProtDefCd", "Defensive Cooldowns", "Use Defensive Cooldowns", true)
		mtsLib.config:addCheckBox("PalaProtBuffs", "Buffing", "Use Buffs Kings/Might/Fury", true)
		mtsLib.config:addDropDown("toUsePalaProtBuff", "Buff To Use:", "Choose buff to use Might or Kings", {MIGHT="Might", KINGS="Kings"}, "KINGS")
		mtsLib.config:addSlider("PalaProtHs", "HealthStone @ HP %", "HP percentage you need to drop to use HealthStone", 10,100,60,1)

	--Paladin Holy
		mtsLib.config:addTitle("\124cffF58CBA---> Paladin Holy: <---")
		mtsLib.config:addText("Everything in here only affects the Paladin Holy profile.")
		mtsLib.config:addCheckBox("PalaHolyItems", "Use items", "Allows usage of items", true)
		mtsLib.config:addCheckBox("PalaHolyBuffs", "Buffing", "Use Buffs", true)
		mtsLib.config:addCheckBox("PalaHolyDispells", "Auto Dispelling", "Allows Auto Dispelling", true)
		mtsLib.config:addDropDown("toUsePalaHolyBuff", "Buff To Use:", "Choose buff to use Might or Kings", {MIGHT="Might", KINGS="Kings"}, "KINGS")
		mtsLib.config:addDropDown("toUsePalaHolyHr", "Holy Radiance:", "Choose how to use Holy Radiance", {AUTO="Auto", MANUAL="Manual"}, "AUTO")
		mtsLib.config:addSlider("PalaHolyHs", "HealthStone @ HP %", "HP percentage you need to drop to use HealthStone", 10,100,60,1)
		mtsLib.config:addSlider("PalaHolyEf", "Eternal Flame @ HP %", "HP percentage you need to drop to use Eternal Flame", 10,100,93,1)
		mtsLib.config:addSlider("PalaHolyLoh", "Lay on Hands @ HP %", "HP percentage you need to drop to use Lay on Hands", 10,100,15,1)
		mtsLib.config:addCheckBox("usePalaHolyTk1", "Use Trinket 1", "Allows usage of Trinket 1", true)
		mtsLib.config:addCheckBox("usePalaHolyTk2", "Use Trinket 2", "Allows usage of Trinket 2", true)
		mtsLib.config:addSlider("PalaHolyTk1", "Trinket 1 @ MANA %", "MANA percentage you need to drop to use Trinket 1", 10,100,85,1)
		mtsLib.config:addSlider("PalaHolyTk2", "Trinket 2 @ MANA %", "MANA percentage you need to drop to use Trinket 2", 10,100,85,1)
		mtsLib.config:addSlider("PalaHolyAct", "Arcane Torrent *Racial* @ MANA %", "MANA percentage you need to drop to use Arcane Torrent *Racial*", 10,100,90,1)
		mtsLib.config:addSlider("PalaHolyDvp", "Divine Plea @ MANA %", "MANA percentage you need to drop to use Divine Plea", 10,100,85,1)

	-- Warrior Fury
		mtsLib.config:addTitle("\124cffC79C6E---> Warrior Fury: <---")
		mtsLib.config:addText("Everything in here only affects the Warrior Fury profile.")
		mtsLib.config:addCheckBox("WarFuryItems", "Use items", "Allows usage of items", true)
		mtsLib.config:addCheckBox("WarFuryChangeStances", "Change Stances", "Allow the rotation to change Stances suto", true)
		mtsLib.config:addCheckBox("WarFuryDefCd", "Defensive Cooldowns", "Use Defensive Cooldowns", true)
		mtsLib.config:addCheckBox("WarFuryBuffs", "Buffing", "Use Buffs", true)
		mtsLib.config:addSlider("WarFuryHs", "HealthStone @ HP %", "HP percentage you need to drop to use HealthStone", 10,100,60,1)

	-- Druid Guardian
		mtsLib.config:addTitle("\124cffFF7D0A---> Druid Guardian: <---")
		mtsLib.config:addText("Everything in here only affects the Druid Guardian profile.")
		mtsLib.config:addCheckBox("DoodGuardTaunts", "Auto Taunting", "Allows Auto Taunts", true)
		mtsLib.config:addCheckBox("DoodGuardDefCd", "Defensive Cooldowns", "Use Defensive Cooldowns", true)
		mtsLib.config:addCheckBox("DoodGuardBuffs", "Buffing", "Use Buffs", true)
		mtsLib.config:addCheckBox("DoodGuardItems", "Use items", "Allows usage of items", true)
		mtsLib.config:addSlider("DoodGuardHs", "HealthStone @ HP %", "HP percentage you need to drop to use HealthStone", 10,100,60,1)

	-- Druid Restoration
		mtsLib.config:addTitle("\124cffFF7D0A---> Druid Restoration: <---")
		mtsLib.config:addText("Everything in here only affects the Druid Restoration profile.")
		mtsLib.config:addCheckBox("DoodRestoDispells", "Auto Dispelling", "Allows Auto Dispelling", true)
		mtsLib.config:addCheckBox("DoodRestoBuffs", "Buffing", "Use Buffs", true)
		mtsLib.config:addCheckBox("DoodRestoItems", "Use items", "Allows usage of items", true)
		mtsLib.config:addCheckBox("DoodRestoMr", "Use Wild Mushroom", "Allows usage of Wild Mushroom", true)
		mtsLib.config:addSlider("toUseDoodRestoMr", "Wild Mushroom @ HP %", "HP percentage you need to drop to use Wild Mushroom", 60,100,95,1)
		mtsLib.config:addSlider("DoodRestoHs", "HealthStone @ HP %", "HP percentage you need to drop to use HealthStone", 10,100,60,1)

	-- DeathKinght Blood
		mtsLib.config:addTitle("\124cffC41F3B---> DeathKinght Blood: <---")
		mtsLib.config:addCheckBox("DkBloodTaunts", "Auto Taunting", "Allows Auto Taunts", true)
		mtsLib.config:addSlider("DkBloodHs", "HealthStone @ HP %", "HP percentage you need to drop to use HealthStone", 10,100,60,1)
		mtsLib.config:addCheckBox("DkBloodOutOfCombatHorn", "Horn of Winter out of combat", "Use Horn of Winter out of combat", true)
		mtsLib.config:addSlider("runeTapPercentage","Rune Tap HP %","HP % you need to drop to use Rune Tap", 10,100,80,1)
		mtsLib.config:addSlider("DkBloodDeathStrikePercentage","Death Strike HP %","HP % you need to drop to use Death Strike on CD", 10,100,70,1)
		mtsLib.config:addSlider("DkBloodLichbornePercentage","Lichborne HP %","HP % you need to drop to use Lichborne", 10,100,50,1)
		mtsLib.config:addSlider("BloodDpPercentage","Death Pact HP %","HP % you need to drop to use Death Pact", 10,100,50,1)
		mtsLib.config:addSlider("vbPercentage","Vampiric Blood HP %","HP % you need to drop to use Vampiric Blood", 10,100,40,1)
		mtsLib.config:addSlider("DkBloodIbfPercentage","Icebound Fortitude HP %","HP % you need to drop to use Icebound Fortitude", 10,100,40,1)
		

end

mtsLib.initConfig()

--[[   !!!Combat Alert Tracker!!!   ]]
ProbablyEngine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)
local event = select(2, ...)
local source = select(4, ...)
local spellId = select(12, ...)
local tname = UnitName("target")
if source ~= UnitGUID("player") then return false end

	if event == "SPELL_CAST_SUCCESS" then	

    -- Paladin

		if spellId == 114158 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Light´s Hammer*")
		end
		if spellId == 633 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigWhisper(tname.." MSG: Casted Lay On Hands on you.")
			mtsLib.ConfigAlert("*Casted Lay on Hands*")
		end
		if spellId == 1044 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigWhisper(tname.." MSG: Casted Hand of Freedom on you.")
			mtsLib.ConfigAlert("*Casted Hand of Freedom*")
		end
		if spellId == 6940 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Hand of Sacrifice*")
			mtsLib.ConfigWhisper("/w "..tname.." MSG: Casted Hand of Sacrifice on you.")
		end
		if spellId == 105593 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Stunned Target*")
		end
		if spellId == 853 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Stunned Target*")
		end
		if spellId == 31821 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Devotion Aura*")
		end
		if spellId == 31884 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Avenging Wrath*")
		end
		if spellId == 105809 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Guardian of Ancient Kings*")
		end
		if spellId == 31850 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Ardent Defender*")
		end
		if spellId == 86659 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Holy Avenger*")
		end
		if spellId == 86669 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Guardian of Ancient Kings*")
		end
		if spellId == 31842 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Divine Favor*")
		end

    -- DeathKnight

		if spellId == 43265 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Death and Decay*")
		end
		if spellId == 48707 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Anti-Magic Shell*")
		end
		if spellId == 49028 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Dancing Rune Weapon*")
		end
		if spellId == 55233 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Vampiric Blood*")
		end
		if spellId == 48792 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casted Icebound Fortitude*")
		end
		if spellId == 42650 then
			mtsLib.ConfigAlertSound()
			mtsLib.ConfigAlert("*Casting Army of the Dead*")
		end

	end
end)