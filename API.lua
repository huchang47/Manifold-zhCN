--[[
    Manifold API Documentation

    `ManifoldAPI.OpenSettingUI()`
]]

local env = select(2, ...)
ManifoldAPI = ManifoldAPI or {}

do -- @\\Setting
    local Setting_Logic = env.WPM:Await("@\\Setting\\Logic")
    ManifoldAPI_OpenSettingUI = Setting_Logic.OpenSettingUI
    ManifoldAPI.OpenSettingUI = Setting_Logic.OpenSettingUI
end
