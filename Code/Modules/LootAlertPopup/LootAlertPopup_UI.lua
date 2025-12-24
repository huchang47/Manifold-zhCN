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


Frame("Manifold_LootAlertPopup", {
    Frame("Manifold_LootAlertPopup.Content", {
        Frame("Manifold_LootAlertPopup.Background")
            :id("Manifold_LootAlertPopup.Background")
            :frameLevel(1000)
            :size(UIKit.Define.Fill{ delta = -8 })
            :background(BACKGROUND_TEXTURE),

        Frame("Manifold_LootAlertPopup.Main", {
            LayoutHorizontal("Manifold_LootAlertPopup.Instruction", {
                Frame("Manifold_LootAlertPopup.Instruction.Hint")
                    :id("Manifold_LootAlertPopup.Instruction.Hint")
                    :frameLevel(1002)
                    :size(CONTENT_SIZE, CONTENT_SIZE)
                    :background(LMB_BACKGROUND),

                Text("Manifold_LootAlertPopup.Instruction.Text")
                    :id("Manifold_LootAlertPopup.Instruction.Text")
                    :frameLevel(1002)
                    :size(UIKit.Define.Fit{}, CONTENT_SIZE)
                    :fontObject(UIFont.UIFontObjectNormal12)
                    :textColor(LootAlertFrame_UI.PrimaryTextColor)
            })
                :id("Manifold_LootAlertPopup.Instruction")
                :frameLevel(1002)
                :point(UIKit.Enum.Point.Left)
                :size(UIKit.Define.Fit{}, CONTENT_SIZE)
                :layoutAlignmentV(UIKit.Enum.Direction.Justified)
                :layoutSpacing(2),

            LayoutHorizontal("Manifold_LootAlertPopup.ItemComparison", {
                Frame("Manifold_LootAlertPopup.ItemComparison.Icon")
                    :id("Manifold_LootAlertPopup.ItemComparison.Icon")
                    :frameLevel(1002)
                    :size(CONTENT_SIZE, CONTENT_SIZE)
                    :background(TEXTURE_NIL),

                Text("Manifold_LootAlertPopup.ItemComparison.ItemLevel")
                    :id("Manifold_LootAlertPopup.ItemComparison.ItemLevel")
                    :frameLevel(1002)
                    :size(UIKit.Define.Fit{}, CONTENT_SIZE)
                    :fontObject(UIFont.UIFontObjectNormal12)
                    :textColor(LootAlertFrame_UI.ItemComparisonTextColor)
            })
                :id("Manifold_LootAlertPopup.ItemComparison")
                :frameLevel(1002)
                :point(UIKit.Enum.Point.Right)
                :size(UIKit.Define.Fit{}, CONTENT_SIZE)
                :layoutAlignmentV(UIKit.Enum.Direction.Justified)
                :layoutSpacing(-2),

            Frame("Manifold_LootAlertPopup.Spinner")
                :id("Manifold_LootAlertPopup.Spinner")
                :frameLevel(1002)
                :point(UIKit.Enum.Point.Right)
                :size(CONTENT_SIZE, CONTENT_SIZE)
                :background(SPINNER_BACKGROUND)
                :backgroundColor(LootAlertFrame_UI.PrimaryTextColor),

            Frame("Manifold_LootAlertPopup.Tick")
                :id("Manifold_LootAlertPopup.Tick")
                :frameLevel(1002)
                :point(UIKit.Enum.Point.Right)
                :size(CONTENT_SIZE, CONTENT_SIZE)
                :background(TICK_BACKGROUND)

        })
            :id("Manifold_LootAlertPopup.Main")
            :frameLevel(1001)
            :point(UIKit.Enum.Point.Center)
            :size(UIKit.Define.Percentage{ value = 100, operator = "-", delta = CONTENT_SIZE }, UIKit.Define.Percentage{ value = 100, operator = "-", delta = CONTENT_SIZE })
    })
        :id("Manifold_LootAlertPopup.Content")
        :frameLevel(1001)
        :point(UIKit.Enum.Point.Center)
        :size(UIKit.Define.Percentage{ value = 100 }, UIKit.Define.Percentage{ value = 100 })
})
    :id("Manifold_LootAlertPopup")
    :parent(UIParent)
    :frameStrata(UIKit.Enum.FrameStrata.Tooltip, 999)
    :size(175, 32)
    :_Render()


