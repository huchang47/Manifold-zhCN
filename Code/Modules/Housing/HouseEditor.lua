local env              = select(2, ...)
local Config           = env.Config
local CallbackRegistry = env.WPM:Import("wpm_modules\\callback-registry")
local WoWClient        = env.WPM:Import("wpm_modules\\wow-client")

local IsAddOnLoaded            = C_AddOns.IsAddOnLoaded
local ActivateHouseEditorMode  = C_HouseEditor.ActivateHouseEditorMode
local SetPrecisionSubmode      = C_HousingExpertMode.SetPrecisionSubmode


local isLoaded = false

local function OnLoad()
    if isLoaded then return end
    isLoaded = true


    local KEYBINDS_TO_SUBMODE_MAP = {
        HOUSING_EXPERTDECORTRANSLATESUBMODE = Enum.HousingPrecisionSubmode.Translate,
        HOUSING_EXPERTDECORROTATESUBMODE    = Enum.HousingPrecisionSubmode.Rotate,
        HOUSING_EXPERTDECORSCALESUBMODE     = Enum.HousingPrecisionSubmode.Scale
    }

    CallbackRegistry.Add("WoWClient.OnKeyDown", function(event, key)
        for binding, submode in pairs(KEYBINDS_TO_SUBMODE_MAP) do
            if WoWClient.IsKeyBinding(key, binding) then
                WoWClient.BlockKeyEvent()

                ActivateHouseEditorMode(Enum.HouseEditorMode.ExpertDecor)
                SetPrecisionSubmode(submode)
            end
        end
    end)
end


if IsAddOnLoaded("Blizzard_HouseEditor") then
    OnLoad()
else
    EventUtil.ContinueOnAddOnLoaded("Blizzard_HouseEditor", OnLoad)
end
