local env              = select(2, ...)

local Sound            = env.WPM:Import("wpm_modules\\sound")
local CallbackRegistry = env.WPM:Import("wpm_modules\\callback-registry")
local UIFont           = env.WPM:Import("wpm_modules\\ui-font")
local SavedVariables   = env.WPM:Import("wpm_modules\\saved-variables")
local Path             = env.WPM:Import("wpm_modules\\path")

env.NAME               = "Manifold"
env.ICON               = Path.Root .. "\\Art\\Icon\\Icon.png"
env.ICON_ALT           = Path.Root .. "\\Art\\Icon\\IconAlt.png"
env.VERSION_STRING     = "Alpha 6"
env.VERSION_NUMBER     = 000060
env.DEBUG_MODE         = false


local L = {}; env.L = L


local Enum = {}; env.Enum = Enum
do

end


local Config = {}; env.Config = Config
do
    Config.DBGlobal                     = nil
    Config.DBGlobalPersistent           = nil
    Config.DBLocal                      = nil
    Config.DBLocalPersistent            = nil

    local NAME_GLOBAL                   = "ManifoldDB_Global"
    local NAME_GLOBAL_PERSISTENT        = "ManifoldDB_Global_Persistent"
    local NAME_LOCAL                    = "ManifoldDB_Local"
    local NAME_LOCAL_PERSISTENT         = "ManifoldDB_Local_Persistent"

    ---@format disable
    local DB_GLOBAL_DEFAULTS            = {
        lastLoadedVersion = nil,

        --Housing
        DecorMerchant = true,
        HouseChest = true,
        PlacedDecorList = true,
        DecorTooltip = false,

        --Tooltip
        QuestDetailTooltip = true,
        ExperienceBarTooltip = true,

        --Loot
        LootAlertPopup = true,

        --Events
        MidnightPrepatch = true
    }
    local DB_GLOBAL_PERSISTENT_DEFAULTS = {}
    local DB_LOCAL_DEFAULTS             = {}
    local DB_LOCAL_PERSISTENT_DEFAULTS  = {}
    ---@format enable

    local DB_GLOBAL_MIGRATION           = {}

    function Config.LoadDB()
        if ManifoldDB_Global and ManifoldDB_Global.lastLoadedVersion == env.VERSION_NUMBER then
            -- Same version, skip migration
            SavedVariables.RegisterDatabase(NAME_GLOBAL).defaults(DB_GLOBAL_DEFAULTS)
            SavedVariables.RegisterDatabase(NAME_GLOBAL_PERSISTENT).defaults(DB_GLOBAL_PERSISTENT_DEFAULTS)
        else
            -- Migrate if new version
            SavedVariables.RegisterDatabase(NAME_GLOBAL).defaults(DB_GLOBAL_DEFAULTS).migrationPlan(DB_GLOBAL_MIGRATION)
            SavedVariables.RegisterDatabase(NAME_GLOBAL_PERSISTENT).defaults(DB_GLOBAL_PERSISTENT_DEFAULTS)
        end

        SavedVariables.RegisterDatabase(NAME_LOCAL).defaults(DB_LOCAL_DEFAULTS)
        SavedVariables.RegisterDatabase(NAME_LOCAL_PERSISTENT).defaults(DB_LOCAL_PERSISTENT_DEFAULTS)

        Config.DBGlobal = SavedVariables.GetDatabase(NAME_GLOBAL)
        Config.DBGlobalPersistent = SavedVariables.GetDatabase(NAME_GLOBAL_PERSISTENT)
        Config.DBLocal = SavedVariables.GetDatabase(NAME_LOCAL)
        Config.DBLocalPersistent = SavedVariables.GetDatabase(NAME_LOCAL_PERSISTENT)

        CallbackRegistry.Trigger("Preload.DatabaseReady")
    end
end


local SoundHandler = {}
do
    local function UpdateMainSoundLayer()
        local Setting_AudioGlobal = Config.DBGlobal:GetVariable("AudioGlobal")

        if Setting_AudioGlobal == true then
            Sound.SetEnabled("Main", true)
        elseif Setting_AudioGlobal == false then
            Sound.SetEnabled("Main", false)
        end
    end

    SavedVariables.OnChange("ManifoldDB_Global", "AudioGlobal", UpdateMainSoundLayer)

    function SoundHandler.Load()
        UpdateMainSoundLayer()
    end
end


local FontHandler = {}
do
    local function UpdateFonts()
        UIFont.CustomFont:RefreshFontList()

        local selectedFontIndex = Config.DBGlobal:GetVariable("PrefFont")
        local fontPath = UIFont.CustomFont.GetFontPathForIndex(selectedFontIndex)

        UIFont.UIFontObjectNormal8:SetFontFile(fontPath)
        UIFont.UIFontObjectNormal10:SetFontFile(fontPath)
        UIFont.UIFontObjectNormal11:SetFontFile(fontPath)
        UIFont.UIFontObjectNormal12:SetFontFile(fontPath)
        UIFont.UIFontObjectNormal14:SetFontFile(fontPath)
        UIFont.UIFontObjectNormal16:SetFontFile(fontPath)
        UIFont.UIFontObjectNormal18:SetFontFile(fontPath)
    end

    SavedVariables.OnChange("ManifoldDB_Global", "PrefFont", UpdateFonts)

    function FontHandler.Load()
        UpdateFonts()
    end
end


local function OnAddonLoaded()
    Config.LoadDB()
    SoundHandler.Load()
    C_Timer.After(0, FontHandler.Load)

    Config.DBGlobal:SetVariable("lastLoadedVersion", env.VERSION_NUMBER)
    CallbackRegistry.Trigger("Preload.AddonReady")
end

CallbackRegistry.Add("WoWClient.OnAddonLoaded", OnAddonLoaded)