Manifold_LootAlertPopup                          = UIKit.GetElementById("Manifold_LootAlertPopup")
Manifold_LootAlertPopup.Background               = UIKit.GetElementById("Manifold_LootAlertPopup.Background")
Manifold_LootAlertPopup.BackgroundTexture        = Manifold_LootAlertPopup.Background:GetBackground()
Manifold_LootAlertPopup.Content                  = UIKit.GetElementById("Manifold_LootAlertPopup.Content")
Manifold_LootAlertPopup.Main                     = UIKit.GetElementById("Manifold_LootAlertPopup.Main")
Manifold_LootAlertPopup.Instruction              = UIKit.GetElementById("Manifold_LootAlertPopup.Instruction")
Manifold_LootAlertPopup.Instruction.Hint         = UIKit.GetElementById("Manifold_LootAlertPopup.Instruction.Hint")
Manifold_LootAlertPopup.Instruction.Text         = UIKit.GetElementById("Manifold_LootAlertPopup.Instruction.Text")
Manifold_LootAlertPopup.ItemComparison           = UIKit.GetElementById("Manifold_LootAlertPopup.ItemComparison")
Manifold_LootAlertPopup.ItemComparison.Icon      = UIKit.GetElementById("Manifold_LootAlertPopup.ItemComparison.Icon")
Manifold_LootAlertPopup.ItemComparison.ItemLevel = UIKit.GetElementById("Manifold_LootAlertPopup.ItemComparison.ItemLevel")
Manifold_LootAlertPopup.Spinner                  = UIKit.GetElementById("Manifold_LootAlertPopup.Spinner")
Manifold_LootAlertPopup.Tick                     = UIKit.GetElementById("Manifold_LootAlertPopup.Tick")


Manifold_LootAlertPopup.AnimDefinition = UIAnim.New()
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

    Manifold_LootAlertPopup.AnimDefinition:State("INTRO", function(frame)
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

    Manifold_LootAlertPopup.AnimDefinition:State("OUTRO", function(frame)
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

    Manifold_LootAlertPopup.AnimDefinition:State("TRANSITION", function(frame)
        TransitionAlpha:Play(frame.Main)
        TransitionTranslate:Play(frame.Main)
    end)
end

do -- Spinner
    Manifold_LootAlertPopup.Spinner.AnimDefinition = UIAnim.New()

    local Rotate = UIAnim.Animate()
        :property(UIAnim.Enum.Property.Rotation)
        :duration(1)
        :from(0)
        :to(-360)
        :easing(UIAnim.Enum.Easing.Linear)
        :loop(UIAnim.Enum.Looping.Reset)

    Manifold_LootAlertPopup.Spinner.AnimDefinition:State("PLAYBACK", function(frame)
        Rotate:Play(frame)
    end)

    local function UpdateAnimation(self, isShown)
        if isShown then
            if not self.AnimDefinition:IsPlaying(self, "PLAYBACK") then
                self.AnimDefinition:Play(Manifold_LootAlertPopup.Spinner:GetBackground(), "PLAYBACK")
            end
        else
            if self.AnimDefinition:IsPlaying(self, "PLAYBACK") then
                self.AnimDefinition:Stop()
            end
        end
    end

    hooksecurefunc(Manifold_LootAlertPopup.Spinner, "Show", function(self) UpdateAnimation(self, true) end)
    hooksecurefunc(Manifold_LootAlertPopup.Spinner, "Hide", function(self) UpdateAnimation(self, false) end)
    hooksecurefunc(Manifold_LootAlertPopup.Spinner, "SetShown", UpdateAnimation)
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
    self:SetInstruction(not inCombat and LMB_BACKGROUND, inCombat and L["Modules - Loot - LootAlertPopup - Combat"] or L["Modules - Loot - LootAlertPopup - Equip"])
    LootAlertFrame_UI.PrimaryTextColor:Set(inCombat and LootAlertFrame_UI.TEXT_COLOR_RED or LootAlertFrame_UI.TEXT_COLOR_WHITE)

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
    Manifold_LootAlertPopup.ItemComparison.Icon:background(icon)
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

Mixin(Manifold_LootAlertPopup, LootAlertPopupMixin)
Manifold_LootAlertPopup:OnLoad()


Manifold_LootAlertPopup:Hide()
Manifold_LootAlertPopup.ItemComparison:Hide()
Manifold_LootAlertPopup.Spinner:Hide()
Manifold_LootAlertPopup.Tick:Hide()
