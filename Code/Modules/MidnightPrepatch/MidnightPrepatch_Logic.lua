local env                    = select(2, ...)
local L                      = env.L
local Config                 = env.Config
local Path                   = env.WPM:Import("wpm_modules\\path")
local Sound                  = env.WPM:Import("wpm_modules\\sound")
local CallbackRegistry       = env.WPM:Import("wpm_modules\\callback-registry")
local GenericEnum            = env.WPM:Import("wpm_modules\\generic-enum")
local SavedVariables         = env.WPM:Import("wpm_modules\\saved-variables")
local Utils_Blizzard         = env.WPM:Import("wpm_modules\\utils\\blizzard")
local Utils_Formatting       = env.WPM:Import("wpm_modules\\utils\\formatting")
local MidnightPrepatch       = env.WPM:Import("@\\MidnightPrepatch")
local MidnightPrepatch_Logic = env.WPM:New("@\\MidnightPrepatch\\Logic")
local function IsModuleEnabled() return Config.DBGlobal:GetVariable("MidnightPrepatch") == true end

local MidnightPrepatchFrame      = ManifoldMidnightPrepatchFrame
local GetBestMapForUnit          = C_Map.GetBestMapForUnit
local GetCurrencyInfo            = C_CurrencyInfo.GetCurrencyInfo
local IsQuestFlaggedCompleted    = C_QuestLog.IsQuestFlaggedCompleted
local IsOnQuest                  = C_QuestLog.IsOnQuest
local GetTitleForQuestID         = C_QuestLog.GetTitleForQuestID
local GetVignettes               = C_VignetteInfo.GetVignettes
local GetVignettePosition        = C_VignetteInfo.GetVignettePosition
local GetHealthPercent           = C_VignetteInfo.GetHealthPercent
local GetSecondsUntilWeeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset
local GetServerTime              = GetServerTime
local SecondsToTime              = SecondsToTime
local SetSuperTrackedVignette    = C_SuperTrack.SetSuperTrackedVignette
local OpenWorldMap               = C_Map.OpenWorldMap
local ipairs                     = ipairs
local tostring                   = tostring
local tonumber                   = tonumber


-- Shared
----------------------------------------------------------------------------------------------------

do -- Util to acquire localized NPC name
    local npcNameCache = {}

    local function GetNPCIDFromGUID(guid)
        if not guid then return end
        local _, _, _, _, _, unitID, _ = Utils_Blizzard.ParseUnitGUID(guid)
        return unitID and tonumber(unitID) or nil
    end

    local function ResolveLocalizedName(npcID)
        if not npcID then return end
        npcID = type(npcID) == "number" and tostring(npcID) or npcID

        local cached = npcNameCache[npcID]
        if cached then return cached end

        local tip = C_TooltipInfo.GetHyperlink(("unit:Creature-0-0-0-0-%d-0"):format(npcID))
        local name = tip and tip.lines and tip.lines[1] and tip.lines[1].leftText
        if name and name ~= "" then
            npcNameCache[npcID] = name
            return name
        end
    end

    function MidnightPrepatch_Logic.GetLocalizedNPCNameByNPCID(npcID)
        return ResolveLocalizedName(npcID)
    end

    function MidnightPrepatch_Logic.GetLocalizedNPCNameFromGUID(guid)
        return ResolveLocalizedName(GetNPCIDFromGUID(guid))
    end
end

local EVENT_MAP_ID                 = 241
local EVENT_POI_ID                 = 8244 -- AreaPOIID
local EVENT_CURRENCY_ID            = 3319
local EVENT_QUEST_CURRENCY_REWARDS = {
    [87308] = 40, -- Twilight's Dawn
    [91795] = 40 -- Disrupt the Call
}
local WEEKLY_QUEST_IDS             = { 87308, 91795 }
local WEEKLY_QUEST_GIVER_POSITION  = { x = 0.499, y = 0.807 }

