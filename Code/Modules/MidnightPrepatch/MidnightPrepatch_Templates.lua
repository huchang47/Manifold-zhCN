local env                                                                                                                                          = select(2, ...)
local Path                                                                                                                                         = env.WPM:Import("wpm_modules\\path")
local UIKit                                                                                                                                        = env.WPM:Import("wpm_modules\\ui-kit")
local Frame, LayoutGrid, LayoutVertical, LayoutHorizontal, ScrollView, ScrollBar, Text, Input, LinearSlider, InteractiveRect, LazyScrollView, List = UIKit.UI.Frame, UIKit.UI.LayoutGrid, UIKit.UI.LayoutVertical, UIKit.UI.LayoutHorizontal, UIKit.UI.ScrollView, UIKit.UI.ScrollBar, UIKit.UI.Text, UIKit.UI.Input, UIKit.UI.LinearSlider, UIKit.UI.InteractiveRect, UIKit.UI.LazyScrollView, UIKit.UI.List
local UIAnim                                                                                                                                       = env.WPM:Import("wpm_modules\\ui-anim")
local MidnightPrepatch_Templates                                                                                                                   = env.WPM:New("@\\MidnightPrepatch\\Templates")


-- Shared
----------------------------------------------------------------------------------------------------

local TEXTURE_NIL = UIKit.Define.Texture{ path = nil }
local FILL        = UIKit.Define.Fill{}


-- Item Slot
----------------------------------------------------------------------------------------------------

do
    local ITEM_SLOT_BORDER      = UIKit.Define.Texture{ path = Path.Root .. "\\Art\\MidnightPrepatch\\ItemSlot-Border.png" }
    local ITEM_SLOT_MASK        = UIKit.Define.Texture{ path = Path.Root .. "\\Art\\MidnightPrepatch\\ItemSlot-Mask.png" }
    local ITEM_SLOT_BORDER_SIZE = UIKit.Define.Fill{ delta = -8 }
    local ITEM_SLOT_IMAGE_SIZE  = FILL


    local ItemSlotMixin = {}

    function ItemSlotMixin:SetImage(texturePath)
        self.ImageTexture:SetTexture(texturePath)
    end


    MidnightPrepatch_Templates.ItemSlot = UIKit.Prefab(function(id, name, children, ...)
        local frame = Frame(name, {
            Frame(name .. ".Border")
                :id("Border", id)
                :size(ITEM_SLOT_BORDER_SIZE)
                :background(ITEM_SLOT_BORDER)
                :frameLevel(2),

            Frame(name .. ".Image")
                :id("Image", id)
                :size(ITEM_SLOT_IMAGE_SIZE)
                :background(TEXTURE_NIL)
                :mask(ITEM_SLOT_MASK)
                :frameLevel(1)
        })

        frame.Border = UIKit.GetElementById("Border", id)
        frame.Image = UIKit.GetElementById("Image", id)
        frame.ImageTexture = frame.Image:GetTextureFrame()

        Mixin(frame, ItemSlotMixin)

        return frame
    end)
end
