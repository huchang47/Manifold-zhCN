local env              = select(2, ...)
local L                = env.L
local Config           = env.Config
local Path             = env.WPM:Import("wpm_modules\\path")
local WoWClient        = env.WPM:Import("wpm_modules\\wow-client")
local GenericEnum      = env.WPM:Import("wpm_modules\\generic-enum")
local Utils_InlineIcon = env.WPM:Import("wpm_modules\\utils\\inline-icon")
local function IsModuleEnabled() return Config.DBGlobal:GetVariable("DecorTooltip") == true end

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded


local isLoaded = false

local function OnLoad()
    if isLoaded then return end
    isLoaded = true


    local isDecorTooltip = true
    local PLACEMENT_COST_INLINE_ICON = Utils_InlineIcon.New(
        {
            path   = Path.Root .. "\\Art\\Housing\\HouseUI.png",
            width  = 256,
            height = 256,
            left   = 0,
            right  = 32,
            top    = 0,
            bottom = 32
        }, 12, 12, 0, 0, GenericEnum.ColorRGB255.NormalText
    ) .. " "


    local function ShowTooltip(isExpertDecorSelectionHovered)
        if HouseEditorFrame.ExpertDecorModeFrame.PlacedDecorList:IsMouseOver() then return end
        if WoWClient.IsPlayerTurning or WoWClient.IsPlayerLooking then return end

        local selectedDecorInfo = C_HousingDecor.GetSelectedDecorInfo()
        local hoveredDecorInfo  = (isExpertDecorSelectionHovered and selectedDecorInfo or C_HousingDecor.GetHoveredDecorInfo())
        if not hoveredDecorInfo then return end
        if selectedDecorInfo and hoveredDecorInfo.decorGUID and selectedDecorInfo.decorGUID == hoveredDecorInfo.decorGUID then return end

        local catalogInfo = C_HousingCatalog.GetCatalogEntryInfoByRecordID(Enum.HousingCatalogEntryType.Decor, hoveredDecorInfo.decorID, true)
        if not catalogInfo then return end

        local placementCost = catalogInfo.placementCost
        local quality       = hoveredDecorInfo.quality or (catalogInfo and catalogInfo.quality)
        local qualityColor  = (quality and ITEM_QUALITY_COLORS[quality]) or GenericEnum.ColorRGB01.White

        GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR_RIGHT")
        GameTooltip:AddDoubleLine(hoveredDecorInfo.name, PLACEMENT_COST_INLINE_ICON .. placementCost, qualityColor.r, qualityColor.g, qualityColor.b, GenericEnum.ColorRGB01.NormalText.r, GenericEnum.ColorRGB01.NormalText.g, GenericEnum.ColorRGB01.NormalText.b)
        GameTooltip:AddLine(L["Modules - Housing - DecorTooltip - LeftClick"])
        GameTooltip:Show()

        isDecorTooltip = true
    end


    local f = CreateFrame("Frame")
    f:RegisterEvent("HOUSING_BASIC_MODE_HOVERED_TARGET_CHANGED")
    f:RegisterEvent("HOUSING_EXPERT_MODE_HOVERED_TARGET_CHANGED")
    f:RegisterEvent("HOUSING_CUSTOMIZE_MODE_HOVERED_TARGET_CHANGED")
    f:RegisterEvent("HOUSING_CLEANUP_MODE_HOVERED_TARGET_CHANGED")
    f:RegisterEvent("HOUSING_DECOR_PRECISION_MANIPULATION_EVENT")
    f:RegisterEvent("HOUSE_EDITOR_MODE_CHANGED")
    f:RegisterEvent("WORLD_CURSOR_TOOLTIP_UPDATE")
    f:SetScript("OnEvent", function(self, event, ...)
        if not IsModuleEnabled() then return end

        local editorMode = C_HouseEditor.GetActiveHouseEditorMode()
        local selectedDecorInfo = C_HousingDecor.GetSelectedDecorInfo()
        local hoveredDecorInfo = C_HousingDecor.GetHoveredDecorInfo()

        if selectedDecorInfo and hoveredDecorInfo and hoveredDecorInfo.decorGUID and selectedDecorInfo.decorGUID == hoveredDecorInfo.decorGUID then
            if GameTooltip:IsShown() and isDecorTooltip then
                GameTooltip:Hide()
            end
            return
        end

        local isExpertDecorSelectionHovered = event == "HOUSING_DECOR_PRECISION_MANIPULATION_EVENT" and ... == Enum.TransformManipulatorEvent.Hover
        local isHoveringDecor = C_HousingDecor.IsHoveringDecor()
        local isValidMode = editorMode == Enum.HouseEditorMode.BasicDecor or editorMode == Enum.HouseEditorMode.ExpertDecor
        if (isHoveringDecor or isExpertDecorSelectionHovered) and isValidMode then
            ShowTooltip(isExpertDecorSelectionHovered)
        elseif GameTooltip:IsShown() and isDecorTooltip then
            GameTooltip:Hide()
        end
    end)

    GameTooltip:HookScript("OnHide", function()
        isDecorTooltip = false
    end)
end


if IsAddOnLoaded("Blizzard_HouseEditor") then
    OnLoad()
else
    EventUtil.ContinueOnAddOnLoaded("Blizzard_HouseEditor", OnLoad)
end
