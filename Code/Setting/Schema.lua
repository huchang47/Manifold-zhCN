--[[
    widgetName:                         string
    widgetDecsription:                  Setting_Define.Descriptor
    widgetType:                         Setting_Enum.WidgetType
    widgetTransparent:                  boolean

    Shared:
        key:                            string
        set:                            function

    Tab:
        widgetTab_isFooter:             boolean

    Title:
        widgetTitle_info:               Setting_Define.TitleInfo

    Container:
        widgetContainer_isNested:       boolean

    Text:

    Range:
        widgetRange_min:                number|function
        widgetRange_max:                number|function
        widgetRange_step:               number|function
        widgetRange_textFormatting      string (%s: value)
        widgetRange_textFormattingFunc: function

    Button:
        widgetButton_text:              string
        widgetButton_refreshOnClick:    boolean

    CheckButton:

    SelectionMenu:
        widgetSelectionMenu_data:       table|function

    Color Input:

    Input:
        widgetInput_placeholder:        string|function

    disableWhen:                        function
    showWhen:                           function
    indent:                             number
    children:                           table
]]


local env            = select(2, ...)
local Config         = env.Config
local L              = env.L

local Path           = env.WPM:Import("wpm_modules\\path")
local Sound          = env.WPM:Import("wpm_modules\\sound")
local UIFont         = env.WPM:Import("wpm_modules\\ui-font")
local LocalUtil      = env.WPM:Import("@\\LocalUtil")
local Setting_Define = env.WPM:Import("@\\Setting\\Define")
local Setting_Enum   = env.WPM:Import("@\\Setting\\Enum")
local Setting_Shared = env.WPM:Import("@\\Setting\\Shared")
local Setting_Schema = env.WPM:New("@\\Setting\\Schema")


-- Shared
----------------------------------------------------------------------------------------------------

local SETTING_PROMPT = _G[Setting_Shared.FRAME_NAME].Prompt


local function HandleAccept()
    Config.DBGlobal:Wipe()
    ReloadUI()
end

local RESET_SETTING_PROMPT_INFO = {
    text         = L["Config - General - Other - ResetPrompt"],
    options      = {
        {
            text     = L["Config - General - Other - ResetPrompt - Yes"],
            callback = HandleAccept
        },
        {
            text     = L["Config - General - Other - ResetPrompt - No"],
            callback = nil
        }
    },
    hideOnEscape = true,
    timeout      = 10
}


-- Schema
----------------------------------------------------------------------------------------------------

local function GetIcon(name) return Path.Root .. "\\Art\\Setting\\Icon\\" .. name .. ".png" end
local function GetModulePreviewImage(name) return Path.Root .. "\\Art\\ModulePreview\\" .. name .. ".png" end


