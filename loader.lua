print("EXC FREEMIUM - Loading Modules...")

-- [[ 1. SECURE GITHUB LOADER ]]
local GITHUB_BASE = "https://raw.githubusercontent.com/lilyml2222-source/a9/main/"

local function DecodeURL(encoded)
    return encoded:gsub("EXCBASE", GITHUB_BASE)
end

local Config = loadstring(game:HttpGet(DecodeURL("EXCBASEconfig.lua")))()
local Core = loadstring(game:HttpGet(DecodeURL("EXCBASEcore.lua")))()

Core.Config = Config

print("✅ Modules Loaded!")

-- [[ 2. SERVICES ]]
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- [[ 3. SETUP WINDUI ]]
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/Main-v2.lua"
))()

Core.WindUI = WindUI

-- Get custom settings
local CustomSettings = Config.CustomSettings

local Window = WindUI:CreateWindow({
    Title = CustomSettings.UITitle,
    Icon = "rbxassetid://74535250876802",
    Author = CustomSettings.UIAuthor,
    Folder = "exc freemium",
    Transparent = true,
    Theme = "Dark",
    Background = "rbxassetid://99554444694555",
    BackgroundImageTransparency = 0.9,
    ToggleKeybind = Enum.KeyCode.RightControl,
    SideBarWidth = 160,
    KeySystem = {
        Key = { "FREE" },
        Note = "Key: FREE - Enjoy all features!",
        SaveKey = true
    }
})

-- [[ 4. TABS ]]
local AutoWalkTab = Window:Tab({ Title = "Auto Walk", Icon = "footprints" })

