repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ==================== SISTEMA DE AUTORIZACIÓN (WHITELIST) ====================
local ALLOWED_PLACE = 104715542330896 -- PlaceId de Block Spin

local ALLOWED_USERS = {
    [8216624047] = true, -- UserId PIRUZ
    [9493474736] = true, -- UserId ALWEFT
    [2646021845] = true, -- UserId SXULL
}

if game.PlaceId ~= ALLOWED_PLACE then
    return warn("Este script solo funciona en Block Spin.")
end

if not ALLOWED_USERS[LocalPlayer.UserId] then
    return warn("No estás autorizado a usar este script.")
end
-- =============================================================================

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local CoreGuiService = game:GetService("CoreGui")
local CoreGui = type(cloneref) == "function" and cloneref(CoreGuiService) or CoreGuiService

local Camera = workspace.CurrentCamera

-- Settings
local Settings = {
    Aimbot = true,
    NoRecoil = true,
    FOV = 150,
    AimPart = "Head",
    ESP = true,
    Box3D = true,
    HPBar = true,
    Distance = true,
    FOVVisible = true,
    HideName = false,
    DefaultFOV = Camera.FieldOfView,
    Whitelist = {} 
}

-- PALETA DE COLORES DE LA INTERFAZ
local BlackPure = Color3.fromRGB(10, 10, 12)       -- Negro Absoluto (Fondo principal)
local DarkGrey = Color3.fromRGB(24, 24, 28)        -- Gris Muy Oscuro (Botones y realces)
local BlueLight = Color3.fromRGB(0, 162, 255)      -- Azul Brillante (Textos destacados y acentos)

-- PALETA DE COLORES DEL ESP
local GreyESP = Color3.fromRGB(140, 140, 145)      -- Box Gris
local WhiteESP = Color3.new(1, 1, 1)               -- Nombre Blanco
local LightGreenDistESP = Color3.fromRGB(160, 255, 160) -- Verde Clarito para los Metros

-- Notification
local function Notify(msg, color)
    local NotifyGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
    local Frame = Instance.new("Frame", NotifyGui)
    Frame.Size = UDim2.new(0, 240, 0, 50)
    Frame.Position = UDim2.new(1, 10, 0.8, 0)
    Frame.BackgroundColor3 = BlackPure
    Instance.new("UICorner", Frame)
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = color or BlueLight
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = msg
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = "GothamBold"
    Label.TextSize = 14
    Label.TextXAlignment = "Left"

    Frame:TweenPosition(UDim2.new(1, -250, 0.8, 0), "Out", "Back", 0.5)
    task.delay(3, function()
        Frame:TweenPosition(UDim2.new(1, 10, 0.8, 0), "In", "Linear", 0.5)
        task.wait(0.5)
        NotifyGui:Destroy()
    end)
end

-- ==================== NO RECOIL AVANZADO ====================
task.spawn(function()
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if Settings.NoRecoil and not checkcaller() and type(key) == "string" then
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
        if Settings.NoRecoil and LocalPlayer.Character then
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

-- Ocultar Nombre
local function UpdateHideName()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if Settings.HideName then
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("BillboardGui") then
                obj.Enabled = false
            end
        end
    else
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
        end
        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("BillboardGui") then
                obj.Enabled = true
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.3) do
        pcall(UpdateHideName)
    end
end)

-- ==================== ESP SYSTEM ====================
local ESPObjects = {}

local function CreateESPObjects()
    local obj = {
        Name = Drawing.new("Text"),
        DistLabel = Drawing.new("Text"),
        Box = Drawing.new("Square"),
        HealthBarBg = Drawing.new("Square"),
        HealthBar = Drawing.new("Square")
    }
    obj.Name.Size = 14; obj.Name.Center = true; obj.Name.Outline = true; obj.Name.Color = WhiteESP
    obj.DistLabel.Size = 12; obj.DistLabel.Center = true; obj.DistLabel.Outline = true; obj.DistLabel.Color = LightGreenDistESP
    obj.Box.Thickness = 1.8; obj.Box.Color = GreyESP
    obj.HealthBarBg.Filled = true; obj.HealthBarBg.Color = Color3.new(0,0,0)
    obj.HealthBar.Filled = true
    return obj
end

local function HideESP(objs)
    if objs then
        objs.Name.Visible = false
        objs.DistLabel.Visible = false
        objs.Box.Visible = false
        objs.HealthBarBg.Visible = false
        objs.HealthBar.Visible = false
    end
end

local function RemoveESP(player)
    if ESPObjects[player] then
        for _, drawingObj in pairs(ESPObjects[player]) do
            drawingObj:Remove()
        end
        ESPObjects[player] = nil
    end
end

