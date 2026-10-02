# Modern Script UI

โครงสร้างโมดูลสำหรับ UI สไตล์ Dark Modern / Premium ของ Roblox Script

## โครงสร้างไฟล์

```
ModernScriptUI/
├── Theme.lua              -- สี/ฟอนต์/ระยะห่างกลาง (แก้สีที่นี่ที่เดียว)
├── Animation.lua          -- Tween helper: Open/Close (Scale+Fade+Slide), Fade
├── Draggable.lua          -- ลาก Mouse/Touch แบบ smooth (ใช้กับ Floating Icon + Window)
├── FloatingIcon.lua       -- ปุ่มลอยโลโก้ script, ลากได้, เปิด/ปิด Main UI
├── Sidebar.lua            -- เมนู 6 รายการ + User Profile ด้านล่าง
├── Window.lua             -- ประกอบ Header/Search/Sidebar/Content ทั้งหมด
├── Components/
│   ├── Card.lua           -- กล่อง section
│   ├── Toggle.lua
│   ├── Button.lua
│   ├── Dropdown.lua
│   └── Slider.lua
└── init_example.client.lua -- ตัวอย่างการประกอบใช้งานจริง
```

## วิธีติดตั้งใน Roblox Studio

1. สร้าง Folder ชื่อ `ModernScriptUI` ใน `ReplicatedStorage`
2. นำไฟล์ `Theme.lua`, `Animation.lua`, `Draggable.lua`, `FloatingIcon.lua`,
   `Sidebar.lua`, `Window.lua` ไปแปลงเป็น **ModuleScript** ชื่อเดียวกัน (ตัดนามสกุล `.lua`)
   ไว้ใต้โฟลเดอร์นั้น
3. สร้าง Folder ย่อยชื่อ `Components` และนำ `Card.lua` / `Toggle.lua` / `Button.lua` /
   `Dropdown.lua` / `Slider.lua` ไปแปลงเป็น ModuleScript ไว้ข้างใน
4. นำ `init_example.client.lua` ไปแปลงเป็น **LocalScript** วางใน `StarterPlayerScripts`
   (หรือฝัง logic เดียวกันใน Executor script ถ้าใช้กับ exploit/executor — เปลี่ยนแค่
   `require(UIFolder.Window)` เป็น `loadstring`/`require` ตามระบบที่ script ใช้)
5. รันเกม → จะเห็น Floating Icon ลอยอยู่ที่ขอบจอซ้าย คลิกเพื่อเปิด Main UI

## จุดที่ต้องไปใส่โค้ดเอง (ค้นด้วยคำว่า `TODO:`)

- `config.LogoId` ใน `Window.New` และ `FloatingIcon.New` — ใส่ `rbxassetid://` ของโลโก้จริง
- `callback` ของทุก Toggle/Button/Dropdown/Slider ใน `init_example.client.lua` —
  ใส่ logic ของแต่ละฟีเจอร์ (AutoFarm, Webhook, ESP ฯลฯ)
- `GetSavedIconPosition` / `SaveIconPosition` — ผูกกับระบบเซฟตำแหน่งจริง
  (เช่น `player:SetAttribute`, DataStore, หรือไฟล์ของ executor)

## หมายเหตุการออกแบบ

- **สีหลัก**: Dark/Black/Gray (`Theme.Colors.Background/Surface/SurfaceAlt`)
  ไม่มีสีม่วงเป็นสีหลักตามที่ระบุ — ใช้ Accent เขียวมิ้นต์-ฟ้าเป็นตัวอย่าง
  เปลี่ยนได้ที่ `Theme.Colors.Accent` ให้ตรงกับโทนโลโก้จริง
- **Responsive**: `Window.lua` คำนวณขนาดจาก `workspace.CurrentCamera.ViewportSize`
  เพื่อหด UI บนมือถือ (`isMobile`) และ clamp ความสูงไม่ให้เกินจอ
- **Drag ลื่นไม่กระตุก**: `Draggable.lua` ใช้ `RenderStepped` + `Lerp` แทนการเซ็ต
  Position ตรงๆ ทุกเฟรม อินพุต
- **Animation เปิด/ปิด**: `Animation.Open/Close` ทำ Scale 0.92→1 + Fade + Slide 16px
  ด้วย `Back`/`Quint` easing ระยะเวลา ~200–250ms ตามที่ระบุ


## ใช้งานแบบไฟล์เดียวด้วย loadstring

ไม่ต้องสร้างโฟลเดอร์ `ModernScriptUI` ใน `ReplicatedStorage` สามารถเรียกไฟล์ `main.lua` ซึ่งรวมทุก Module ไว้แล้วได้โดยตรง:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/nightEX1/testui.lua/main/main.lua"))()
```

ไฟล์นี้เป็นตัวโหลดแบบ standalone และจะสร้าง UI จากตัวอย่างใน `init_example.client.lua` ให้ทันที
