--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--// RIDE A PET - ULTRA HUB V8 (NEW UI DESIGN + EGG SPAWN ALERTS & SOUND)
--// Put in StarterPlayer > StarterPlayerScripts or run in Executor

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local Player = Players.LocalPlayer

-- Dein permanenter GitHub Raw-Link für Auto-Reexecute beim Server-Hop:
local ScriptLoadstring = [[
	loadstring(game:HttpGet("https://raw.githubusercontent.com/bananielheinrich-spec/RobloxScripts/refs/heads/main/main.lua"))()
]]

--==================================================
-- THEMES DATABASE
--==================================================

local Themes = {
	["Midnight Blue"] = {
		MainBg = Color3.fromRGB(12, 14, 22),
		SidebarBg = Color3.fromRGB(16, 19, 30),
		TopbarBg = Color3.fromRGB(20, 24, 38),
		Accent = Color3.fromRGB(0, 140, 255),
		CardBg = Color3.fromRGB(22, 27, 42),
		Stroke = Color3.fromRGB(0, 180, 255)
	},
	["Cyberpunk Purple"] = {
		MainBg = Color3.fromRGB(16, 10, 25),
		SidebarBg = Color3.fromRGB(22, 12, 35),
		TopbarBg = Color3.fromRGB(30, 15, 48),
		Accent = Color3.fromRGB(180, 0, 255),
		CardBg = Color3.fromRGB(28, 15, 45),
		Stroke = Color3.fromRGB(220, 0, 255)
	},
	["Emerald Green"] = {
		MainBg = Color3.fromRGB(10, 20, 15),
		SidebarBg = Color3.fromRGB(12, 28, 20),
		TopbarBg = Color3.fromRGB(15, 36, 25),
		Accent = Color3.fromRGB(0, 200, 120),
		CardBg = Color3.fromRGB(16, 35, 25),
		Stroke = Color3.fromRGB(0, 255, 150)
	},
	["Dark Minimal"] = {
		MainBg = Color3.fromRGB(14, 14, 14),
		SidebarBg = Color3.fromRGB(20, 20, 20),
		TopbarBg = Color3.fromRGB(26, 26, 26),
		Accent = Color3.fromRGB(180, 180, 180),
		CardBg = Color3.fromRGB(24, 24, 24),
		Stroke = Color3.fromRGB(100, 100, 100)
	}
}

--==================================================
-- EGG DATABASE
--==================================================

local Eggs = {
	["White Egg"] = {luck = 1, rarity = "Common"},
	["Brown Egg"] = {luck = 5, rarity = "Common"},
	["Cracked Egg"] = {luck = 30, rarity = "Rare"},
	["Easter Egg"] = {luck = 50, rarity = "Rare"},
	["Stone Egg"] = {luck = 100, rarity = "Rare"},
	["Leaf Egg"] = {luck = 200, rarity = "Rare"},
	["Mushroom Egg"] = {luck = 500, rarity = "Epic"},
	["Flower Egg"] = {luck = 750, rarity = "Epic"},
	["Slime Egg"] = {luck = 1000, rarity = "Epic"},
	["Ice Egg"] = {luck = 3000, rarity = "Epic"},
	["Glass Egg"] = {luck = 10000, rarity = "Legendary"},
	["Golden Egg"] = {luck = 30000, rarity = "Legendary"},
	["Crystal Egg"] = {luck = 150000, rarity = "Mythic"},
	["Skull Egg"] = {luck = 250000, rarity = "Mythic"},
	["Dominus Egg"] = {luck = 700000, rarity = "Mythic"},
	["Flaming Egg"] = {luck = 1000000, rarity = "Mythic"},
	["Sinister Egg"] = {luck = 3000000, rarity = "Mythic"},
	["Soul Egg"] = {luck = 7000000, rarity = "Mythic"},
	["Aurora Egg"] = {luck = 300000000, rarity = "Divine"},
	["Galaxy Egg"] = {luck = 1500000000, rarity = "Divine"},
	["Black Hole Egg"] = {luck = 100000000000, rarity = "Etheral"},
	["Cherub Egg"] = {luck = 1000000000000, rarity = "Etheral"},
}

local RarityColors = {
	Common = Color3.fromRGB(220, 225, 235),
	Rare = Color3.fromRGB(0, 190, 255),
	Epic = Color3.fromRGB(180, 40, 255),
	Legendary = Color3.fromRGB(255, 210, 0),
	Mythic = Color3.fromRGB(255, 60, 90),
	Divine = Color3.fromRGB(255, 120, 255),
	Etheral = Color3.fromRGB(0, 255, 240),
}

--==================================================
-- SETTINGS & CONFIG SYSTEM
--==================================================

local SettingsFile = "RideAPet_HubSettings_V8.json"

local Settings = {
	ESPEnabled = true,
	RadarEnabled = true,
	FlyEnabled = false,
	AutoClaimEnabled = false,
	WalkSpeed = 16,
	FlySpeed = 60,
	CurrentTheme = "Midnight Blue",
	AllowedEggs = {},
	AlertEggs = {},
	AlertSoundEnabled = true
}

local safeWrite = writefile or (syn and syn.writefile)
local safeRead = readfile or (syn and syn.readfile)
local safeIsFile = isfile or (syn and syn.isfile)

for EggName, Data in pairs(Eggs) do
	Settings.AllowedEggs[EggName] = true
	if Data.luck >= 10000 then
		Settings.AlertEggs[EggName] = true
	else
		Settings.AlertEggs[EggName] = false
	end
end

local function SaveSettings()
	if safeWrite then
		pcall(function() safeWrite(SettingsFile, HttpService:JSONEncode(Settings)) end)
	end
end

