local env            = select(2, ...)
local Config         = env.Config
local Utils_Blizzard = env.WPM:Import("wpm_modules\\utils\\blizzard")
local function IsModuleEnabled() return Config.DBGlobal:GetVariable("DecorMerchant") == true end

local CreateFrame             = CreateFrame
local IsShiftKeyDown          = IsShiftKeyDown
local StaticPopup_FindVisible = StaticPopup_FindVisible
local StaticPopup_Show        = StaticPopup_Show
local GetMerchantItemMaxStack = GetMerchantItemMaxStack


-- GUID: [typeStr]-[typeID]-[serverID]-[instanceID]-[zoneUID]-[npcID]-[spawnUID]
local DECOR_VENDOR_NPC_ID = {
    -- Founder's Point
    ["255213"] = true, -- Faarden the Builder
    ["255203"] = true, -- Xiao Dan
    ["255216"] = true, -- Balen Starfinder
    ["255218"] = true, -- Argan Hammerfist
    ["248854"] = true, -- The Last Architect
    ["255221"] = true, -- Trevor Grenner
    ["255222"] = true, -- High Tides Ren
    ["255228"] = true, -- Len Splinthoof
    ["255230"] = true, -- Yen Malone

    -- Razorwind Shores
    ["255298"] = true, -- Jehzar Starfall
    ["255299"] = true, -- Lefton Farrer
    ["255301"] = true, -- Botanist Boh'an
    ["253596"] = true, -- The Last Architect
    ["255297"] = true, -- Shon'ja
    ["255278"] = true, -- Gronthul
    ["255325"] = true, -- High Tides Ren
    ["255326"] = true, -- Len Splinthoof
    ["255319"] = true -- Yen Malone
}

local function IsInteractingWithDecorMerchant()
    local targetGUID = UnitGUID("target")
    if not targetGUID then return false end

    local _, _, _, _, _, unitID, _ = Utils_Blizzard.ParseUnitGUID(targetGUID)
    return DECOR_VENDOR_NPC_ID[unitID]
end


do -- Skip CONFIRM_HIGH_COST_ITEM pop-up on decor merchants
    hooksecurefunc("StaticPopup_Show", function(which)
        if which == "CONFIRM_HIGH_COST_ITEM" then
            if not IsModuleEnabled() then return end

            local dialog = StaticPopup_FindVisible(which)
            if dialog and IsInteractingWithDecorMerchant() then
                dialog:GetButton1():Click() -- Accept button
            end
        end
    end)
end

do -- Allow bulk buy on decor merchants
    local isInMerchantUI = false

    local function BulkBuyItem(itemButton, quantity)
        local index = itemButton:GetID()
        for i = 1, quantity do
            C_Timer.After(i * 0.125, function()
                if not IsInteractingWithDecorMerchant() or not isInMerchantUI then return end
                BuyMerchantItem(index, 1)
            end)
        end
    end

    local function OpenBulkBuyUI(itemButton, maxQuantity)
        maxQuantity = maxQuantity or 99 -- Default max if not specified

        -- Store original SplitStack and replace with our repeated-buy version
        local originalSplitStack = itemButton.SplitStack

        itemButton.SplitStack = function(button, split)
            if split > 0 then
                BulkBuyItem(button, split)
            end
            -- Restore original after use
            itemButton.SplitStack = originalSplitStack
        end

        -- Force open StackSplitFrame regardless of item's actual max stack
        StackSplitFrame:OpenStackSplitFrame(maxQuantity, itemButton, "BOTTOMLEFT", "TOPLEFT", 1)
    end

    local function SetupMerchantButtons()
        for i = 1, MERCHANT_ITEMS_PER_PAGE do
            local itemButton = _G["MerchantItem" .. i .. "ItemButton"]
            if itemButton and not itemButton.__manifoldSetup then
                itemButton:HookScript("OnClick", function(self, button)
                    if not IsModuleEnabled() then return end

                    -- Shift+RightClick to open buy-multiple dialog for any item
                    if IsShiftKeyDown() and button == "RightButton" then
                        local maxStack = GetMerchantItemMaxStack(self:GetID())
                        -- If it's a single-stack item, open our custom dialog
                        if maxStack == 1 then
                            OpenBulkBuyUI(self, 99)
                        end
                    end
                end)
                itemButton.__manifoldSetup = true
            end
        end
    end


    local f = CreateFrame("Frame")
    f:RegisterEvent("MERCHANT_SHOW")
    f:RegisterEvent("MERCHANT_CLOSED")
    f:SetScript("OnEvent", function(self, event, ...)
        if event == "MERCHANT_SHOW" then
            isInMerchantUI = true
            SetupMerchantButtons()
        elseif event == "MERCHANT_CLOSED" then
            isInMerchantUI = false
        end
    end)
end


--[[
local COPY_PASTE_POPUP_ID = "MANIFOLD_COPY_PASTE_UTIL"

StaticPopupDialogs[COPY_PASTE_POPUP_ID] = {
    text                   = "Copy Paste Utility",
    button1                = OKAY,
    hasEditBox             = true,
    hasWideEditBox         = true,
    editBoxWidth           = 280,
    maxLetters             = 0,
    preferredIndex         = 3,
    timeout                = 0,
    whileDead              = true,
    hideOnEscape           = true,
    OnShow                 = function(self, data)
        local message = data.text
        self:GetEditBox():SetText(message)
    end,
    OnAccept               = function(self)
        self:GetEditBox():ClearFocus()
    end,
    EditBoxOnEscapePressed = function(editBox)
        editBox:GetParent():Hide()
    end
}

function CopyUnitGUID()
    StaticPopup_Show(COPY_PASTE_POPUP_ID, nil, nil, {
        title = "Target GUID",
        text  = UnitGUID("target") or ""
    })
end
]]
