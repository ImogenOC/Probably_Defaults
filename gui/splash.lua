--[[ ///---INFO---////
// Alerts GUI //
Thank Your For Your My ProFiles
I Hope Your Enjoy Them
MTS
]]

local currentSpec = GetSpecialization()
local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "None"

local function onUpdate(mtsStart,elapsed) 
	if mtsStart.time < GetTime() - 2.0 and mtsSplash.time < GetTime() - 2.0 then
		if mtsStart:GetAlpha() == 0 and  mtsSplash:GetAlpha() then
			mtsStart:Hide()
			mtsSplash:Hide()
		else 
			mtsStart:SetAlpha(mtsStart:GetAlpha() - .05)
			mtsSplash:SetAlpha(mtsStart:GetAlpha() - .05)
		end
	end
end

mtsSplash = CreateFrame("Frame", nil,UIParent)
mtsSplash:SetPoint("CENTER",UIParent)
mtsSplash:SetWidth(512)
mtsSplash:SetHeight(256)
mtsSplash:SetBackdrop({ bgFile = "Interface\\AddOns\\Probably_MrTheSoulz\\media\\splash.tga" })
mtsSplash:SetScript("OnUpdate",onUpdate)
mtsSplash:Hide()
mtsSplash.time = 0
	
mtsStart = CreateFrame("Frame",nil,UIParent)
mtsStart:SetWidth(400)
mtsStart:SetHeight(30)
mtsStart:Hide()
mtsStart:SetScript("OnUpdate",onUpdate)
mtsStart:SetPoint("TOP",0,0)
mtsStart.text = mtsStart:CreateFontString(nil,"OVERLAY","MovieSubtitleFont")
mtsStart.text:SetAllPoints()
mtsStart.time = 0

function mtsStart:message(message) 
	if mts_getSetting('getSplash') then
		mtsStart.text:SetText(message)
		mtsStart:SetAlpha(1)
		mtsSplash:SetAlpha(1)
		mtsStart.time = GetTime()
		mtsSplash.time = GetTime()
		mtsStart:Show()
		mtsSplash:Show()
		PlaySoundFile("Sound\\Interface\\Levelup.Wav")
	end
end