local function LoadSettings()
	if safeRead and safeIsFile and safeIsFile(SettingsFile) then
		pcall(function()
			local Loaded = HttpService:JSONDecode(safeRead(SettingsFile))
			if type(Loaded) == "table" then
				for k, v in pairs(Loaded) do
					if k == "AllowedEggs" and type(v) == "table" then
						for egg, val in pairs(v) do Settings.AllowedEggs[egg] = val end
					elseif k == "AlertEggs" and type(v) == "table" then
						for egg, val in pairs(v) do Settings.AlertEggs[egg] = val end
					else
						Settings[k] = v
					end
				end
			end
		end)
	end
end

LoadSettings()

local GridSpacing = 6
local MaxColumns = 5
local EggESP = {}
local AlertedEggsCache = {}
local NeedsTPListUpdate = false
local FilterButtons = {}
local AlertButtons = {}

--==================================================
-- AUTO RE-EXECUTE & SERVER HOP SYSTEM
--==================================================

local queueOnTeleport = queue_on_teleport or (syn and syn.queue_on_teleport) or queueonteleport

local function QueueAutoReexecute()
	if queueOnTeleport then
		queueOnTeleport([[
			repeat task.wait() until game:IsLoaded()
		]] .. ScriptLoadstring)
	end
end

local function RejoinCurrentServer()
	QueueAutoReexecute()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
end

local function ServerHopLowPlayers()
	QueueAutoReexecute()
	local ApiUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
	local Success, Response = pcall(function()
		return HttpService:JSONDecode(game:HttpGet(ApiUrl))
	end)

	if Success and Response and Response.data then
		for _, ServerData in ipairs(Response.data) do
			if ServerData.playing < ServerData.maxPlayers and ServerData.id ~= game.JobId then
				TeleportService:TeleportToPlaceInstance(game.PlaceId, ServerData.id, Player)
				return
			end
		end
	end
	TeleportService:Teleport(game.PlaceId, Player)
end

--==================================================
-- HELPER & GRID FUNCTIONS
--==================================================

local function GetCharacter() return Player.Character end
local function GetRoot() local Char = GetCharacter(); return Char and Char:FindFirstChild("HumanoidRootPart") or nil end
local function GetHumanoid() local Char = GetCharacter(); return Char and Char:FindFirstChildOfClass("Humanoid") or nil end

local function FormatNumber(Number)
	if Number >= 1e12 then return string.format("%.1fT", Number / 1e12)
	elseif Number >= 1e9 then return string.format("%.1fB", Number / 1e9)
	elseif Number >= 1e6 then return string.format("%.1fM", Number / 1e6)
	elseif Number >= 1e3 then return string.format("%.1fK", Number / 1e3) end
	return tostring(Number)
end

local function GetObjectPosition(Object)
	if Object:IsA("BasePart") then return Object.Position
	elseif Object:IsA("Model") then return Object:GetPivot().Position end
	return nil
end

local function TeleportTo(Position)
	local Root = GetRoot()
	if Root and Position then Root.CFrame = CFrame.new(Position + Vector3.new(0, 3, 0)) end
end

local function PressKey2()
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
	task.wait(0.08)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
end

local function GetUserPlot()
	local PlotsFolder = workspace:FindFirstChild("Plots")
	if PlotsFolder then
		for _, Plot in ipairs(PlotsFolder:GetChildren()) do
			local DataFolder = Plot:FindFirstChild("Data")
			if DataFolder then
				local OwnerValue = DataFolder:FindFirstChild("Owner")
				if OwnerValue and OwnerValue.Value == Player then return Plot end
			end
		end
	end
	return nil
end

local function GetNextBaseplateSpot()
	local Plot = GetUserPlot()
	if not Plot then return nil end

	local Baseplate = Plot:FindFirstChild("Baseplate") or Plot.PrimaryPart or Plot:FindFirstChildWhichIsA("BasePart", true)
	if not Baseplate then return nil end

	local EggsFolder = Plot:FindFirstChild("Eggs")
	local ExistingCount = EggsFolder and #EggsFolder:GetChildren() or 0

	local Column = ExistingCount % MaxColumns
	local Row = math.floor(ExistingCount / MaxColumns)

	local StartX = -((MaxColumns - 1) * GridSpacing) / 2
	local StartZ = -4

	local OffsetX = StartX + (Column * GridSpacing)
	local OffsetZ = StartZ + (Row * GridSpacing)

	local BaseCFrame = Baseplate.CFrame
	return (BaseCFrame * CFrame.new(OffsetX, (Baseplate.Size.Y / 2) + 2.5, OffsetZ)).Position
end

local function TeleportToBase()
	local Spot = GetNextBaseplateSpot()
	if Spot then
		TeleportTo(Spot)
	else
		local SpawnLocation = workspace:FindFirstChildWhichIsA("SpawnLocation", true)
		if SpawnLocation then TeleportTo(SpawnLocation.Position) end
	end
end

local function IsEgg(Object)
	if not (Object:IsA("Model") or Object:IsA("BasePart")) then return false end
	if not Eggs[Object.Name] then return false end
	local PlotsFolder = workspace:FindFirstChild("Plots")
	if PlotsFolder and Object:IsDescendantOf(PlotsFolder) then return false end
	return true
end

local function GetAdornee(Egg)
	if Egg:IsA("BasePart") then return Egg end
	if Egg:IsA("Model") then return Egg.PrimaryPart or Egg:FindFirstChildWhichIsA("BasePart", true) end
	return nil
end

--==================================================
-- GUI CREATION & MODERN UI DESIGN
--==================================================

local GUI = Instance.new("ScreenGui")
GUI.Name = "RideAPetUltraV8"
GUI.ResetOnSpawn = false
GUI.Parent = Player:WaitForChild("PlayerGui")