local RARE_MAP                     = { -- Corresponds to rare spawn order
    [1]  = { -- Redeye the Skullchewer
        npcID      = 246572,
        vignetteID = 7007
    },
    [2]  = { -- T'aavihan the Unbound
        npcID      = 246844,
        vignetteID = 7043
    },
    [3]  = { -- Ray of Putrescence
        npcID      = 246460,
        vignetteID = 6995
    },
    [4]  = { -- Ix the Bloodfallen
        npcID      = 246471,
        vignetteID = 6997
    },
    [5]  = { -- Commander Ix'vaarha
        npcID      = 246478,
        vignetteID = 6998
    },
    [6]  = { -- Sharfadi, Bulwark of the Night
        npcID      = 246559,
        vignetteID = 7004
    },
    [7]  = { -- Ez'Haadosh the Liminality
        npcID      = 246549,
        vignetteID = 7001
    },
    [8]  = { -- Berg the Spellfist
        npcID      = 237853,
        vignetteID = 6755
    },
    [9]  = { -- Corla, Herald of Twilight
        npcID      = 39679,
        vignetteID = 6761
    },
    [10] = { -- Void Zealot Devinda
        npcID      = 246272,
        vignetteID = 6988
    },
    [11] = { -- Asira Dawnslayer
        npcID      = 54968,
        vignetteID = 6994
    },
    [12] = { -- Archbishop Benedictus
        npcID      = 54938,
        vignetteID = 6996
    },
    [13] = { -- Nedrand the Eyegorger
        npcID      = 246577,
        vignetteID = 7008
    },
    [14] = { -- Executioner Lynthelma
        npcID      = 246840,
        vignetteID = 7042
    },
    [15] = { -- Gustavan, Herald of the End
        npcID      = 246565,
        vignetteID = 7005
    },
    [16] = { -- Voidclaw Hexathor
        npcID      = 246578,
        vignetteID = 7009
    },
    [17] = { -- Mirrorvise
        npcID      = 246566,
        vignetteID = 7006
    },
    [18] = { -- Saligrum the Observer
        npcID      = 246558,
        vignetteID = 7003
    }
}

-- Populate localized names
for i = 1, #RARE_MAP do
    RARE_MAP[i].name = MidnightPrepatch_Logic.GetLocalizedNPCNameByNPCID(RARE_MAP[i].npcID)
end

local State = {
    isInEvent   = false,
    eventPin    = nil,
    lastMapID   = nil,
    currentRare = {
        valid        = false,
        active       = false,
        index        = nil,
        info         = nil,
        spawnTime    = nil,
        vignetteGUID = nil,
        x            = nil,
        y            = nil
    }
}

local function SetCurrentRare(rareMapIndex, spawnTime, vignetteGUID, x, y)
    local isNewRare = (State.currentRare.index ~= rareMapIndex)

    State.currentRare.valid = true
    State.currentRare.active = true
    State.currentRare.index = rareMapIndex
    State.currentRare.info = RARE_MAP[rareMapIndex]
    State.currentRare.spawnTime = spawnTime
    State.currentRare.vignetteGUID = vignetteGUID
    State.currentRare.x = x
    State.currentRare.y = y

    if isNewRare then
        CallbackRegistry.Trigger("MidnightPrepatch.RareChanged")
    end
end

local function SetCurrentRareActive(isActive)
    State.currentRare.active = isActive
end

local function WipeActiveRare()
    State.currentRare.valid = false
    State.currentRare.active = false
    State.currentRare.index = nil
    State.currentRare.info = nil
    State.currentRare.spawnTime = nil
    State.currentRare.vignetteGUID = nil
    State.currentRare.x = nil
    State.currentRare.y = nil
end


-- Checks
----------------------------------------------------------------------------------------------------

