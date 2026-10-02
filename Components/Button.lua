--[[
    Button.lua
    ปุ่มมุมโค้ง มี hover/press feedback นุ่มนวล
--]]

local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

local Button = {}

function Button.New(parent, config)
    config = config or {}
    local text = config.Text or "Button"
    local callback = config.Callback
    local variant = config.Variant or "default" -- "default" | "accent" | "danger"

    local bg = Theme.Colors.SurfaceHover
    if variant == "accent" then
        bg = Theme.Colors.Accent
    elseif variant == "danger" then
        bg = Theme.Colors.Danger
    end

    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Font = Theme.Fonts.Medium
    btn.TextSize = 13
    btn.TextColor3 = variant == "default" and Theme.Colors.TextPrimary or Color3.new(1, 1, 1)
    btn.BackgroundColor3 = bg
    btn.AutoButtonColor = false
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = Theme.Radius.Medium
    corner.Parent = btn

    btn.MouseEnter:Connect(function()
        Animation.Tween(btn, { BackgroundColor3 = variant == "default" and Theme.Colors.Border or Theme.Colors.AccentHover }, Theme.Animation.Fast)
    end)
    btn.MouseLeave:Connect(function()
        Animation.Tween(btn, { BackgroundColor3 = bg }, Theme.Animation.Fast)
    end)

    btn.MouseButton1Click:Connect(function()
        Animation.Tween(btn, { Size = UDim2.new(1, -6, 0, 32) }, 0.08)
        task.delay(0.08, function()
            Animation.Tween(btn, { Size = UDim2.new(1, 0, 0, 34) }, 0.1)
        end)
        if callback then
            callback() -- TODO: logic จริงถูกกำหนดตอนเรียกใช้ Button.New
        end
    end)

    return { Instance = btn }
end

return Button
