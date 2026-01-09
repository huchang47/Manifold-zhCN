-- ♡ Translation // huchang47


if GetLocale() ~= "zhCN" then return end

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
L["Config - General"] = "通用"
L["Config - General - Title"] = "通用"
L["Config - General - Title - Subtext"] = "管理插件的整体设置和偏好。"
L["Config - General - Other"] = "其他"
L["Config - General - Other - ResetButton"] = "重置所有设置"
L["Config - General - Other - ResetPrompt"] = "确定要重置所有设置吗？"
L["Config - General - Other - ResetPrompt - Yes"] = "确认"
L["Config - General - Other - ResetPrompt - No"] = "取消"

L["Config - Modules"] = "模块"
L["Config - Modules - Title"] = "模块"
L["Config - Modules - Title - Subtext"] = "功能和质量提升增强。"
L["Config - Modules - WIP"] = "UI搭建功能正在进行中。"

L["Config - About"] = "关于"
L["Config - About - Contributors"] = "贡献者"
L["Config - About - Developer"] = "开发者"
L["Config - About - Developer - AdaptiveX"] = "AdaptiveX"

-- Dashboard
L["Dashboard - Activated"] = "Activated"
L["Dashboard - Deactivated"] = "Deactivated"

-- Modules
L["Modules - Housing"] = "房屋"
L["Modules - Housing - DecorMerchant"] = "装饰商人"
L["Modules - Housing - DecorMerchant - Description"] = "自动确认高成本购买弹出窗口，并允许批量购买（Shift+右键点击）在装饰供应商处。"
L["Modules - Housing - HouseChest"] = "持久化房屋箱子"
L["Modules - Housing - HouseChest - Description"] = "保持房屋箱子面板在所有房屋编辑器模式下可见。"
L["Modules - Housing - PlacedDecorList"] = "已放置装饰列表"
L["Modules - Housing - PlacedDecorList - Description"] = "启用已放置装饰列表的调整大小功能，并显示每个装饰的放置成本。"
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

L["Modules - Tooltip"] = "提示"
L["Modules - Tooltip - QuestDetailTooltip"] = "任务详情提示"
L["Modules - Tooltip - QuestDetailTooltip - Description"] = "在任务跟踪器和任务日志中悬停任务时显示详细的任务信息，包括目标、奖励等。"
L["Modules - Tooltip - ExperienceBarTooltip"] = "经验条提示"
L["Modules - Tooltip - ExperienceBarTooltip - Description"] = "增强经验条提示，显示更多详细信息。"

L["Modules - Loot"] = "拾取"
L["Modules - Loot - LootAlertPopup"] = "拾取提示"
L["Modules - Loot - LootAlertPopup - Description"] = "从拾取提示中直接点击左键装备装备。"
L["Modules - Loot - LootAlertPopup - Equip"] = "装备"
L["Modules - Loot - LootAlertPopup - Equipping"] = "装备中..."
L["Modules - Loot - LootAlertPopup - Equipped"] = "已装备"
L["Modules - Loot - LootAlertPopup - Combat"] = "战斗中"
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