local function RefreshEventPin()
    if State.isInEvent then return end

    local ongoing = C_EventScheduler.GetOngoingEvents()
    if ongoing then
        for _, v in ipairs(ongoing) do
            if v.areaPoiID == EVENT_POI_ID then
                local poiInfo = C_AreaPoiInfo.GetAreaPOIInfo(EVENT_MAP_ID, v.areaPoiID)

                State.eventPin = v
                State.eventPin.poiInfo = poiInfo

                return
            end
        end
    end

    State.eventPin = nil
end

function MidnightPrepatch_Logic.IsInEvent()
    local mapID = GetBestMapForUnit("player")
    local isNewMapID = mapID ~= State.lastMapID
    State.lastMapID = mapID

    if isNewMapID then
        RefreshEventPin()

        if mapID == EVENT_MAP_ID and State.eventPin ~= nil then
            State.isInEvent = true
            return true
        end

        State.isInEvent = false
        return false
    else
        return State.isInEvent
    end
end


-- Rare Scanner
----------------------------------------------------------------------------------------------------

function MidnightPrepatch_Logic.ScanRare(rareMapIndex)
    local targetID = RARE_MAP[rareMapIndex].vignetteID
    if not targetID then return false end

    local vignettes = GetVignettes()
    for _, vignette in ipairs(vignettes) do
        local _, _, _, _, _, vignetteID, _ = Utils_Blizzard.ParseVignetteGUID(vignette)

        if tostring(vignetteID) == tostring(targetID) then
            local spawnTime = Utils_Blizzard.GetSpawnTimeFromGUID_Epoch(vignette)
            local position = GetVignettePosition(vignette, GetBestMapForUnit("player"))
            local x, y = position.x, position.y
            return true, spawnTime, vignette, x, y
        end
    end

    return false, nil
end

function MidnightPrepatch_Logic.RefreshActiveRare()
    for index, rare in ipairs(RARE_MAP) do
        local targetID = rare.vignetteID
        if targetID then
            local isActive, spawnTime, vignetteGUID, x, y = MidnightPrepatch_Logic.ScanRare(index)
            if isActive then
                SetCurrentRare(index, spawnTime, vignetteGUID, x, y)
                return
            end
        end
    end
    SetCurrentRareActive(false)
end

function MidnightPrepatch_Logic.HasRare()
    return State.currentRare.valid
end

function MidnightPrepatch_Logic.IsCurrentRareActive()
    if not State.currentRare.valid then return nil end
    return State.currentRare.active
end

function MidnightPrepatch_Logic.GetCurrentRare()
    if not State.currentRare.valid then return nil end
    return State.currentRare.index
end

function MidnightPrepatch_Logic.GetNextRare()
    if not State.currentRare.valid then return nil end
    local idx = State.currentRare.index
    if not idx then return end
    if idx >= #RARE_MAP then return 1 end
    return idx + 1
end

function MidnightPrepatch_Logic.GetPreviousRare()
    if not State.currentRare.valid then return nil end
    local idx = State.currentRare.index
    if not idx then return end
    if idx <= 1 then return 1 end
    return idx - 1
end

function MidnightPrepatch_Logic.GetNextRareSpawnTime()
    if not State.currentRare.valid then return nil end
    return State.currentRare.spawnTime + 600
end

function MidnightPrepatch_Logic.GetTimeUntilNextRare()
    if not State.currentRare.valid then return nil end
    return MidnightPrepatch_Logic.GetNextRareSpawnTime() - GetServerTime()
end


-- Methods
----------------------------------------------------------------------------------------------------

function MidnightPrepatch_Logic.SetWaypointToQuestGiver()
    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(EVENT_MAP_ID, WEEKLY_QUEST_GIVER_POSITION.x, WEEKLY_QUEST_GIVER_POSITION.y))
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
end

function MidnightPrepatch_Logic.SetWaypointToActiveRare()
    if not State.currentRare.valid or not State.currentRare.active then return end
    local vignetteGUID = State.currentRare.vignetteGUID
    if not vignetteGUID then return end

    SetSuperTrackedVignette(vignetteGUID)
end

function MidnightPrepatch_Logic.OpenEventMap()
    OpenWorldMap(EVENT_MAP_ID)
