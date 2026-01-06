local env                                           = select(2, ...)
local L                                             = env.L
local Path                                          = env.WPM:Import("wpm_modules\\path")
local Sound                                         = env.WPM:Import("wpm_modules\\sound")
local UIFont                                        = env.WPM:Import("wpm_modules\\ui-font")
local UIKit                                         = env.WPM:Import("wpm_modules\\ui-kit")
local Frame, LayoutVertical, LayoutHorizontal, Text = UIKit.UI.Frame, UIKit.UI.LayoutVertical, UIKit.UI.LayoutHorizontal, UIKit.UI.Text
local UIAnim                                        = env.WPM:Import("wpm_modules\\ui-anim")
local GenericEnum                                   = env.WPM:Import("wpm_modules\\generic-enum")
local MidnightPrepatch_Templates                    = env.WPM:Import("@\\MidnightPrepatch\\Templates")
local MidnightPrepatch                              = env.WPM:Import("@\\MidnightPrepatch")
local MidnightPrepatch_Logic                        = env.WPM:Await("@\\MidnightPrepatch\\Logic")

local GetSecondsUntilWeeklyReset                    = C_DateAndTime.GetSecondsUntilWeeklyReset
local GetCurrencyInfo                               = C_CurrencyInfo.GetCurrencyInfo
local IsQuestFlaggedCompleted                       = C_QuestLog.IsQuestFlaggedCompleted
local IsOnQuest                                     = C_QuestLog.IsOnQuest
local ipairs                                        = ipairs


-- Shared
----------------------------------------------------------------------------------------------------

local ATLAS                         = UIKit.Define.Texture_Atlas{ path = Path.Root .. "\\Art\\MidnightPrepatch\\Frame.png" }
local TEXTURE_NIL                   = UIKit.Define.Texture{ path = nil }
local FIT                           = UIKit.Define.Fit{}
local FILL                          = UIKit.Define.Fill{}
local P_FILL                        = UIKit.Define.Percentage{ value = 100 }
local TEXT_COLOR                    = UIKit.Define.Color_HEX{ hex = "FFCBC2F8" }

local WEEKLY_QUEST_ICON_AVAILABLE   = Path.Root .. "\\Art\\MidnightPrepatch\\EventQuest-Available.png"
local WEEKLY_QUEST_ICON_INCOMPLETE  = Path.Root .. "\\Art\\MidnightPrepatch\\EventQuest-Incomplete.png"
local WEEKLY_QUEST_ICON_UNAVAILABLE = Path.Root .. "\\Art\\MidnightPrepatch\\EventQuest-Unavailable.png"
local WEEKLY_QUEST_ICON_INVALID     = Path.Root .. "\\Art\\MidnightPrepatch\\EventQuest-Invalid.png"
local WEEKLY_QUEST_IDS              = { 87308, 91795 }


-- ManifoldMidnightPrepatchFrame
----------------------------------------------------------------------------------------------------