-- EGG ALERT BANNER GUI (OBEN AM BILDSCHIRM)
local AlertBanner = Instance.new("Frame")
AlertBanner.Size = UDim2.fromOffset(380, 65)
AlertBanner.Position = UDim2.new(0.5, -190, -0.2, 0) -- Ausgeblendet oben
AlertBanner.BackgroundColor3 = Color3.fromRGB(18, 12, 32)
AlertBanner.BorderSizePixel = 0
AlertBanner.ZIndex = 100
AlertBanner.Parent = GUI
Instance.new("UICorner", AlertBanner).CornerRadius = UDim.new(0, 12)

local AlertStroke = Instance.new("UIStroke")
AlertStroke.Color = Color3.fromRGB(255, 0, 180)
AlertStroke.Thickness = 2
AlertStroke.Parent = AlertBanner

local AlertTitle = Instance.new("TextLabel")
AlertTitle.Size = UDim2.new(1, -20, 0, 24)
AlertTitle.Position = UDim2.fromOffset(12, 8)
AlertTitle.BackgroundTransparency = 1
AlertTitle.Text = "🚨 RARE EGG DETECTED!"
AlertTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
AlertTitle.TextSize = 13
AlertTitle.Font = Enum.Font.GothamBold
AlertTitle.TextXAlignment = Enum.TextXAlignment.Left
AlertTitle.ZIndex = 101
AlertTitle.Parent = AlertBanner

local AlertSub = Instance.new("TextLabel")
AlertSub.Size = UDim2.new(1, -20, 0, 22)
AlertSub.Position = UDim2.fromOffset(12, 32)
AlertSub.BackgroundTransparency = 1
AlertSub.Text = "Galaxy Egg [1 in 1.5B] has spawned on the server!"
AlertSub.TextColor3 = Color3.fromRGB(240, 240, 255)
AlertSub.TextSize = 11
AlertSub.Font = Enum.Font.GothamMedium
AlertSub.TextXAlignment = Enum.TextXAlignment.Left
AlertSub.ZIndex = 101
AlertSub.Parent = AlertBanner

local function TriggerEggAlertGUI(EggName, Rarity, Luck)
	if Settings.AlertSoundEnabled then
		local Sound = Instance.new("Sound")
		Sound.SoundId = "rbxassetid://138718776377217" -- Premium Notification Sound
		Sound.Volume = 1
		Sound.Parent = SoundService
		Sound:Play()
		Debris:AddItem(Sound, 3)
	end

	AlertTitle.Text = "🚨 " .. Rarity:upper() .. " EGG DETECTED!"
	AlertSub.Text = "Egg: " .. EggName .. " (Luck: 1 in " .. FormatNumber(Luck) .. ")"
	AlertStroke.Color = RarityColors[Rarity] or Color3.fromRGB(255, 0, 180)

	-- Animate In
	TweenService:Create(AlertBanner, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -190, 0, 20)}):Play()

	task.spawn(function()
		task.wait(4.5)
		-- Animate Out
		TweenService:Create(AlertBanner, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -190, -0.2, 0)}):Play()
	end)
end

-- MAIN HUB FRAME
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(680, 490)
Main.Position = UDim2.new(0.5, -340, 0.5, -245)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = GUI
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Parent = Main

local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 52)
Topbar.BorderSizePixel = 0
Topbar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.fromOffset(20, 0)
Title.BackgroundTransparency = 1
Title.Text = "💎 RIDE A PET • ULTRA HUB V8"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(32, 32)
Minimize.Position = UDim2.new(1, -74, 0, 10)
Minimize.BackgroundColor3 = Color3.fromRGB(35, 40, 58)
Minimize.Text = "−"
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = Topbar
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0, 8)

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(32, 32)
Close.Position = UDim2.new(1, -38, 0, 10)
Close.BackgroundColor3 = Color3.fromRGB(220, 45, 65)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 18
Close.Font = Enum.Font.GothamBold
Close.Parent = Topbar
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

local Sidebar = Instance.new("Frame")
Sidebar.Position = UDim2.fromOffset(0, 52)
Sidebar.Size = UDim2.new(0, 180, 1, -52)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 6)
SidebarList.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

local Container = Instance.new("Frame")
Container.Position = UDim2.fromOffset(180, 52)
Container.Size = UDim2.new(1, -180, 1, -52)
Container.BackgroundTransparency = 1
Container.Parent = Main

local ActiveTabBtn = nil
local Pages = {}

local function CreateClickBounce(Button)
	Button.MouseButton1Down:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.08), {Size = UDim2.new(Button.Size.X.Scale, Button.Size.X.Offset - 3, Button.Size.Y.Scale, Button.Size.Y.Offset - 2)}):Play()
	end)
	Button.MouseButton1Up:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Bounce), {Size = UDim2.new(Button.Size.X.Scale, Button.Size.X.Offset + 3, Button.Size.Y.Scale, Button.Size.Y.Offset + 2)}):Play()
	end)
end

local function ApplyTheme(ThemeName)
	local Theme = Themes[ThemeName] or Themes["Midnight Blue"]
	Settings.CurrentTheme = ThemeName
	SaveSettings()

	TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundColor3 = Theme.MainBg}):Play()
	TweenService:Create(Sidebar, TweenInfo.new(0.3), {BackgroundColor3 = Theme.SidebarBg}):Play()
	TweenService:Create(Topbar, TweenInfo.new(0.3), {BackgroundColor3 = Theme.TopbarBg}):Play()
	TweenService:Create(MainStroke, TweenInfo.new(0.3), {Color = Theme.Stroke}):Play()

	for Name, p in pairs(Pages) do
		if p.btn == ActiveTabBtn then
			TweenService:Create(p.btn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Accent, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		else
			TweenService:Create(p.btn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.CardBg, TextColor3 = Color3.fromRGB(170, 180, 200)}):Play()
		end
	end
