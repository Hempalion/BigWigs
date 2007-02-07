﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Gruul the Dragonkiller"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local grasp
local slam

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Gruul",

	engage_cmd = "engage",
	engage_name = "Engage Alert",
	engage_desc = "Warn when Grull is pulled",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Warning",
	enrage_desc = "Warn when Grull becomes enraged",

	grasp_cmd = "grasp",
	grasp_name = "Grasp Warning",
	grasp_desc = "Warn when Gruul casts Gronn Lord's Grasp",

	cavein_cmd = "cavein",
	cavein_name = "Cave In on You",
	cavein_desc = "Warn for a Cave In on You",

	engage_trigger = "Come.... and die.",
	engage_message = "Gruul Engaged!",

	enrage_trigger = "%s grows in size!",
	enrage_message = "Enrage!",

	grasp_trigger1 = "afflicted by Ground Slam",
	grasp_trigger2 = "afflicted by Gronn Lord's Grasp",
	grasp_message1 = "Grasp Incoming!",
	grasp_message2 = "Grasp!",
	grasp_warning = "Grasp Soon!",

	cavein_trigger = "You are afflicted by Cave In.",
	cavein_message = "Cave In on YOU!",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGruul = BigWigs:NewModule(boss)
BigWigsGruul.zonename = AceLibrary("Babble-Zone-2.2")["Gruul's Lair"]
BigWigsGruul.otherMenu = "Outland"
BigWigsGruul.enabletrigger = boss
BigWigsGruul.toggleoptions = {"engage", -1, "cavein", -1, "grasp", "enrage", "bosskill"}
BigWigsGruul.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGruul:OnEnable()
	slam = nil
	grasp = nil

	self:RegisterEvent("BigWigs_Message")

	self:RegisterEvent("CHAT_MSG_MONSTER_SAY")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsGruul:CHAT_MSG_MONSTER_SAY(msg)
	if self.db.profile.engage and msg == L["engage_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["engage_message"], "Attention")
	end
end

function BigWigsGruul:CHAT_MSG_MONSTER_EMOTE(msg)
	if self.db.profile.enrage and msg == L["enrage_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["enrage_message"], "Important")
	end
end

function BigWigsGruul:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(msg)
	if not slam and self.db.profile.grasp and msg:find(L["grasp_trigger1"]) then
		self:TriggerEvent("BigWigs_Message", L["grasp_message1"], "Attention")
		self:ScheduleEvent("BigWigs_Message", 83, L["grasp_warning"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["grasp_warning"], 85, "Interface\\Icons\\Ability_ThunderClap")
		slam = true
	elseif not grasp and self.db.profile.grasp and msg:find(L["grasp_trigger2"]) then
		self:TriggerEvent("BigWigs_Message", L["grasp_message2"], "Urgent")
		grasp = true
	elseif self.db.profile.cavein and msg == L["cavein_trigger"] then
		self:TriggerEvent("BigWigs_Message", L["cavein_message"], "Personal", true, "Alarm")
	end
end

function BigWigsGruul:BigWigs_Message(text)
	if text == L["grasp_warning"] then
		slam = nil
		grasp = nil
	end
end
