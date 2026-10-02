--[[
    Sidebar.lua
    เมนูซ้าย 6 รายการตายตัว (Main, AutoFarm, Webhook, ESP, Shop, Setting)
    + User Profile ติดด้านล่างสุด คั่นด้วย Divider
    Active state เปลี่ยนแบบ smooth ด้วย Animation.Tween
--]]

local Theme = require(script.Parent.Theme)
local Animation = require(script.Parent.Animation)

local Sidebar = {}

local MENU_ITEMS = { "Main", "AutoFarm", "Webhook", "ESP", "Shop", "Setting" }

-- config.UserInfo = { Username = "...", PlayerTag = "@...", Role = "Script User", AvatarId = "rbxassetid://..." }
-- config.OnSelect = function(name) end -- เรียกตอนเปลี่ยนเมนู
function Sidebar.New(parent, config)
    config = config or {}

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.BackgroundColor3 = Theme.Colors.Surface
    sidebar.Size = UDim2.new(0, Theme.Sizing.SidebarWidth, 1, 0)
    sidebar.Parent = parent

    -- ---------------- Nav list ----------------
    local navHolder = Instance.new("Frame")
    navHolder.BackgroundTransparency = 1
    navHolder.Position = UDim2.fromOffset(0, 12)
    navHolder.Size = UDim2.new(1, 0, 1, -112) -- เผื่อที่ให้ profile ด้านล่าง
    navHolder.Parent = sidebar

    local navLayout = Instance.new("UIListLayout")
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Padding = UDim.new(0, 4)
    navLayout.Parent = navHolder

    local navPadding = Instance.new("UIPadding")
    navPadding.PaddingLeft = UDim.new(0, 10)
    navPadding.PaddingRight = UDim.new(0, 10)
    navPadding.Parent = navHolder

    local buttons = {}
    local activeName = MENU_ITEMS[1]

    local function setActive(name)
        activeName = name
        for itemName, btn in pairs(buttons) do
            local active = itemName == name
            Animation.Tween(btn, {
                BackgroundTransparency = active and 0 or 1,
                BackgroundColor3 = Theme.Colors.SurfaceHover,
            }, Theme.Animation.Fast)
            Animation.Tween(btn.Indicator, {
                BackgroundTransparency = active and 0 or 1,
            }, Theme.Animation.Fast)
            btn.TextLabel.TextColor3 = active and Theme.Colors.TextPrimary or Theme.Colors.TextSecondary
        end
        if config.OnSelect then
            config.OnSelect(name) -- TODO: เชื่อมกับการสลับ Content page จริง
        end
    end

    for i, name in ipairs(MENU_ITEMS) do
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Text = ""
        btn.BackgroundColor3 = Theme.Colors.SurfaceHover
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.LayoutOrder = i
        btn.Parent = navHolder

        local corner = Instance.new("UICorner")
        corner.CornerRadius = Theme.Radius.Medium
        corner.Parent = btn

        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.BackgroundColor3 = Theme.Colors.Accent
        indicator.BackgroundTransparency = 1
        indicator.Size = UDim2.new(0, 3, 0, 18)
        indicator.Position = UDim2.new(0, 0, 0.5, -9)
        indicator.Parent = btn

        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = Theme.Radius.Pill
        indicatorCorner.Parent = indicator

        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "TextLabel"
        textLabel.Text = name
        textLabel.Font = Theme.Fonts.Medium
        textLabel.TextSize = 13
        textLabel.TextColor3 = Theme.Colors.TextSecondary
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.BackgroundTransparency = 1
        textLabel.Position = UDim2.fromOffset(14, 0)
        textLabel.Size = UDim2.new(1, -14, 1, 0)
        textLabel.Parent = btn

        btn.TextLabel = textLabel
        btn.Indicator = indicator
        buttons[name] = btn

        btn.MouseButton1Click:Connect(function()
            setActive(name)
        end)
    end

    -- ---------------- Divider ----------------
    local divider = Instance.new("Frame")
    divider.BackgroundColor3 = Theme.Colors.Divider
    divider.BorderSizePixel = 0
    divider.Size = UDim2.new(1, -20, 0, 1)
    divider.Position = UDim2.new(0, 10, 1, -92)
    divider.Parent = sidebar

    -- ---------------- User profile (ติดล่างสุด) ----------------
    local profile = Instance.new("Frame")
    profile.BackgroundTransparency = 1
    profile.Size = UDim2.new(1, -20, 0, 70)
    profile.Position = UDim2.new(0, 10, 1, -80)
    profile.Parent = sidebar

    local avatar = Instance.new("ImageLabel")
    avatar.BackgroundColor3 = Theme.Colors.SurfaceHover
    avatar.Size = UDim2.fromOffset(38, 38)
    avatar.Position = UDim2.new(0, 0, 0.5, -19)
    avatar.Image = (config.UserInfo and config.UserInfo.AvatarId) or ""
    avatar.Parent = profile

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = Theme.Radius.Pill
    avatarCorner.Parent = avatar

    local username = Instance.new("TextLabel")
    username.Text = (config.UserInfo and config.UserInfo.Username) or "Username"
    username.Font = Theme.Fonts.Bold
    username.TextSize = 13
    username.TextColor3 = Theme.Colors.TextPrimary
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.BackgroundTransparency = 1
    username.Position = UDim2.fromOffset(48, 0)
    username.Size = UDim2.new(1, -48, 0, 16)
    username.Parent = profile

    local tag = Instance.new("TextLabel")
    tag.Text = (config.UserInfo and config.UserInfo.PlayerTag) or "@PlayerName"
    tag.Font = Theme.Fonts.Regular
    tag.TextSize = 11
    tag.TextColor3 = Theme.Colors.TextSecondary
    tag.TextXAlignment = Enum.TextXAlignment.Left
    tag.BackgroundTransparency = 1
    tag.Position = UDim2.fromOffset(48, 17)
    tag.Size = UDim2.new(1, -48, 0, 14)
    tag.Parent = profile

    local role = Instance.new("TextLabel")
    role.Text = (config.UserInfo and config.UserInfo.Role) or "Script User"
    role.Font = Theme.Fonts.Regular
    role.TextSize = 10
    role.TextColor3 = Theme.Colors.Accent
    role.TextXAlignment = Enum.TextXAlignment.Left
    role.BackgroundTransparency = 1
    role.Position = UDim2.fromOffset(48, 32)
    role.Size = UDim2.new(1, -48, 0, 14)
    role.Parent = profile

    setActive(MENU_ITEMS[1])

    return {
        Instance = sidebar,
        SetActive = setActive,
        GetActive = function() return activeName end,
        Items = MENU_ITEMS,
    }
end

return Sidebar
