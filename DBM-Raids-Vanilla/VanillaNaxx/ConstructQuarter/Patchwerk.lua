local mod	= DBM:NewMod("PatchwerkVanilla", "DBM-Raids-Vanilla", 1)
local L		= mod:GetLocalizedStrings()

if DBM:IsSeasonal("SeasonOfDiscovery") then
	mod.statTypes = "normal,heroic,mythic"
else
	mod.statTypes = "normal"
end

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 28131",
)

mod:SetRevision("@file-date-integer@")
mod:DisableHardcodedOptions()
mod:SetCreatureID(16028)
mod:SetEncounterID(1118)
mod:SetModelID(16174)
mod:SetZone(533)

mod:RegisterCombat("combat_yell", L.Pull1, L.Pull2)

local enrageTimer	= mod:NewBerserkTimer(420)
local warnEnrage 	= mod:NewSpellAnnounce(28131, 4)

function mod:OnCombatStart()
	enrageTimer:Start()
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpell(28131) then
		warnEnrage:Show()
	end
end