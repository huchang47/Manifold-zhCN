local env       = select(2, ...)
local Config    = env.Config
local LazyTimer = env.WPM:Import("wpm_modules\\lazy-timer")
local function IsModuleEnabled() return Config.DBGlobal:GetVariable("HouseChest") == true end

local IsAddOnLoaded            = C_AddOns.IsAddOnLoaded
local GetActiveHouseEditorMode = C_HouseEditor.GetActiveHouseEditorMode
local GetPrecisionSubmode      = C_HousingExpertMode.GetPrecisionSubmode


local isLoaded = false
local Data = {}

local function ResetData()
    Data.lastEditMode                    = Enum.HouseEditorMode.BasicDecor
    Data.lastExpertPrecisionSubmode      = Enum.HousingPrecisionSubmode.Translate
    Data.lastEditModeChangeTime          = 0
    Data.lastDecorPlacementTime          = 0
    Data.isCurrentPlacementFromOtherMode = nil
    Data.isHouseChestHighlighted         = false
    Data.isHouseChestCollapsed           = false
    Data.isPlacedDecorListOpen           = false
end

ResetData()


local function OnLoad()
    if isLoaded then return end
    isLoaded = true

    local function IsPlacementFromOtherMode()
        -- allow 1 sec threshold
        if abs(Data.lastEditModeChangeTime - Data.lastDecorPlacementTime) < 1 and HouseEditorFrame.StoragePanel:IsShown() and Data.isHouseChestHighlighted then
            return true
        end
        return false
    end

    local function OnDecorPlacementBegin(targetType)
        if targetType == Enum.HousingBasicModeTargetType.Decor then
        elseif targetType == Enum.HousingBasicModeTargetType.House then
        end

        Data.isCurrentPlacementFromOtherMode = (IsPlacementFromOtherMode() and Data.lastEditMode) or nil
    end

    local function OnDecorPlacementEnd()
        if Data.lastEditMode ~= Enum.HouseEditorMode.BasicDecor then
            -- Revert to previous mode
            C_HouseEditor.ActivateHouseEditorMode(Data.lastEditMode)

            -- Revert precision submode for expert decor mode, and revert Placed Decor List visibility
            if Data.isCurrentPlacementFromOtherMode == Enum.HouseEditorMode.ExpertDecor then
                C_HousingExpertMode.SetPrecisionSubmode(Data.lastExpertPrecisionSubmode or Enum.HousingPrecisionSubmode.Translate)
                HouseEditorFrame.ExpertDecorModeFrame.PlacedDecorList:SetShown(Data.isPlacedDecorListOpen)
            end
        end
        ResetData()
    end

    local function OnEditorClose()
        ResetData()
    end

    local f = CreateFrame("Frame")
    f:RegisterEvent("HOUSE_EDITOR_MODE_CHANGED")
    f:RegisterEvent("HOUSING_DECOR_PRECISION_SUBMODE_CHANGED")
    f:RegisterEvent("HOUSING_BASIC_MODE_SELECTED_TARGET_CHANGED")
    f:RegisterEvent("GLOBAL_MOUSE_DOWN")
    f:SetScript("OnEvent", function(self, event, ...)
        if not IsModuleEnabled() then return end

        -- House Chest
        if event == "HOUSE_EDITOR_MODE_CHANGED" then
            local mode = ...
            if mode == Enum.HouseEditorMode.None then
                OnEditorClose()
            else
                Data.isHouseChestCollapsed = HouseEditorFrame.StoragePanel:IsCollapsed()
            end
        end

        -- Placement
        if event == "HOUSING_BASIC_MODE_SELECTED_TARGET_CHANGED" then
            Data.lastDecorPlacementTime = GetTime()

            local selected, targetType = ...
            if selected then
                OnDecorPlacementBegin(targetType)
            else
                OnDecorPlacementEnd()
            end
        end

        -- Check for mouse down over HouseEditorFrame.StoragePanel
        if event == "GLOBAL_MOUSE_DOWN" then
            local button = ...
            if button == "LeftButton" then
                Data.isHouseChestHighlighted = HouseEditorFrame.StoragePanel:IsMouseOver()
                if Data.isHouseChestHighlighted then
                    -- Save our current state prior to placement
                    local currentEditMode = GetActiveHouseEditorMode()
                    Data.lastEditMode = currentEditMode
                    Data.lastEditModeChangeTime = GetTime()
                    if currentEditMode == Enum.HouseEditorMode.ExpertDecor then
                        Data.lastExpertPrecisionSubmode = GetPrecisionSubmode()
                    end
                end
            end
        end
    end)

    local function UpdatePlacedDecorListState()
        Data.isPlacedDecorListOpen = HouseEditorFrame.ExpertDecorModeFrame.PlacedDecorList:IsShown()
    end

    HouseEditorFrame.ExpertDecorModeFrame.PlacedDecorList:HookScript("OnShow", UpdatePlacedDecorListState)
    HouseEditorFrame.ExpertDecorModeFrame.PlacedDecorList:HookScript("OnHide", UpdatePlacedDecorListState)

    do -- Force show House Chest
        local Timer = LazyTimer.New()
        Timer:SetAction(function()
            if not HouseEditorFrame or not HouseEditorFrame.StoragePanel then return end
            HouseEditorFrame.StoragePanel:Show()
            HouseEditorFrame.StorageButton:Show()
            HouseEditorFrame.StoragePanel:SetCollapsed(Data.isHouseChestCollapsed)
        end)

        local function ForceShowStorage()
            Timer:Start(0)
        end

        EventRegistry:RegisterCallback("HouseEditor.HouseStorageSetShown", function(_, shown)
            if not IsModuleEnabled() then return end

            if not shown and GetActiveHouseEditorMode() ~= Enum.HouseEditorMode.BasicDecor then
                ForceShowStorage()
            end
        end)
    end
end

if IsAddOnLoaded("Blizzard_HouseEditor") then
    OnLoad()
else
    EventUtil.ContinueOnAddOnLoaded("Blizzard_HouseEditor", OnLoad)
end
