local env = select(2, ...)
local GenericEnum = env.WPM:New("wpm_modules\\generic-enum")

do -- Color
    GenericEnum.ColorRGB = {
        White      = { r = 1, g = 1, b = 1 },
        Black      = { r = 0, g = 0, b = 0 },
        Orange     = { r = 1, g = 0.5, b = 0.25 },
        Yellow     = { r = 1, g = 1, b = 0 },
        Green      = { r = 0.1, g = 1, b = 0.1 },
        Red        = { r = 1, g = 0.125, b = 0.125 },
        Gray       = { r = 0.5, g = 0.5, b = 0.5 },
        LightGray  = { r = 0.75, g = 0.75, b = 0.75 },
        NormalText = { r = 1, g = 0.823, b = 0 }
    }

    GenericEnum.ColorHEX = {
        White      = "|cffFFFFFF",
        Black      = "|cff000000",
        Orange     = "|cffFFA500",
        Yellow     = "|cffFFCC1A",
        Green      = "|cff54CB34",
        Red        = "|cffD05555",
        Gray       = "|cff9D9D9D",
        LightGray  = "|cffCDCDCD",
        NormalText = "|cffFFD200"
    }
end