end

local function CreateTab(Name, Icon)
	local TabBtn = Instance.new("TextButton")
	TabBtn.Size = UDim2.new(1, 0, 0, 38)
	TabBtn.Text = "  " .. Icon .. "  " .. Name
	TabBtn.TextSize = 11
	TabBtn.Font = Enum.Font.GothamSemibold
	TabBtn.TextXAlignment = Enum.TextXAlignment.Left
	TabBtn.Parent = Sidebar
	Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
	CreateClickBounce(TabBtn)

	local Page = Instance.new("Frame")
	Page.Size = UDim2.new(1, -24, 1, -24)
	Page.Position = UDim2.fromOffset(12, 12)
	Page.BackgroundTransparency = 1
	Page.Visible = false
	Page.Parent = Container

	Pages[Name] = {btn = TabBtn, page = Page}

	TabBtn.MouseButton1Click:Connect(function()
		ActiveTabBtn = TabBtn
		ApplyTheme(Settings.CurrentTheme)
		for _, p in pairs(Pages) do p.page.Visible = false end
		Page.Visible = true
	end)

	return Page
end

local MainTab = CreateTab("Dashboard", "⚡")
local FilterTab = CreateTab("Auto Filter", "🎯")
local AlertsTab = CreateTab("Egg Alerts", "🚨")
local TeleportTab = CreateTab("Teleports", "🚀")
local SettingsTab = CreateTab("Settings & Hop", "⚙️")

ActiveTabBtn = Pages["Dashboard"].btn
Pages["Dashboard"].page.Visible = true

--==================================================
-- ESP SYSTEM & ALERT DETECTION
--==================================================

local function CreateESP(Egg)
	if EggESP[Egg] or not IsEgg(Egg) then return end
	local Adornee = GetAdornee(Egg)
	if not Adornee then return end

	local Data = Eggs[Egg.Name]
	local Billboard = Instance.new("BillboardGui")
	Billboard.Name = "EggESP"
	Billboard.Adornee = Adornee
	Billboard.Size = UDim2.fromOffset(145, 46)
	Billboard.StudsOffset = Vector3.new(0, 2.5, 0)
	Billboard.AlwaysOnTop = true
	Billboard.MaxDistance = 600
	Billboard.Enabled = Settings.ESPEnabled
	Billboard.Parent = Egg

	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.fromScale(1, 1)
	Frame.BackgroundColor3 = Color3.fromRGB(15, 17, 25)
	Frame.BackgroundTransparency = 0.15
	Frame.Parent = Billboard
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = RarityColors[Data.rarity] or Color3.new(1, 1, 1)
	Stroke.Thickness = 1.8
	Stroke.Parent = Frame

	local Text = Instance.new("TextLabel")
	Text.Size = UDim2.new(1, -6, 1, -2)
	Text.Position = UDim2.fromOffset(3, 1)
	Text.BackgroundTransparency = 1
	Text.TextColor3 = Color3.fromRGB(255, 255, 255)
	Text.TextSize = 11
	Text.Font = Enum.Font.GothamBold
	Text.TextWrapped = true
	Text.Parent = Frame

	EggESP[Egg] = { gui = Billboard, text = Text }
	NeedsTPListUpdate = true

	-- EGG SPAWN ALERT TRIGGER
	if Settings.AlertEggs[Egg.Name] and not AlertedEggsCache[Egg] then
		AlertedEggsCache[Egg] = true
		TriggerEggAlertGUI(Egg.Name, Data.rarity, Data.luck)
	end
end

local function RemoveESP(Egg)
	local Info = EggESP[Egg]
	if Info then
		if Info.gui then Info.gui:Destroy() end
		EggESP[Egg] = nil
		NeedsTPListUpdate = true
	end
end

local function ScanEggs()
	local Found = {}
	for _, Object in ipairs(workspace:GetDescendants()) do
		if IsEgg(Object) then
			Found[Object] = true
			if not EggESP[Object] then CreateESP(Object) end
		end
	end
	for Egg, _ in pairs(EggESP) do
		if not Found[Egg] or not Egg.Parent or not IsEgg(Egg) then RemoveESP(Egg) end
	end
end

--==================================================
-- DASHBOARD TAB CONTROLS
--==================================================

local MainLayout = Instance.new("UIListLayout")
MainLayout.Padding = UDim.new(0, 8)
MainLayout.Parent = MainTab

local function CreateToggle(Parent, Text, SettingKey, Callback)
	local DefaultState = Settings[SettingKey]
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, 0, 0, 40)
	Btn.BackgroundColor3 = DefaultState and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(25, 30, 45)
	Btn.Text = "  " .. Text .. "  ➔  " .. (DefaultState and "ON" or "OFF")
	Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Btn.TextSize = 11
	Btn.Font = Enum.Font.GothamBold
	Btn.TextXAlignment = Enum.TextXAlignment.Left
	Btn.Parent = Parent
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
	CreateClickBounce(Btn)

	Btn.MouseButton1Click:Connect(function()
		Settings[SettingKey] = not Settings[SettingKey]
		local State = Settings[SettingKey]
		Btn.Text = "  " .. Text .. "  ➔  " .. (State and "ON" or "OFF")
		TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = State and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(25, 30, 45)}):Play()
		SaveSettings()
		if Callback then Callback(State) end
	end)
	return Btn
end

CreateToggle(MainTab, "ESP Tracker", "ESPEnabled", function(val)
	for _, Info in pairs(EggESP) do Info.gui.Enabled = val end
end)
CreateToggle(MainTab, "Radar Display", "RadarEnabled")
CreateToggle(MainTab, "Auto Claim & Grid Place", "AutoClaimEnabled")
CreateToggle(MainTab, "Fly Mode", "FlyEnabled", function(val)
	if val then StartFly() else StopFly() end
end)