Setting_Schema.SCHEMA = {
    {
        widgetName = L["Config - General"],
        widgetType = Setting_Enum.WidgetType.Tab,
        children   = {
            {
                widgetName       = L["Config - General - Title"],
                widgetType       = Setting_Enum.WidgetType.Title,
                widgetTitle_info = Setting_Define.TitleInfo{ imagePath = GetIcon("Cog"), text = L["Config - General - Title"], subtext = L["Config - General - Title - Subtext"] }
            },
            {
                widgetName = L["Config - General - Other"],
                widgetType = Setting_Enum.WidgetType.Container,
                children   = {
                    {
                        widgetName        = nil,
                        widgetType        = Setting_Enum.WidgetType.Button,
                        widgetButton_text = L["Config - General - Other - ResetButton"],
                        set               = function() SETTING_PROMPT:Open(RESET_SETTING_PROMPT_INFO) end
                    }
                }
            }
        }
    },
    {
        widgetName = L["Modules - Housing"],
        widgetType = Setting_Enum.WidgetType.Tab,
        children   = {
            {
                widgetName       = L["Modules - Housing"],
                widgetType       = Setting_Enum.WidgetType.Title,
                widgetTitle_info = Setting_Define.TitleInfo{ imagePath = GetIcon("List"), text = L["Modules - Housing"], subtext = L["Config - Modules - WIP"] }
            },
            {
                widgetType = Setting_Enum.WidgetType.Container,
                children   = {
                    {
                        widgetName        = L["Modules - Housing - DecorMerchant"],
                        widgetDescription = Setting_Define.Descriptor{ imageType = Setting_Enum.ImageType.Large, imagePath = GetModulePreviewImage("DecorMerchant"), description = L["Modules - Housing - DecorMerchant - Description"] },
                        widgetType        = Setting_Enum.WidgetType.CheckButton,
                        key               = "DecorMerchant"
                    },
                    {
                        widgetName        = L["Modules - Housing - HouseChest"],
                        widgetDescription = Setting_Define.Descriptor{ imageType = Setting_Enum.ImageType.Large, imagePath = GetModulePreviewImage("HouseChest"), description = L["Modules - Housing - HouseChest - Description"] },
                        widgetType        = Setting_Enum.WidgetType.CheckButton,
                        key               = "HouseChest"
                    },
                    {
                        widgetName        = L["Modules - Housing - PlacedDecorList"],
                        widgetDescription = Setting_Define.Descriptor{ imageType = Setting_Enum.ImageType.Large, imagePath = GetModulePreviewImage("PlacedDecorList"), description = L["Modules - Housing - PlacedDecorList - Description"] },
                        widgetType        = Setting_Enum.WidgetType.CheckButton,
                        key               = "PlacedDecorList"
                    },
                    {
                        widgetName        = L["Modules - Housing - DecorTooltip"],
                        widgetDescription = Setting_Define.Descriptor{ imageType = Setting_Enum.ImageType.Large, imagePath = GetModulePreviewImage("DecorTooltip"), description = L["Modules - Housing - DecorTooltip - Description"] },
                        widgetType        = Setting_Enum.WidgetType.CheckButton,
                        key               = "DecorTooltip"
                    },
                    {
                        widgetName        = L["Modules - Housing - PreciseMovement"],
                        widgetDescription = Setting_Define.Descriptor{ imageType = Setting_Enum.ImageType.Large, imagePath = GetModulePreviewImage("PreciseMovement"), description = L["Modules - Housing - PreciseMovement - Description"] },
                        widgetType        = Setting_Enum.WidgetType.Text,
                        key               = "PreciseMovement"
                    }
                }
            }
        }
    },
    {
        widgetName = L["Modules - Tooltip"],
        widgetType = Setting_Enum.WidgetType.Tab,
        children   = {
            {
                widgetName       = L["Modules - Tooltip"],
                widgetType       = Setting_Enum.WidgetType.Title,
                widgetTitle_info = Setting_Define.TitleInfo{ imagePath = GetIcon("List"), text = L["Modules - Tooltip"], subtext = L["Config - Modules - WIP"] }
            },
            {
                widgetType = Setting_Enum.WidgetType.Container,
                children   = {
                    {
                        widgetName        = L["Modules - Tooltip - QuestDetailTooltip"],
                        widgetDescription = Setting_Define.Descriptor{ imageType = Setting_Enum.ImageType.Large, imagePath = GetModulePreviewImage("QuestDetailTooltip"), description = L["Modules - Tooltip - QuestDetailTooltip - Description"] },
                        widgetType        = Setting_Enum.WidgetType.CheckButton,
                        key               = "QuestDetailTooltip"
                    },
                    {
                        widgetName        = L["Modules - Tooltip - ExperienceBarTooltip"],
                        widgetDescription = Setting_Define.Descriptor{ imageType = Setting_Enum.ImageType.Large, imagePath = GetModulePreviewImage("ExperienceBarTooltip"), description = L["Modules - Tooltip - ExperienceBarTooltip - Description"] },
                        widgetType        = Setting_Enum.WidgetType.CheckButton,
                        key               = "ExperienceBarTooltip"
                    }
                }
            }
        }
    },
    {
        widgetName = L["Modules - Loot"],
        widgetType = Setting_Enum.WidgetType.Tab,
        children   = {
            {
                widgetName       = L["Modules - Loot"],
                widgetType       = Setting_Enum.WidgetType.Title,
                widgetTitle_info = Setting_Define.TitleInfo{ imagePath = GetIcon("List"), text = L["Modules - Loot"], subtext = L["Config - Modules - WIP"] }
            },
            {
                widgetType = Setting_Enum.WidgetType.Container,
                children   = {
                    {
                        widgetName        = L["Modules - Loot - LootAlertPopup"],
                        widgetDescription = Setting_Define.Descriptor{ imageType = Setting_Enum.ImageType.Large, imagePath = GetModulePreviewImage("LootAlertPopup"), description = L["Modules - Loot - LootAlertPopup - Description"] },
                        widgetType        = Setting_Enum.WidgetType.CheckButton,
                        key               = "LootAlertPopup"
                    }
                }
            }
        }
    },
    {
        widgetName = L["Modules - Events"],
        widgetType = Setting_Enum.WidgetType.Tab,
        children   = {
            {
                widgetName       = L["Modules - Events"],
                widgetType       = Setting_Enum.WidgetType.Title,
                widgetTitle_info = Setting_Define.TitleInfo{ imagePath = GetIcon("List"), text = L["Modules - Events"], subtext = L["Config - Modules - WIP"] }
            },
            {
                widgetType = Setting_Enum.WidgetType.Container,
                children   = {
                    {
                        widgetName        = L["Modules - Events - MidnightPrepatch"],
                        widgetDescription = Setting_Define.Descriptor{ imageType = Setting_Enum.ImageType.Large, imagePath = GetModulePreviewImage("MidnightPrepatch"), description = L["Modules - Events - MidnightPrepatch - Description"] },
                        widgetType        = Setting_Enum.WidgetType.CheckButton,
                        key               = "MidnightPrepatch"
                    }
                }
            }
        }
    },
    {
        widgetName         = L["Config - About"],
        widgetType         = Setting_Enum.WidgetType.Tab,
        widgetTab_isFooter = true,
        children           = {
            {
                widgetName       = L["Config - About"],
                widgetType       = Setting_Enum.WidgetType.Title,
                widgetTitle_info = Setting_Define.TitleInfo{ imagePath = env.ICON_ALT, text = env.NAME, subtext = env.VERSION_STRING }
            },
            {
                widgetName        = L["Config - About - Contributors"],
                widgetType        = Setting_Enum.WidgetType.Container,
                widgetTransparent = true,
                children          = {
                    {
                        widgetName        = L["Contributors - huchang47"],
                        widgetType        = Setting_Enum.WidgetType.Text,
                        widgetDescription = Setting_Define.Descriptor{ description = L["Contributors - huchang47 - Description"] },
                        widgetTransparent = true
                    }
                }
            },
            {
                widgetName        = L["Config - About - Developer"],
                widgetType        = Setting_Enum.WidgetType.Container,
                widgetTransparent = true,
                children          = {
                    {
                        widgetName        = L["Config - About - Developer - AdaptiveX"],
                        widgetType        = Setting_Enum.WidgetType.Text,
                        widgetTransparent = true
                    }
                }
            }
        }
    }
}
