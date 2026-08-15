local GetTime = GetTime


local trinketSpells = {
	["PvP Trinket"] = 120,
	["Every Man for Himself"] = 120,  -- Will to survive (Humano)
}


local sharedSpells = {
	["Will of the Forsaken"] = 45
}

local trinketData = {
	["Alliance"] = { texture = "Interface\\Icons\\Inv_jewelry_necklace_37"},
	["Horde"] = { texture = "Interface\\Icons\\Inv_jewelry_necklace_38"},
    ["Human"] = { texture = "Interface\\Icons\\Spell_shadow_charm"},
}

local spellStartTimes = {}

local function GetRemainingCD(spellName)
	if not spellStartTimes then
		spellStartTimes = {}
	end

	local currTime = GetTime()
	local duration = trinketSpells[spellName]

	if not duration then
		return 0
	end

	local startTime = spellStartTimes[spellName] or 0
	local remainingCD = math.max(0, (startTime + duration) - currTime)

	return remainingCD
end

function sArenaFrameMixin:FindTrinket(event, spellParam, duration)
    if event ~= "SPELL_CAST_SUCCESS" then return end

	
	local spellName = spellParam
	if type(spellParam) == "number" then
		spellName = GetSpellInfo(spellParam)
	end

	if not spellName then return end

	local currentCD = GetRemainingCD(spellName)
	if sharedSpells[spellName] and currentCD < sharedSpells[spellName] then
		duration = sharedSpells[spellName]
	end

    duration = duration or trinketSpells[spellName]

    if duration then
        local currTime = GetTime()
		spellStartTimes[spellName] = currTime  -- FIX Ascension
		self.Trinket.spellName = spellName
		self.Trinket.Cooldown:SetCooldown(currTime, duration)
	end
end

function sArenaFrameMixin:UpdateTrinket()
	-- Always show the plain faction insignia (Horde/Alliance), regardless of race,
	-- for a consistent look instead of switching to a special icon for Humans.
	local faction = UnitFactionGroup(self.unit)
	if faction and trinketData[faction] then
		self.Trinket.Texture:SetTexture(trinketData[faction].texture)
	end
end

function sArenaFrameMixin:ResetTrinket()
	self.Trinket.spellName = nil
    self.Trinket.Texture:SetTexture(nil)
    self.Trinket.Cooldown:Clear()
    self:UpdateTrinket()
end