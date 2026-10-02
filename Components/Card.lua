--[[
    Card.lua
    กล่อง Section พื้นฐาน ใช้ห่อ element อื่นๆ (Toggle/Button/Dropdown/Slider)
--]]

local Theme = require(script.Parent.Parent.Theme)

local Card = {}

function Card.New(parent, title, layoutOrder)
    local card = Instance.new("Frame")
    card.Name = "Card"
    card.BackgroundColor3 = Theme.Colors.SurfaceAlt
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.LayoutOrder = layoutOrder or 1
    card.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = Theme.Radius.Large
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Colors.Border
    stroke.Thickness = 1
    stroke.Parent = card

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, Theme.Sizing.CardPadding)
    padding.PaddingBottom = UDim.new(0, Theme.Sizing.CardPadding)
    padding.PaddingLeft = UDim.new(0, Theme.Sizing.CardPadding)
    padding.PaddingRight = UDim.new(0, Theme.Sizing.CardPadding)
    padding.Parent = card

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, Theme.Sizing.ElementSpacing)
    layout.Parent = card

    if title then
        local label = Instance.new("TextLabel")
        label.Name = "Title"
        label.Text = title
        label.Font = Theme.Fonts.Bold
        label.TextSize = 14
        label.TextColor3 = Theme.Colors.TextPrimary
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 18)
        label.LayoutOrder = 0
        label.Parent = card
    end

    return card
end

return Card
