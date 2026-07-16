repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ==================== CONFIGURACIÓN DE PAGA (SÓLO COMPRADORES POR ID) ====================
local USUARIOS_PERMITIDOS = {
    [8216624047] = true,   -- Comprador 1
    [10603802243] = true,  -- Comprador 2
    [7149173878] = true,    -- Comprador 3
    [9763328724] = true,    -- Comprador 4
    [0] = true,            -- Comprador 5
}
-- ====================================================================================

if not USUARIOS_PERMITIDOS[LocalPlayer.UserId] then
    return 
end

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Camera = workspace.CurrentCamera

local IsAiming = false

-- PALETA DE COLORES MINIMALISTA (NEGRO, BLANCO, GRIS Y AZUL CELESTE)
local Color_Backdrop = Color3.fromRGB(17, 17, 17)       -- Fondo Negro #111111
local Color_Card = Color3.fromRGB(24, 24, 24)           -- Tarjetas oscuras para contraste
local Color_CardDark = Color3.fromRGB(12, 12, 12)       -- Fondo secundario profundo
local Color_NeonBlue = Color3.fromRGB(0, 168, 255)      -- Azul Celeste #00a8ff (Activo)
local Color_NeonBlueDim = Color3.fromRGB(0, 55, 85)     -- Azul apagado para transiciones
local Color_TextMain = Color3.fromRGB(255, 255, 255)    -- Texto principal Blanco Puro
local Color_TextSub = Color3.fromRGB(160, 160, 160)     -- Texto secundario Gris Claro
local Color_BorderActive = Color3.fromRGB(200, 200, 200) -- Bordes Blancos Finos para elementos activos
local Color_BorderMuted = Color3.fromRGB(70, 70, 70)     -- Bordes Grises para elementos desactivados

-- ESP Colores
local MainESPColor = Color3.fromRGB(0, 168, 255)       
local WhiteESP = Color3.fromRGB(255, 255, 255)          -- ESP Blanco
local DistESPColor = Color3.fromRGB(160, 160, 160)      -- Distancia en Gris (Modificado)

local originalName = LocalPlayer.Name
local originalDisplayName = LocalPlayer.DisplayName

-- Settings
local Settings = {
    Aimbot = true,
    AimKey = Enum.UserInputType.MouseButton2,
    NoRecoil = true,
    NameOne = false, 
    FOV = 150,
    AimPart = "Head",
    ESP = true,           
    NameESP = true,       
    DistanceESP = true,   
    SkeletonESP = true,   
    WeaponESP = true,     
    HPBar = true,
    FOVVisible = true,
    DefaultFOV = Camera.FieldOfView,
    Whitelist = {} 
}

local function CheckInput(input, state)
    if input.UserInputType == Settings.AimKey then
        IsAiming = state
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    CheckInput(input, true)
end)

UserInputService.InputEnded:Connect(function(input)
    CheckInput(input, false)
end)

-- Nombre reactivo
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = LocalPlayer.Character
            if Settings.NameOne then
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.DisplayName ~= "1" then
                        humanoid.DisplayName = "1"
                    end
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("TextLabel") or obj:IsA("TextBox") then
                            if obj.Text == originalName or obj.Text == originalDisplayName then
                                obj.Text = "1"
                            end
                        end
                    end
                end
            else
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.DisplayName ~= originalDisplayName then
                        humanoid.DisplayName = originalDisplayName
                    end
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("TextLabel") or obj:IsA("TextBox") then
                            if obj.Text == "1" then
                                obj.Text = originalDisplayName
                            end
                        end
                    end
                end
            end
        end)
    end
end)

local function TieneArmaEquipada()
    if not LocalPlayer.Character then return false end
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool and tool.Name ~= "Fists" then
        return true
    end
    return false
end

local function PlaySound(id, vol, pitch)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(id)
    sound.Volume = vol or 0.3
    sound.PlaybackSpeed = pitch or 1.1
    sound.PlayOnRemove = true
    sound.Parent = SoundService
    sound:Destroy()
end

local function PlayWindToggleOn() PlaySound(134012322, 0.25, 1.3) end   
local function PlayWindToggleOff() PlaySound(134012322, 0.2, 0.9) end 
local function PlayWindMenuOpen() PlaySound(9114228358, 0.4, 1.0) end  
local function PlayWindMenuClose() PlaySound(9114228358, 0.3, 1.2) end 