do
    local FrameWidth = 320

    local BACKGROUND = ATLAS{ left = 0 / 320, right = 320 / 320, top = 0 / 128, bottom = 64 / 128 }
    local SHEEN      = ATLAS{ left = 0 / 320, right = 320 / 320, top = 64 / 128, bottom = 128 / 128 }
    local SHEEN_MASK = UIKit.Define.Texture{ path = Path.Root .. "\\Art\\MidnightPrepatch\\Frame-SheenMask.png" }


    local name = "ManifoldMidnightPrepatchFrame"
    local id = "ManifoldMidnightPrepatchFrame"

    local frame =
        Frame(name, {
            LayoutVertical(name .. ".Content", {
                Frame(name .. ".Content.TitleFrame", {
                    Text(name .. ".Content.TitleFrame.Text")
                        :id("Content.TitleFrame.Text", id)
                        :point(UIKit.Enum.Point.Center)
                        :size(P_FILL, FIT)
                        :fontObject(UIFont.UIFontObjectNormal12)
                        :textJustifyH("CENTER")
                        :textJustifyV("MIDDLE")
                        :textColor(TEXT_COLOR)
                })
                    :id("TitleFrame", id)
                    :size(P_FILL, FIT),

                Frame(name .. ".Content.RareFrame", {
                    Frame(name .. ".Content.RareFrame.Background")
                        :id("Content.RareFrame.Background", id)
                        :size(UIKit.Define.Fill{ delta = -12 })
                        :background(BACKGROUND)
                        :frameLevel(1),

                    Frame(name .. ".Content.RareFrame.SheenMask")
                        :id("Content.RareFrame.SheenMask", id)
                        :point(UIKit.Enum.Point.Center)
                        :size(125, 125)
                        :scale(1)
                        :maskBackground(SHEEN_MASK)
                        :frameLevel(2),

                    Frame(name .. ".Content.RareFrame.Sheen")
                        :id("Content.RareFrame.Sheen", id)
                        :size(UIKit.Define.Fill{ delta = -12 })
                        :background(SHEEN)
                        :mask(UIKit.NewGroupCaptureString("Content.RareFrame.SheenMask", id))
                        :frameLevel(2),

                    LayoutHorizontal(name .. ".Content.RareFrame.RareTracker", {
                        Text(name .. ".Content.RareFrame.RareTracker.Previous")
                            :id("Content.RareFrame.RareTracker.Previous", id)
                            :size(UIKit.Define.Percentage{ value = 20, operator = "-", delta = 5 }, P_FILL)
                            :point(UIKit.Enum.Point.Left)
                            :fontObject(UIFont.UIFontObjectNormal12)
                            :textColor(GenericEnum.UIColorRGB.White)
                            :textJustifyH("CENTER")
                            :textJustifyV("MIDDLE")
                            :maxLines(1)
                            :alpha(0.5),

                        Text(name .. ".Content.RareFrame.RareTracker.Current")
                            :id("Content.RareFrame.RareTracker.Current", id)
                            :size(UIKit.Define.Percentage{ value = 60, operator = "-", delta = 5 }, P_FILL)
                            :point(UIKit.Enum.Point.Left)
                            :fontObject(UIFont.UIFontObjectNormal14)
                            :textColor(GenericEnum.UIColorRGB.White)
                            :textJustifyH("CENTER")
                            :textJustifyV("MIDDLE")
                            :maxLines(1),

                        Text(name .. ".Content.RareFrame.RareTracker.Next")
                            :id("Content.RareFrame.RareTracker.Next", id)
                            :size(UIKit.Define.Percentage{ value = 20, operator = "-", delta = 5 }, P_FILL)
                            :point(UIKit.Enum.Point.Left)
                            :fontObject(UIFont.UIFontObjectNormal12)
                            :textColor(GenericEnum.UIColorRGB.White)
                            :textJustifyH("CENTER")
                            :textJustifyV("MIDDLE")
                            :maxLines(1)
                            :alpha(0.5)
                    })
                        :id("Content.RareFrame.RareTracker", id)
                        :point(UIKit.Enum.Point.Center)
                        :size(UIKit.Define.Percentage{ value = 70 }, P_FILL)
                        :layoutSpacing(5)

                })
                    :id("RareFrame", id)
                    :size(FrameWidth, FrameWidth / 10),

                LayoutHorizontal(name .. ".Content.OverviewFrame", {
                    LayoutHorizontal(name .. ".Content.OverviewFrame.CurrencyTracker", {
                        MidnightPrepatch_Templates.ItemSlot(name .. ".Content.OverviewFrame.CurrencyTracker.Icon")
                            :id("Content.OverviewFrame.CurrencyTracker.Icon", id)
                            :point(UIKit.Enum.Point.Left)
                            :size(16, 16),

                        Text(name .. ".Content.OverviewFrame.CurrencyTracker.Count")
                            :id("Content.OverviewFrame.CurrencyTracker.Count", id)
                            :point(UIKit.Enum.Point.Left)
                            :size(FIT, P_FILL)
                            :fontObject(UIFont.UIFontObjectNormal12)
                            :textColor(GenericEnum.UIColorRGB.White)
                            :textJustifyH("LEFT")
                            :textJustifyV("MIDDLE")
                    })
                        :id("Content.OverviewFrame.CurrencyTracker", id)
                        :size(FIT, P_FILL)
                        :layoutSpacing(5),

                    LayoutHorizontal(name .. ".Content.OverviewFrame.WeeklyQuestTracker", {
                        Frame(name .. ".Content.OverviewFrame.WeeklyQuestTracker.Icon")
                            :id("Content.OverviewFrame.WeeklyQuestTracker.Icon", id)
                            :point(UIKit.Enum.Point.Left)
                            :background(TEXTURE_NIL)
                            :size(16, 16),

                        Text(name .. ".Content.OverviewFrame.WeeklyQuestTracker.Count")
                            :id("Content.OverviewFrame.WeeklyQuestTracker.Count", id)
                            :point(UIKit.Enum.Point.Left)
                            :size(FIT, P_FILL)
                            :fontObject(UIFont.UIFontObjectNormal12)
                            :textColor(GenericEnum.UIColorRGB.White)
                            :textJustifyH("LEFT")
                            :textJustifyV("MIDDLE")
                    })
                        :id("Content.OverviewFrame.WeeklyQuestTracker", id)
                        :size(FIT, P_FILL)
                        :layoutSpacing(5)
                })
                    :id("Content.OverviewFrame", id)
                    :y(-6)
                    :size(FIT, 16)
                    :layoutSpacing(10)
            })
                :id("Content", id)
                :point(UIKit.Enum.Point.Center)
                :size(P_FILL, FIT)
                :layoutAlignmentH(UIKit.Enum.Direction.Justified)
                :layoutSpacing(10)
        })
        :parent(UIParent)
        :frameStrata(UIKit.Enum.FrameStrata.Low, 1)
        :point(UIKit.Enum.Point.Top)
        :y(-10)
        :size(FrameWidth, FIT)
        :_Render()


    frame.Content                                      = UIKit.GetElementById("Content", id)
    frame.TitleFrame                                   = UIKit.GetElementById("TitleFrame", id)
    frame.TitleFrame.Text                              = UIKit.GetElementById("Content.TitleFrame.Text", id)
    frame.RareFrame                                    = UIKit.GetElementById("RareFrame", id)
    frame.RareFrame.Background                         = UIKit.GetElementById("Content.RareFrame.Background", id)
    frame.RareFrame.SheenMask                          = UIKit.GetElementById("Content.RareFrame.SheenMask", id)
    frame.RareFrame.Sheen                              = UIKit.GetElementById("Content.RareFrame.Sheen", id)
    frame.RareFrame.RareTracker                        = UIKit.GetElementById("Content.RareFrame.RareTracker", id)
    frame.RareFrame.RareTracker.Previous               = UIKit.GetElementById("Content.RareFrame.RareTracker.Previous", id)
    frame.RareFrame.RareTracker.Current                = UIKit.GetElementById("Content.RareFrame.RareTracker.Current", id)
    frame.RareFrame.RareTracker.Next                   = UIKit.GetElementById("Content.RareFrame.RareTracker.Next", id)
    frame.OverviewFrame                                = UIKit.GetElementById("Content.OverviewFrame", id)
    frame.OverviewFrame.CurrencyTracker                = UIKit.GetElementById("Content.OverviewFrame.CurrencyTracker", id)
    frame.OverviewFrame.CurrencyTracker.Icon           = UIKit.GetElementById("Content.OverviewFrame.CurrencyTracker.Icon", id)
    frame.OverviewFrame.CurrencyTracker.Count          = UIKit.GetElementById("Content.OverviewFrame.CurrencyTracker.Count", id)
    frame.OverviewFrame.WeeklyQuestTracker             = UIKit.GetElementById("Content.OverviewFrame.WeeklyQuestTracker", id)
    frame.OverviewFrame.WeeklyQuestTracker.Icon        = UIKit.GetElementById("Content.OverviewFrame.WeeklyQuestTracker.Icon", id)
    frame.OverviewFrame.WeeklyQuestTracker.IconTexture = frame.OverviewFrame.WeeklyQuestTracker.Icon:GetTextureFrame()
    frame.OverviewFrame.WeeklyQuestTracker.Count       = UIKit.GetElementById("Content.OverviewFrame.WeeklyQuestTracker.Count", id)
    ManifoldMidnightPrepatchFrame                      = frame


    frame.AnimDefinition = UIAnim.New()
    do
        local IntroAlpha = UIAnim.Animate()
            :property(UIAnim.Enum.Property.Alpha)
            :duration(0.2)
            :from(0)
            :to(1)

        frame.AnimDefinition:State("INTRO", function(frame)
            IntroAlpha:Play(frame)
        end)


        local OutroAlpha = UIAnim.Animate()
            :property(UIAnim.Enum.Property.Alpha)
            :duration(1)
            :to(0)

        frame.AnimDefinition:State("OUTRO", function(frame)
            OutroAlpha:Play(frame)
        end)


        local NewEncounterTimer = nil

        local NewEncounterIntroAlpha = UIAnim.Animate()
            :property(UIAnim.Enum.Property.Alpha)
            :duration(0.2)
            :from(0)
            :to(1)

        local NewEncounterIntroScale = UIAnim.Animate()
            :property(UIAnim.Enum.Property.Scale)
            :duration(2.5)
            :easing(UIAnim.Enum.Easing.SmootherStep)
            :from(0)
            :to(15)

        local NewEncounterIntroCurrentAlpha = UIAnim.Animate()
            :wait(0.2)
            :property(UIAnim.Enum.Property.Alpha)
            :duration(0.2)
            :from(0)
            :to(1)

        local NewEncounterIntroPreviousAlpha = UIAnim.Animate()
            :wait(0.2)
            :property(UIAnim.Enum.Property.Alpha)
            :duration(0.7)
            :from(0)
            :to(0.5)

        local NewEncounterIntroNextAlpha = UIAnim.Animate()
            :wait(0.2)
            :property(UIAnim.Enum.Property.Alpha)
            :duration(0.7)
            :from(0)
            :to(0.5)

        local NewEncounterOutroAlpha = UIAnim.Animate()
            :wait(1)
            :property(UIAnim.Enum.Property.Alpha)
            :duration(0.5)
            :from(1)
            :to(0)

        frame.AnimDefinition:State("NEW_ENCOUNTER", function(frame)
            frame.RareFrame.Sheen:Show()
            frame.RareFrame.SheenMask:Show()
            frame.RareFrame.RareTracker.Current:SetAlpha(0)
            frame.RareFrame.RareTracker.Previous:SetAlpha(0)
            frame.RareFrame.RareTracker.Next:SetAlpha(0)

            NewEncounterIntroAlpha:Play(frame.RareFrame.Sheen)
            NewEncounterIntroCurrentAlpha:Play(frame.RareFrame.RareTracker.Current)
            NewEncounterIntroPreviousAlpha:Play(frame.RareFrame.RareTracker.Previous)
            NewEncounterIntroNextAlpha:Play(frame.RareFrame.RareTracker.Next)
            NewEncounterIntroScale:Play(frame.RareFrame.SheenMask)
            NewEncounterOutroAlpha:Play(frame.RareFrame.Sheen)

            if NewEncounterTimer then NewEncounterTimer:Cancel() end
            NewEncounterTimer = C_Timer.NewTimer(1.5, function()
                NewEncounterTimer = nil
                frame.RareFrame.Sheen:Hide()
                frame.RareFrame.SheenMask:Hide()
            end)
        end)
    end


    local MidnightPrepatchFrameMixin = {}

    local EVENT_CURRENCY_ID = 3319

    function MidnightPrepatchFrameMixin:UpdateCurrencyTracker()
        local currencyInfo = GetCurrencyInfo(EVENT_CURRENCY_ID)
        self.OverviewFrame.CurrencyTracker.Icon:SetImage(currencyInfo.iconFileID)
        self.OverviewFrame.CurrencyTracker.Count:SetText(currencyInfo.quantity)
    end

    function MidnightPrepatchFrameMixin:UpdateWeeklyQuestTracker()
        local icon, text, color, alpha
        local isIntroQuestlineComplete = MidnightPrepatch.IsIntroQuestlineComplete()

        if not isIntroQuestlineComplete then
            icon = WEEKLY_QUEST_ICON_INVALID
            text = L["Modules - Events - MidnightPrepatch - WeeklyQuests - CompleteIntroQuestline"]
        else
            local turnedInCount, completedCount, availableCount = 0, 0, 0
            for _, questID in ipairs(WEEKLY_QUEST_IDS) do
                if IsQuestFlaggedCompleted(questID) then
                    if not C_QuestLog.IsOnQuest(questID) then
                        turnedInCount = turnedInCount + 1
                    end
                    completedCount = completedCount + 1
                elseif not IsOnQuest(questID) then
                    availableCount = availableCount + 1
                end
            end

            local total = #WEEKLY_QUEST_IDS
            if turnedInCount == total then
                local resetTime = GetSecondsUntilWeeklyReset()
                icon = WEEKLY_QUEST_ICON_UNAVAILABLE
                text = L["Modules - Events - MidnightPrepatch - WeeklyQuests - Reset"]:format(SecondsToTime(resetTime))
                color = GenericEnum.ColorRGB01.Green
                alpha = 0.75
            elseif availableCount > 0 then
                icon = WEEKLY_QUEST_ICON_AVAILABLE
                text = availableCount .. "/" .. total .. L["Modules - Events - MidnightPrepatch - WeeklyQuests - Available"]
                color = GenericEnum.ColorRGB01.White
                alpha = 1
            else
                icon = WEEKLY_QUEST_ICON_INCOMPLETE
                text = completedCount .. "/" .. total .. L["Modules - Events - MidnightPrepatch - WeeklyQuests - Complete"]
                color = GenericEnum.ColorRGB01.White
                alpha = 1
            end
        end

        self.OverviewFrame.WeeklyQuestTracker.IconTexture:SetTexture(icon)
        self.OverviewFrame.WeeklyQuestTracker.Count:SetText(text)
        self.OverviewFrame.WeeklyQuestTracker.Count:SetTextColor(color.r, color.g, color.b)
        self.OverviewFrame.WeeklyQuestTracker.Count:SetAlpha(alpha)
    end

    function MidnightPrepatchFrameMixin:UpdateRareTracker(current, isCurrentRareActive, previous, next)
        self.RareFrame.RareTracker.Previous:SetText(previous or "")
        self.RareFrame.RareTracker.Current:SetText(current or "")
        self.RareFrame.RareTracker.Next:SetText(next or "")

        self.RareFrame.RareTracker.Current:SetAlpha(isCurrentRareActive and 1 or 0.8)

        if isCurrentRareActive then
            MidnightPrepatch_Logic.StopRareTextUpdater()
        else
            MidnightPrepatch_Logic.StartRareTextUpdater()
        end
    end

    function MidnightPrepatchFrameMixin:SetTitle(text)
        self.TitleFrame.Text:SetText(text)
        self:_Render()
    end

    function MidnightPrepatchFrameMixin:ShowFrame()
        if not self.hidden then return end
        self.hidden = false

        self:Show()
        self.AnimDefinition:Play(self, "INTRO")
    end

    function MidnightPrepatchFrameMixin:HideFrame()
        if self.hidden then return end
        self.hidden = true

        self.AnimDefinition:Play(self, "OUTRO").onFinish(function()
            self:Hide()
        end)
    end


    Mixin(frame, MidnightPrepatchFrameMixin)

    do -- Title
        local Title = frame.TitleFrame.Text

        local function UpdateAnimation()
            Title:SetAlpha(Title.isMouseOver and 1 or 0.8)
        end

        Title:SetScript("OnEnter", function()
            Title.isMouseOver = true
            UpdateAnimation()
            MidnightPrepatch_Logic.SetEventTooltip(Title)
        end)

        Title:SetScript("OnLeave", function()
            Title.isMouseOver = false
            UpdateAnimation()
            MidnightPrepatch_Logic.HideTooltip()
        end)

        Title:SetScript("OnMouseUp", function()
            MidnightPrepatch_Logic.OpenEventMap()
            Sound.PlaySound("UI", SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        end)

        UpdateAnimation()
    end

    do -- Currency Tracker
        local CurrencyTracker = frame.OverviewFrame.CurrencyTracker

        local function UpdateAnimation()
            CurrencyTracker:SetAlpha(CurrencyTracker.isMouseOver and 1 or 0.8)
        end

        CurrencyTracker:SetScript("OnEnter", function()
            CurrencyTracker.isMouseOver = true
            UpdateAnimation()
            MidnightPrepatch_Logic.SetCurrencyTooltip(CurrencyTracker)
        end)

        CurrencyTracker:SetScript("OnLeave", function()
            CurrencyTracker.isMouseOver = false
            UpdateAnimation()
            MidnightPrepatch_Logic.HideTooltip()
        end)

        UpdateAnimation()
    end

    do -- Weekly Quest Tracker
        local WeeklyQuestTracker = frame.OverviewFrame.WeeklyQuestTracker

        local function UpdateAnimation()
            if MidnightPrepatch.IsIntroQuestlineComplete() then
                WeeklyQuestTracker:SetAlpha(WeeklyQuestTracker.isMouseOver and 1 or 0.8)
            else
                WeeklyQuestTracker:SetAlpha(0.5)
            end
        end

        WeeklyQuestTracker:SetScript("OnEnter", function()
            WeeklyQuestTracker.isMouseOver = true
            UpdateAnimation()
            MidnightPrepatch_Logic.SetWeeklyQuestTooltip(WeeklyQuestTracker)
        end)

        WeeklyQuestTracker:SetScript("OnLeave", function()
            WeeklyQuestTracker.isMouseOver = false
            UpdateAnimation()
            MidnightPrepatch_Logic.HideTooltip()
        end)

        WeeklyQuestTracker:SetScript("OnMouseUp", function()
            MidnightPrepatch_Logic.SetWaypointToQuestGiver()
            Sound.PlaySound("UI", SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        end)

        UpdateAnimation()
    end

    do -- Rare Tracker
        local RareTracker = frame.RareFrame.RareTracker

        local function UpdateAnimation()
            RareTracker:SetAlpha(RareTracker.isMouseOver and 1 or 0.8)
        end

        RareTracker:SetScript("OnEnter", function()
            RareTracker.isMouseOver = true
            UpdateAnimation()
            MidnightPrepatch_Logic.SetRareTrackerTooltip(RareTracker)
        end)

        RareTracker:SetScript("OnLeave", function()
            RareTracker.isMouseOver = false
            UpdateAnimation()
            MidnightPrepatch_Logic.HideTooltip()
        end)

        RareTracker:SetScript("OnMouseUp", function()
            MidnightPrepatch_Logic.SetWaypointToActiveRare()
            Sound.PlaySound("UI", SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        end)

        UpdateAnimation()
    end


    frame:Hide()
    frame.hidden = true
    frame.RareFrame.Sheen:Hide()
    frame.RareFrame.SheenMask:Hide()
end