local function UpdateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end

        if not ESPObjects[p] then
            ESPObjects[p] = CreateESPObjects()
        end

        local objs = ESPObjects[p]
        local char = p.Character

        if Settings.ESP and char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            
            if onScreen then
                local h = (Camera.ViewportSize.Y / screenPos.Z) * 2.6
                local w = h * 0.62
                local x, y = screenPos.X - w/2, screenPos.Y - h/2
                
                local isWhitelisted = Settings.Whitelist[p.Name] == true
                
                objs.Box.Color = isWhitelisted and BlueLight or GreyESP
                objs.Box.Visible = Settings.Box3D
                objs.Box.Size = Vector2.new(w, h)
                objs.Box.Position = Vector2.new(x, y)

                objs.Name.Visible = true
                objs.Name.Text = p.DisplayName
                objs.Name.Position = Vector2.new(screenPos.X, y - 20)

                objs.DistLabel.Visible = Settings.Distance
                objs.DistLabel.Text = "[" .. math.floor(screenPos.Z) .. "m]"
                objs.DistLabel.Position = Vector2.new(screenPos.X, y + h + 6) -- Ajustado hacia arriba al quitar el texto de arma

                if Settings.HPBar then
                    local hp = math.clamp(char.Humanoid.Health / char.Humanoid.MaxHealth, 0, 1)
                    objs.HealthBarBg.Visible = true
                    objs.HealthBarBg.Size = Vector2.new(4, h)
                    objs.HealthBarBg.Position = Vector2.new(x - 6, y)
                    
                    objs.HealthBar.Visible = true
                    objs.HealthBar.Size = Vector2.new(2, h * hp)
                    objs.HealthBar.Position = Vector2.new(x - 5, y + h*(1-hp))
                    objs.HealthBar.Color = Color3.fromHSV(hp*0.33, 1, 1)
                else
                    objs.HealthBarBg.Visible = false
                    objs.HealthBar.Visible = false
                end
            else
                HideESP(objs)
            end
        else
            HideESP(objs)
        end
    end
end

RunService.RenderStepped:Connect(UpdateESP)
Players.PlayerRemoving:Connect(RemoveESP)

-- ==================== AIMBOT ====================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Radius = Settings.FOV

local function GetAimPart(char)
    if not char then return nil end
    local partName = Settings.AimPart
    if partName == "Head" then return char:FindFirstChild("Head")
    elseif partName == "Chest" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    elseif partName == "Hand" then return char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
    elseif partName == "Leg" then return char:FindFirstChild("RightLeg") or char:FindFirstChild("Right Leg")
    end
    return char:FindFirstChild("Head")
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Visible = Settings.FOVVisible and Settings.Aimbot
    FOVCircle.Radius = Settings.FOV

    if not Settings.Aimbot or Camera.FieldOfView >= (Settings.DefaultFOV - 3) then return end

    local bestTarget = nil
    local maxD = Settings.FOV

    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer or Settings.Whitelist[p.Name] then continue end
        local char = p.Character
        if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then continue end

        local targetPart = GetAimPart(char)
        if not targetPart then continue end

        local aimPos = targetPart.Position
        if Settings.AimPart == "Head" then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root and (targetPart.Position.Y - root.Position.Y > 2.5) then
                aimPos = targetPart.Position - Vector3.new(0, 1.35, 0)
            end
        end

        local pos, onScreen = Camera:WorldToViewportPoint(aimPos)
        if onScreen then
            local dist = (Vector2.new(pos.X, pos.Y) - FOVCircle.Position).Magnitude
            if dist < maxD then
                maxD = dist
                bestTarget = aimPos
            end
        end
    end

    if bestTarget then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, bestTarget)
    end
end)

-- ==================== MAIN MENU CREATION ====================
local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 620, 0, 480)
Main.Position = UDim2.new(0.5, -310, 0.5, -240)
Main.BackgroundColor3 = BlackPure
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local MenuStroke = Instance.new("UIStroke", Main)
MenuStroke.Color = DarkGrey
MenuStroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "Piru HUB"
Title.TextColor3 = BlueLight
Title.Font = "GothamBold"
Title.TextSize = 24

local LeftFrame = Instance.new("Frame", Main)
LeftFrame.Size = UDim2.new(0.48, 0, 0.85, 0)
LeftFrame.Position = UDim2.new(0.02, 0, 0.12, 0)
LeftFrame.BackgroundTransparency = 1

-- FOV Slider
local FOVFrame = Instance.new("Frame", LeftFrame)
FOVFrame.Size = UDim2.new(1, 0, 0, 55)
FOVFrame.Position = UDim2.new(0, 0, 0, 0)
FOVFrame.BackgroundColor3 = DarkGrey
Instance.new("UICorner", FOVFrame)

local FOVLabel = Instance.new("TextLabel", FOVFrame)
FOVLabel.Size = UDim2.new(1, 0, 0.45, 0)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "FOV Size: 150"
FOVLabel.TextColor3 = Color3.new(1,1,1)
FOVLabel.Font = "GothamBold"
FOVLabel.TextSize = 13

local SliderBar = Instance.new("Frame", FOVFrame)
SliderBar.Size = UDim2.new(0.9, 0, 0, 6)
SliderBar.Position = UDim2.new(0.05, 0, 0.65, 0)
SliderBar.BackgroundColor3 = BlackPure
Instance.new("UICorner", SliderBar)

