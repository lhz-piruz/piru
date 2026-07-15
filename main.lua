repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ========================================
local KEY_CORRECTA = "PIRU-HUB" -- La contraseña que deben escribir
local USUARIOS_PERMITIDOS = {
    [8216624047] = true,   -- Comprador 1
    [10603802243] = true,  -- Comprador 2
    [7149173878] = true,    -- Comprador 3
    [9763328724] = true,    -- Comprador 4
    [10984453287] = true,            -- Comprador 5
}
-- ====================================================================================

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Camera = workspace.CurrentCamera

-- Variables de control para el apuntado
local IsAiming = false

-- PALETA DE COLORES COMBINADA (FONDO NEGRO Y ROJO OSCURO)
local Color_Backdrop = Color3.fromRGB(0, 0, 0)         -- Fondo Negro Absoluto
local Color_Card = Color3.fromRGB(15, 5, 5)            -- Fondo de tarjetas (Negro con tono rojo muy sutil)
local Color_CardDark = Color3.fromRGB(10, 0, 0)        -- Fondo secundario más oscuro
local Color_NeonBlue = Color3.fromRGB(180, 0, 0)       -- Rojo Oscuro Brillante (Sustituye al azul neón activo)
local Color_NeonBlueDim = Color3.fromRGB(60, 0, 0)     -- Rojo Oscuro Apagado (Sustituye al azul apagado)
local Color_TextMain = Color3.fromRGB(255, 230, 230)   -- Texto Principal Blanco/Rojizo
local Color_TextSub = Color3.fromRGB(150, 100, 100)    -- Texto Secundario Rojo Opaco
local Color_Border = Color3.fromRGB(50, 5, 5)          -- Bordes Rojo Muy Oscuro

-- ESP Colores
local SoftRedESP = Color3.fromRGB(220, 40, 40)       
local WhiteESP = Color3.new(1, 1, 1)
local LightGreenDistESP = Color3.fromRGB(255, 160, 160) -- Distancia en tono rojizo claro para combinar

-- Crear la interfaz de la Key (Bloqueo de pantalla)
local KeyGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local KeyFrame = Instance.new("Frame", KeyGui)
KeyFrame.Size = UDim2.new(0, 350, 0, 220)
KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
KeyFrame.BackgroundColor3 = Color_Backdrop
KeyFrame.BorderSizePixel = 0
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)
local KeyStroke = Instance.new("UIStroke", KeyFrame)
KeyStroke.Color = Color_Border
KeyStroke.Thickness = 1.5

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "PIRUZ HUB - KEY SYSTEM"
KeyTitle.TextColor3 = Color_TextMain
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 16

local KeySubtitle = Instance.new("TextLabel", KeyFrame)
KeySubtitle.Size = UDim2.new(1, 0, 0, 20)
KeySubtitle.Position = UDim2.new(0, 0, 0, 45)
KeySubtitle.BackgroundTransparency = 1
KeySubtitle.Text = "Ingresa la llave de acceso para continuar"
KeySubtitle.TextColor3 = Color_TextSub
KeySubtitle.Font = Enum.Font.Gotham
KeySubtitle.TextSize = 12

local TextBox = Instance.new("TextBox", KeyFrame)
TextBox.Size = UDim2.new(0, 280, 0, 40)
TextBox.Position = UDim2.new(0.5, -140, 0, 85)
TextBox.BackgroundColor3 = Color_CardDark
TextBox.BorderSizePixel = 0
TextBox.Text = ""
TextBox.PlaceholderText = "Escribe la Key aquí..."
TextBox.TextColor3 = Color_TextMain
TextBox.PlaceholderColor3 = Color_TextSub
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 14
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 8)
local BoxStroke = Instance.new("UIStroke", TextBox)
BoxStroke.Color = Color_Border

local VerifyBtn = Instance.new("TextButton", KeyFrame)
VerifyBtn.Size = UDim2.new(0, 280, 0, 40)
VerifyBtn.Position = UDim2.new(0.5, -140, 0, 145)
VerifyBtn.BackgroundColor3 = Color_NeonBlue
VerifyBtn.BorderSizePixel = 0
VerifyBtn.Text = "VERIFICAR ACCESO"
VerifyBtn.TextColor3 = Color_TextMain
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 13
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 8)

