local env = select(2, ...)
local Config = env.Config
local function IsModuleEnabled() return Config.DBGlobal:GetVariable("LootAlertPopup") == true end



local Util = {}
do
    function Util.IsEquippableGearLink(itemLink)
        if not itemLink then return false end

        local _, _, _, itemEquipLoc, _, classID = C_Item.GetItemInfoInstant(itemLink)
        if not itemEquipLoc or itemEquipLoc == "" then
            return false
        end

        return classID == Enum.ItemClass.Armor or classID == Enum.ItemClass.Weapon
    end

    function Util.ParseItemLink(itemLink)
        if not itemLink then return nil end

        local itemString = itemLink:match("|Hitem:([^|]+)|")
        if not itemString then return nil end

        local parts = { strsplit(":", itemString) }
        local itemID = tonumber(parts[1])
        if not itemID then return nil end

        local bonusIDs = {}

        while #parts > 0 and parts[#parts] == "" do
            parts[#parts] = nil
        end

        local modifierCountIndex = nil
        for i = #parts, 2, -1 do
            local modifierCount = tonumber(parts[i])
            if modifierCount and modifierCount >= 0 and modifierCount <= 20 then
                if i + (2 * modifierCount) == #parts then
                    modifierCountIndex = i
                    break
                end
            end
        end

        if modifierCountIndex then
            local numBonusesIndex = modifierCountIndex - 1
            local numBonuses = tonumber(parts[numBonusesIndex]) or 0
            if numBonuses > 0 then
                local firstBonusIndex = numBonusesIndex - numBonuses
                if firstBonusIndex >= 2 then
                    for i = firstBonusIndex, (numBonusesIndex - 1) do
                        local bonusID = tonumber(parts[i])
                        if bonusID then
                            bonusIDs[bonusID] = true
                        end
                    end
                end
            end
        end

        return itemID, bonusIDs
    end

    function Util.ItemLinksMatch(linkA, linkB)
        local idA, bonusA = Util.ParseItemLink(linkA)
        local idB, bonusB = Util.ParseItemLink(linkB)

        if not idA or not idB or idA ~= idB then
            return false
        end

        local ilvlA = Util.GetItemLevel(linkA)
        local ilvlB = Util.GetItemLevel(linkB)
        if type(ilvlA) == "number" and type(ilvlB) == "number" and ilvlA ~= ilvlB then
            return false
        end

        for k in pairs(bonusA) do
            if not bonusB[k] then return false end
        end
        for k in pairs(bonusB) do
            if not bonusA[k] then return false end
        end

        return true
    end

    function Util.GetItemLevel(itemLink)
        if not itemLink then return nil end
        local itemLevel = nil
        if C_Item and C_Item.GetDetailedItemLevelInfo then
            itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink)
        else
            itemLevel = GetDetailedItemLevelInfo(itemLink)
        end
        if type(itemLevel) ~= "number" then
            return nil
        end
        return itemLevel
    end

    local INVTYPE_TO_SLOTS = {
        INVTYPE_AMMO           = {},
        INVTYPE_HEAD           = { "HeadSlot" },
        INVTYPE_NECK           = { "NeckSlot" },
        INVTYPE_SHOULDER       = { "ShoulderSlot" },
        INVTYPE_BODY           = { "ShirtSlot" },
        INVTYPE_CHEST          = { "ChestSlot" },
        INVTYPE_ROBE           = { "ChestSlot" },
        INVTYPE_WAIST          = { "WaistSlot" },
        INVTYPE_LEGS           = { "LegsSlot" },
        INVTYPE_FEET           = { "FeetSlot" },
        INVTYPE_WRIST          = { "WristSlot" },
        INVTYPE_HAND           = { "HandsSlot" },
        INVTYPE_FINGER         = { "Finger0Slot", "Finger1Slot" },
        INVTYPE_TRINKET        = { "Trinket0Slot", "Trinket1Slot" },
        INVTYPE_CLOAK          = { "BackSlot" },
        INVTYPE_WEAPON         = { "MainHandSlot", "SecondaryHandSlot" },
        INVTYPE_2HWEAPON       = { "MainHandSlot" },
        INVTYPE_WEAPONMAINHAND = { "MainHandSlot" },
        INVTYPE_WEAPONOFFHAND  = { "SecondaryHandSlot" },
        INVTYPE_HOLDABLE       = { "SecondaryHandSlot" },
        INVTYPE_SHIELD         = { "SecondaryHandSlot" },
        INVTYPE_RANGED         = { "MainHandSlot" },
        INVTYPE_RANGEDRIGHT    = { "MainHandSlot" },
        INVTYPE_THROWN         = { "MainHandSlot" },
        INVTYPE_RELIC          = {},
        INVTYPE_TABARD         = { "TabardSlot" }
    }

    function Util.IsItemEquippedByPlayer(itemLink)
        if not itemLink then return false end

        local _, _, _, itemEquipLoc = C_Item.GetItemInfoInstant(itemLink)
        if not itemEquipLoc or itemEquipLoc == "" then
            return false
        end

        local slotNames = INVTYPE_TO_SLOTS[itemEquipLoc]
        if not slotNames or #slotNames == 0 then
            return false
        end

        for _, slotName in ipairs(slotNames) do
            local slotId = GetInventorySlotInfo(slotName)
            if slotId then
                local equippedLink = GetInventoryItemLink("player", slotId)
                if equippedLink and Util.ItemLinksMatch(equippedLink, itemLink) then
                    return true
                end
            end
        end

        return false
    end

    function Util.CalculateItemLevelDelta(itemLink)
        if not itemLink then return 0 end

        local newItemLevel = Util.GetItemLevel(itemLink)
        if not newItemLevel then return 0 end

        local _, _, _, itemEquipLoc = C_Item.GetItemInfoInstant(itemLink)
        if not itemEquipLoc or itemEquipLoc == "" then
            return 0
        end

        local slotNames = INVTYPE_TO_SLOTS[itemEquipLoc]
        if not slotNames or #slotNames == 0 then
            return 0
        end

        local equippedItemLevel = nil
        for _, slotName in ipairs(slotNames) do
            local slotId = GetInventorySlotInfo(slotName)
            if slotId then
                local equippedLink = GetInventoryItemLink("player", slotId)
                local ilvl = Util.GetItemLevel(equippedLink)
                if type(ilvl) == "number" then
                    if equippedItemLevel == nil or ilvl < equippedItemLevel then
                        equippedItemLevel = ilvl
                    end
                end
            end
        end

        if equippedItemLevel == nil then
            equippedItemLevel = 0
        end

        return newItemLevel - equippedItemLevel
    end
