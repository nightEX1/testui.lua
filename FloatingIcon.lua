--[[
    FloatingIcon.lua
    ปุ่มลอย (Logo) ลากได้ทั้ง Mouse/Touch, จำตำแหน่งล่าสุด (ผ่าน SaveLoad callback ที่ส่งเข้ามา),
    คลิกเพื่อเปิด/ปิด Main UI, อยู่ได้แม้ Main UI ถูกปิด
--]]

local Theme = require(script.Parent.Theme)
local Animation = require(script.Parent.Animation)
local Draggable = require(script.Parent.Draggable)

local FloatingIcon = {}

-- config.LogoId: rbxassetid ของโลโก้ script (ใส่เองภายหลัง)
-- config.OnToggle: function(isOpen) -- เรียกเมื่อคลิกไอคอน
-- config.GetSavedPosition / config.SavePosition: function สำหรับจำตำแหน่งล่าสุด (เช่นบันทึกลง attribute หรือไฟล์)
function FloatingIcon.New(screenGui, config)
    config = config or {}

    local icon = Instance.new("ImageButton")
    icon.Name = "FloatingIcon"
    icon.Size = UDim2.fromOffset(56, 56)
    icon.Position = config.GetSavedPosition and config.GetSavedPosition() or UDim2.new(0, 20, 0.5, -28)
    icon.BackgroundColor3 = Theme.Colors.Surface
    icon.Image = config.LogoId or "" -- TODO: ใส่ rbxassetid ของโลโก้ script ตรงนี้
    icon.ScaleType = Enum.ScaleType.Fit
    icon.ZIndex = 1000
    icon.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = Theme.Radius.Pill
    corner.Parent = icon

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Colors.Accent
    stroke.Thickness = 2
    stroke.Parent = icon

    -- padding กันโลโก้ชนขอบวงกลม
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = icon

    -- เอฟเฟกต์ hover เบาๆ
    icon.MouseEnter:Connect(function()
        Animation.Tween(icon, { Size = UDim2.fromOffset(60, 60) }, Theme.Animation.Fast)
    end)
    icon.MouseLeave:Connect(function()
        Animation.Tween(icon, { Size = UDim2.fromOffset(56, 56) }, Theme.Animation.Fast)
    end)

    -- ลากได้ smooth ทั้ง mouse/touch, ไม่ trigger click ตอนลาก
    local didDrag = false
    local dragHandle = Draggable.Make(icon, {
        OnDragEnd = function(position)
            if config.SavePosition then
                config.SavePosition(position) -- TODO: บันทึกตำแหน่งจริง (DataStore/attribute) ตอนเรียกใช้งาน
            end
        end,
    })

    local isOpen = false
    icon.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if config.OnToggle then
            config.OnToggle(isOpen) -- TODO: เชื่อมกับ Window:Open()/Window:Close() ตอนประกอบใช้งานจริง
        end
    end)

    return {
        Instance = icon,
        SetOpenState = function(_, value) isOpen = value end,
        Destroy = function()
            dragHandle.Disconnect()
            icon:Destroy()
        end,
    }
end

return FloatingIcon