local BaseBtn = Instance.new("TextButton")
BaseBtn.Size = UDim2.new(1, 0, 0, 40)
BaseBtn.BackgroundColor3 = Color3.fromRGB(140, 40, 255)
BaseBtn.Text = "🏠 Teleport To Baseplate Spot"
BaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BaseBtn.TextSize = 11
BaseBtn.Font = Enum.Font.GothamBold
BaseBtn.Parent = MainTab
Instance.new("UICorner", BaseBtn).CornerRadius = UDim.new(0, 8)
CreateClickBounce(BaseBtn)
BaseBtn.MouseButton1Click:Connect(TeleportToBase)

local StatusCard = Instance.new("Frame")
StatusCard.Size = UDim2.new(1, 0, 0, 95)
StatusCard.BackgroundColor3 = Color3.fromRGB(20, 25, 38)
StatusCard.Parent = MainTab
Instance.new("UICorner", StatusCard).CornerRadius = UDim.new(0, 10)

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -20, 1, -16)
StatusText.Position = UDim2.fromOffset(10, 8)
StatusText.BackgroundTransparency = 1
StatusText.TextColor3 = Color3.fromRGB(230, 235, 245)
StatusText.TextSize = 11
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextWrapped = true
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.TextYAlignment = Enum.TextYAlignment.Top
StatusText.Text = "🧭 RADAR & STATUS\nScanning for nearby eggs..."
StatusText.Parent = StatusCard

--==================================================
-- EGG ALERTS TAB (NEW FEATURE)
--==================================================

CreateToggle(AlertsTab, "Notification Sound Enabled", "AlertSoundEnabled")

local AlertBulkFrame = Instance.new("Frame")
AlertBulkFrame.Size = UDim2.new(1, 0, 0, 32)
AlertBulkFrame.BackgroundTransparency = 1
AlertBulkFrame.Parent = AlertsTab

local AlertSelectAll = Instance.new("TextButton")
AlertSelectAll.Size = UDim2.new(0.5, -4, 1, 0)
AlertSelectAll.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
AlertSelectAll.Text = "✓ ALL ALERTS"
AlertSelectAll.TextColor3 = Color3.fromRGB(255, 255, 255)
AlertSelectAll.TextSize = 10
AlertSelectAll.Font = Enum.Font.GothamBold
AlertSelectAll.Parent = AlertBulkFrame
Instance.new("UICorner", AlertSelectAll).CornerRadius = UDim.new(0, 8)

local AlertDeselectAll = Instance.new("TextButton")
AlertDeselectAll.Position = UDim2.new(0.5, 4, 0, 0)
AlertDeselectAll.Size = UDim2.new(0.5, -4, 1, 0)
AlertDeselectAll.BackgroundColor3 = Color3.fromRGB(180, 40, 60)
AlertDeselectAll.Text = "✕ NO ALERTS"
AlertDeselectAll.TextColor3 = Color3.fromRGB(255, 255, 255)
AlertDeselectAll.TextSize = 10
AlertDeselectAll.Font = Enum.Font.GothamBold
AlertDeselectAll.Parent = AlertBulkFrame
Instance.new("UICorner", AlertDeselectAll).CornerRadius = UDim.new(0, 8)

local AlertScroll = Instance.new("ScrollingFrame")
AlertScroll.Position = UDim2.fromOffset(0, 80)
AlertScroll.Size = UDim2.new(1, 0, 1, -80)
AlertScroll.BackgroundTransparency = 1
AlertScroll.BorderSizePixel = 0
AlertScroll.ScrollBarThickness = 4
AlertScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 70, 95)
AlertScroll.Parent = AlertsTab

local AlertLayout = Instance.new("UIListLayout")
AlertLayout.Padding = UDim.new(0, 6)
AlertLayout.Parent = AlertScroll

local SortedEggList = {}
for EggName, Data in pairs(Eggs) do table.insert(SortedEggList, {name = EggName, luck = Data.luck, rarity = Data.rarity}) end
table.sort(SortedEggList, function(a, b) return a.luck < b.luck end)

local function RefreshAlertButton(Btn, Name, Rarity)
	local Active = Settings.AlertEggs[Name]
	TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Active and Color3.fromRGB(120, 30, 180) or Color3.fromRGB(22, 26, 40)}):Play()
	Btn.Text = "  " .. (Active and "🚨 ALERT: ON  " or "🔕 OFF  ") .. Name .. " [" .. Rarity .. "]"
end

for i, EggData in ipairs(SortedEggList) do
	local Name = EggData.name
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, -8, 0, 34)
	Btn.TextColor3 = RarityColors[EggData.rarity] or Color3.fromRGB(255, 255, 255)
	Btn.TextSize = 11
	Btn.Font = Enum.Font.GothamSemibold
	Btn.TextXAlignment = Enum.TextXAlignment.Left
	Btn.Parent = AlertScroll
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

	AlertButtons[Name] = Btn
	RefreshAlertButton(Btn, Name, EggData.rarity)

	Btn.MouseButton1Click:Connect(function()
		Settings.AlertEggs[Name] = not Settings.AlertEggs[Name]
		RefreshAlertButton(Btn, Name, EggData.rarity)
		SaveSettings()
	end)
