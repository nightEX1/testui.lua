--[[
    Dropdown.lua
    กดเพื่อขยายรายการตัวเลือก ปิดเองเมื่อเลือกแล้ว
--]]

local Theme = require(script.Parent.Parent.Theme)
local Animation = require(script.Parent.Parent.Animation)

local Dropdown = {}

function Dropdown.New(parent, config)
    config = config or {}
    local text = config.Text or "Dropdown"
    local options = config.Options or {}
    local default = config.Default or options[1] or "None"
    local callback = config.Callback

    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = container

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Theme.Fonts.Medium
    label.TextSize = 13
    label.TextColor3 = Theme.Colors.TextPrimary
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 16)
    label.LayoutOrder = 1
    label.Parent = container

    local head = Instance.new("TextButton")
    head.Text = ""
    head.BackgroundColor3 = Theme.Colors.SurfaceHover
    head.Size = UDim2.new(1, 0, 0, 36)
    head.LayoutOrder = 2
    head.Parent = container

    local headCorner = Instance.new("UICorner")
    headCorner.CornerRadius = Theme.Radius.Medium
    headCorner.Parent = head

    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Text = default
    selectedLabel.Font = Theme.Fonts.Regular
    selectedLabel.TextSize = 13
    selectedLabel.TextColor3 = Theme.Colors.TextSecondary
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Position = UDim2.fromOffset(12, 0)
    selectedLabel.Size = UDim2.new(1, -36, 1, 0)
    selectedLabel.Parent = head

    local arrow = Instance.new("TextLabel")
    arrow.Text = "▾"
    arrow.Font = Theme.Fonts.Bold
    arrow.TextSize = 14
    arrow.TextColor3 = Theme.Colors.TextSecondary
    arrow.BackgroundTransparency = 1
    arrow.Size = UDim2.fromOffset(24, 36)
    arrow.Position = UDim2.new(1, -28, 0, 0)
    arrow.Parent = head

    local list = Instance.new("Frame")
    list.BackgroundColor3 = Theme.Colors.SurfaceHover
    list.Size = UDim2.new(1, 0, 0, 0)
    list.ClipsDescendants = true
    list.LayoutOrder = 3
    list.Parent = container

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = Theme.Radius.Medium
    listCorner.Parent = list

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = list

    local open = false
    local optionHeight = 32

    local function close()
        open = false
        Animation.Tween(list, { Size = UDim2.new(1, 0, 0, 0) }, Theme.Animation.Fast)
        Animation.Tween(arrow, { Rotation = 0 }, Theme.Animation.Fast)
    end

    local function toggleOpen()
        open = not open
        if open then
            Animation.Tween(list, { Size = UDim2.new(1, 0, 0, optionHeight * #options) }, Theme.Animation.Fast)
            Animation.Tween(arrow, { Rotation = 180 }, Theme.Animation.Fast)
        else
            close()
        end
    end

    for i, optionText in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Text = optionText
        optBtn.Font = Theme.Fonts.Regular
        optBtn.TextSize = 13
        optBtn.TextColor3 = Theme.Colors.TextSecondary
        optBtn.BackgroundTransparency = 1
        optBtn.Size = UDim2.new(1, 0, 0, optionHeight)
        optBtn.LayoutOrder = i
        optBtn.Parent = list

        optBtn.MouseButton1Click:Connect(function()
            selectedLabel.Text = optionText
            close()
            if callback then
                callback(optionText) -- TODO: logic จริงถูกกำหนดตอนเรียกใช้ Dropdown.New
            end
        end)
    end

    head.MouseButton1Click:Connect(toggleOpen)

    return {
        Instance = container,
        Get = function() return selectedLabel.Text end,
    }
end

return Dropdown