local function FastTween(instance, properties, duration, style)
    TweenService:Create(instance, TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties):Play()
end

-- Notificación Minimalista
local function Notify(msg, color)
    local NotifyGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
    local Frame = Instance.new("Frame", NotifyGui)
    Frame.Size = UDim2.new(0, 260, 0, 45)
    Frame.Position = UDim2.new(1, 30, 0.9, 0)
    Frame.BackgroundColor3 = Color_Backdrop
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = color or Color_NeonBlue
    Stroke.Thickness = 1
    
    local Accent = Instance.new("Frame", Frame)
    Accent.Size = UDim2.new(0, 3, 1, 0)
    Accent.BackgroundColor3 = color or Color_NeonBlue
    Instance.new("UICorner", Accent).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = msg
    Label.TextColor3 = Color_TextMain
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 11
    Label.TextXAlignment = "Left"

    FastTween(Frame, {Position = UDim2.new(1, -280, 0.9, 0)}, 0.3)
    task.delay(3.5, function()
        FastTween(Frame, {Position = UDim2.new(1, 30, 0.9, 0)}, 0.3)
        task.wait(0.3)
        NotifyGui:Destroy()
    end)
end

-- No Recoil Engine
task.spawn(function()
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if Settings.NoRecoil and IsAiming and TieneArmaEquipada() and not checkcaller() and type(key) == "string" then
            local k = string.lower(key)
            if k == "recoil" or k == "recoilcontrol" or k == "kickback" or k == "spread" or k:find("recoil") or k:find("spread") then 
                return 0 
            end
        end
        return oldIndex(self, key)
    end)
end)

task.spawn(function()
    while task.wait(0.2) do
        if Settings.NoRecoil and IsAiming and TieneArmaEquipada() and LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                for _, obj in ipairs(tool:GetDescendants()) do
                    if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                        local name = string.lower(obj.Name)
                        if name:find("recoil") or name:find("spread") or name:find("kickback") or name:find("shake") then
                            obj.Value = 0
                        end
                    end
                end
                for attrName, _ in pairs(tool:GetAttributes()) do
                    local name = string.lower(attrName)
                    if name:find("recoil") or name:find("spread") or name:find("kickback") then
                        tool:SetAttribute(attrName, 0)
                    end
                end
            end
        end
    end
end)

-- Registro de Armas
local Items = game:GetService("ReplicatedStorage"):WaitForChild("Items")
local WeaponRegistry = {}

local function registerItems(folder)
    for _, tool in ipairs(folder:GetChildren()) do
        if tool:IsA("Tool") then
            local handle = tool:FindFirstChild("Handle")
            local displayName = tool:GetAttribute("DisplayName") or tool.Name
            local itemId = tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name
            local key

            if handle then
                local mesh = handle:FindFirstChildOfClass("SpecialMesh")
                if mesh and mesh.MeshId ~= "" then
                    key = mesh.MeshId .. (mesh.TextureId or "")
                elseif handle:IsA("MeshPart") and handle.MeshId ~= "" then
                    key = handle.MeshId .. (handle.TextureID or "")
                end
            end

            if not key and itemId and itemId ~= "" and itemId ~= tool.Name then
                key = "ITEMID_" .. itemId
            end

            if not key then
                key = "NAME_" .. displayName .. "_" .. tool.Name
            end

            WeaponRegistry[key] = {
                Name = displayName,
                ToolName = tool.Name
            }
        end
    end
end

local function scanFolders(folder)
    registerItems(folder)
    folder.ChildAdded:Connect(function(child)
        task.wait(0.1)
        if child:IsA("Folder") then
            scanFolders(child)
        else
            registerItems(folder)
        end
    end)

    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("Folder") then
            scanFolders(child)
        end
    end
end
scanFolders(Items)

local function getItemKey(tool)
    local handle = tool:FindFirstChild("Handle")
    local displayName = tool:GetAttribute("DisplayName") or tool.Name
    local itemId = tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name

    if handle then
        local mesh = handle:FindFirstChildOfClass("SpecialMesh")
        if mesh and mesh.MeshId ~= "" then return mesh.MeshId .. (mesh.TextureId or "") end
        if handle:IsA("MeshPart") and handle.MeshId ~= "" then return handle.MeshId .. (handle.TextureID or "") end
    end
    if itemId and itemId ~= "" and itemId ~= tool.Name then return "ITEMID_" .. itemId end
    return "NAME_" .. displayName .. "_" .. tool.Name
