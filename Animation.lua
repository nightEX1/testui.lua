--[[
    Animation.lua
    รวม Tween helper ทั้งหมด ใช้ easing เดียวกันทั้งระบบเพื่อความลื่นไหลสม่ำเสมอ
--]]

local TweenService = game:GetService("TweenService")
local Theme = require(script.Parent.Theme)

local Animation = {}

local function makeInfo(duration, style, direction)
    return TweenInfo.new(
        duration or Theme.Animation.Normal,
        style or Theme.Animation.Easing,
        direction or Theme.Animation.EasingDirection
    )
end

function Animation.Tween(instance, props, duration, style, direction)
    local tween = TweenService:Create(instance, makeInfo(duration, style, direction), props)
    tween:Play()
    return tween
end

-- เปิด UI ด้วย Scale + Fade + Slide
function Animation.Open(frame, opts)
    opts = opts or {}
    local duration = opts.Duration or 0.25

    local targetSize = opts.Size or frame.Size
    local targetPos = opts.Position or frame.Position

    frame.Visible = true
    frame.Size = UDim2.new(targetSize.X.Scale * 0.92, targetSize.X.Offset, targetSize.Y.Scale * 0.92, targetSize.Y.Offset)
    frame.Position = targetPos + UDim2.fromOffset(0, 16)

    -- fade: ตั้ง GroupTransparency ผ่าน UIStroke/ground frame ที่มี BackgroundTransparency
    if frame:FindFirstChild("UIStroke") then
        frame.UIStroke.Transparency = 1
    end
    local startTransparency = frame.BackgroundTransparency
    frame.BackgroundTransparency = 1

    Animation.Tween(frame, {
        Size = targetSize,
        Position = targetPos,
        BackgroundTransparency = startTransparency,
    }, duration, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

-- ปิด UI แบบย้อนกลับ (Reverse animation)
function Animation.Close(frame, opts, onComplete)
    opts = opts or {}
    local duration = opts.Duration or 0.2

    local shrunkSize = UDim2.new(frame.Size.X.Scale * 0.92, frame.Size.X.Offset, frame.Size.Y.Scale * 0.92, frame.Size.Y.Offset)
    local droppedPos = frame.Position + UDim2.fromOffset(0, 16)

    local tween = Animation.Tween(frame, {
        Size = shrunkSize,
        Position = droppedPos,
        BackgroundTransparency = 1,
    }, duration, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

    tween.Completed:Connect(function()
        frame.Visible = false
        if onComplete then
            onComplete()
        end
    end)
end

-- fade เฉพาะความโปร่งใส (ใช้กับ icon, overlay)
function Animation.Fade(instance, transparency, duration)
    return Animation.Tween(instance, { BackgroundTransparency = transparency }, duration or Theme.Animation.Fast)
end

return Animation