-- [[ 5. SETUP FLOATING MENU ]]
local function CreateMiniMenu()
    if getgenv().MiniUI then getgenv().MiniUI:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AutoWalkMiniMenu"
    ScreenGui.ResetOnSpawn = false
    if pcall(function() ScreenGui.Parent = CoreGui end) then
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    getgenv().MiniUI = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.Position = UDim2.new(0.1, 0, 0.65, 0)
    MainFrame.Size = UDim2.new(0, 220, 0, 50)
    MainFrame.Active = true
    MainFrame.Draggable = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 0, 0)
    UIStroke.Thickness = 1.5
    UIStroke.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = MainFrame
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    Layout.Padding = UDim.new(0, 10)

    local function CreateButton(text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Parent = MainFrame
        Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Btn.Size = UDim2.new(0, 60, 0, 30)
        Btn.Font = Enum.Font.GothamBold
        Btn.Text = text
        Btn.TextColor3 = Color3.fromRGB(255, 0, 0)
        Btn.TextSize = 14
        local BtnCorner = Instance.new("UICorner", Btn)
        BtnCorner.CornerRadius = UDim.new(0, 6)
        Btn.MouseButton1Click:Connect(callback)
        return Btn
    end

    CreateButton("PLAY", function()
        if Config.isPlaying then 
            WindUI:Notify({Title="Info", Content="Already running...", Duration=1}) 
            return 
        end
        if Config.CurrentRepoURL == "" then 
            WindUI:Notify({Title="Error", Content="No track loaded!", Duration=2,
            Icon="map-plus"}) 
            return 
        end
        
        Config.isPlaying = true
        WindUI:Notify({Title="Play", Content="Auto Walk Started", Duration=2,
        Icon="footprints"})
        
        task.spawn(function()
            if not Config.isCached then
                WindUI:Notify({Title="Download", Content="Downloading data...", Duration=2,
                Icon="download"})
                local success = Core.DownloadData(Config.CurrentRepoURL)
                if not success then
                    Config.isPlaying = false
                    WindUI:Notify({Title="Failed", Content="Error / Empty data", Duration=3})
                    return
                end
                Config.isCached = true
            end
            Core.RunPlayback()
        end)
    end)

    CreateButton("STOP", function()
        if Config.isPlaying then
            Config.isPlaying = false
            task.wait(0.1)
            Core.ResetCharacter()
            WindUI:Notify({Title="Stopped", Content="Autowalk paused.", Duration=3,
            Icon="circle-pause"})
        else
            WindUI:Notify({Title="Info", Content="Already stopped.", Duration=1})
        end
    end)

    CreateButton("FLIP", function()
        if Config.FlipOffset == 0 then
            Config.FlipOffset = math.pi
            WindUI:Notify({Title="Flip", Content="Facing Backward", Duration=1})
        else
            Config.FlipOffset = 0
            WindUI:Notify({Title="Flip", Content="Facing Normal", Duration=1})
        end
    end)
end

-- [[ 6. AUTO WALK TAB CONTENT ]]

-- Auto Walk | Settings
AutoWalkTab:Section({
    Title = "Auto Walk | Settings"
})

AutoWalkTab:Toggle({
    Title = "Enable Loop",
    Desc = "Repeat playback automatically from start after reaching the end",
    Value = false,
    Callback = function(state) 
        Config.isLooping = state 
        
        if state then
            WindUI:Notify({
                Title="Loop Enabled", 
                Content="Playback will repeat infinitely", 
                Duration=2,
                Icon="repeat"
            })
        else
            WindUI:Notify({
                Title="Loop Disabled", 
                Content="Playback will stop after completion", 
                Duration=2,
                Icon="repeat-2"
            })
        end
    end
})

AutoWalkTab:Toggle({
    Title = "Auto Respawn on Loop",
    Desc = "Still in beta",
    Value = false,
    Callback = function(state)
        Config.autoRespawnLoop = state
        
        if state then
            WindUI:Notify({
                Title="Auto Respawn Enabled", 
                Content="Character will respawn after each loop completion", 
                Duration=2
            })
        else
            WindUI:Notify({
                Title="Auto Respawn Disabled", 
                Content="Character will continue without respawning", 
                Duration=2
            })
        end
    end
})

AutoWalkTab:Slider({
    Title = "AutoWalk Speed",
    Desc = "Adjust autowalk speed (0.9x - 3.0x)",
    Step = 0.1,
    Value = {
        Min = 0.9,
        Max = 3.0,
        Default = 1.0
    },
    Callback = function(value)
        Config.PlaybackSpeed = value
        
        WindUI:Notify({
            Title="Playback Speed", 
            Content=string.format("Speed: %.1fx", value), 
            Duration=1.5,
            Icon="circle-gauge"
        })
    end
})

-- Auto Walk | Track Info
AutoWalkTab:Section({
    Title = "Auto Walk | Track Info",
    Desc = ""
})

-- Display track information
AutoWalkTab:Button({
    Title = "📍 Track: " .. CustomSettings.MountName,
    Desc = "Repository: " .. CustomSettings.GitHubUser,
    Callback = function()
        WindUI:Notify({
            Title="Track Info", 
            Content=CustomSettings.MountName .. " by " .. CustomSettings.UIAuthor, 
            Duration=3,
            Icon="info"
        })
    end
})

AutoWalkTab:Button({
    Title = "Load Track",
    Desc = "Click to load " .. CustomSettings.MountName,
    Callback = function()
        -- Set the repo URL using custom settings
        local repoName = string.lower(string.match(CustomSettings.MountName, "%S+$"))
        Config.CurrentRepoURL = string.format(
            "https://raw.githubusercontent.com/%s/%s/%s/", 
            CustomSettings.GitHubUser, 
            repoName, 
            CustomSettings.Branch
        )
        Config.isCached = false
        Config.SavedCP = 0
        Config.SavedFrame = 1
        Config.TASDataCache = {}
        
        WindUI:Notify({
            Title="Track Loaded", 
            Content=CustomSettings.MountName .. " ready to play!", 
            Duration=2,
            Icon="check"
        })
    end
})

AutoWalkTab:Toggle({
    Title = "[◉] Show/Hide Auto Walk Menu",
    Desc = "Toggle the floating control menu",
    Value = false,
    Callback = function(state)
        if state then 
            CreateMiniMenu() 
        else 
            if getgenv().MiniUI then 
                getgenv().MiniUI:Destroy() 
            end 
        end
    end
})

-- [[ 7. AUTO LOAD TRACK ON STARTUP ]]
task.spawn(function()
    wait(0.5)
    -- Auto load the custom track
    local repoName = string.lower(string.match(CustomSettings.MountName, "%S+$"))
    Config.CurrentRepoURL = string.format(
        "https://raw.githubusercontent.com/%s/%s/%s/", 
        CustomSettings.GitHubUser, 
        repoName, 
        CustomSettings.Branch
    )
    
    WindUI:Notify({
        Title = "Welcome!", 
        Content = CustomSettings.MountName .. " loaded successfully!", 
        Duration = 3,
        Icon="folder-key"
    })
end)