end


-- Tooltips
----------------------------------------------------------------------------------------------------

local RareTrackerTooltipUpdater = nil

local function RareTrackerTooltipUpdater_OnUpdate()
    if not State.currentRare.valid then return end
    MidnightPrepatch_Logic.SetRareTrackerTooltip(MidnightPrepatchFrame.RareFrame.RareTracker)
end

local function RareTrackerTooltipUpdater_Enable()
    if not RareTrackerTooltipUpdater then
        RareTrackerTooltipUpdater = C_Timer.NewTicker(0.5, RareTrackerTooltipUpdater_OnUpdate)
    end
end

local function RareTrackerTooltipUpdater_Disable()
    if RareTrackerTooltipUpdater then
        RareTrackerTooltipUpdater:Cancel()
        RareTrackerTooltipUpdater = nil
    end
end

local RareTextUpdater = nil

local function RareTextUpdater_OnUpdate()
    if not State.currentRare.valid or State.currentRare.active then return end
    local timeUntilNext = MidnightPrepatch_Logic.GetTimeUntilNextRare() or 0
    local currentText = timeUntilNext < 0 and L["Modules - Events - MidnightPrepatch - RareTracker - Await"] or L["Modules - Events - MidnightPrepatch - RareTracker - Timer"]:format(Utils_Formatting.FormatTimeNoSeconds(timeUntilNext))
    MidnightPrepatchFrame.RareFrame.RareTracker.Current:SetText(currentText)
end

function MidnightPrepatch_Logic.StartRareTextUpdater()
    if not RareTextUpdater then
        RareTextUpdater = C_Timer.NewTicker(0.5, RareTextUpdater_OnUpdate)
    end
end

function MidnightPrepatch_Logic.StopRareTextUpdater()
    if RareTextUpdater then
        RareTextUpdater:Cancel()
        RareTextUpdater = nil
    end
end


function MidnightPrepatch_Logic.SetCurrencyTooltip(owner)
    GameTooltip:SetOwner(owner, "ANCHOR_BOTTOMLEFT")
    GameTooltip:SetCurrencyByID(EVENT_CURRENCY_ID)
end