end

local function getWeapons(player)
    local items = {}
    local function scan(container)
        if not container then return end
        for _, tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") and tool.Name ~= "Fists" then
                local info = WeaponRegistry[getItemKey(tool)]
                if info then table.insert(items, { Name = info.Name }) end
            end
        end
    end
    scan(player:FindFirstChild("Backpack"))
    scan(player.Character)
    return items
end

-- RENDER ESP
local ESPObjects = {}
local SkeletonConnections = {
    R15 = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"}
    },
    R6 = {
        {"Head", "Torso"},
        {"Torso", "Left Arm"},
        {"Torso", "Right Arm"},
        {"Torso", "Left Leg"},
        {"Torso", "Right Leg"}
    }
}

local function RemoveESP(player)
    if ESPObjects[player] then
        for _, object in pairs(ESPObjects[player].Drawings) do 
            object.Visible = false
            object:Destroy() 
        end
        for _, weaponDraw in pairs(ESPObjects[player].Weapons) do 
            weaponDraw.Visible = false
            weaponDraw:Destroy() 
        end
        for _, line in ipairs(ESPObjects[player].SkeletonLines) do
            line.Visible = false
            line:Destroy()
        end
        ESPObjects[player] = nil
    end
end

local function CreateESPObjects(player)
    if ESPObjects[player] then return ESPObjects[player] end
    
    local obj = {
        Drawings = {
            Name = Drawing.new("Text"), DistLabel = Drawing.new("Text"), Box = Drawing.new("Square"),           
            HealthBarBg = Drawing.new("Square"), HealthBar = Drawing.new("Square"), HealthText = Drawing.new("Text")       
        }, 
        Weapons = {}, 
        SkeletonLines = {}
    }
    obj.Drawings.Name.Size = 13; obj.Drawings.Name.Center = true; obj.Drawings.Name.Outline = true; obj.Drawings.Name.Color = WhiteESP
    obj.Drawings.DistLabel.Size = 11; obj.Drawings.DistLabel.Center = true; obj.Drawings.DistLabel.Outline = true; obj.Drawings.DistLabel.Color = DistESPColor
    obj.Drawings.Box.Thickness = 1.2; obj.Drawings.Box.Color = MainESPColor
    obj.Drawings.HealthBarBg.Filled = true; obj.Drawings.HealthBarBg.Color = Color3.new(0,0,0)
    obj.Drawings.HealthBar.Filled = true
    obj.Drawings.HealthText.Size = 11; obj.Drawings.HealthText.Center = false; obj.Drawings.HealthText.Outline = true
    
    for i = 1, 15 do
        local line = Drawing.new("Line")
        line.Thickness = 1.2
        line.Color = MainESPColor
        line.Visible = false
        table.insert(obj.SkeletonLines, line)
    end

    ESPObjects[player] = obj
    return obj
end