local SliderFill = Instance.new("Frame", SliderBar)
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = BlueLight
Instance.new("UICorner", SliderFill)

local dragging = false
SliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mouseX = UserInputService:GetMouseLocation().X
        local percent = math.clamp((mouseX - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local newFOV = math.floor(50 + percent * 250)
        Settings.FOV = newFOV
        FOVLabel.Text = "FOV Size: " .. newFOV
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    end
end)

-- Aim At Button
local AimPartBtn = Instance.new("TextButton", LeftFrame)
AimPartBtn.Size = UDim2.new(1, 0, 0, 36)
AimPartBtn.Position = UDim2.new(0, 0, 0.15, 0)
AimPartBtn.BackgroundColor3 = DarkGrey
AimPartBtn.Text = "Aim At: Head"
AimPartBtn.TextColor3 = Color3.new(1,1,1)
AimPartBtn.Font = "GothamBold"
AimPartBtn.TextSize = 13
Instance.new("UICorner", AimPartBtn)

local aimOptions = {"Head", "Chest", "Hand", "Leg"}
AimPartBtn.MouseButton1Click:Connect(function()
    local idx = table.find(aimOptions, Settings.AimPart) or 1
    idx = (idx % #aimOptions) + 1
    Settings.AimPart = aimOptions[idx]
    AimPartBtn.Text = "Aim At: " .. Settings.AimPart
end)

-- Toggles Automáticos
local currentToggleY = 0.25
local function AddToggle(name, key)
    local btn = Instance.new("TextButton", LeftFrame)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Position = UDim2.new(0, 0, currentToggleY, 0)
    btn.BackgroundColor3 = Settings[key] and DarkGrey or Color3.fromRGB(15, 15, 18)
    btn.Text = name .. (Settings[key] and " : ON" or " : OFF")
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = "GothamBold"
    btn.TextSize = 13
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.BackgroundColor3 = Settings[key] and DarkGrey or Color3.fromRGB(15, 15, 18)
        btn.Text = name .. (Settings[key] and " : ON" or " : OFF")
        if key == "HideName" then UpdateHideName() end
    end)
    currentToggleY = currentToggleY + 0.095
end

AddToggle("Aimbot Master", "Aimbot")
AddToggle("No Recoil System", "NoRecoil")
AddToggle("Hybrid ESP", "ESP")
AddToggle("Show HP Bar", "HPBar")
AddToggle("Hide Name", "HideName")

-- Right Side Whitelist
local WLFrame = Instance.new("Frame", Main)
WLFrame.Size = UDim2.new(0.45, 0, 0.82, 0)
WLFrame.Position = UDim2.new(0.53, 0, 0.13, 0)
WLFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Instance.new("UICorner", WLFrame)

local WLTitle = Instance.new("TextLabel", WLFrame)
WLTitle.Size = UDim2.new(1, 0, 0, 40)
WLTitle.BackgroundTransparency = 1
WLTitle.Text = "Whitelist (Add / Remove)"
WLTitle.TextColor3 = Color3.new(1,1,1)
WLTitle.Font = "GothamBold"
WLTitle.TextSize = 14

local WLScrolling = Instance.new("ScrollingFrame", WLFrame)
WLScrolling.Size = UDim2.new(1, -10, 1, -50)
WLScrolling.Position = UDim2.new(0, 5, 0, 45)
WLScrolling.BackgroundTransparency = 1
WLScrolling.ScrollBarThickness = 6

local WLLayout = Instance.new("UIListLayout", WLScrolling)
WLLayout.Padding = UDim.new(0, 4)
WLLayout.SortOrder = Enum.SortOrder.Name

local function UpdateWhitelistMenu()
    for _, child in pairs(WLScrolling:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 35)
        btn.BackgroundColor3 = Settings.Whitelist[p.Name] and BlueLight or DarkGrey
        btn.Text = p.DisplayName
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = "Gotham"
        btn.TextSize = 13
        Instance.new("UICorner", btn)
        btn.Parent = WLScrolling

        btn.MouseButton1Click:Connect(function()
            Settings.Whitelist[p.Name] = not Settings.Whitelist[p.Name]
            Notify(Settings.Whitelist[p.Name] and "Whitelisted: " .. p.DisplayName or "Removed: " .. p.DisplayName)
            UpdateWhitelistMenu()
        end)
    end
end

-- Main Toggle Button
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 75, 0, 75)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -37.5)
ToggleBtn.Text = "Piru"
ToggleBtn.BackgroundColor3 = DarkGrey
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = "GothamBold"
ToggleBtn.TextSize = 16
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1,0)

local ButtonStroke = Instance.new("UIStroke", ToggleBtn)
ButtonStroke.Color = BlueLight
ButtonStroke.Thickness = 1.5

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    if Main.Visible then UpdateWhitelistMenu() end
end)

-- Init
Main.Visible = true
UpdateWhitelistMenu()
Players.PlayerAdded:Connect(UpdateWhitelistMenu)

Notify("Piru HUB | Autorización Correcta", BlueLight)