function MidnightPrepatch_Logic.SetWeeklyQuestTooltip(owner)
    if not MidnightPrepatch.IsIntroQuestlineComplete() then return end

    local currencyInfo = GetCurrencyInfo(EVENT_CURRENCY_ID)
    local currencyIcon = currencyInfo and currencyInfo.iconFileID

    GameTooltip:SetOwner(owner, "ANCHOR_BOTTOMLEFT")

    -- Title
    GameTooltip:AddLine(L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Title"], GenericEnum.ColorRGB01.NormalText.r, GenericEnum.ColorRGB01.NormalText.g, GenericEnum.ColorRGB01.NormalText.b)

    -- Reset time
    local resetTime = GetSecondsUntilWeeklyReset()
    GameTooltip:AddLine(L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Reset"]:format(SecondsToTime(resetTime)), GenericEnum.ColorRGB01.Blue.r, GenericEnum.ColorRGB01.Blue.g, GenericEnum.ColorRGB01.Blue.b)
    GameTooltip:AddLine(" ")

    -- Quests
    for _, questID in ipairs(WEEKLY_QUEST_IDS) do
        local title = GetTitleForQuestID(questID) or ("Quest #" .. questID)
        local isComplete = IsQuestFlaggedCompleted(questID)
        local isActive = IsOnQuest(questID)
        local rewardAmount = EVENT_QUEST_CURRENCY_REWARDS[questID] or 0
        local currencyText = currencyIcon and ("|T" .. currencyIcon .. ":0|t " .. rewardAmount .. "  ") or ""

        local statusText = nil
        local color = nil
        if isComplete then
            statusText = L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Complete"]
            color = GenericEnum.ColorRGB01.Green
        elseif isActive then
            statusText = L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - InProgress"]
            color = GenericEnum.ColorRGB01.White
        else
            statusText = L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Available"]
            color = GenericEnum.ColorRGB01.NormalText
        end

        GameTooltip:AddDoubleLine(currencyText .. title, statusText, GenericEnum.ColorRGB01.White.r, GenericEnum.ColorRGB01.White.g, GenericEnum.ColorRGB01.White.b, color.r, color.g, color.b)
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Hint"], GenericEnum.ColorRGB01.Green.r, GenericEnum.ColorRGB01.Green.g, GenericEnum.ColorRGB01.Green.b)
    GameTooltip:Show()
end

function MidnightPrepatch_Logic.SetRareTrackerTooltip(owner)
    RareTrackerTooltipUpdater_Enable()

    GameTooltip:SetOwner(owner, "ANCHOR_BOTTOM")
    GameTooltip:AddLine(L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Title"], GenericEnum.ColorRGB01.White.r, GenericEnum.ColorRGB01.White.g, GenericEnum.ColorRGB01.White.b)
    GameTooltip:AddLine(" ")

    if not State.currentRare.valid then
        GameTooltip:AddLine(L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Unavailable"], GenericEnum.ColorRGB01.Red.r, GenericEnum.ColorRGB01.Red.g, GenericEnum.ColorRGB01.Red.b)
        GameTooltip:Show()
        return
    end

    local currentIndex = State.currentRare.index
    local currentSpawnTime = State.currentRare.spawnTime
    local now = GetServerTime()
    local rareCount = #RARE_MAP

    for rareIndex = 1, rareCount do
        local isCurrentRare  = (MidnightPrepatch_Logic.GetCurrentRare() == rareIndex)
        local isNextRare     = (MidnightPrepatch_Logic.GetNextRare() == rareIndex)

        local rareInfo       = RARE_MAP[rareIndex]
        local rareName       = rareInfo.name
        local timeOffset     = ((rareIndex - currentIndex) % rareCount) * 600
        local spawnTime      = currentSpawnTime + timeOffset
        local timeUntilSpawn = spawnTime - now

        local infoText, color
        if isCurrentRare and State.currentRare.active then
            local vignetteHealthPercent = GetHealthPercent(State.currentRare.vignetteGUID)
            color = GenericEnum.ColorRGB01.Green

            if vignetteHealthPercent then
                infoText = string.format("%0.0f%%", vignetteHealthPercent * 100)
                if vignetteHealthPercent < 0.25 then
                    color = GenericEnum.ColorRGB01.Red
                elseif vignetteHealthPercent < 0.5 then
                    color = GenericEnum.ColorRGB01.Orange
                elseif vignetteHealthPercent < 1 then
                    color = GenericEnum.ColorRGB01.NormalText
                end
            else
                infoText = L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Active"]
            end
        elseif isCurrentRare then
            infoText = L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Inactive"]
            color = GenericEnum.ColorRGB01.LightGray
        else
            infoText = timeUntilSpawn > 0 and SecondsToTime(timeUntilSpawn) or L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Await"]
            if isNextRare then
                color = GenericEnum.ColorRGB01.White
            else
                color = GenericEnum.ColorRGB01.Gray
            end
        end

        GameTooltip:AddDoubleLine(rareName, infoText, color.r, color.g, color.b, color.r, color.g, color.b)
    end

    if State.currentRare.active then
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Hint"], GenericEnum.ColorRGB01.Green.r, GenericEnum.ColorRGB01.Green.g, GenericEnum.ColorRGB01.Green.b)
    end

    GameTooltip:Show()
end

function MidnightPrepatch_Logic.SetEventTooltip(owner)
    if not State.eventPin then return end

    local poiInfo = State.eventPin.poiInfo
    if not poiInfo then return end

    GameTooltip:SetOwner(owner, "ANCHOR_BOTTOM")
    GameTooltip:SetText(poiInfo.name, GenericEnum.ColorRGB01.White.r, GenericEnum.ColorRGB01.White.g, GenericEnum.ColorRGB01.White.b)
    if poiInfo.description then
        GameTooltip:AddLine(poiInfo.description, nil, nil, nil, true)
    end

    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L["Modules - Events - MidnightPrepatch - Event - Tooltip - Hint"], GenericEnum.ColorRGB01.Green.r, GenericEnum.ColorRGB01.Green.g, GenericEnum.ColorRGB01.Green.b)
    GameTooltip:Show()
end

function MidnightPrepatch_Logic.HideTooltip()
    GameTooltip:Hide()
    RareTrackerTooltipUpdater_Disable()
end


-- UI
----------------------------------------------------------------------------------------------------

function MidnightPrepatch_Logic.UpdateUI()
    if IsModuleEnabled() and MidnightPrepatch_Logic.IsInEvent() then
        MidnightPrepatch_Logic.RefreshActiveRare()
        MidnightPrepatchFrame:UpdateCurrencyTracker()
        MidnightPrepatchFrame:UpdateWeeklyQuestTracker()

        if State.eventPin then
            MidnightPrepatchFrame:SetTitle(State.eventPin.poiInfo.name)
        end

        if MidnightPrepatch_Logic.HasRare() then
            local currentRareActive = MidnightPrepatch_Logic.IsCurrentRareActive()
            local currentRareName = RARE_MAP[MidnightPrepatch_Logic.GetCurrentRare()].name
            local previousRareName = RARE_MAP[MidnightPrepatch_Logic.GetPreviousRare()].name
            local nextRareName = RARE_MAP[MidnightPrepatch_Logic.GetNextRare()].name
            local timeUntilNext = MidnightPrepatch_Logic.GetTimeUntilNextRare() or 0
            local currentText
            if currentRareActive then
                currentText = currentRareName
            elseif timeUntilNext < 0 then
                currentText = L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Await"]
            else
                currentText = L["Modules - Events - MidnightPrepatch - RareTracker - Timer"]:format(Utils_Formatting.FormatTimeNoSeconds(timeUntilNext))
            end
            MidnightPrepatchFrame:UpdateRareTracker(currentText, currentRareActive, previousRareName, nextRareName)
        else
            MidnightPrepatchFrame:UpdateRareTracker(L["Modules - Events - MidnightPrepatch - RareTracker - Unavailable"], false, nil, nil)
        end

        MidnightPrepatchFrame:ShowFrame()
    else
        MidnightPrepatchFrame:HideFrame()
    end
end


-- Additional Features
----------------------------------------------------------------------------------------------------

do -- Re-render on UI scale change
    CallbackRegistry:Add("WoWClient.UIScaleChanged", function()
        if MidnightPrepatchFrame:IsVisible() then
            MidnightPrepatchFrame:_Render()
        end
    end)
end


-- Events
----------------------------------------------------------------------------------------------------

local function OnEventSchedulerUpdate()
    RefreshEventPin()
end

OnEventSchedulerUpdate()

function OnRareChanged()
    MidnightPrepatchFrame.AnimDefinition:Play(MidnightPrepatchFrame, "NEW_ENCOUNTER")
    Sound.PlaySound("UI", 89643)
end

CallbackRegistry.Add("MidnightPrepatch.RareChanged", OnRareChanged)


local f = CreateFrame("Frame")
f:RegisterEvent("VIGNETTES_UPDATED")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("QUEST_LOG_UPDATE")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("EVENT_SCHEDULER_UPDATE")
f:SetScript("OnEvent", function(self, event, ...)
    if not IsModuleEnabled() then return end

    if event == "PLAYER_ENTERING_WORLD" then
        C_EventScheduler.RequestEvents()
    elseif event == "EVENT_SCHEDULER_UPDATE" then
        OnEventSchedulerUpdate()
    end

    MidnightPrepatch_Logic.UpdateUI()
end)

SavedVariables.OnChange("ManifoldDB_Global", "MidnightPrepatch", MidnightPrepatch_Logic.UpdateUI)
