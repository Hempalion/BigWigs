local L = BigWigs:NewBossLocale("Al'Akir", "koKR")
if L then
	
end

L = BigWigs:NewBossLocale("Conclave of Wind", "koKR")
if L then
	L.gather_strength = "힘 모으기: %s"
	
	L.full_power = "Full Power"	--check
	L.full_power_desc = "full power에 도달시 특별한 능력에 대해 알립니다."	--check
	L.gather_strength_emote = "%s begins to gather strength from the remaining Wind Lords!"	--check
	
	L.wind_chill = "당신은 바람 한기 x%s 중첩"
end
