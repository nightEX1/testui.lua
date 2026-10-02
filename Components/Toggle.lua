--[[
    Toggle.lua
    แถว label + switch มุมโค้ง เปลี่ยนสถานะด้วย Tween
--]]

local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

local Toggle = {}

function Toggle.New(parent, config)
    config = config or {}
    local text = config.Text or "Toggle"
    local default = config.Default or false
    local callback = config.Callback
    local state = default

    local row = Instance.new("Frame")
    row.Name = "Toggle"
    row.BackgroundTransparency = 1
    row.Size = UDim2.new(1, 0, 0, 24)
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Theme.Fonts.Medium
    label.TextSize = 13
    label.TextColor3 = Theme.Colors.TextPrimary
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Parent = row

    local switch = Instance.new("Frame")
    switch.Size = UDim2.fromOffset(40, 22)
    switch.Position = UDim2.new(1, -40, 0.5, -11)
    switch.BackgroundColor3 = state and Theme.Colors.Accent or Theme.Colors.Border
    switch.Parent = row

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = Theme.Radius.Pill
    switchCorner.Parent = switch

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent = switch

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = Theme.Radius.Pill
    knobCorner.Parent = knob

    local click = Instance.new("TextButton")
    click.Text = ""
    click.BackgroundTransparency = 1
    click.Size = UDim2.fromScale(1, 1)
    click.Parent = row

    local function setState(value, fire)
        state = value
        Animation.Tween(switch, { BackgroundColor3 = state and Theme.Colors.Accent or Theme.Colors.Border }, Theme.Animation.Fast)
        Animation.Tween(knob, { Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8) }, Theme.Animation.Fast)
        if fire and callback then
            callback(state) -- TODO: logic จริงถูกกำหนดตอนเรียกใช้ Toggle.New
        end
    end

    click.MouseButton1Click:Connect(function()
        setState(not state, true)
    end)

    return {
        Instance = row,
        Set = function(_, value) setState(value, false) end,
        Get = function() return state end,
    }
end

return Toggle