end
AlertScroll.CanvasSize = UDim2.new(0, 0, 0, #SortedEggList * 40)

AlertSelectAll.MouseButton1Click:Connect(function()
	for EggName, _ in pairs(Eggs) do
		Settings.AlertEggs[EggName] = true
		if AlertButtons[EggName] then RefreshAlertButton(AlertButtons[EggName], EggName, Eggs[EggName].rarity) end
	end
	SaveSettings()
end)

AlertDeselectAll.MouseButton1Click:Connect(function()
	for EggName, _ in pairs(Eggs) do
		Settings.AlertEggs[EggName] = false
		if AlertButtons[EggName] then RefreshAlertButton(AlertButtons[EggName], EggName, Eggs[EggName].rarity) end
	end
	SaveSettings()
end)

--==================================================
-- EGG AUTO FILTER TAB
--==================================================

local FilterBulkFrame = Instance.new("Frame")
FilterBulkFrame.Size = UDim2.new(1, 0, 0, 32)
FilterBulkFrame.BackgroundTransparency = 1
FilterBulkFrame.Parent = FilterTab

local SelectAllBtn = Instance.new("TextButton")
SelectAllBtn.Size = UDim2.new(0.5, -4, 1, 0)
SelectAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
SelectAllBtn.Text = "✓ ENABLE ALL"
SelectAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectAllBtn.TextSize = 10
SelectAllBtn.Font = Enum.Font.GothamBold
SelectAllBtn.Parent = FilterBulkFrame
Instance.new("UICorner", SelectAllBtn).CornerRadius = UDim.new(0, 8)

local DeselectAllBtn = Instance.new("TextButton")
DeselectAllBtn.Position = UDim2.new(0.5, 4, 0, 0)
DeselectAllBtn.Size = UDim2.new(0.5, -4, 1, 0)
DeselectAllBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 60)
DeselectAllBtn.Text = "✕ DISABLE ALL"
DeselectAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DeselectAllBtn.TextSize = 10
DeselectAllBtn.Font = Enum.Font.GothamBold
DeselectAllBtn.Parent = FilterBulkFrame
Instance.new("UICorner", DeselectAllBtn).CornerRadius = UDim.new(0, 8)

local FilterScroll = Instance.new("ScrollingFrame")
FilterScroll.Position = UDim2.fromOffset(0, 40)
FilterScroll.Size = UDim2.new(1, 0, 1, -40)
FilterScroll.BackgroundTransparency = 1
FilterScroll.BorderSizePixel = 0
FilterScroll.ScrollBarThickness = 4
FilterScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 70, 95)
FilterScroll.Parent = FilterTab

local FilterLayout = Instance.new("UIListLayout")
FilterLayout.Padding = UDim.new(0, 6)
FilterLayout.Parent = FilterScroll

local function RefreshFilterButton(Btn, Name, Rarity)
	local Active = Settings.AllowedEggs[Name]
	TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Active and Color3.fromRGB(0, 100, 60) or Color3.fromRGB(22, 26, 40)}):Play()
	Btn.Text = "  " .. (Active and "✓ " or "✕ ") .. Name .. " [" .. Rarity .. "]"
end

for i, EggData in ipairs(SortedEggList) do
	local Name = EggData.name
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, -8, 0, 34)
	Btn.TextColor3 = RarityColors[EggData.rarity] or Color3.fromRGB(255, 255, 255)
	Btn.TextSize = 11
	Btn.Font = Enum.Font.GothamSemibold
	Btn.TextXAlignment = Enum.TextXAlignment.Left
	Btn.Parent = FilterScroll
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

	FilterButtons[Name] = Btn
	RefreshFilterButton(Btn, Name, EggData.rarity)

	Btn.MouseButton1Click:Connect(function()
		Settings.AllowedEggs[Name] = not Settings.AllowedEggs[Name]
		RefreshFilterButton(Btn, Name, EggData.rarity)
		SaveSettings()
	end)
end
FilterScroll.CanvasSize = UDim2.new(0, 0, 0, #SortedEggList * 40)

SelectAllBtn.MouseButton1Click:Connect(function()
	for EggName, _ in pairs(Eggs) do
		Settings.AllowedEggs[EggName] = true
		if FilterButtons[EggName] then RefreshFilterButton(FilterButtons[EggName], EggName, Eggs[EggName].rarity) end
	end
	SaveSettings()
end)

DeselectAllBtn.MouseButton1Click:Connect(function()
	for EggName, _ in pairs(Eggs) do
		Settings.AllowedEggs[EggName] = false
		if FilterButtons[EggName] then RefreshFilterButton(FilterButtons[EggName], EggName, Eggs[EggName].rarity) end
	end
	SaveSettings()
end)

--==================================================
-- SETTINGS & SERVER TAB
--==================================================

local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Padding = UDim.new(0, 8)
SettingsLayout.Parent = SettingsTab

local ServerHeader = Instance.new("TextLabel")
ServerHeader.Size = UDim2.new(1, 0, 0, 18)
ServerHeader.BackgroundTransparency = 1
ServerHeader.Text = "🌐 SERVER MANAGEMENT (AUTO RE-EXECUTE)"
ServerHeader.TextColor3 = Color3.fromRGB(180, 190, 210)
ServerHeader.TextSize = 10
ServerHeader.Font = Enum.Font.GothamBold
ServerHeader.TextXAlignment = Enum.TextXAlignment.Left
ServerHeader.Parent = SettingsTab

local HopBtn = Instance.new("TextButton")
HopBtn.Size = UDim2.new(1, 0, 0, 38)
HopBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
HopBtn.Text = "🚀 Server Hop (Low Players)"
HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBtn.TextSize = 11
HopBtn.Font = Enum.Font.GothamBold
HopBtn.Parent = SettingsTab
Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0, 8)
CreateClickBounce(HopBtn)
HopBtn.MouseButton1Click:Connect(ServerHopLowPlayers)