local function VincularJugador(p)
    if p == LocalPlayer then return end
    CreateESPObjects(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.1)
        CreateESPObjects(p)
    end)
    p.CharacterRemoving:Connect(function()
        local objs = ESPObjects[p]
        if objs then
            for _, draw in pairs(objs.Drawings) do draw.Visible = false end
            for _, wd in pairs(objs.Weapons) do wd.Visible = false end
            for _, line in ipairs(objs.SkeletonLines) do line.Visible = false end
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do VincularJugador(p) end
Players.PlayerAdded:Connect(VincularJugador)
Players.PlayerRemoving:Connect(RemoveESP)

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local objs = ESPObjects[p]
        if not objs then objs = CreateESPObjects(p) end
        
        local char = p.Character
        local canRenderAny = (Settings.ESP or Settings.NameESP or Settings.DistanceESP or Settings.WeaponESP or Settings.SkeletonESP)
        
        if not canRenderAny or not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 or not char:FindFirstChild("HumanoidRootPart") then
            for _, draw in pairs(objs.Drawings) do draw.Visible = false end
            for _, wd in pairs(objs.Weapons) do wd.Visible = false end
            for _, line in ipairs(objs.SkeletonLines) do line.Visible = false end
            continue
        end

        local root = char.HumanoidRootPart
        local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local isWhitelisted = Settings.Whitelist[p.Name] == true
        local colToUse = isWhitelisted and Color3.fromRGB(200,200,200) or MainESPColor

        if onScreen and Settings.SkeletonESP then
            local isR15 = char.Humanoid.RigType == Enum.HumanoidRigType.R15
            local connections = isR15 and SkeletonConnections.R15 or SkeletonConnections.R6
            local lineIndex = 1

            for _, pair in ipairs(connections) do
                local partA = char:FindFirstChild(pair[1])
                local partB = char:FindFirstChild(pair[2])

                if partA and partB then
                    local posA, onScreenA = Camera:WorldToViewportPoint(partA.Position)
                    local posB, onScreenB = Camera:WorldToViewportPoint(partB.Position)

                    if onScreenA and onScreenB then
                        local line = objs.SkeletonLines[lineIndex]
                        if line then
                            line.From = Vector2.new(posA.X, posA.Y)
                            line.To = Vector2.new(posB.X, posB.Y)
                            line.Color = colToUse
                            line.Visible = true
                            lineIndex = lineIndex + 1
                        end
                    end
                end
            end
            for i = lineIndex, #objs.SkeletonLines do
                objs.SkeletonLines[i].Visible = false
            end
        else
            for _, line in ipairs(objs.SkeletonLines) do line.Visible = false end
        end

        if onScreen then
            local h = (Camera.ViewportSize.Y / screenPos.Z) * 2.6
            local w = h * 0.62
            local x, y = screenPos.X - w/2, screenPos.Y - h/2
            
            if Settings.ESP then
                objs.Drawings.Box.Color = colToUse
                objs.Drawings.Box.Size = Vector2.new(w, h); objs.Drawings.Box.Position = Vector2.new(x, y); objs.Drawings.Box.Visible = true
            else objs.Drawings.Box.Visible = false end

            if Settings.NameESP then objs.Drawings.Name.Visible = true; objs.Drawings.Name.Text = p.DisplayName; objs.Drawings.Name.Position = Vector2.new(screenPos.X, y - 18)
            else objs.Drawings.Name.Visible = false end

            if Settings.DistanceESP then objs.Drawings.DistLabel.Visible = true; objs.Drawings.DistLabel.Text = math.floor(screenPos.Z) .. "m"; objs.Drawings.DistLabel.Position = Vector2.new(screenPos.X, y + h + 4)
            else objs.Drawings.DistLabel.Visible = false end

            if Settings.HPBar then
                local rawHp = math.floor(char.Humanoid.Health)
                local hpPercent = math.clamp(char.Humanoid.Health / char.Humanoid.MaxHealth, 0, 1)
                local hpColor = Color3.fromHSV(hpPercent * 0.33, 0.9, 0.9)
                objs.Drawings.HealthBarBg.Visible = true; objs.Drawings.HealthBarBg.Size = Vector2.new(3, h); objs.Drawings.HealthBarBg.Position = Vector2.new(x - 5, y)
                objs.Drawings.HealthBar.Visible = true; objs.Drawings.HealthBar.Size = Vector2.new(1.5, h * hpPercent); objs.Drawings.HealthBar.Position = Vector2.new(x - 4.2, y + h * (1 - hpPercent)); objs.Drawings.HealthBar.Color = hpColor
                objs.Drawings.HealthText.Visible = true; objs.Drawings.HealthText.Text = tostring(rawHp); objs.Drawings.HealthText.Color = hpColor; objs.Drawings.HealthText.Position = Vector2.new(x - 26, y + h * (1 - hpPercent) - 3)
            else
                objs.Drawings.HealthBarBg.Visible = false; objs.Drawings.HealthBar.Visible = false; objs.Drawings.HealthText.Visible = false
            end

            for _, weaponDraw in pairs(objs.Weapons) do weaponDraw.Visible = false end
            if Settings.WeaponESP then
                local items = getWeapons(p)
                for i, w in ipairs(items) do
                    if not objs.Weapons[i] then
                        local txt = Drawing.new("Text")
                        txt.Size = 11; txt.Center = true; txt.Outline = true; txt.Font = 2
                        objs.Weapons[i] = txt
                    end
                    local draw = objs.Weapons[i]
                    draw.Text = w.Name; draw.Color = WhiteESP 
                    local extraOffset = Settings.DistanceESP and 16 or 4
                    draw.Position = Vector2.new(screenPos.X, y + h + extraOffset + ((i - 1) * 10))
                    draw.Visible = true
                end
            end
        else 
            for _, draw in pairs(objs.Drawings) do draw.Visible = false end
            for _, weaponDraw in pairs(objs.Weapons) do weaponDraw.Visible = false end
        end
    end
end)

