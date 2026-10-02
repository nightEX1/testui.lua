--[[
    Slider.lua
    แถบเลื่อนมุมโค้ง ลากด้วย Mouse/Touch ได้ แสดงค่าปัจจุบันด้านขวา
--]]

local UserInputService = game:GetService("UserInputService")
local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

local Slider = {}

function Slider.New(parent, config)
    config = config or {}
    local text = config.Text or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local callback = config.Callback
    local suffix = config.Suffix or ""

    local value = math.clamp(default, min, max)

    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 44)
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Theme.Fonts.Medium
    label.TextSize = 13
    label.TextColor3 = Theme.Colors.TextPrimary
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -50, 0, 16)
    label.Parent = container

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(value) .. suffix
    valueLabel.Font = Theme.Fonts.Medium
    valueLabel.TextSize = 13
    valueLabel.TextColor3 = Theme.Colors.Accent
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.Size = UDim2.new(0, 50, 0, 16)
    valueLabel.Parent = container

    local track = Instance.new("Frame")
    track.BackgroundColor3 = Theme.Colors.Border
    track.Position = UDim2.new(0, 0, 0, 26)
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Parent = container

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = Theme.Radius.Pill
    trackCorner.Parent = track

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Theme.Colors.Accent
    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = Theme.Radius.Pill
    fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(14, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent = track

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = Theme.Radius.Pill
    knobCorner.Parent = knob

    local dragging = false

    local function setFromAlpha(alpha, fire)
        alpha = math.clamp(alpha, 0, 1)
        value = math.floor(min + (max - min) * alpha + 0.5)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        valueLabel.Text = tostring(value) .. suffix
        if fire and callback then
            callback(value) -- TODO: logic จริงถูกกำหนดตอนเรียกใช้ Slider.New
        end
    end

    local function inputToAlpha(input)
        local relativeX = input.Position.X - track.AbsolutePosition.X
        return relativeX / track.AbsoluteSize.X
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFromAlpha(inputToAlpha(input), true)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            setFromAlpha(inputToAlpha(input), true)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return {
        Instance = container,
        Set = function(_, v) setFromAlpha((v - min) / (max - min), false) end,
        Get = function() return value end,
    }
end

return Slider