local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Size = UDim2.new(1, 0, 0, 38)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(190, 80, 0)
RejoinBtn.Text = "🔄 Rejoin Same Server"
RejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinBtn.TextSize = 11
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.Parent = SettingsTab
Instance.new("UICorner", RejoinBtn).CornerRadius = UDim.new(0, 8)
CreateClickBounce(RejoinBtn)
RejoinBtn.MouseButton1Click:Connect(RejoinCurrentServer)

local ThemeHeader = Instance.new("TextLabel")
ThemeHeader.Size = UDim2.new(1, 0, 0, 22)
ThemeHeader.BackgroundTransparency = 1
ThemeHeader.Text = "🎨 THEME SWITCHER"
ThemeHeader.TextColor3 = Color3.fromRGB(180, 190, 210)
ThemeHeader.TextSize = 10
ThemeHeader.Font = Enum.Font.GothamBold
ThemeHeader.TextXAlignment = Enum.TextXAlignment.Left
ThemeHeader.Parent = SettingsTab

for ThemeName, _ in pairs(Themes) do
	local ThemeBtn = Instance.new("TextButton")
	ThemeBtn.Size = UDim2.new(1, 0, 0, 32)
	ThemeBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
	ThemeBtn.Text = "  🎨 " .. ThemeName
	ThemeBtn.TextColor3 = Color3.fromRGB(220, 225, 240)
	ThemeBtn.TextSize = 11
	ThemeBtn.Font = Enum.Font.GothamSemibold
	ThemeBtn.TextXAlignment = Enum.TextXAlignment.Left
	ThemeBtn.Parent = SettingsTab
	Instance.new("UICorner", ThemeBtn).CornerRadius = UDim.new(0, 8)
	CreateClickBounce(ThemeBtn)

	ThemeBtn.MouseButton1Click:Connect(function() ApplyTheme(ThemeName) end)
end

--==================================================
-- TELEPORT TAB
--==================================================

local TPScroll = Instance.new("ScrollingFrame")
TPScroll.Size = UDim2.new(1, 0, 1, 0)
TPScroll.BackgroundTransparency = 1
TPScroll.BorderSizePixel = 0
TPScroll.ScrollBarThickness = 4
TPScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 70, 95)
TPScroll.Parent = TeleportTab

local TPLayout = Instance.new("UIListLayout")
TPLayout.Padding = UDim.new(0, 6)
TPLayout.Parent = TPScroll

local function UpdateTPList()
	if not NeedsTPListUpdate then return end
	NeedsTPListUpdate = false

	for _, Child in ipairs(TPScroll:GetChildren()) do
		if Child:IsA("TextButton") then Child:Destroy() end
	end

	local SortedEggs = {}
	for Egg, _ in pairs(EggESP) do
		if Egg and Egg.Parent and IsEgg(Egg) then
			local Data = Eggs[Egg.Name]
			table.insert(SortedEggs, { Object = Egg, Name = Egg.Name, Luck = Data and Data.luck or 0, Rarity = Data and Data.rarity or "Common" })
		end
	end
	table.sort(SortedEggs, function(a, b) return a.Luck > b.Luck end)

	for i, EggData in ipairs(SortedEggs) do
		local Item = Instance.new("TextButton")
		Item.Size = UDim2.new(1, -8, 0, 34)
		Item.BackgroundColor3 = Color3.fromRGB(22, 26, 40)
		Item.Text = "  🚀 Teleport To " .. EggData.Name .. " [" .. EggData.Rarity .. "]"
		Item.TextColor3 = RarityColors[EggData.Rarity] or Color3.new(1, 1, 1)
		Item.TextSize = 11
		Item.Font = Enum.Font.GothamSemibold
		Item.TextXAlignment = Enum.TextXAlignment.Left
		Item.Parent = TPScroll
		Instance.new("UICorner", Item).CornerRadius = UDim.new(0, 8)
		CreateClickBounce(Item)

		local EggObj = EggData.Object
		Item.MouseButton1Click:Connect(function()
			if EggObj and EggObj.Parent then
				local Pos = GetObjectPosition(EggObj)
				if Pos then TeleportTo(Pos) end
			end
		end)
	end
	TPScroll.CanvasSize = UDim2.new(0, 0, 0, #SortedEggs * 40)
end

--==================================================
-- WINDOW CONTROLS & DRAGGING
--==================================================

local Reopen = Instance.new("TextButton")
Reopen.Size = UDim2.fromOffset(56, 56)
Reopen.Position = UDim2.new(0, 20, 0.5, -28)
Reopen.BackgroundColor3 = Color3.fromRGB(18, 22, 34)
Reopen.Text = "💎"
Reopen.TextSize = 24
Reopen.Visible = false
Reopen.Parent = GUI
Instance.new("UICorner", Reopen).CornerRadius = UDim.new(1, 0)
CreateClickBounce(Reopen)

local Minimized = false

Minimize.MouseButton1Click:Connect(function()
	Minimized = not Minimized
	Sidebar.Visible = not Minimized
	Container.Visible = not Minimized
	local GoalSize = Minimized and UDim2.fromOffset(680, 52) or UDim2.fromOffset(680, 490)
	TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = GoalSize}):Play()
	Minimize.Text = Minimized and "+" or "−"
end)

Close.MouseButton1Click:Connect(function()
	TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0, 0)}):Play()
	task.wait(0.3)
	Main.Visible = false
	Main.Size = UDim2.fromOffset(680, 490)
	Reopen.Visible = true
	Reopen.Size = UDim2.fromOffset(0, 0)
	TweenService:Create(Reopen, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(56, 56)}):Play()
end)

Reopen.MouseButton1Click:Connect(function()
	TweenService:Create(Reopen, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0, 0)}):Play()
	task.wait(0.2)
	Reopen.Visible = false
	Main.Visible = true
	Main.Size = UDim2.fromOffset(0, 0)
	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(680, 490)}):Play()