-- Motor Aimbot
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1; FOVCircle.Color = Color_NeonBlue; FOVCircle.Radius = Settings.FOV

local function GetAimPart(char)
    if not char then return nil end
    local partName = Settings.AimPart
    if partName == "Head" then return char:FindFirstChild("Head")
    elseif partName == "Chest" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    elseif partName == "Hand" then return char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
    elseif partName == "Leg" then return char:FindFirstChild("RightLeg") or char:FindFirstChild("Right Leg") end
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Visible = Settings.FOVVisible and Settings.Aimbot
    FOVCircle.Radius = Settings.FOV

    if not Settings.Aimbot or not IsAiming or not TieneArmaEquipada() then return end
    
    local bestTarget = nil
    local maxD = Settings.FOV

    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer or Settings.Whitelist[p.Name] == true then continue end
        
        local char = p.Character
        if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then continue end
        
        local targetPart = GetAimPart(char)
        if not targetPart then continue end
        
        local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        if onScreen then
            local dist = (Vector2.new(pos.X, pos.Y) - FOVCircle.Position).Magnitude
            if dist < maxD then maxD = dist; bestTarget = targetPart.Position end
        end
    end
    if bestTarget then Camera.CFrame = CFrame.new(Camera.CFrame.Position, bestTarget) end
end)

-- INTERFAZ PRINCIPAL MINIMALISTA (Velocity)
local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 640, 0, 480) 
Main.Position = UDim2.new(0.5, -320, 0.5, -240)
Main.BackgroundColor3 = Color_Backdrop; Main.BorderSizePixel = 0; Main.ClipsDescendants = true; Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local MenuStroke = Instance.new("UIStroke", Main)
MenuStroke.Color = Color_BorderMuted; MenuStroke.Thickness = 1

-- SISTEMA DINÁMICO DE NEXOS/PLEXUS (35 Nodos, velocidad duplicada + líneas de conexión blancas)
local MotionCanvas = Instance.new("Frame", Main)
MotionCanvas.Size = UDim2.new(1, 0, 1, 0); MotionCanvas.BackgroundTransparency = 1; MotionCanvas.ZIndex = 1

local nodes = {}
local lines = {}
local maxNodes = 35
local connectionDistance = 85 -- Distancia máxima en píxeles para dibujar líneas entre nudos

for i = 1, maxNodes do
    local dot = Instance.new("Frame", MotionCanvas)
    dot.Size = UDim2.new(0, 4, 0, 4) -- Partículas un poco más notorias
    dot.Position = UDim2.new(math.random(), 0, math.random(), 0)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BackgroundTransparency = 0.3
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    table.insert(nodes, {
        frame = dot,
        speedX = (math.random(-45, 45) / 100) * 0.25, -- Velocidad duplicada y más agresiva
        speedY = (math.random(-45, 45) / 100) * 0.25
    })
end

-- Limpiador e instanciador de líneas de nexos (Frame UI optimizados)
local function getLineFrame(index)
    if not lines[index] then
        local line = Instance.new("Frame", MotionCanvas)
        line.BorderSizePixel = 0
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        lines[index] = line
    end
    return lines[index]
end

RunService.RenderStepped:Connect(function(deltaTime)
    if not Main.Visible then return end
    
    -- Actualizar posiciones físicas de los nodos
    for _, node in ipairs(nodes) do
        local curPos = node.frame.Position
        local nextX = curPos.X.Scale + (node.speedX * deltaTime)
        local nextY = curPos.Y.Scale + (node.speedY * deltaTime)
        
        if nextX < 0 or nextX > 1 then node.speedX = -node.speedX end
        if nextY < 0 or nextY > 1 then node.speedY = -node.speedY end
        
        node.frame.Position = UDim2.new(math.clamp(nextX, 0, 1), 0, math.clamp(nextY, 0, 1), 0)
    end
    
    -- Dibujar interconexiones (Plexus)
    local lineIndex = 1
    for i = 1, #nodes do
        for j = i + 1, #nodes do
            local posA = nodes[i].frame.AbsolutePosition + Vector2.new(2, 2)
            local posB = nodes[j].frame.AbsolutePosition + Vector2.new(2, 2)
            local dist = (posA - posB).Magnitude
            
            if dist < connectionDistance then
                local line = getLineFrame(lineIndex)
                local midPoint = (posA + posB) / 2
                local delta = posB - posA
                local angle = math.atan2(delta.Y, delta.X)
                
                -- Se adapta la transparencia según la proximidad (más cerca = más visible)
                local alpha = 1 - (dist / connectionDistance)
                line.BackgroundTransparency = 1 - (alpha * 0.25) -- Líneas blancas suaves y dinámicas
                
                -- Posicionar dentro de la GUI relativa al canvas
                local canvasPos = MotionCanvas.AbsolutePosition
                line.Position = UDim2.new(0, midPoint.X - canvasPos.X, 0, midPoint.Y - canvasPos.Y)
                line.Size = UDim2.new(0, dist, 0, 1)
                line.Rotation = math.deg(angle)
                line.Visible = true
                
                lineIndex = lineIndex + 1
                if lineIndex > 120 then break end -- Límite de conexiones para evitar sobrecarga de UI
            end
        end
        if lineIndex > 120 then break end
    end
    
    -- Ocultar líneas excedentes que no están activas en este frame
    for k = lineIndex, #lines do
        lines[k].Visible = false
    end
end)

