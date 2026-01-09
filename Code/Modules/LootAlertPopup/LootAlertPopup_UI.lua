local env                                                                                                                                          = select(2, ...)
local L                                                                                                                                            = env.L
local Path                                                                                                                                         = env.WPM:Import("wpm_modules\\path")
local UIFont                                                                                                                                       = env.WPM:Import("wpm_modules\\ui-font")
local UIKit                                                                                                                                        = env.WPM:Import("wpm_modules\\ui-kit")
local Frame, LayoutGrid, LayoutVertical, LayoutHorizontal, ScrollView, ScrollBar, Text, Input, LinearSlider, InteractiveRect, LazyScrollView, List = UIKit.UI.Frame, UIKit.UI.LayoutGrid, UIKit.UI.LayoutVertical, UIKit.UI.LayoutHorizontal, UIKit.UI.ScrollView, UIKit.UI.ScrollBar, UIKit.UI.Text, UIKit.UI.Input, UIKit.UI.LinearSlider, UIKit.UI.InteractiveRect, UIKit.UI.LazyScrollView, UIKit.UI.List
local UIAnim                                                                                                                                       = env.WPM:Import("wpm_modules\\ui-anim")
local React                                                                                                                                        = env.WPM:Import("wpm_modules\\react")
local GenericEnum                                                                                                                                  = env.WPM:Import("wpm_modules\\generic-enum")
local LootAlertFrame_UI                                                                                                                            = env.WPM:New("@\\Modules\\LootAlertFrame\\UI")

local Mixin                                                                                                                                        = Mixin


-- Shared
----------------------------------------------------------------------------------------------------

local ATLAS       = UIKit.Define.Texture_Atlas{ path = Path.Root .. "\\Art\\LootAlertFrame\\LootAlertFrame.png" }
local TEXTURE_NIL = UIKit.Define.Texture{ path = nil }


-- Manifold_LootAlertPopup
----------------------------------------------------------------------------------------------------

