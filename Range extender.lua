SERVICES
------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

------------------------------------------------------------
-- PASSWORD CONFIG
------------------------------------------------------------
local PASSWORD = "ZANE."

------------------------------------------------------------
-- PASSWORD GUI
------------------------------------------------------------
local PassGui = Instance.new("ScreenGui")
PassGui.Name = "PasswordGui"
PassGui.Parent = CoreGui
PassGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", PassGui)
Frame.Size = UDim2.new(0, 300, 0, 160)
Frame.Position = UDim2.new(0.5, -150, 0.5, -80)
Frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
Frame.BorderSizePixel = 0

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "Enter Password"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1

local Box = Instance.new("TextBox", Frame)
Box.Size = UDim2.new(1,-40,0,35)
Box.Position = UDim2.new(0,20,0,55)
Box.PlaceholderText = "Password"
Box.Text = ""
Box.ClearTextOnFocus = false
Box.TextColor3 = Color3.fromRGB(255,255,255)
Box.BackgroundColor3 = Color3.fromRGB(25,25,25)
Box.Font = Enum.Font.Gotham
Box.TextSize = 14
Box.BorderSizePixel = 0

Instance.new("UICorner", Box).CornerRadius = UDim.new(0,6)

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(1,-40,0,35)
Button.Position = UDim2.new(0,20,0,105)
Button.Text = "Unlock"
Button.Font = Enum.Font.GothamBold
Button.TextSize = 14
Button.TextColor3 = Color3.fromRGB(255,255,255)
Button.BackgroundColor3 = Color3.fromRGB(0,0,0)
Button.BorderSizePixel = 0

Instance.new("UICorner", Button).CornerRadius = UDim.new(0,6)

------------------------------------------------------------
-- MAIN SCRIPT FUNCTION
------------------------------------------------------------
local function StartScript()
    PassGui:Destroy()

    ------------------------------------------------------------
    -- SAFE ANIMATIONS
    ------------------------------------------------------------
    local SAFE_ANIMATIONS = {
        ["180426354"]=true,["180435792"]=true,["180435557"]=true,["180435571"]=true,
        ["180436148"]=true,["684949179"]=true,["684969250"]=true,
        ["7950784441"]=true,["12245963642"]=true,["16398226659"]=true,
        ["6691954521"]=true,["6768460286"]=true,["6835294179"]=true,
        ["6835294624"]=true,["6835295587"]=true,["6835295340"]=true,
        ["6835295768"]=true,["6843685401"]=true,["6843686183"]=true,
        ["6843688241"]=true,["6844129816"]=true,["6844132951"]=true,
        ["6848072990"]=true,["6857596237"]=true,["6887306042"]=true,
        ["6887334158"]=true,["6891877544"]=true,["6910931126"]=true,
        ["18850450498"]=true,
        ["507777826"]=true,["507767714"]=true,["125750702"]=true,
        ["129423030"]=true,["129423131"]=true,
        ["2801263"]=true,["616088211"]=true,["616091570"]=true
    }

    ------------------------------------------------------------
    -- KAVO UI
    ------------------------------------------------------------
    local Library = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"
    ))()

    local Window = Library.CreateLib("Karate Range Extender", "DarkTheme")

    local CombatTab = Window:NewTab("Combat")
    local Combat = CombatTab:NewSection("Range")

    local SystemTab = Window:NewTab("System")
    local System = SystemTab:NewSection("Control")

    ------------------------------------------------------------
    -- SETTINGS
    ------------------------------------------------------------
    local Settings = {
        Enabled = false,
        SafeOnly = true,
        HRPRange = 12,
        LimbRange = 8,
        Transparency = 0.8
    }

    local Connection
    local Originals = {}
    local ScriptAlive = true

    local PARTS = {
        "HumanoidRootPart","Head",
        "Left Arm","Right Arm","Left Leg","Right Leg",
        "LeftHand","RightHand","LeftFoot","RightFoot"
    }

    ------------------------------------------------------------
    -- SAFE CHECK
    ------------------------------------------------------------
    local function SafeAnimPlaying()
        if not Settings.SafeOnly then return true end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return false end

        for _,track in pairs(hum:GetPlayingAnimationTracks()) do
            local id = track.Animation.AnimationId:match("%d+$")
            if id and SAFE_ANIMATIONS[id] then
                return true
            end
        end
        return false
    end

    ------------------------------------------------------------
    -- RANGE LOOP
    ------------------------------------------------------------
    local function Start()
        Connection = RunService.Heartbeat:Connect(function()
            if not ScriptAlive or not Settings.Enabled then return end
            if not SafeAnimPlaying() then return end

            for _,plr in pairs(Players:GetPlayers()) do
                if plr == LocalPlayer then continue end
                local char = plr.Character
                if not char then continue end

                Originals[char] = Originals[char] or {}

                for _,name in pairs(PARTS) do
                    local part = char:FindFirstChild(name)
                    if part and part:IsA("BasePart") then
                        if not Originals[char][name] then
                            Originals[char][name] = {
                                Size = part.Size,
                                Transparency = part.Transparency
                            }
                        end

                        local size = (name=="HumanoidRootPart")
                            and Settings.HRPRange or Settings.LimbRange

                        part.Size = Vector3.new(size,size,size)
                        part.Transparency = Settings.Transparency
                        part.CanCollide = false
                    end
                end
            end
        end)
    end

    local function Stop()
        if Connection then Connection:Disconnect() end
        for char,parts in pairs(Originals) do
            if char.Parent then
                for name,data in pairs(parts) do
                    local p = char:FindFirstChild(name)
                    if p then
                        p.Size = data.Size
                        p.Transparency = data.Transparency
                    end
                end
            end
        end
        Originals = {}
    end

    ------------------------------------------------------------
    -- UI CONTROLS
    ------------------------------------------------------------
    Combat:NewToggle("Enable Range Extender", nil, function(v)
        Settings.Enabled = v
        if v then Start() else Stop() end
    end)

    Combat:NewToggle("Safe Animations Only", nil, function(v)
        Settings.SafeOnly = v
    end)

    Combat:NewSlider("HRP Range", 25, 5, function(v)
        Settings.HRPRange = v
    end)

    Combat:NewSlider("Limb Range", 15, 3, function(v)
        Settings.LimbRange = v
    end)

    Combat:NewSlider("Transparency", 1, 0, function(v)
        Settings.Transparency = v
    end)

    ------------------------------------------------------------
    -- DELETE SCRIPT
    ------------------------------------------------------------
    System:NewButton("DELETE SCRIPT", "Removes everything", function()
        ScriptAlive = false
        Settings.Enabled = false
        Stop()

        for _,v in pairs(CoreGui:GetChildren()) do
            if v.Name:lower():find("kavo") or v.Name=="FlockToggle" then
                v:Destroy()
            end
        end
    end)
end

------------------------------------------------------------
-- PASSWORD CHECK
------------------------------------------------------------
Button.MouseButton1Click:Connect(function()
    if Box.Text == PASSWORD then
        StartScript()
    else
        Box.Text = ""
        Box.PlaceholderText = "Wrong Password"
    end
end)