end



local State = {
    valid             = false,
    currentFrame      = nil,
    isWaitingForEquip = false,
    isEquipped        = false
}

local function ResetState()
    State.valid = false
    State.currentFrame = nil
    State.isWaitingForEquip = false
    State.isEquipped = false
end

local function InitState(frame)
    ResetState()
    State.valid = true
    State.currentFrame = frame
    State.isEquipped = Util.IsItemEquippedByPlayer(frame and frame.hyperlink)
end

local function UpdateLootAlertPopupState()
    local wasShown = false

    -- Visibility
    if not State.valid then
        if frame.isShown then
            frame:HideFrame()
        end
        return
    elseif not frame.isShown then
        frame:ShowFrame()
        wasShown = true
    end


    -- State
    if not State.currentFrame then return end

    if State.isEquipped then -- Equipped
        frame:SetTick()
        if not wasShown then
            frame.AnimDefinition:Play(frame, "TRANSITION")
        end
    elseif State.isWaitingForEquip then -- Equipping...
        frame:SetSpinner()
        if not wasShown then
            frame.AnimDefinition:Play(frame, "TRANSITION")
        end
    else -- Click to Equip
        local itemLevelDelta = Util.CalculateItemLevelDelta(State.currentFrame.hyperlink)
        frame:SetItemComparison(itemLevelDelta)
    end
end

local function SetTooltip()
    if not State.valid then return end

    GameTooltip:SetOwner(State.currentFrame, "ANCHOR_RIGHT")
    if State.currentFrame.hyperlink then
        GameTooltip:SetHyperlink(State.currentFrame.hyperlink)
        GameTooltip:Show()
    end
end

local function UpdateTooltip()
    if GameTooltip:IsShown() and GameTooltip:IsOwned(State.currentFrame) and State.currentFrame.hyperlink then
        GameTooltip:Hide()
        SetTooltip()
    end
end



local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_EQUIPMENT_CHANGED" then
        if State.currentFrame and State.isWaitingForEquip then
            State.isWaitingForEquip = false
            State.isEquipped = Util.IsItemEquippedByPlayer(State.currentFrame.hyperlink)

            UpdateLootAlertPopupState()
            UpdateTooltip()
        end
    end

    if event == "PLAYER_REGEN_ENABLED" then
        if State.valid and not State.isEquipped and not State.isWaitingForEquip then
            UpdateLootAlertPopupState()
        end
    end
end)

local function LootAlertFrame_OnEnter(self)
    if not IsModuleEnabled() then return end
    if not Util.IsEquippableGearLink(self.hyperlink) then return end

    if State.currentFrame ~= self then
        InitState(self)
    end

    SetTooltip()

    frame:SetOwner(self)
    UpdateLootAlertPopupState()
end

local function LootAlertFrame_OnLeave(self)
    if not IsModuleEnabled() then return end
    if not Util.IsEquippableGearLink(self.hyperlink) then return end

    if GameTooltip:IsOwned(self) then
        GameTooltip:Hide()
    end

    if not State.isWaitingForEquip then
        ResetState()
    end

    UpdateLootAlertPopupState()
end

local function LootAlertFrame_OnClick(frame, button)
    if not IsModuleEnabled() then return end
    if InCombatLockdown() then return end

    if button == "LeftButton" then
        local targetLink = frame.hyperlink
        if not targetLink then return end
        if not Util.IsEquippableGearLink(targetLink) then return end

        for bag = 0, NUM_BAG_SLOTS do
            for slot = 1, C_Container.GetContainerNumSlots(bag) do
                local info = C_Container.GetContainerItemInfo(bag, slot)
                if info and Util.ItemLinksMatch(info.hyperlink, targetLink) then
                    C_Container.UseContainerItem(bag, slot)
                    State.isWaitingForEquip = true
                    UpdateLootAlertPopupState()
                    return
                end
            end
        end
    end
end

local function LootAlertFrame_OnHide(frame)
    if frame:GetOwner() == frame then
        ResetState()
        UpdateLootAlertPopupState()
    end
end

hooksecurefunc(LootAlertSystem, "ShowAlert", function(self, ...)
    if not IsModuleEnabled() then return end

    for alertFrame in self.alertFramePool:EnumerateActive() do
        if not alertFrame.__manifoldSetup then
            alertFrame.__manifoldSetup = true

            alertFrame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
            alertFrame:HookScript("OnEnter", LootAlertFrame_OnEnter)
            alertFrame:HookScript("OnLeave", LootAlertFrame_OnLeave)
            alertFrame:HookScript("OnMouseUp", LootAlertFrame_OnClick)
            alertFrame:HookScript("OnHide", LootAlertFrame_OnHide)
        end
    end
end)
