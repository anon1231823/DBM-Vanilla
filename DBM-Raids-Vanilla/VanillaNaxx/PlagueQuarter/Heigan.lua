local mod	= DBM:NewMod("HeiganVanilla", "DBM-Raids-Vanilla", 1)
local L		= mod:GetLocalizedStrings()

if DBM:IsSeasonal("SeasonOfDiscovery") then
	mod.statTypes = "normal,heroic,mythic"
else
	mod.statTypes = "normal"
end

mod:SetRevision("@file-date-integer@")
mod:DisableHardcodedOptions()
mod:SetCreatureID(15936)
mod:SetEncounterID(1112)
mod:SetModelID(16309)
mod:SetZone(533)

mod:RegisterCombat("combat_yell", L.Pull1, L.Pull2, L.Pull3)

mod:RegisterEventsInCombat(
	"UNIT_SPELLCAST_SUCCEEDED",
	"UNIT_SPELLCAST_CHANNEL_STOP"
)

local warnTeleport		= mod:NewSpellAnnounce(30211, 3, "135736")
local warnTeleportSoon	= mod:NewSoonAnnounce(30211, 2, "135736")

local timerTeleport		= mod:NewNextTimer(90.7, 30211, nil, nil, nil, 6, "135736")
local timerDance		= mod:NewBuffActiveTimer(45, 29350, nil, nil, nil, 6)

function mod:OnCombatStart()
	timerTeleport:Start()
	warnTeleportSoon:Schedule(80)
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, spellId)
	if spellId == 30211 then
		self:SendSync("Teleport")
	elseif spellId == 29350 then
		self:SendSync("DancePhase")
	end
end

function mod:UNIT_SPELLCAST_CHANNEL_STOP(_, _, spellId)
	if spellId == 29350 then
		self:SendSync("DancePhaseFinish")
	end
end

function mod:OnSync(event)
	if not self:IsInCombat() then return end
    if event == "Teleport" then
		warnTeleport:Show()
		warnTeleportSoon:Cancel()
		timerTeleport:Stop()
	elseif event == "DancePhase" then
		timerDance:Start()
	elseif event == "DancePhaseFinish" then
		warnTeleportSoon:Schedule(80)
		timerTeleport:Start()
		timerDance:Stop()
	end
end