local ContentFrame = Instance.new("Frame", Main)
ContentFrame.Size = UDim2.new(1, 0, 1, 0); ContentFrame.BackgroundTransparency = 1; ContentFrame.ZIndex = 2

local HeaderFrame = Instance.new("Frame", ContentFrame); HeaderFrame.Size = UDim2.new(1, 0, 0, 50); HeaderFrame.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", HeaderFrame); Title.Size = UDim2.new(1, -40, 1, 0); Title.Position = UDim2.new(0, 20, 0, 0); Title.BackgroundTransparency = 1
Title.Text = "VELOCITY"; Title.TextColor3 = Color_TextMain; Title.Font = Enum.Font.GothamMedium; Title.TextSize = 15; Title.TextXAlignment = "Left"

local Subtitle = Instance.new("TextLabel", HeaderFrame); Subtitle.Size = UDim2.new(1, -40, 0, 20); Subtitle.Position = UDim2.new(0, 95, 0.5, -9); Subtitle.BackgroundTransparency = 1
Subtitle.Text = "• minimal edition"; Subtitle.TextColor3 = Color_TextSub; Subtitle.Font = Enum.Font.Gotham; Subtitle.TextSize = 10; Subtitle.TextXAlignment = "Left"

-- PANEL IZQUIERDO COMPACTO
local LeftPanelFrame = Instance.new("Frame", ContentFrame)
LeftPanelFrame.Size = UDim2.new(0.48, 0, 0.85, 0)
LeftPanelFrame.Position = UDim2.new(0.03, 0, 0.12, 0)
LeftPanelFrame.BackgroundTransparency = 1

local LeftLayout = Instance.new("UIListLayout", LeftPanelFrame)
LeftLayout.Padding = UDim.new(0, 3) 
LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Slider FOV Card
local FOVCard = Instance.new("Frame", LeftPanelFrame); FOVCard.Size = UDim2.new(1, -6, 0, 42); FOVCard.BackgroundColor3 = Color_Card; FOVCard.BorderSizePixel = 0; FOVCard.LayoutOrder = 1
Instance.new("UICorner", FOVCard).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", FOVCard).Color = Color_BorderMuted
local FOVLabel = Instance.new("TextLabel", FOVCard); FOVLabel.Size = UDim2.new(1, -30, 0, 14); FOVLabel.Position = UDim2.new(0, 10, 0, 4); FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "Rango de FOV: 150"; FOVLabel.TextColor3 = Color_TextSub; FOVLabel.Font = Enum.Font.GothamMedium; FOVLabel.TextSize = 10; FOVLabel.TextXAlignment = "Left"
local SliderBar = Instance.new("Frame", FOVCard); SliderBar.Size = UDim2.new(0, 260, 0, 3); SliderBar.Position = UDim2.new(0.04, 0, 0.65, 0); SliderBar.BackgroundColor3 = Color_CardDark; SliderBar.BorderSizePixel = 0; Instance.new("UICorner", SliderBar)
local SliderFill = Instance.new("Frame", SliderBar); SliderFill.Size = UDim2.new(0.5, 0, 1, 0); SliderFill.BackgroundColor3 = Color_NeonBlue; SliderFill.BorderSizePixel = 0; Instance.new("UICorner", SliderFill)

