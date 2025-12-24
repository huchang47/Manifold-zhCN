local env = select(2, ...)
local Config = env.Config
local GenericEnum = env.WPM:Import("wpm_modules\\generic-enum")

local function IsModuleEnabled() return Config.DBGlobal:GetVariable("ExperienceBarTooltip") == true end



local COLOR_NORMAL = GenericEnum.ColorRGB01.NormalText
local COLOR_WHITE = GenericEnum.ColorRGB01.White

do -- Add level text to experience bar tooltip
    local function OnLoad()
        local MainStatusTrackingBarContainer = StatusTrackingBarManager and StatusTrackingBarManager.MainStatusTrackingBarContainer
        if not MainStatusTrackingBarContainer then return end
        local ExperienceBar = MainStatusTrackingBarContainer.bars and MainStatusTrackingBarContainer.bars[StatusTrackingBarInfo.BarsEnum.Experience]
        if not ExperienceBar or not ExperienceBar.ExhaustionTick then return end

        local Method_ExhaustionTooltTipText = ExperienceBar.ExhaustionTick.ExhaustionToolTipText

        local function ShowCustomTooltip(self)
            local exhaustionStateID, exhaustionStateName, exhaustionStateMultiplier = GetRestState()
            if not exhaustionStateID then return end

            local tooltip = GetAppropriateTooltip()
            GameTooltip:SetOwner(ExperienceBar, "ANCHOR_RIGHT")
            GameTooltip:ClearLines()

            -- level
            local level = UnitLevel("player")
            local maxLevel = GetMaxLevelForPlayerExpansion()
            GameTooltip:AddLine(string.format("Level: %s / %s", level, maxLevel), COLOR_NORMAL.r, COLOR_NORMAL.g, COLOR_NORMAL.b)

            -- xp
            local xp = UnitXP("player")
            local xpToNextLevel = UnitXPMax("player")
            local xpPercentage = string.format("%0.1f", xp / xpToNextLevel * 100)
            GameTooltip:AddLine(string.format("%s / %s" .. GenericEnum.ColorHEX.Gray .. " (%s%%)|r", BreakUpLargeNumbers(xp), BreakUpLargeNumbers(xpToNextLevel), xpPercentage), COLOR_WHITE.r, COLOR_WHITE.g, COLOR_WHITE.b)

            -- rested xp
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(EXHAUST_TOOLTIP1:format(exhaustionStateName, exhaustionStateMultiplier * 100))

            if not IsResting() and (exhaustionStateID == 4 or exhaustionStateID == 5) then
                GameTooltip:AddLine(EXHAUST_TOOLTIP2, COLOR_WHITE.r, COLOR_WHITE.g, COLOR_WHITE.b)
            end

            if GameLimitedMode_IsBankedXPActive() then
                local bankedLevels = UnitTrialBankedLevels("player")
                local bankedXP = UnitTrialXP("player")

                if bankedLevels > 0 or bankedXP > 0 then
                    GameTooltip_AddBlankLineToTooltip(tooltip)
                    GameTooltip_AddNormalLine(tooltip, XP_TEXT_BANKED_XP_HEADER)
                end

                if bankedLevels > 0 then
                    GameTooltip_AddHighlightLine(tooltip, TRIAL_CAP_BANKED_LEVELS_TOOLTIP:format(bankedLevels))
                elseif bankedXP > 0 then
                    GameTooltip_AddHighlightLine(tooltip, TRIAL_CAP_BANKED_XP_TOOLTIP)
                end
            end

            GameTooltip:Show()
        end

        ExperienceBar.ExhaustionTick.ExhaustionToolTipText = function(...)
            -- Use original method when module is disabled
            if not IsModuleEnabled() then
                Method_ExhaustionTooltTipText(...)
                return
            end

            -- Use our custom tooltip
            ShowCustomTooltip(...)
        end


        return true
    end

    if not OnLoad() then
        local f = CreateFrame("Frame")
        f:RegisterEvent("PLAYER_ENTERING_WORLD")
        f:SetScript("OnEvent", function(self)
            if OnLoad() then
                self:UnregisterAllEvents()
            end
        end)
    end
end
