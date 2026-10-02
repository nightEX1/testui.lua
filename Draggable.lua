--[[
    Draggable.lua
    ทำให้ GuiObject ลากได้ทั้ง Mouse และ Touch แบบลื่น (ไม่กระตุกเพราะอัปเดตผ่าน RenderStepped
    และใช้ UDim2 offset ตรงๆ ไม่ผ่าน TweenService ระหว่างลาก)

    ใช้งาน:
        Draggable.Make(frame, {
            DragTarget = frame,          -- ส่วนที่ลากได้จริง (ถ้าไม่ใส่ = frame เอง)
            OnDragEnd = function(position) end, -- เรียกตอนปล่อยมือ เพื่อเซฟตำแหน่งล่าสุด
        })
--]]

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Draggable = {}

function Draggable.Make(frame, opts)
    opts = opts or {}
    local dragTarget = opts.DragTarget or frame
    local onDragEnd = opts.OnDragEnd

    local dragging = false
    local dragInput
    local dragStart
    local startPos
    local targetPos -- ตำแหน่งปลายทางล่าสุดที่ต้องการไป (สำหรับ smoothing)

    local connection

    local function update(input)
        local delta = input.Position - dragStart
        targetPos = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    dragTarget.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            targetPos = startPos

            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    conn:Disconnect()
                    if onDragEnd then
                        onDragEnd(frame.Position)
                    end
                end
            end)
        end
    end)

    dragTarget.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)

    -- Smooth interpolation ทุกเฟรม กัน input กระตุก
    connection = RunService.RenderStepped:Connect(function(dt)
        if targetPos then
            local alpha = math.clamp(dt * 18, 0, 1) -- smoothing factor
            frame.Position = frame.Position:Lerp(targetPos, alpha)
        end
    end)

    return {
        Disconnect = function()
            if connection then
                connection:Disconnect()
            end
        end,
    }
end

return Draggable
