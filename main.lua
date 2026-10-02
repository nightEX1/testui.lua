-- ModernScriptUI main loader
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local URL = "https://raw.githubusercontent.com/nightEX1/testui.lua/refs/heads/main/src/ModernScriptUI.lua"
local source = game:HttpGet(URL)
local run, compileError = loadstring(source)
assert(run, "ModernScriptUI compile error: " .. tostring(compileError))

local ok, runtimeError = pcall(run)
if not ok then
    error("ModernScriptUI runtime error: " .. tostring(runtimeError), 0)
end
