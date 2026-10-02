--[[
    Theme.lua
    ค่าสีและฟอนต์กลางของทั้งระบบ ปรับที่นี่ที่เดียว ทุก Component ดึงจากนี่หมด
    Accent สามารถเปลี่ยนให้ตรงกับ Logo ได้ (ค่าเริ่มต้น = ฟ้า-เขียว โทนเทคโนโลยี)
--]]

local Theme = {}

Theme.Colors = {
    -- base (dark / black / gray)
    Background      = Color3.fromRGB(18, 18, 20),   -- พื้นหลังหลัก
    Surface         = Color3.fromRGB(26, 26, 29),   -- Sidebar / Header
    SurfaceAlt      = Color3.fromRGB(32, 32, 36),   -- Card
    SurfaceHover    = Color3.fromRGB(40, 40, 45),
    Border          = Color3.fromRGB(46, 46, 51),

    -- text
    TextPrimary     = Color3.fromRGB(235, 235, 240),
    TextSecondary   = Color3.fromRGB(150, 150, 158),
    TextMuted       = Color3.fromRGB(100, 100, 108),

    -- accent (ของโลโก้ script — ไม่ใช้ม่วง)
    Accent          = Color3.fromRGB(64, 196, 160),   -- เขียวมิ้นต์/ฟ้า
    AccentDim       = Color3.fromRGB(40, 120, 100),
    AccentHover     = Color3.fromRGB(80, 215, 178),

    -- status
    Success         = Color3.fromRGB(76, 201, 140),
    Warning         = Color3.fromRGB(230, 180, 70),
    Danger          = Color3.fromRGB(230, 90, 90),

    Divider         = Color3.fromRGB(44, 44, 48),
}

Theme.Fonts = {
    Regular = Enum.Font.Gotham,
    Medium  = Enum.Font.GothamMedium,
    Bold    = Enum.Font.GothamBold,
}

Theme.Radius = {
    Small  = UDim.new(0, 6),
    Medium = UDim.new(0, 10),
    Large  = UDim.new(0, 14),
    Pill   = UDim.new(1, 0),
}

Theme.Sizing = {
    SidebarWidth   = 180,
    HeaderHeight   = 52,
    CardPadding    = 14,
    ElementSpacing = 10,
}

Theme.Animation = {
    Fast   = 0.15,
    Normal = 0.22,
    Slow   = 0.3,
    Easing = Enum.EasingStyle.Quint,
    EasingDirection = Enum.EasingDirection.Out,
}

return Theme
