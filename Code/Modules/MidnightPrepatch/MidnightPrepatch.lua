local env = select(2, ...)
local MidnightPrepatch = env.WPM:New("@\\MidnightPrepatch")

local IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted


-- Checks
----------------------------------------------------------------------------------------------------

local INTRO_QUEST_COMPLETION_ID = 90768

function MidnightPrepatch.IsIntroQuestlineComplete()
    return IsQuestFlaggedCompleted(INTRO_QUEST_COMPLETION_ID)
end