-- ==================== INICIO DEL SCRIPT v7.0 COMPLETO TRAS VERIFICACIÓN ====================
local function IniciarScriptOriginal()
    KeyGui:Destroy()

    local originalName = LocalPlayer.Name
    local originalDisplayName = LocalPlayer.DisplayName

    -- Settings
    local Settings = {
        Aimbot = true,
        AimKey = Enum.UserInputType.MouseButton2, -- Clic derecho por defecto
        NoRecoil = true,
        NameOne = false, 
        FOV = 150,
        AimPart = "Head",
        ESP = true,           
        NameESP = true,       
        DistanceESP = true,   
        SkeletonESP = true,   -- Reemplazo de Chams por Skeleton     
        WeaponESP = true,     
        HPBar = true,
        FOVVisible = true,
        DefaultFOV = Camera.FieldOfView,
        Whitelist = {} 
    }

    -- Detectar cuando se presiona o suelta la tecla para apuntar
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

    -- Cambio de nombre reactivo (Name 1)
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

    -- Función auxiliar para verificar si el jugador sostiene un arma real
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
        sound.Volume = vol or 0.5
        sound.PlaybackSpeed = pitch or 1
        sound.PlayOnRemove = true
        sound.Parent = SoundService
        sound:Destroy()
    end

    local function PlayWindToggleOn() PlaySound(134012322, 0.4, 1.2) end   
    local function PlayWindToggleOff() PlaySound(134012322, 0.35, 0.8) end 
    local function PlayWindMenuOpen() PlaySound(9114228358, 0.5, 0.9) end  
    local function PlayWindMenuClose() PlaySound(9114228358, 0.4, 1.1) end 

    local function FastTween(instance, properties, duration, style)
        TweenService:Create(instance, TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), properties):Play()
    end

    -- Notificación Premium Aero
    local function Notify(msg, color)
        local NotifyGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
        local Frame = Instance.new("Frame", NotifyGui)
        Frame.Size = UDim2.new(0, 280, 0, 50)
        Frame.Position = UDim2.new(1, 30, 0.9, 0)
        Frame.BackgroundColor3 = Color_Card
        Frame.BorderSizePixel = 0
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
        
        local Stroke = Instance.new("UIStroke", Frame)
        Stroke.Color = color or Color_NeonBlue
        Stroke.Thickness = 1.5
        
        local Accent = Instance.new("Frame", Frame)
        Accent.Size = UDim2.new(0, 4, 1, 0)
        Accent.BackgroundColor3 = color or Color_NeonBlue
        Instance.new("UICorner", Accent).CornerRadius = UDim.new(0, 10)

        local Label = Instance.new("TextLabel", Frame)
        Label.Size = UDim2.new(1, -25, 1, 0)
        Label.Position = UDim2.new(0, 15, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = msg
        Label.TextColor3 = Color_TextMain
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 12
        Label.TextXAlignment = "Left"

        FastTween(Frame, {Position = UDim2.new(1, -300, 0.9, 0)}, 0.4)
        task.delay(3, function()
            FastTween(Frame, {Position = UDim2.new(1, -300, 0.9, 0)}, 0.4)
            task.wait(0.4)
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

    -- MOTOR DE RENDER ESP
    local ESPObjects = {}

    -- Estructura de conexiones para Skeleton ESP (soporta R6 y R15)
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
        obj.Drawings.Name.Size = 14; obj.Drawings.Name.Center = true; obj.Drawings.Name.Outline = true; obj.Drawings.Name.Color = WhiteESP
        obj.Drawings.DistLabel.Size = 12; obj.Drawings.DistLabel.Center = true; obj.Drawings.DistLabel.Outline = true; obj.Drawings.DistLabel.Color = LightGreenDistESP
        obj.Drawings.Box.Thickness = 1.8; obj.Drawings.Box.Color = SoftRedESP
        obj.Drawings.HealthBarBg.Filled = true; obj.Drawings.HealthBarBg.Color = Color3.new(0,0,0)
        obj.Drawings.HealthBar.Filled = true
        obj.Drawings.HealthText.Size = 12; obj.Drawings.HealthText.Center = false; obj.Drawings.HealthText.Outline = true
        
        -- Inicializar 15 líneas para el esqueleto
        for i = 1, 15 do
            local line = Drawing.new("Line")
            line.Thickness = 1.5
            line.Color = SoftRedESP
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
            local colToUse = isWhitelisted and Color_NeonBlue or SoftRedESP

            -- Render del Skeleton ESP
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
                -- Ocultar las líneas sobrantes no usadas
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

                if Settings.NameESP then objs.Drawings.Name.Visible = true; objs.Drawings.Name.Text = p.DisplayName; objs.Drawings.Name.Position = Vector2.new(screenPos.X, y - 20)
                else objs.Drawings.Name.Visible = false end

                if Settings.DistanceESP then objs.Drawings.DistLabel.Visible = true; objs.Drawings.DistLabel.Text = "[" .. math.floor(screenPos.Z) .. "m]"; objs.Drawings.DistLabel.Position = Vector2.new(screenPos.X, y + h + 6)
                else objs.Drawings.DistLabel.Visible = false end

                if Settings.HPBar then
                    local rawHp = math.floor(char.Humanoid.Health)
                    local hpPercent = math.clamp(char.Humanoid.Health / char.Humanoid.MaxHealth, 0, 1)
                    local hpColor = Color3.fromHSV(hpPercent * 0.33, 1, 1)
                    objs.Drawings.HealthBarBg.Visible = true; objs.Drawings.HealthBarBg.Size = Vector2.new(4, h); objs.Drawings.HealthBarBg.Position = Vector2.new(x - 6, y)
                    objs.Drawings.HealthBar.Visible = true; objs.Drawings.HealthBar.Size = Vector2.new(2, h * hpPercent); objs.Drawings.HealthBar.Position = Vector2.new(x - 5, y + h * (1 - hpPercent)); objs.Drawings.HealthBar.Color = hpColor
                    objs.Drawings.HealthText.Visible = true; objs.Drawings.HealthText.Text = "[" .. tostring(rawHp) .. " HP]"; objs.Drawings.HealthText.Color = hpColor; objs.Drawings.HealthText.Position = Vector2.new(x - 52, y + h * (1 - hpPercent) - 2)
                else
                    objs.Drawings.HealthBarBg.Visible = false; objs.Drawings.HealthBar.Visible = false; objs.Drawings.HealthText.Visible = false
                end

                for _, weaponDraw in pairs(objs.Weapons) do weaponDraw.Visible = false end
                if Settings.WeaponESP then
                    local items = getWeapons(p)
                    for i, w in ipairs(items) do
                        if not objs.Weapons[i] then
                            local txt = Drawing.new("Text")
                            txt.Size = 13.75; txt.Center = true; txt.Outline = true; txt.Font = 2
                            objs.Weapons[i] = txt
                        end
                        local draw = objs.Weapons[i]
                        draw.Text = w.Name; draw.Color = WhiteESP 
                        local extraOffset = Settings.DistanceESP and 20 or 4
                        draw.Position = Vector2.new(screenPos.X, y + h + extraOffset + ((i - 1) * 12))
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
    FOVCircle.Thickness = 1.5; FOVCircle.Color = Color3.new(1,1,1); FOVCircle.Radius = Settings.FOV

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

    -- Interfaz Principal del Script (Piru HUB)
    local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 660, 0, 520) 
    Main.Position = UDim2.new(0.5, -330, 0.5, -260)
    Main.BackgroundColor3 = Color_Backdrop; Main.BorderSizePixel = 0; Main.ClipsDescendants = true; Main.Visible = false
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

    local MenuStroke = Instance.new("UIStroke", Main)
    MenuStroke.Color = Color_Border; MenuStroke.Thickness = 1.6

    -- Canvas de Partículas
    local ParticleCanvas = Instance.new("Frame", Main)
    ParticleCanvas.Size = UDim2.new(1, 0, 1, 0); ParticleCanvas.BackgroundTransparency = 1; ParticleCanvas.ZIndex = 1

    local particles = {}
    for i = 1, 26 do
        local p = Instance.new("Frame", ParticleCanvas)
        local size = math.random(5, 11) 
        p.Size = UDim2.new(0, size, 0, size); p.Position = UDim2.new(math.random(), 0, math.random(), 0)
        p.BackgroundColor3 = Color_NeonBlue; p.BackgroundTransparency = math.random(50, 75) / 100; p.BorderSizePixel = 0
        Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
        table.insert(particles, { frame = p, speedY = -math.random(30, 75) / 100, speedX = (math.random(-25, 25) / 100), baseOpacity = p.BackgroundTransparency })
    end

    local tickCounter = 0
    RunService.RenderStepped:Connect(function(deltaTime)
        if not Main.Visible then return end
        tickCounter = tickCounter + deltaTime
        local colorShift = Color3.fromHSV((tickCounter * 0.05) % 1, 0.8, 1)
        MenuStroke.Color = Color_Border:Lerp(colorShift, 0.2)
        
        for _, part in ipairs(particles) do
            local currentPos = part.frame.Position
            local newY = currentPos.Y.Scale + (part.speedY * deltaTime * 0.2)
            local newX = currentPos.X.Scale + (part.speedX * deltaTime * 0.2)
            if newY < -0.05 then newY = 1.05; newX = math.random() end
            if newX < -0.05 or newX > 1.05 then part.speedX = -part.speedX end
            local wave = math.sin(tickCounter * 3 + currentPos.Y.Scale * 10) * 0.15
            part.frame.BackgroundTransparency = math.clamp(part.baseOpacity + wave, 0.3, 0.9)
            part.frame.Position = UDim2.new(newX, 0, newY, 0)
        end
    end)

    local ContentFrame = Instance.new("Frame", Main)
    ContentFrame.Size = UDim2.new(1, 0, 1, 0); ContentFrame.BackgroundTransparency = 1; ContentFrame.ZIndex = 2

    local HeaderFrame = Instance.new("Frame", ContentFrame); HeaderFrame.Size = UDim2.new(1, 0, 0, 65); HeaderFrame.BackgroundTransparency = 1
    local Title = Instance.new("TextLabel", HeaderFrame); Title.Size = UDim2.new(1, -40, 1, 0); Title.Position = UDim2.new(0, 25, 0, 0); Title.BackgroundTransparency = 1
    Title.Text = "PIRU HUB"; Title.TextColor3 = Color_TextMain; Title.Font = Enum.Font.GothamBold; Title.TextSize = 22; Title.TextXAlignment = "Left"

    local Subtitle = Instance.new("TextLabel", HeaderFrame); Subtitle.Size = UDim2.new(1, -40, 0, 20); Subtitle.Position = UDim2.new(0, 135, 0.5, -8); Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "• wind universal v7.0"; Subtitle.TextColor3 = Color_NeonBlue; Subtitle.Font = Enum.Font.GothamBold; Subtitle.TextSize = 12; Subtitle.TextXAlignment = "Left"

    -- PANEL IZQUIERDO COMPACTO (TODO JUNTO, SIN SCROLL)
    local LeftPanelFrame = Instance.new("Frame", ContentFrame)
    LeftPanelFrame.Size = UDim2.new(0.48, 0, 0.83, 0)
    LeftPanelFrame.Position = UDim2.new(0.03, 0, 0.14, 0)
    LeftPanelFrame.BackgroundTransparency = 1
    
    local LeftLayout = Instance.new("UIListLayout", LeftPanelFrame)
    LeftLayout.Padding = UDim.new(0, 4) -- Menor espaciado para agrupar todo
    LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Slider FOV Card (Altura Reducida)
    local FOVCard = Instance.new("Frame", LeftPanelFrame); FOVCard.Size = UDim2.new(1, -6, 0, 48); FOVCard.BackgroundColor3 = Color_Card; FOVCard.BorderSizePixel = 0; FOVCard.LayoutOrder = 1
    Instance.new("UICorner", FOVCard).CornerRadius = UDim.new(0, 10); Instance.new("UIStroke", FOVCard).Color = Color_Border
    local FOVLabel = Instance.new("TextLabel", FOVCard); FOVLabel.Size = UDim2.new(1, -30, 0, 18); FOVLabel.Position = UDim2.new(0, 12, 0, 4); FOVLabel.BackgroundTransparency = 1
    FOVLabel.Text = "Rango de FOV: 150"; FOVLabel.TextColor3 = Color_TextMain; FOVLabel.Font = Enum.Font.GothamBold; FOVLabel.TextSize = 11; FOVLabel.TextXAlignment = "Left"
    local SliderBar = Instance.new("Frame", FOVCard); SliderBar.Size = UDim2.new(0, 260, 0, 4); SliderBar.Position = UDim2.new(0.04, 0, 0.65, 0); SliderBar.BackgroundColor3 = Color_CardDark; SliderBar.BorderSizePixel = 0; Instance.new("UICorner", SliderBar)
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

    -- Selector de Parte del Cuerpo (Altura Reducida)
    local AimPartBtn = Instance.new("TextButton", LeftPanelFrame); AimPartBtn.Size = UDim2.new(1, -6, 0, 30); AimPartBtn.BackgroundColor3 = Color_Card; AimPartBtn.BorderSizePixel = 0
    AimPartBtn.Text = "   Fijar en: " .. Settings.AimPart; AimPartBtn.TextColor3 = Color_TextMain; AimPartBtn.Font = Enum.Font.GothamBold; AimPartBtn.TextSize = 11; AimPartBtn.TextXAlignment = "Left"; AimPartBtn.LayoutOrder = 2
    Instance.new("UICorner", AimPartBtn).CornerRadius = UDim.new(0, 10); Instance.new("UIStroke", AimPartBtn).Color = Color_Border

    local aimOptions = {"Head", "Chest", "Hand", "Leg"}
    AimPartBtn.MouseButton1Click:Connect(function()
        PlayWindToggleOn()
        local idx = table.find(aimOptions, Settings.AimPart) or 1
        idx = (idx % #aimOptions) + 1; Settings.AimPart = aimOptions[idx]
        AimPartBtn.Text = "   Fijar en: " .. Settings.AimPart
    end)

    -- Generador de Toggles de Tamaño Reducido
    local function AddToggle(name, key, order)
        local btn = Instance.new("TextButton", LeftPanelFrame); btn.Size = UDim2.new(1, -6, 0, 30); btn.BorderSizePixel = 0; btn.Text = "    " .. name
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.TextXAlignment = "Left"; btn.LayoutOrder = order; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        local bStroke = Instance.new("UIStroke", btn); bStroke.Thickness = 1.1
        local switchTrack = Instance.new("Frame", btn); switchTrack.Size = UDim2.new(0, 34, 0, 18); switchTrack.Position = UDim2.new(1, -45, 0.5, -9); switchTrack.BorderSizePixel = 0; Instance.new("UICorner", switchTrack).CornerRadius = UDim.new(1, 0)
        local switchBall = Instance.new("Frame", switchTrack); switchBall.Size = UDim2.new(0, 12, 0, 12); switchBall.Position = UDim2.new(0, 3, 0.5, -6); switchBall.BackgroundColor3 = Color_TextMain; Instance.new("UICorner", switchBall).CornerRadius = UDim.new(1, 0)

        local function updateVisuals(isInitial)
            if not isInitial then if Settings[key] then PlayWindToggleOn() else PlayWindToggleOff() end end
            if Settings[key] then
                FastTween(btn, {BackgroundColor3 = Color_NeonBlue}); FastTween(bStroke, {Color = Color_NeonBlue})
                FastTween(switchTrack, {BackgroundColor3 = Color_CardDark}); FastTween(switchBall, {Position = UDim2.new(1, -15, 0.5, -6)})
                btn.TextColor3 = Color_TextMain
            else
                FastTween(btn, {BackgroundColor3 = Color_Card}); FastTween(bStroke, {Color = Color_Border})
                FastTween(switchTrack, {BackgroundColor3 = Color_NeonBlueDim}); FastTween(switchBall, {Position = UDim2.new(0, 3, 0.5, -6)})
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
    AddToggle("Esqueleto (Skeleton ESP)", "SkeletonESP", 9) -- Modificado
    AddToggle("Radar de Armas Portadas", "WeaponESP", 10)
    AddToggle("Barra de Vida Dinámica", "HPBar", 11)
    AddToggle("Circulo FOV Visible", "FOVVisible", 12)

    -- PANEL DE WHITELIST (LADO DERECHO)
    local RightPanel = Instance.new("Frame", ContentFrame)
    RightPanel.Size = UDim2.new(0.44, 0, 0.83, 0); RightPanel.Position = UDim2.new(0.53, 0, 0.14, 0); RightPanel.BackgroundColor3 = Color_Card; RightPanel.BorderSizePixel = 0
    Instance.new("UICorner", RightPanel).CornerRadius = UDim.new(0, 14)
    local RightStroke = Instance.new("UIStroke", RightPanel); RightStroke.Color = Color_Border

    local WLTitle = Instance.new("TextLabel", RightPanel)
    WLTitle.Size = UDim2.new(1, 0, 0, 35); WLTitle.BackgroundTransparency = 1; WLTitle.Text = "SISTEMA DE WHITELIST"; WLTitle.TextColor3 = Color_NeonBlue
    WLTitle.Font = Enum.Font.GothamBold; WLTitle.TextSize = 13

    local WLScroll = Instance.new("ScrollingFrame", RightPanel)
    WLScroll.Size = UDim2.new(1, -20, 1, -50); WLScroll.Position = UDim2.new(0, 10, 0, 40); WLScroll.BackgroundTransparency = 1; WLScroll.BorderSizePixel = 0
    WLScroll.ScrollBarThickness = 2; WLScroll.ScrollBarImageColor3 = Color_Border; WLScroll.CanvasSize = UDim2.new(0,0,0,0)
    local WLListLayout = Instance.new("UIListLayout", WLScroll); WLListLayout.Padding = UDim.new(0, 5)

    local function ActualizarPanelWhitelist()
        for _, oldBtn in ipairs(WLScroll:GetChildren()) do if oldBtn:IsA("TextButton") then oldBtn:Destroy() end end
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
            
            local pBtn = Instance.new("TextButton", WLScroll)
            pBtn.Size = UDim2.new(1, -5, 0, 30); pBtn.BorderSizePixel = 0; pBtn.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
            pBtn.Font = Enum.Font.Gotham; pBtn.TextSize = 12; pBtn.TextXAlignment = "Left"; Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)
            local pStroke = Instance.new("UIStroke", pBtn); pStroke.Thickness = 1
            
            local function RefreshButtonVisuals()
                if Settings.Whitelist[p.Name] then
                    pBtn.BackgroundColor3 = Color_NeonBlueDim; pBtn.TextColor3 = Color_TextMain; pStroke.Color = Color_NeonBlue
                else
                    pBtn.BackgroundColor3 = Color_CardDark; pBtn.TextColor3 = Color_TextSub; pStroke.Color = Color_Border
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

    -- Control de Apertura con la Tecla Control Izquierdo (LeftControl)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.LeftControl then
            Main.Visible = not Main.Visible
            if Main.Visible then PlayWindMenuOpen() else PlayWindMenuClose() end
        end
    end)

    Notify("Pïruz HUB Activado exitosamente. Tecla [Left Control]", Color_NeonBlue)
end

-- Sistema de Autenticación de Llave
VerifyBtn.MouseButton1Click:Connect(function()
    if TextBox.Text == KEY_CORRECTA or USUARIOS_PERMITIDOS[LocalPlayer.UserId] then
        IniciarScriptOriginal()
    else
        TextBox.Text = ""
        TextBox.PlaceholderText = "LLAVE INCORRECTA"
        BoxStroke.Color = Color3.fromRGB(255, 50, 50)
        task.wait(1.5)
        BoxStroke.Color = Color_Border
        TextBox.PlaceholderText = "Escribe la Key aquí..."
    end
end)
