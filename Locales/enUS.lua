-- Base Localization
-- This file contains the default English strings.
-- Other locales will fall back to these values if no translation is provided.



local env = select(2, ...)
local L = env.L

-- Keybinds
BINDING_HEADER_MANIFOLD = "Manifold"

BINDING_HEADER_MANIFOLD_HOUSING = "Housing (Manifold)"
PREFACE_MANIFOLD_HOUSING_EXPERTDECOR_BINDINGS = "Advanced Mode bindings for incrementally manipulating Decor with the mouse wheel."
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_X = "Precise Move (X)"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_Y = "Precise Move (Y)"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_TRANSLATE_Z = "Precise Move (Z)"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_ROTATE = "Precise Rotate"
BINDING_NAME_MANIFOLD_HOUSING_EXPERTDECORPRECISE_SCALE = "Precise Scale"


-- Config
L["Config - General"] = "General"
L["Config - General - Title"] = "General"
L["Config - General - Title - Subtext"] = "Manage the overall set-up and preferences for the add-on."
L["Config - General - Other"] = "Other"
L["Config - General - Other - ResetButton"] = "Reset All Settings"
L["Config - General - Other - ResetPrompt"] = "Are you sure you want to reset all settings?"
L["Config - General - Other - ResetPrompt - Yes"] = "Confirm"
L["Config - General - Other - ResetPrompt - No"] = "Cancel"

L["Config - Modules"] = "Modules"
L["Config - Modules - Title"] = "Modules"
L["Config - Modules - Title - Subtext"] = "Features and quality-of-life enhancements."
L["Config - Modules - WIP"] = "UI work in progress."

L["Config - About"] = "About"
L["Config - About - Contributors"] = "Contributors"
L["Config - About - Developer"] = "Developer"
L["Config - About - Developer - AdaptiveX"] = "AdaptiveX"

-- Dashboard
L["Dashboard - Activated"] = "Activated"
L["Dashboard - Deactivated"] = "Deactivated"

-- Modules
L["Modules - Housing"] = "Housing"
L["Modules - Housing - DecorMerchant"] = "Decor Merchant"
L["Modules - Housing - DecorMerchant - Description"] = "Automatically confirms high-cost purchase popups and allows bulk buying (Shift+Right-Click) at decor vendors."
L["Modules - Housing - HouseChest"] = "Persistent House Chest"
L["Modules - Housing - HouseChest - Description"] = "Keeps the House Chest panel visible across all House Editor modes."
L["Modules - Housing - PlacedDecorList"] = "Placed Decor List"
L["Modules - Housing - PlacedDecorList - Description"] = "Enables resizing for the Placed Decor List and displays placement cost for each decor."
L["Modules - Housing - DecorTooltip"] = "Highlighted Decor Tooltip"
L["Modules - Housing - DecorTooltip - Description"] = "Displays a tooltip with name and placement cost when hovering over a decor."
L["Modules - Housing - DecorTooltip - LeftClick"] = "Left Click to Select"
L["Modules - Housing - PreciseMovement"] = "(Advanced Mode) Precise Movement"
L["Modules - Housing - PreciseMovement - Description"] = "Allows precise movement, rotation and scaling of decor by holding the corresponding keybind and scrolling with the mouse wheel."
L["Modules - Housing - PreciseMovement - MouseWheel"] = "Mouse Wheel"
L["Modules - Housing - PreciseMovement - PreciseMoveX"] = "Precise Move (X)"
L["Modules - Housing - PreciseMovement - PreciseMoveY"] = "Precise Move (Y)"
L["Modules - Housing - PreciseMovement - PreciseMoveZ"] = "Precise Move (Z)"
L["Modules - Housing - PreciseMovement - PreciseRotate"] = "Precise Rotate"
L["Modules - Housing - PreciseMovement - PreciseScale"] = "Precise Scale"

L["Modules - Tooltip"] = "Tooltip"
L["Modules - Tooltip - QuestDetailTooltip"] = "Quest Detail Tooltip"
L["Modules - Tooltip - QuestDetailTooltip - Description"] = "Displays detailed quest information including objectives, rewards and more when hovering over quests in the Objective Tracker and Quest Log."
L["Modules - Tooltip - ExperienceBarTooltip"] = "Experience Bar Tooltip"
L["Modules - Tooltip - ExperienceBarTooltip - Description"] = "Enhances the experience bar tooltip with additional details."

L["Modules - Loot"] = "Loot"
L["Modules - Loot - LootAlertPopup"] = "Loot Alert Popup"
L["Modules - Loot - LootAlertPopup - Description"] = "Quickly equip gear directly from Loot Alert toasts with left-click."
L["Modules - Loot - LootAlertPopup - Equip"] = "Equip"
L["Modules - Loot - LootAlertPopup - Equipping"] = "Equipping..."
L["Modules - Loot - LootAlertPopup - Equipped"] = "Equipped"
L["Modules - Loot - LootAlertPopup - Combat"] = "In Combat"
L["Modules - Loot - LootAlertPopup - Vendor"] = "At Vendor"

L["Modules - Events"] = "Events"
L["Modules - Events - MidnightPrepatch"] = "Midnight Pre-Expansion Event"
L["Modules - Events - MidnightPrepatch - Description"] = "- Rare Tracker: Displays a sequential timeline of rares with estimated spawn times.\n\n- Currency Tracker: Shows your current Twilight's Blade Insignia count.\n\n- Weekly Quest Tracker: Tracks completion status of weekly event quests."
L["Modules - Events - MidnightPrepatch - RareTracker - Unavailable"] = "Unavailable"
L["Modules - Events - MidnightPrepatch - RareTracker - Timer"] = "Next in %s"
L["Modules - Events - MidnightPrepatch - RareTracker - Await"] = "Soon..."
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Title"] = "Rare Timeline"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Unavailable"] = "No data available"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Active"] = "Active"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Inactive"] = "Dead"
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Await"] = "Soon..."
L["Modules - Events - MidnightPrepatch - RareTracker - Tooltip - Hint"] = "<Click to Track Active Rare>"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Reset"] = " Resets in %s"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Complete"] = " Complete"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Available"] = " Available"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - CompleteIntroQuestline"] = "Complete Intro Questline to Unlock"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Title"] = "Weekly Quests"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Reset"] = "Resets in %s"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Complete"] = "Complete"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - InProgress"] = "In Progress"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Available"] = "Available"
L["Modules - Events - MidnightPrepatch - WeeklyQuests - Tooltip - Hint"] = "<Click to Track Quest Giver>"
L["Modules - Events - MidnightPrepatch - Event - Tooltip - Hint"] = "<Click to Open World Map>"

-- Contributors
L["Contributors - huchang47"] = "huchang47"
L["Contributors - huchang47 - Description"] = "Translator — Chinese (Simplified)"