do
    local BACKGROUND_TEXTURE                  = UIKit.Define.Texture_Atlas{ path = Path.Root .. "\\wpm_modules\\uic-common\\resources\\panel.png", inset = 64, scale = 0.15, sliceMode = Enum.UITextureSliceMode.Tiled, left = 0 / 512, top = 256 / 512, right = 128 / 512, bottom = 384 / 512 }
    local SPINNER_BACKGROUND                  = ATLAS{ inset = 0, scale = 1, left = 0 / 256, right = 64 / 256, top = 0 / 128, bottom = 64 / 128 }
    local TICK_BACKGROUND                     = ATLAS{ inset = 0, scale = 1, left = 0 / 256, right = 64 / 256, top = 64 / 128, bottom = 128 / 128 }
    local LMB_BACKGROUND                      = ATLAS{ inset = 0, scale = 1, left = 192 / 256, right = 256 / 256, top = 64 / 128, bottom = 128 / 128 }
    local CONTENT_SIZE                        = 18

    LootAlertFrame_UI.TEXT_COLOR_WHITE        = GenericEnum.UIColorRGB.White
    LootAlertFrame_UI.TEXT_COLOR_GRAY         = GenericEnum.UIColorRGB.Gray
    LootAlertFrame_UI.TEXT_COLOR_GREEN        = GenericEnum.UIColorRGB.Green
    LootAlertFrame_UI.TEXT_COLOR_RED          = GenericEnum.UIColorRGB.Red
    LootAlertFrame_UI.UPGRADE_BACKGROUND      = ATLAS{ inset = 0, scale = 1, left = 64 / 256, right = 128 / 256, top = 64 / 128, bottom = 128 / 128 }
    LootAlertFrame_UI.DOWNGRADE_BACKGROUND    = ATLAS{ inset = 0, scale = 1, left = 128 / 256, right = 192 / 256, top = 64 / 128, bottom = 128 / 128 }
    LootAlertFrame_UI.PrimaryTextColor        = React.New(LootAlertFrame_UI.TEXT_COLOR_WHITE)
    LootAlertFrame_UI.ItemComparisonTextColor = React.New(LootAlertFrame_UI.TEXT_COLOR_WHITE)


    local name = "Manifold_LootAlertPopup"
    local id = "Manifold_LootAlertPopup"

    local frame = Frame(name, {
            Frame(name .. ".Content", {
                Frame(name .. ".Background")
                    :id("Background", id)
                    :frameLevel(1000)
                    :size(UIKit.Define.Fill{ delta = -8 })
                    :background(BACKGROUND_TEXTURE),

                Frame(name .. ".Main", {
                    LayoutHorizontal(name .. ".Instruction", {
                        Frame(name .. ".Instruction.Hint")
                            :id("Instruction.Hint", id)
                            :frameLevel(1002)
                            :size(CONTENT_SIZE, CONTENT_SIZE)
                            :background(LMB_BACKGROUND),

                        Text(name .. ".Instruction.Text")
                            :id("Instruction.Text", id)
                            :frameLevel(1002)
                            :size(UIKit.Define.Fit{}, CONTENT_SIZE)
                            :fontObject(UIFont.UIFontObjectNormal12)
                            :textColor(LootAlertFrame_UI.PrimaryTextColor)
                    })
                        :id("Instruction", id)
                        :frameLevel(1002)
                        :point(UIKit.Enum.Point.Left)
                        :size(UIKit.Define.Fit{}, CONTENT_SIZE)
                        :layoutAlignmentV(UIKit.Enum.Direction.Justified)
                        :layoutSpacing(2),

                    LayoutHorizontal(name .. ".ItemComparison", {
                        Frame(name .. ".ItemComparison.Icon")
                            :id("ItemComparison.Icon", id)
                            :frameLevel(1002)
                            :size(CONTENT_SIZE, CONTENT_SIZE)
                            :background(TEXTURE_NIL),

                        Text(name .. ".ItemComparison.ItemLevel")
                            :id("ItemComparison.ItemLevel", id)
                            :frameLevel(1002)
                            :size(UIKit.Define.Fit{}, CONTENT_SIZE)
                            :fontObject(UIFont.UIFontObjectNormal12)
                            :textColor(LootAlertFrame_UI.ItemComparisonTextColor)
                    })
                        :id("ItemComparison", id)
                        :frameLevel(1002)
                        :point(UIKit.Enum.Point.Right)
                        :size(UIKit.Define.Fit{}, CONTENT_SIZE)
                        :layoutAlignmentV(UIKit.Enum.Direction.Justified)
                        :layoutSpacing(-2),

                    Frame(name .. ".Spinner")
                        :id("Spinner", id)
                        :frameLevel(1002)
                        :point(UIKit.Enum.Point.Right)
                        :size(CONTENT_SIZE, CONTENT_SIZE)
                        :background(SPINNER_BACKGROUND)
                        :backgroundColor(LootAlertFrame_UI.PrimaryTextColor),

                    Frame(name .. ".Tick")
                        :id("Tick", id)
                        :frameLevel(1002)
                        :point(UIKit.Enum.Point.Right)
                        :size(CONTENT_SIZE, CONTENT_SIZE)
                        :background(TICK_BACKGROUND)

                })
                    :id("Main", id)
                    :frameLevel(1001)
                    :point(UIKit.Enum.Point.Center)
                    :size(UIKit.Define.Percentage{ value = 100, operator = "-", delta = CONTENT_SIZE }, UIKit.Define.Percentage{ value = 100, operator = "-", delta = CONTENT_SIZE })
            })
                :id("Content", id)
                :frameLevel(1001)
                :point(UIKit.Enum.Point.Center)
                :size(UIKit.Define.Percentage{ value = 100 }, UIKit.Define.Percentage{ value = 100 })
        })
        :parent(UIParent)
        :frameStrata(UIKit.Enum.FrameStrata.Tooltip, 999)
        :size(175, 32)
        :_Render()


    frame.Background               = UIKit.GetElementById("Background", id)
    frame.BackgroundTexture        = frame.Background:GetTextureFrame()
    frame.Content                  = UIKit.GetElementById("Content", id)
    frame.Main                     = UIKit.GetElementById("Main", id)
    frame.Instruction              = UIKit.GetElementById("Instruction", id)
    frame.Instruction.Hint         = UIKit.GetElementById("Instruction.Hint", id)
    frame.Instruction.Text         = UIKit.GetElementById("Instruction.Text", id)
    frame.ItemComparison           = UIKit.GetElementById("ItemComparison", id)
    frame.ItemComparison.Icon      = UIKit.GetElementById("ItemComparison.Icon", id)
    frame.ItemComparison.ItemLevel = UIKit.GetElementById("ItemComparison.ItemLevel", id)
    frame.Spinner                  = UIKit.GetElementById("Spinner", id)
    frame.Tick                     = UIKit.GetElementById("Tick", id)
    ManifoldLootAlertPopup         = frame


    frame.AnimDefinition = UIAnim.New()
    do
        local IntroAlpha = UIAnim.Animate()
            :property(UIAnim.Enum.Property.Alpha)
            :duration(0.25)
            :from(0)
            :to(1)

        local IntroTranslate = UIAnim.Animate()
            :property(UIAnim.Enum.Property.PosY)
            :easing(UIAnim.Enum.Easing.ElasticOut)
            :duration(1)
            :from(-15)
            :to(0)

        frame.AnimDefinition:State("INTRO", function(frame)
            IntroAlpha:Play(frame.Content)
            IntroTranslate:Play(frame.Content)
        end)


        local OutroAlpha = UIAnim.Animate()
            :property(UIAnim.Enum.Property.Alpha)
            :duration(0.25)
            :to(0)

        local OutroTranslate = UIAnim.Animate()
            :property(UIAnim.Enum.Property.PosY)
            :easing(UIAnim.Enum.Easing.QuintInOut)
            :duration(0.375)
            :to(-15)

        frame.AnimDefinition:State("OUTRO", function(frame)
            OutroAlpha:Play(frame.Content)
            OutroTranslate:Play(frame.Content)
        end)


        local TransitionAlpha = UIAnim.Animate()
            :property(UIAnim.Enum.Property.Alpha)
            :duration(0.125)
            :from(0)
            :to(1)

        local TransitionTranslate = UIAnim.Animate()
            :property(UIAnim.Enum.Property.PosY)
            :easing(UIAnim.Enum.Easing.ExpoOut)
            :duration(0.5)
            :from(-12.5)
            :to(0)

        frame.AnimDefinition:State("TRANSITION", function(frame)
            TransitionAlpha:Play(frame.Main)
            TransitionTranslate:Play(frame.Main)
        end)
    end

    do -- Spinner
        frame.Spinner.AnimDefinition = UIAnim.New()

        local Rotate = UIAnim.Animate()
            :property(UIAnim.Enum.Property.Rotation)
            :duration(1)
            :from(0)
            :to(-360)
            :easing(UIAnim.Enum.Easing.Linear)
            :loop(UIAnim.Enum.Looping.Reset)

        frame.Spinner.AnimDefinition:State("PLAYBACK", function(frame)
            Rotate:Play(frame)
        end)

        local function UpdateAnimation(self, isShown)
            if isShown then
                if not self.AnimDefinition:IsPlaying(self, "PLAYBACK") then
                    self.AnimDefinition:Play(frame.Spinner:GetTextureFrame(), "PLAYBACK")
                end
            else
                if self.AnimDefinition:IsPlaying(self, "PLAYBACK") then
                    self.AnimDefinition:Stop()
                end
            end
        end

        hooksecurefunc(frame.Spinner, "Show", function(self) UpdateAnimation(self, true) end)
        hooksecurefunc(frame.Spinner, "Hide", function(self) UpdateAnimation(self, false) end)
        hooksecurefunc(frame.Spinner, "SetShown", UpdateAnimation)
    end


    local LootAlertPopupMixin = {}

    local FRAME_ID = {
        ItemComparison = 0,
        Spinner        = 1,
        Tick           = 2
    }

    function LootAlertPopupMixin:OnLoad()
        self.owner = nil
    end

    function LootAlertPopupMixin:GetOwner()
        return self.owner
    end

    function LootAlertPopupMixin:SetOwner(frame)
        self.owner = frame
        self:ClearAllPoints()
        self:SetPoint("BOTTOM", frame, "TOP", 0, -8)
    end

    function LootAlertPopupMixin:SetFrame(frameId)
        if frameId == FRAME_ID.ItemComparison then
            self.ItemComparison:Show()
            self.Spinner:Hide()
            self.Tick:Hide()
        elseif frameId == FRAME_ID.Spinner then
            self.ItemComparison:Hide()
            self.Spinner:Show()
            self.Tick:Hide()
        elseif frameId == FRAME_ID.Tick then
            self.ItemComparison:Hide()
            self.Spinner:Hide()
            self.Tick:Show()
        end
    end

    function LootAlertPopupMixin:SetInstruction(hint, text)
        self.Instruction.Text:SetText(text)
        self.Instruction.Hint:SetShown(hint)
        if hint then self.Instruction.Hint:background(hint) end
    end

    function LootAlertPopupMixin:SetItemComparison(itemLevel)
        local inCombat = InCombatLockdown()
        local atVendor = MerchantFrame and MerchantFrame:IsShown()
        local isBlocked = inCombat or atVendor
        local blockText = inCombat and L["Modules - Loot - LootAlertPopup - Combat"] or (atVendor and L["Modules - Loot - LootAlertPopup - Vendor"] or L["Modules - Loot - LootAlertPopup - Equip"])
        self:SetInstruction(not isBlocked and LMB_BACKGROUND, blockText)
        LootAlertFrame_UI.PrimaryTextColor:Set(isBlocked and LootAlertFrame_UI.TEXT_COLOR_RED or LootAlertFrame_UI.TEXT_COLOR_WHITE)

        self:SetFrame(FRAME_ID.ItemComparison)
        local isUpgrade = itemLevel > 0
        local isDowngrade = itemLevel < 0
        local icon = nil
        local textColor = nil
        if isUpgrade then
            icon = LootAlertFrame_UI.UPGRADE_BACKGROUND
            textColor = LootAlertFrame_UI.TEXT_COLOR_GREEN
        elseif isDowngrade then
            icon = LootAlertFrame_UI.DOWNGRADE_BACKGROUND
            textColor = LootAlertFrame_UI.TEXT_COLOR_RED
        else
            icon = TEXTURE_NIL
            textColor = LootAlertFrame_UI.TEXT_COLOR_GRAY
        end
        frame.ItemComparison.Icon:background(icon)
        LootAlertFrame_UI.ItemComparisonTextColor:Set(textColor)
        self.ItemComparison.ItemLevel:SetText(itemLevel)

        self:_Render()
    end

    function LootAlertPopupMixin:SetSpinner()
        self:SetInstruction(nil, L["Modules - Loot - LootAlertPopup - Equipping"])
        LootAlertFrame_UI.PrimaryTextColor:Set(LootAlertFrame_UI.TEXT_COLOR_WHITE)

        self:SetFrame(FRAME_ID.Spinner)
        self:_Render()
    end

    function LootAlertPopupMixin:SetTick()
        self:SetInstruction(nil, L["Modules - Loot - LootAlertPopup - Equipped"])
        LootAlertFrame_UI.PrimaryTextColor:Set(LootAlertFrame_UI.TEXT_COLOR_GREEN)

        self:SetFrame(FRAME_ID.Tick)
        self:_Render()
    end

    function LootAlertPopupMixin:ShowFrame()
        if self.hideTimer then self.hideTimer:Cancel() end

        self.isShown = true
        self:Show()
        self.AnimDefinition:Play(self, "INTRO")
    end

    function LootAlertPopupMixin:HideFrame()
        self.AnimDefinition:Play(self, "OUTRO")

        self.isShown = false
        if self.hideTimer then self.hideTimer:Cancel() end
        self.hideTimer = C_Timer.NewTimer(0.5, function()
            self:Hide()
        end)
    end

    Mixin(frame, LootAlertPopupMixin)
    frame:OnLoad()


    frame:Hide()
    frame.ItemComparison:Hide()
    frame.Spinner:Hide()
    frame.Tick:Hide()
end
