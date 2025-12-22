local env                                                                                                                                          = select(2, ...)
local Config                                                                                                                                       = env.Config
local Path                                                                                                                                         = env.WPM:Import("wpm_modules\\path")
local UIFont                                                                                                                                       = env.WPM:Import("wpm_modules\\ui-font")
local UIKit                                                                                                                                        = env.WPM:Import("wpm_modules\\ui-kit")
local Frame, LayoutGrid, LayoutVertical, LayoutHorizontal, ScrollView, ScrollBar, Text, Input, LinearSlider, InteractiveRect, LazyScrollView, List = UIKit.UI.Frame, UIKit.UI.LayoutGrid, UIKit.UI.LayoutVertical, UIKit.UI.LayoutHorizontal, UIKit.UI.ScrollView, UIKit.UI.ScrollBar, UIKit.UI.Text, UIKit.UI.Input, UIKit.UI.LinearSlider, UIKit.UI.InteractiveRect, UIKit.UI.LazyScrollView, UIKit.UI.List
local React                                                                                                                                        = env.WPM:Import("wpm_modules\\react")
local GenericEnum                                                                                                                                  = env.WPM:Import("wpm_modules\\generic-enum")
local SavedVariables                                                                                                                               = env.WPM:Import("wpm_modules\\saved-variables")
local function IsModuleEnabled() return Config.DBGlobal:GetVariable("PlacedDecorList") == true end

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded


