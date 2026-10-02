--[[
    Window.lua
    ประกอบ Header (Logo+Name, Minimize/Close, Search) + Sidebar + Content เข้าด้วยกัน
    เชื่อมกับ FloatingIcon ให้เปิด/ปิดด้วย Scale+Fade+Slide animation
    Responsive: จำกัดขนาดสูงสุด และ clamp กับขนาดจอ
--]]

local Players = game:GetService("Players")
local Theme = require(script.Parent.Theme)
local Animation = require(script.Parent.Animation)
local Draggable = require(script.Parent.Draggable)
local Sidebar = require(script.Parent.Sidebar)
local FloatingIcon = require(script.Parent.FloatingIcon)

local Window = {}
Window.__index = Window

-- config.Title / config.Subtitle / config.LogoId / config.UserInfo
function Window.New(config)
    config = config or {}
    local self = setmetatable({}, Window)

    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "ModernScriptUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = playerGui

    -- ---------- Responsive sizing ----------
    -- ขนาดสูงสุดไม่เกินจอ, บนมือถือจะหดสัดส่วนลงอัตโนมัติผ่าน Scale
    local viewport = workspace.CurrentCamera.ViewportSize
    local isMobile = viewport.X < 700

    local winWidth = isMobile and UDim2.new(0.92, 0, 0, 420) or UDim2.new(0, 640, 0, 420)

    self.Main = Instance.new("Frame")
    self.Main.Name = "Main"
    self.Main.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Main.Position = UDim2.fromScale(0.5, 0.5)
    self.Main.Size = winWidth
    self.Main.BackgroundColor3 = Theme.Colors.Background
    self.Main.Visible = false
    self.Main.Parent = self.ScreenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = Theme.Radius.Large
    mainCorner.Parent = self.Main

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Name = "UIStroke"
    mainStroke.Color = Theme.Colors.Border
    mainStroke.Thickness = 1
    mainStroke.Parent = self.Main

    -- clamp สูงไม่เกินจอ (กันกรณีจอเตี้ย)
    local maxHeight = math.min(420, viewport.Y - 80)
    self.Main.Size = UDim2.new(winWidth.X.Scale, winWidth.X.Offset, 0, maxHeight)

    -- ================= HEADER =================
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundColor3 = Theme.Colors.Surface
    header.Size = UDim2.new(1, 0, 0, Theme.Sizing.HeaderHeight)
    header.Parent = self.Main

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = Theme.Radius.Large
    headerCorner.Parent = header

    -- ปิดมุมโค้งด้านล่างของ header ไม่ให้โชว์ (เอาไว้ครึ่งล่างเหลี่ยม)
    local headerMask = Instance.new("Frame")
    headerMask.BackgroundColor3 = Theme.Colors.Surface
    headerMask.BorderSizePixel = 0
    headerMask.Size = UDim2.new(1, 0, 0, Theme.Sizing.HeaderHeight / 2)
    headerMask.Position = UDim2.new(0, 0, 1, -Theme.Sizing.HeaderHeight / 2)
    headerMask.ZIndex = 0
    headerMask.Parent = header

    local logo = Instance.new("ImageLabel")
    logo.BackgroundTransparency = 1
    logo.Image = config.LogoId or "" -- TODO: ใส่ rbxassetid โลโก้
    logo.Size = UDim2.fromOffset(28, 28)
    logo.Position = UDim2.fromOffset(14, 12)
    logo.Parent = header

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = config.Title or "Script Name"
    titleLabel.Font = Theme.Fonts.Bold
    titleLabel.TextSize = 15
    titleLabel.TextColor3 = Theme.Colors.TextPrimary
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.fromOffset(50, 8)
    titleLabel.Size = UDim2.new(0, 200, 0, 18)
    titleLabel.Parent = header

    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Text = config.Subtitle or "Premium Script"
    subtitleLabel.Font = Theme.Fonts.Regular
    subtitleLabel.TextSize = 11
    subtitleLabel.TextColor3 = Theme.Colors.TextSecondary
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Position = UDim2.fromOffset(50, 26)
    subtitleLabel.Size = UDim2.new(0, 200, 0, 14)
    subtitleLabel.Parent = header

    -- minimize / close buttons
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.Font = Theme.Fonts.Bold
    closeBtn.TextSize = 13
    closeBtn.TextColor3 = Theme.Colors.TextSecondary
    closeBtn.BackgroundTransparency = 1
    closeBtn.Size = UDim2.fromOffset(32, 32)
    closeBtn.Position = UDim2.new(1, -38, 0, 10)
    closeBtn.Parent = header

    local minBtn = Instance.new("TextButton")
    minBtn.Text = "–"
    minBtn.Font = Theme.Fonts.Bold
    minBtn.TextSize = 15
    minBtn.TextColor3 = Theme.Colors.TextSecondary
    minBtn.BackgroundTransparency = 1
    minBtn.Size = UDim2.fromOffset(32, 32)
    minBtn.Position = UDim2.new(1, -72, 0, 10)
    minBtn.Parent = header

    -- search box
    local searchBox = Instance.new("TextBox")
    searchBox.PlaceholderText = "Search..."
    searchBox.Text = ""
    searchBox.Font = Theme.Fonts.Regular
    searchBox.TextSize = 12
    searchBox.TextColor3 = Theme.Colors.TextPrimary
    searchBox.PlaceholderColor3 = Theme.Colors.TextMuted
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.BackgroundColor3 = Theme.Colors.SurfaceHover
    searchBox.ClearTextOnFocus = false
    searchBox.Size = UDim2.new(0, 160, 0, 28)
    searchBox.Position = UDim2.new(1, -240, 0, 12)
    searchBox.Parent = header

    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = Theme.Radius.Medium
    searchCorner.Parent = searchBox

    local searchPadding = Instance.new("UIPadding")
    searchPadding.PaddingLeft = UDim.new(0, 10)
    searchPadding.Parent = searchBox

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        if self.OnSearch then
            self.OnSearch(searchBox.Text) -- TODO: เชื่อม filter element ในหน้า content จริง
        end
    end)

    -- ================= BODY (Sidebar + Content) =================
    local body = Instance.new("Frame")
    body.Name = "Body"
    body.BackgroundTransparency = 1
    body.Position = UDim2.fromOffset(0, Theme.Sizing.HeaderHeight)
    body.Size = UDim2.new(1, 0, 1, -Theme.Sizing.HeaderHeight)
    body.Parent = self.Main

    self.SidebarComp = Sidebar.New(body, {
        UserInfo = config.UserInfo,
        OnSelect = function(name)
            self:SelectPage(name)
        end,
    })

    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Name = "Content"
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.Position = UDim2.new(0, Theme.Sizing.SidebarWidth, 0, 0)
    self.ContentArea.Size = UDim2.new(1, -Theme.Sizing.SidebarWidth, 1, 0)
    self.ContentArea.Parent = body

    -- สร้างหน้า (ScrollingFrame) ให้ครบ 6 เมนูไว้ล่วงหน้า
    self.Pages = {}
    for i, name in ipairs(self.SidebarComp.Items) do
        local page = Instance.new("ScrollingFrame")
        page.Name = name
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.Size = UDim2.fromScale(1, 1)
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Theme.Colors.Accent
        page.Visible = (i == 1)
        page.Parent = self.ContentArea

        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 14)
        padding.PaddingLeft = UDim.new(0, 14)
        padding.PaddingRight = UDim.new(0, 14)
        padding.PaddingBottom = UDim.new(0, 14)
        padding.Parent = page

        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 12)
        layout.Parent = page

        self.Pages[name] = page
    end

    -- ---------- dragging ด้วย header ----------
    Draggable.Make(self.Main, { DragTarget = header })

    -- ---------- close / minimize ----------
    closeBtn.MouseButton1Click:Connect(function()
        self:Close()
    end)
    minBtn.MouseButton1Click:Connect(function()
        self:Close() -- ย่อกลับไปเหลือแค่ Floating Icon
    end)

    -- ---------- Floating Icon ----------
    self.Floating = FloatingIcon.New(self.ScreenGui, {
        LogoId = config.LogoId,
        GetSavedPosition = config.GetSavedIconPosition, -- TODO: ผูกกับระบบเซฟจริง (attribute/DataStore)
        SavePosition = config.SaveIconPosition,
        OnToggle = function(isOpen)
            if isOpen then
                self:Open()
            else
                self:Close()
            end
        end,
    })

    self.IsOpen = false

    return self
end

function Window:SelectPage(name)
    for pageName, page in pairs(self.Pages) do
        page.Visible = (pageName == name)
    end
end

function Window:GetPage(name)
    return self.Pages[name]
end

function Window:Open()
    self.IsOpen = true
    self.Floating:SetOpenState(true)
    Animation.Open(self.Main, {
        Size = self.Main.Size,
        Position = self.Main.Position,
        Duration = 0.25,
    })
end

function Window:Close()
    self.IsOpen = false
    self.Floating:SetOpenState(false)
    Animation.Close(self.Main, { Duration = 0.2 })
end

function Window:Toggle()
    if self.IsOpen then
        self:Close()
    else
        self:Open()
    end
end

return Window
