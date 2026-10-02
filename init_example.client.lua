--[[
    init_example.client.lua
    ตัวอย่างการประกอบใช้งานทุก Module เข้าด้วยกัน
    วิธีวาง: ให้ไฟล์ทั้งหมดในโฟลเดอร์ ModernScriptUI เป็น ModuleScript ใน ReplicatedStorage
    (Theme, Animation, Draggable, Sidebar, FloatingIcon, Window, Components/*)
    แล้ว LocalScript นี้ require("Window") มาใช้งาน
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIFolder = ReplicatedStorage:WaitForChild("ModernScriptUI")

local Window = require(UIFolder.Window)
local Card = require(UIFolder.Components.Card)
local Toggle = require(UIFolder.Components.Toggle)
local Button = require(UIFolder.Components.Button)
local Dropdown = require(UIFolder.Components.Dropdown)
local Slider = require(UIFolder.Components.Slider)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ================= สร้างหน้าต่างหลัก =================
local window = Window.New({
    Title = "Voidware", -- TODO: เปลี่ยนชื่อ script
    Subtitle = "Premium Script UI",
    LogoId = "rbxassetid://0", -- TODO: ใส่ไอดีโลโก้จริง
    UserInfo = {
        Username = player.DisplayName,
        PlayerTag = "@" .. player.Name,
        Role = "Script User",
        AvatarId = "", -- TODO: ใส่ thumbnail ผู้เล่นจริงถ้าต้องการ
    },
    -- TODO: ผูกกับระบบเซฟตำแหน่งไอคอนจริง (เช่น attribute ของ player หรือไฟล์)
    GetSavedIconPosition = function()
        return nil -- คืนค่า UDim2 ตำแหน่งล่าสุดถ้ามี
    end,
    SaveIconPosition = function(position)
        -- เซฟ position ที่นี่
    end,
})

-- ================= MAIN PAGE =================
do
    local page = window:GetPage("Main")
    local infoCard = Card.New(page, "Status")
    Toggle.New(infoCard, {
        Text = "Enable Script",
        Default = false,
        Callback = function(state)
            -- TODO: logic เปิด/ปิดการทำงานหลักของสคริปต์
        end,
    })
    Button.New(infoCard, {
        Text = "Rejoin Server",
        Variant = "default",
        Callback = function()
            -- TODO: logic rejoin
        end,
    })
end

-- ================= AUTOFARM PAGE =================
do
    local page = window:GetPage("AutoFarm")
    local farmCard = Card.New(page, "Auto Farm")
    Toggle.New(farmCard, {
        Text = "Auto Farm",
        Default = false,
        Callback = function(state)
            -- TODO: logic auto farm
        end,
    })
    Dropdown.New(farmCard, {
        Text = "Farm Mode",
        Options = { "Nearest", "Strongest", "Weakest" },
        Default = "Nearest",
        Callback = function(selected)
            -- TODO: logic เปลี่ยนโหมดฟาร์ม
        end,
    })
    Slider.New(farmCard, {
        Text = "Farm Range",
        Min = 10,
        Max = 200,
        Default = 50,
        Suffix = " studs",
        Callback = function(value)
            -- TODO: logic ปรับระยะฟาร์ม
        end,
    })
end

-- ================= WEBHOOK PAGE =================
do
    local page = window:GetPage("Webhook")
    local hookCard = Card.New(page, "Discord Webhook")
    Toggle.New(hookCard, {
        Text = "Enable Webhook",
        Default = false,
        Callback = function(state)
            -- TODO: logic เปิด/ปิดการส่ง webhook
        end,
    })
    Button.New(hookCard, {
        Text = "Test Webhook",
        Variant = "accent",
        Callback = function()
            -- TODO: logic ยิง webhook ทดสอบ
        end,
    })
end

-- ================= ESP PAGE =================
do
    local page = window:GetPage("ESP")
    local espCard = Card.New(page, "ESP")
    Toggle.New(espCard, {
        Text = "Player ESP",
        Default = false,
        Callback = function(state)
            -- TODO: logic เปิด/ปิด ESP ผู้เล่น
        end,
    })
    Toggle.New(espCard, {
        Text = "Item ESP",
        Default = false,
        Callback = function(state)
            -- TODO: logic เปิด/ปิด ESP ไอเทม
        end,
    })
end

-- ================= SHOP PAGE =================
do
    local page = window:GetPage("Shop")
    local shopCard = Card.New(page, "Premium Key")
    Button.New(shopCard, {
        Text = "Buy Key",
        Variant = "accent",
        Callback = function()
            -- TODO: logic เปิดลิงก์ซื้อ key
        end,
    })
end

-- ================= SETTING PAGE =================
do
    local page = window:GetPage("Setting")
    local settingCard = Card.New(page, "General")
    Dropdown.New(settingCard, {
        Text = "UI Theme",
        Options = { "Dark", "Darker" },
        Default = "Dark",
        Callback = function(selected)
            -- TODO: logic เปลี่ยนธีม (ถ้ารองรับหลายธีม)
        end,
    })
    Button.New(settingCard, {
        Text = "Reset Position",
        Variant = "danger",
        Callback = function()
            -- TODO: logic รีเซ็ตตำแหน่ง UI/ไอคอน
        end,
    })
end

-- หน้าต่างเริ่มต้นแบบซ่อนไว้ก่อน (มีแค่ Floating Icon) ผู้เล่นต้องคลิก Logo เพื่อเปิดเอง