local isLoaded = false
local function OnLoad()
    if isLoaded then return end
    isLoaded = true

    local PlacedDecorList = HouseEditorFrame.ExpertDecorModeFrame.PlacedDecorList


    -- UI
    ----------------------------------------------------------------------------------------------------

    local ATLAS                  = UIKit.Define.Texture_Atlas{ path = Path.Root .. "\\Art\\Housing\\HouseUI.png", inset = 0, scale = 1 }
    local FIT                    = UIKit.Define.Fit{}
    local ICON_BACKGROUND_NORMAL = ATLAS{ left = 0 / 256, right = 32 / 256, top = 0 / 256, bottom = 32 / 256 }
    local COLOR_NORMAL           = UIKit.Define.Color_HEX{ hex = "ff7B7B7B" }
    local COLOR_HIGHLIGHTED      = UIKit.Define.Color_RGBA{ r = GenericEnum.ColorRGB.NormalText.r * 255, g = GenericEnum.ColorRGB.NormalText.g * 255, b = GenericEnum.ColorRGB.NormalText.b * 255, a = 1 }


    local ListInfoMixin = {}

    function ListInfoMixin:OnLoad()
        self:SetHighlighted(false)
    end

    function ListInfoMixin:SetText(text)
        self.Text:SetText(text)
    end

    function ListInfoMixin:SetHighlighted(isHighlighted)
        local color = isHighlighted and COLOR_HIGHLIGHTED or COLOR_NORMAL
        self.Icon:backgroundColor(color)
        self.Text:textColor(color)
    end

    local ListInfo = UIKit.Prefab(function(id, name, children, ...)
        local frame = LayoutHorizontal(name, {
                Frame(name .. ".Icon")
                    :id("Icon", id)
                    :size(12, 12)
                    :background(ICON_BACKGROUND_NORMAL),

                Text(name .. ".Text")
                    :id("Text", id)
                    :size(FIT, 12)
                    :fontObject(UIFont.UIFontObjectNormal12)
                    :textJustifyH("RIGHT")
                    :textJustifyV("MIDDLE")
            })
            :size(FIT, 12)
            :point(UIKit.Enum.Point.Right)
            :layoutSpacing(2)
            :x(-8)


        frame.Icon = UIKit.GetElementById("Icon", id)
        frame.Text = UIKit.GetElementById("Text", id)

        Mixin(frame, ListInfoMixin)
        frame:OnLoad()

        return frame
    end)

    local function SetupListFrame(frame)
        if not frame.__manifoldSetup then
            frame.__manifoldSetup = true

            frame.ListInfo = ListInfo()
                :parent(frame)
        end
    end


    -- Hook
    ----------------------------------------------------------------------------------------------------

    hooksecurefunc(HouseEditorPlacedDecorEntryMixin, "Init", function(self, elementData)
        if not IsModuleEnabled() then return end

        if not elementData or not elementData.decorGUID then return end
        local info = C_HousingDecor.GetDecorInstanceInfoForGUID(elementData.decorGUID)
        local catalogInfo = C_HousingCatalog.GetCatalogEntryInfoByRecordID(1, info.decorID, true)
        local placementCost = catalogInfo.placementCost

        SetupListFrame(self)
        self.ListInfo:SetHighlighted(self.isSelected)
        if self.ListInfo.Text:GetText() ~= placementCost then
            self.ListInfo:SetText(placementCost)
            self.ListInfo:_Render()
        end
    end)

    hooksecurefunc(HouseEditorPlacedDecorEntryMixin, "UpdateVisuals", function(self, ...)
        if self.ListInfo then
            if not IsModuleEnabled() then
                if self.ListInfo:IsShown() then self.ListInfo:Hide() end
                return
            end

            if not self.ListInfo:IsShown() then self.ListInfo:Show() end
            self.ListInfo:SetHighlighted(self.isSelected)
        end
    end)


    -- Additional Features
    ----------------------------------------------------------------------------------------------------

    do -- Add resize button to PlacedDecorList
        local isResizeButtonCreated = false

        local function InitResizeButton()
            local BACKGROUND_RESIZE = ATLAS{ left = 0 / 256, right = 32 / 256, top = 32 / 256, bottom = 64 / 256 }

            PlacedDecorList:SetResizable(true)
            PlacedDecorList.minWidth = 225
            PlacedDecorList.minHeight = 225
            PlacedDecorList.maxWidth = 725
            PlacedDecorList.maxHeight = 725

            PlacedDecorList.ResizeButton = Frame("ResizeButton", {
                    Frame("ResizeButton.Background")
                        :size(20, 20)
                        :point(UIKit.Enum.Point.BottomRight)
                        :background(BACKGROUND_RESIZE)
                })
                :parent(PlacedDecorList)
                :size(20, 20)
                :point(UIKit.Enum.Point.BottomRight)
                :position(5, -4)
                :_Render()

            Mixin(PlacedDecorList.ResizeButton, PanelResizeButtonMixin)
            PlacedDecorList.ResizeButton:SetScript("OnEnter", PlacedDecorList.ResizeButton.OnEnter)
            PlacedDecorList.ResizeButton:SetScript("OnLeave", PlacedDecorList.ResizeButton.OnLeave)
            PlacedDecorList.ResizeButton:SetScript("OnMouseDown", PlacedDecorList.ResizeButton.OnMouseDown)
            PlacedDecorList.ResizeButton:SetScript("OnMouseUp", PlacedDecorList.ResizeButton.OnMouseUp)
            PlacedDecorList.ResizeButton:Init(PlacedDecorList, PlacedDecorList.minWidth, PlacedDecorList.minHeight, PlacedDecorList.maxWidth, PlacedDecorList.maxHeight)

            PlacedDecorList:HookScript("OnShow", function()
                if not PlacedDecorList.ResizeButton.__rendered then
                    PlacedDecorList.ResizeButton.__rendered = true
                    PlacedDecorList.ResizeButton:_Render()
                end
            end)
        end

        local function UpdateResize()
            if not isResizeButtonCreated then
                InitResizeButton()
                isResizeButtonCreated = true
            end

            PlacedDecorList.ResizeButton:SetShown(IsModuleEnabled())
        end

        UpdateResize()
        SavedVariables.OnChange("ManifoldDB_Global", "PlacedDecorList", UpdateResize)
    end
end

if IsAddOnLoaded("Blizzard_HouseEditor") then
    OnLoad()
else
    EventUtil.ContinueOnAddOnLoaded("Blizzard_HouseEditor", OnLoad)
end