end)

local Dragging, DragStart, StartPos
Topbar.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = true
		DragStart = Input.Position
		StartPos = Main.Position
	end
end)
UserInputService.InputChanged:Connect(function(Input)
	if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
		local Delta = Input.Position - DragStart
		Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
	end
end)
UserInputService.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
end)

--==================================================
-- AUTO CLAIM LOOP & FLY LOOPS
--==================================================

local function ClaimEgg(Egg)
	if not Egg or not Egg.Parent then return end
	local Prompt = Egg:FindFirstChildWhichIsA("ProximityPrompt", true)
	if Prompt then fireproximityprompt(Prompt) end
end

task.spawn(function()
	while true do
		task.wait(0.25)
		if Settings.AutoClaimEnabled then
			local Root = GetRoot()
			if Root then
				local NearestEgg = nil
				local NearestDist = math.huge

				for Egg, _ in pairs(EggESP) do
					if Egg and Egg.Parent and IsEgg(Egg) and Settings.AllowedEggs[Egg.Name] then
						local Pos = GetObjectPosition(Egg)
						if Pos then
							local Dist = (Root.Position - Pos).Magnitude
							if Dist < NearestDist then
								NearestDist = Dist
								NearestEgg = Egg
							end
						end
					end
				end

				if NearestEgg then
					local TargetPos = GetObjectPosition(NearestEgg)
					if TargetPos then
						TeleportTo(TargetPos)
						task.wait(0.15)
						ClaimEgg(NearestEgg)
						task.wait(0.15)

						local GridSpot = GetNextBaseplateSpot()
						if GridSpot then
							TeleportTo(GridSpot)
							task.wait(0.3)
						else
							PressKey2()
							task.wait(0.1)
							PressKey2()
							task.wait(0.3)
						end
					end
				end
			end
		end
	end
end)

local FlyVelocity

function StartFly()
	local Root = GetRoot()
	if not Root then return end
	if FlyVelocity then FlyVelocity:Destroy() end
	FlyVelocity = Instance.new("BodyVelocity")
	FlyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	FlyVelocity.Velocity = Vector3.zero
	FlyVelocity.Parent = Root
end

function StopFly()
	if FlyVelocity then FlyVelocity:Destroy(); FlyVelocity = nil end
end

--==================================================
-- RENDER & HEARTBEAT LOOPS
--==================================================

ApplyTheme(Settings.CurrentTheme or "Midnight Blue")
ScanEggs()

local ScanTimer = 0
RunService.Heartbeat:Connect(function(DeltaTime)
	local Hum = GetHumanoid()
	if Hum and not Settings.FlyEnabled then Hum.WalkSpeed = Settings.WalkSpeed end

	ScanTimer += DeltaTime
	if ScanTimer >= 0.5 then
		ScanTimer = 0
		ScanEggs()
		UpdateTPList()
	end
end)

RunService.RenderStepped:Connect(function()
	local Root = GetRoot()
	if not Root then return end

	local NearestEgg, NearestName
	local NearestDistance = math.huge

	for Egg, Info in pairs(EggESP) do
		if not Egg.Parent or not IsEgg(Egg) then
			RemoveESP(Egg)
		else
			Info.gui.Enabled = Settings.ESPEnabled
			local Position = GetObjectPosition(Egg)
			if Position then
				local Distance = (Root.Position - Position).Magnitude
				local Data = Eggs[Egg.Name]
				Info.text.Text = "🥚 " .. Egg.Name .. "\n" .. Data.rarity .. " • " .. FormatNumber(Data.luck) .. "\n" .. math.floor(Distance) .. " studs"

				if Distance < NearestDistance then
					NearestDistance = Distance
					NearestEgg = Egg
					NearestName = Egg.Name
				end
			end
		end
	end

	if Settings.RadarEnabled and NearestEgg then
		local Data = Eggs[NearestName]
		local ActiveStatus = Settings.AllowedEggs[NearestName] and " [Claim: ENABLED]" or " [Claim: IGNORED]"
		StatusText.Text = "🧭 NEAREST EGG\n🥚 " .. NearestName .. ActiveStatus .. "\n⭐ " .. Data.rarity .. " • Luck: " .. FormatNumber(Data.luck) .. "\n📏 " .. math.floor(NearestDistance) .. " studs"
		StatusText.TextColor3 = RarityColors[Data.rarity] or Color3.new(1, 1, 1)
	elseif Settings.RadarEnabled then
		StatusText.Text = "🧭 NEAREST EGG\nNo active eggs found."
		StatusText.TextColor3 = Color3.fromRGB(150, 160, 180)
	else
		StatusText.Text = "🧭 RADAR OFF"
		StatusText.TextColor3 = Color3.fromRGB(100, 110, 130)
	end
end)

RunService.RenderStepped:Connect(function()
	if not Settings.FlyEnabled then return end
	local Root = GetRoot()
	if not Root then return end
	if not FlyVelocity then StartFly() end
	if not FlyVelocity then return end

	local Camera = workspace.CurrentCamera
	local Direction = Vector3.zero

	if UserInputService:IsKeyDown(Enum.KeyCode.W) then Direction += Camera.CFrame.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then Direction -= Camera.CFrame.LookVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then Direction -= Camera.CFrame.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then Direction += Camera.CFrame.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Direction += Vector3.new(0, 1, 0) end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Direction -= Vector3.new(0, 1, 0) end

	if Direction.Magnitude > 0 then Direction = Direction.Unit end
	FlyVelocity.Velocity = Direction * Settings.FlySpeed
end)

Player.CharacterAdded:Connect(function()
	task.wait(1)
	if Settings.FlyEnabled then StartFly() end
end)

print("Ride A Pet Ultra Hub V8 Loaded Successfully!")