local dragging = false
SliderBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
RunService.RenderStepped:Connect(function()
    if dragging then
        local mouseX = UserInputService:GetMouseLocation().X
        local percent = math.clamp((mouseX - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        Settings.FOV = math.floor(50 + percent * 250)
        FOVLabel.Text = "Rango de FOV: " .. Settings.FOV
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    end
end)

-- Selector de Parte del Cuerpo
local AimPartBtn = Instance.new("TextButton", LeftPanelFrame); AimPartBtn.Size = UDim2.new(1, -6, 0, 26); AimPartBtn.BackgroundColor3 = Color_Card; AimPartBtn.BorderSizePixel = 0
AimPartBtn.Text = "   Fijar en: " .. Settings.AimPart; AimPartBtn.TextColor3 = Color_TextSub; AimPartBtn.Font = Enum.Font.GothamMedium; AimPartBtn.TextSize = 10; AimPartBtn.TextXAlignment = "Left"; AimPartBtn.LayoutOrder = 2
Instance.new("UICorner", AimPartBtn).CornerRadius = UDim.new(0, 6); local AimStroke = Instance.new("UIStroke", AimPartBtn); AimStroke.Color = Color_BorderMuted

local aimOptions = {"Head", "Chest", "Hand", "Leg"}
AimPartBtn.MouseButton1Click:Connect(function()
    PlayWindToggleOn()
    local idx = table.find(aimOptions, Settings.AimPart) or 1
    idx = (idx % #aimOptions) + 1; Settings.AimPart = aimOptions[idx]
    AimPartBtn.Text = "   Fijar en: " .. Settings.AimPart
end)

-- Generador de Toggles
local function AddToggle(name, key, order)
    local btn = Instance.new("TextButton", LeftPanelFrame); btn.Size = UDim2.new(1, -6, 0, 26); btn.BorderSizePixel = 0; btn.Text = "    " .. name
    btn.Font = Enum.Font.GothamMedium; btn.TextSize = 10; btn.TextXAlignment = "Left"; btn.LayoutOrder = order; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local bStroke = Instance.new("UIStroke", btn); bStroke.Thickness = 1
    local switchTrack = Instance.new("Frame", btn); switchTrack.Size = UDim2.new(0, 26, 0, 12); switchTrack.Position = UDim2.new(1, -36, 0.5, -6); switchTrack.BorderSizePixel = 0; Instance.new("UICorner", switchTrack).CornerRadius = UDim.new(1, 0)
    local switchBall = Instance.new("Frame", switchTrack); switchBall.Size = UDim2.new(0, 8, 0, 8); switchBall.Position = UDim2.new(0, 2, 0.5, -4); switchBall.BackgroundColor3 = Color_TextMain; Instance.new("UICorner", switchBall).CornerRadius = UDim.new(1, 0)

    local function updateVisuals(isInitial)
        if not isInitial then if Settings[key] then PlayWindToggleOn() else PlayWindToggleOff() end end
        if Settings[key] then
            FastTween(btn, {BackgroundColor3 = Color_CardDark}); FastTween(bStroke, {Color = Color_NeonBlue})
            FastTween(switchTrack, {BackgroundColor3 = Color_NeonBlue}); FastTween(switchBall, {Position = UDim2.new(1, -10, 0.5, -4)})
            btn.TextColor3 = Color_TextMain
        else
            -- Estilo desactivado: Bordes y textos cambian a gris
            FastTween(btn, {BackgroundColor3 = Color_Card}); FastTween(bStroke, {Color = Color_BorderMuted})
            FastTween(switchTrack, {BackgroundColor3 = Color_CardDark}); FastTween(switchBall, {Position = UDim2.new(0, 2, 0.5, -4)})
            btn.TextColor3 = Color_TextSub
        end
    end
    btn.MouseEnter:Connect(function() if not Settings[key] then FastTween(btn, {BackgroundColor3 = Color_CardDark}) end end)
    btn.MouseLeave:Connect(function() if not Settings[key] then FastTween(btn, {BackgroundColor3 = Color_Card}) end end)
    btn.MouseButton1Click:Connect(function() 
        Settings[key] = not Settings[key]; 
        updateVisuals(false); 
    end)

    updateVisuals(true)
end

AddToggle("Aimbot Assist", "Aimbot", 3)
AddToggle("Estabilizador NoRecoil", "NoRecoil", 4)
AddToggle("Name 1 (Tu nombre -> 1)", "NameOne", 5) 
AddToggle("Visuales ESP Jugadores", "ESP", 6)
AddToggle("Mostrar Nombres", "NameESP", 7)
AddToggle("Mostrar Distancia", "DistanceESP", 8)
AddToggle("Esqueleto (Skeleton ESP)", "SkeletonESP", 9) 
AddToggle("Radar de Armas Portadas", "WeaponESP", 10)
AddToggle("Barra de Vida Dinámica", "HPBar", 11)
AddToggle("Circulo FOV Visible", "FOVVisible", 12)

-- PANEL DE WHITELIST
local RightPanel = Instance.new("Frame", ContentFrame)
RightPanel.Size = UDim2.new(0.44, 0, 0.85, 0); RightPanel.Position = UDim2.new(0.53, 0, 0.12, 0); RightPanel.BackgroundColor3 = Color_Card; RightPanel.BorderSizePixel = 0
Instance.new("UICorner", RightPanel).CornerRadius = UDim.new(0, 6)
local RightStroke = Instance.new("UIStroke", RightPanel); RightStroke.Color = Color_BorderMuted

local WLTitle = Instance.new("TextLabel", RightPanel)
WLTitle.Size = UDim2.new(1, 0, 0, 30); WLTitle.BackgroundTransparency = 1; WLTitle.Text = "EXCEPCIONES (WHITELIST)"; WLTitle.TextColor3 = Color_TextMain
WLTitle.Font = Enum.Font.GothamMedium; WLTitle.TextSize = 10

local WLScroll = Instance.new("ScrollingFrame", RightPanel)
WLScroll.Size = UDim2.new(1, -16, 1, -40); WLScroll.Position = UDim2.new(0, 8, 0, 35); WLScroll.BackgroundTransparency = 1; WLScroll.BorderSizePixel = 0
WLScroll.ScrollBarThickness = 1; WLScroll.ScrollBarImageColor3 = Color_BorderMuted; WLScroll.CanvasSize = UDim2.new(0,0,0,0)
local WLListLayout = Instance.new("UIListLayout", WLScroll); WLListLayout.Padding = UDim.new(0, 4)

local function ActualizarPanelWhitelist()
    for _, oldBtn in ipairs(WLScroll:GetChildren()) do if oldBtn:IsA("TextButton") then oldBtn:Destroy() end end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        
        local pBtn = Instance.new("TextButton", WLScroll)
        pBtn.Size = UDim2.new(1, -4, 0, 26); pBtn.BorderSizePixel = 0; pBtn.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
        pBtn.Font = Enum.Font.Gotham; pBtn.TextSize = 9; pBtn.TextXAlignment = "Left"; Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)
        local pStroke = Instance.new("UIStroke", pBtn); pStroke.Thickness = 1
        
        local function RefreshButtonVisuals()
            if Settings.Whitelist[p.Name] then
                pBtn.BackgroundColor3 = Color_NeonBlueDim; pBtn.TextColor3 = Color_TextMain; pStroke.Color = Color_NeonBlue
            else
                -- Los nombres inactivos/normales en la whitelist ahora usan Color_TextSub (Gris) en lugar de negro
                pBtn.BackgroundColor3 = Color_CardDark; pBtn.TextColor3 = Color_TextSub; pStroke.Color = Color_BorderMuted
            end
        end
        
        pBtn.MouseButton1Click:Connect(function()
            if Settings.Whitelist[p.Name] then
                Settings.Whitelist[p.Name] = nil
                PlayWindToggleOff()
            else
                Settings.Whitelist[p.Name] = true
                PlayWindToggleOn()
            end
            RefreshButtonVisuals()
        end)
        
        RefreshButtonVisuals()
    end
    WLScroll.CanvasSize = UDim2.new(0, 0, 0, WLListLayout.AbsoluteContentSize.Y + 10)
end

ActualizarPanelWhitelist()
Players.PlayerAdded:Connect(function() task.wait(0.5) ActualizarPanelWhitelist() end)
Players.PlayerRemoving:Connect(function() task.wait(0.5) ActualizarPanelWhitelist() end)

-- Keybind para abrir/cerrar menú
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        Main.Visible = not Main.Visible
        if Main.Visible then PlayWindMenuOpen() else PlayWindMenuClose() end
    end
end)

Notify("Velocity • Activado exitosamente. Tecla [Left Control]", Color_NeonBlue)
