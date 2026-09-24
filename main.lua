--[[
	RIDE A PET - ULTRA HUB V9 (CLEAN UI + REAL IMAGES + BUGFIXES)
	Fixes: Scrolling Frame, Auto TP on Claim, Image Icons, Customization
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

local ScriptLoadstring = [[
	loadstring(game:HttpGet("https://raw.githubusercontent.com/bananielheinrich-spec/Roblox-Scripts/refs/heads/main/main.lua"))()
]]

--==================================================
-- THEMES & ICONS DATABASE
--==================================================

local Icons = {
	Dashboard = "rbxassetid://10723415903",
	Filter    = "rbxassetid://10723376114",
	Teleport  = "rbxassetid://10723345431",
	Settings  = "rbxassetid://10723343321",
	Home      = "rbxassetid://10734934585",
	Check     = "rbxassetid://10709790637",
	Cross     = "rbxassetid://10709790298",
	Speed     = "rbxassetid://10747373158",
	Fly       = "rbxassetid://10723434557",
	Theme     = "rbxassetid://10734940880",
	Radar     = "rbxassetid://10734933966"
}

local Themes = {
	["Midnight Blue"] = {
		MainBg = Color3.fromRGB(12, 14, 22),
		SidebarBg = Color3.fromRGB(16, 19, 30),
		TopbarBg = Color3.fromRGB(20, 24, 38),
		Accent = Color3.fromRGB(0, 140, 255),
		CardBg = Color3.fromRGB(24, 29, 44),
		Stroke = Color3.fromRGB(0, 180, 255)
	},
	["Cyberpunk Purple"] = {
		MainBg = Color3.fromRGB(16, 10, 25),
		SidebarBg = Color3.fromRGB(22, 12, 35),
		TopbarBg = Color3.fromRGB(30, 15, 48),
		Accent = Color3.fromRGB(180, 0, 255),
		CardBg = Color3.fromRGB(35, 20, 55),
		Stroke = Color3.fromRGB(220, 0, 255)
	},
	["Emerald Green"] = {
		MainBg = Color3.fromRGB(10, 20, 15),
		SidebarBg = Color3.fromRGB(12, 28, 20),
		TopbarBg = Color3.fromRGB(15, 36, 25),
		Accent = Color3.fromRGB(0, 200, 120),
		CardBg = Color3.fromRGB(20, 42, 30),
		Stroke = Color3.fromRGB(0, 255, 150)
	},
	["Dark Minimal"] = {
		MainBg = Color3.fromRGB(14, 14, 14),
		SidebarBg = Color3.fromRGB(20, 20, 20),
		TopbarBg = Color3.fromRGB(26, 26, 26),
		Accent = Color3.fromRGB(180, 180, 180),
		CardBg = Color3.fromRGB(35, 35, 35),
		Stroke = Color3.fromRGB(100, 100, 100)
	}
}

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
-- SETTINGS MANAGEMENT
--==================================================

local SettingsFile = "RideAPet_HubSettings_V9.json"

local Settings = {
	ESPEnabled = true,
	ESPTracers = false,
	ESPRange = 800,
	RadarEnabled = true,
	FlyEnabled = false,
	AutoClaimEnabled = false,
	AutoTPToBase = false,
	WalkSpeed = 16,
	FlySpeed = 60,
	UITransparency = 0,
	CurrentTheme = "Midnight Blue",
	AllowedEggs = {}
}

local GridSpacing = 6
local MaxColumns = 5

for EggName, _ in pairs(Eggs) do Settings.AllowedEggs[EggName] = true end

local function SaveSettings()
	if writefile then pcall(function() writefile(SettingsFile, HttpService:JSONEncode(Settings)) end) end
end

local function LoadSettings()
	if readfile and isfile and isfile(SettingsFile) then
		pcall(function()
			local Loaded = HttpService:JSONDecode(readfile(SettingsFile))
			if type(Loaded) == "table" then
				for k, v in pairs(Loaded) do
					if k == "AllowedEggs" and type(v) == "table" then
						for egg, val in pairs(v) do Settings.AllowedEggs[egg] = val end
					else
						Settings[k] = v
					end
				end
			end
		end)
	end
end

LoadSettings()

local EggESP = {}
local NeedsTPListUpdate = false
local FilterButtons = {}
local UI_Toggles = {}
local UI_SliderFills = {}
local UI_FramesToTransparent = {}

--==================================================
-- SCROLLING FRAME FIX HELPER
--==================================================

local function BindAutoScroll(ScrollingFrame, UIListLayout)
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
	UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
	end)
end

--==================================================
-- HELPER FUNCTIONS
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
-- ESP SYSTEM
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
	Billboard.MaxDistance = Settings.ESPRange
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

workspace.DescendantAdded:Connect(function(Object)
	if IsEgg(Object) then task.spawn(function() CreateESP(Object) end) end
end)
workspace.DescendantRemoving:Connect(function(Object)
	if EggESP[Object] then RemoveESP(Object) end
end)

--==================================================
-- MAIN UI CONSTRUCTION
--==================================================

local GUI = Instance.new("ScreenGui")
GUI.Name = "RideAPetUltraV9"
GUI.ResetOnSpawn = false
GUI.Parent = Player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(660, 480)
Main.Position = UDim2.new(0.5, -330, 0.5, -240)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = GUI
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
table.insert(UI_FramesToTransparent, Main)

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Parent = Main

local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 50)
Topbar.BorderSizePixel = 0
Topbar.Parent = Main
table.insert(UI_FramesToTransparent, Topbar)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.fromOffset(20, 0)
Title.BackgroundTransparency = 1
Title.Text = "RIDE A PET • ULTRA HUB V9"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(32, 32)
Minimize.Position = UDim2.new(1, -74, 0, 9)
Minimize.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
Minimize.Text = "−"
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = Topbar
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0, 8)

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(32, 32)
Close.Position = UDim2.new(1, -38, 0, 9)
Close.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 18
Close.Font = Enum.Font.GothamBold
Close.Parent = Topbar
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

local Sidebar = Instance.new("Frame")
Sidebar.Position = UDim2.fromOffset(0, 50)
Sidebar.Size = UDim2.new(0, 175, 1, -50)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
table.insert(UI_FramesToTransparent, Sidebar)

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 8)
SidebarList.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 12)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

local Container = Instance.new("Frame")
Container.Position = UDim2.fromOffset(175, 50)
Container.Size = UDim2.new(1, -175, 1, -50)
Container.BackgroundTransparency = 1
Container.Parent = Main

local ActiveTabBtn = nil
local Pages = {}

local function ApplyTheme(ThemeName)
	local Theme = Themes[ThemeName] or Themes["Midnight Blue"]
	Settings.CurrentTheme = ThemeName
	SaveSettings()

	local Trans = Settings.UITransparency / 100

	TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundColor3 = Theme.MainBg, BackgroundTransparency = Trans}):Play()
	TweenService:Create(Sidebar, TweenInfo.new(0.3), {BackgroundColor3 = Theme.SidebarBg, BackgroundTransparency = Trans}):Play()
	TweenService:Create(Topbar, TweenInfo.new(0.3), {BackgroundColor3 = Theme.TopbarBg, BackgroundTransparency = Trans}):Play()
	TweenService:Create(MainStroke, TweenInfo.new(0.3), {Color = Theme.Stroke}):Play()

	for Name, p in pairs(Pages) do
		if p.btn == ActiveTabBtn then
			TweenService:Create(p.btn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Accent, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		else
			TweenService:Create(p.btn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.CardBg, TextColor3 = Color3.fromRGB(170, 180, 200)}):Play()
		end
	end

	for _, toggle in pairs(UI_Toggles) do
		local IsOn = Settings[toggle.Key]
		TweenService:Create(toggle.Btn, TweenInfo.new(0.3), {BackgroundColor3 = IsOn and Theme.Accent or Theme.CardBg}):Play()
	end

	for _, fill in pairs(UI_SliderFills) do
		fill.BackgroundColor3 = Theme.Accent
	end
end

local function CreateTab(Name, IconAsset)
	local TabBtn = Instance.new("TextButton")
	TabBtn.Size = UDim2.new(1, 0, 0, 40)
	TabBtn.Text = "       " .. Name
	TabBtn.TextSize = 12
	TabBtn.Font = Enum.Font.GothamSemibold
	TabBtn.TextXAlignment = Enum.TextXAlignment.Left
	TabBtn.Parent = Sidebar
	Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

	local IconImg = Instance.new("ImageLabel")
	IconImg.Size = UDim2.fromOffset(20, 20)
	IconImg.Position = UDim2.fromOffset(10, 10)
	IconImg.BackgroundTransparency = 1
	IconImg.Image = IconAsset
	IconImg.Parent = TabBtn

	local Page = Instance.new("ScrollingFrame")
	Page.Size = UDim2.new(1, -24, 1, -24)
	Page.Position = UDim2.fromOffset(12, 12)
	Page.BackgroundTransparency = 1
	Page.BorderSizePixel = 0
	Page.ScrollBarThickness = 5
	Page.ScrollBarImageColor3 = Color3.fromRGB(80, 90, 120)
	Page.Active = true
	Page.Visible = false
	Page.Parent = Container

	local PageLayout = Instance.new("UIListLayout")
	PageLayout.Padding = UDim.new(0, 8)
	PageLayout.Parent = Page

	-- Fix Scrolling dynamically!
	BindAutoScroll(Page, PageLayout)

	Pages[Name] = {btn = TabBtn, page = Page, layout = PageLayout}

	TabBtn.MouseButton1Click:Connect(function()
		ActiveTabBtn = TabBtn
		ApplyTheme(Settings.CurrentTheme)
		for _, p in pairs(Pages) do p.page.Visible = false end
		Page.Visible = true
	end)

	return Page
end

local MainTab = CreateTab("Dashboard", Icons.Dashboard)
local FilterTab = CreateTab("Egg Filter", Icons.Filter)
local TeleportTab = CreateTab("Teleports", Icons.Teleport)
local SettingsTab = CreateTab("Settings", Icons.Settings)

ActiveTabBtn = Pages["Dashboard"].btn
Pages["Dashboard"].page.Visible = true

--==================================================
-- DASHBOARD BUILDER
--==================================================

local function CreateToggle(Parent, Text, SettingKey, Callback)
	local DefaultState = Settings[SettingKey]
	local Theme = Themes[Settings.CurrentTheme] or Themes["Midnight Blue"]

	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, -8, 0, 38)
	Btn.BackgroundColor3 = DefaultState and Theme.Accent or Theme.CardBg
	Btn.Text = "  " .. Text .. "  ➔  " .. (DefaultState and "ON" or "OFF")
	Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Btn.TextSize = 12
	Btn.Font = Enum.Font.GothamBold
	Btn.TextXAlignment = Enum.TextXAlignment.Left
	Btn.Parent = Parent
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

	table.insert(UI_Toggles, {Btn = Btn, Key = SettingKey})

	Btn.MouseButton1Click:Connect(function()
		Settings[SettingKey] = not Settings[SettingKey]
		local State = Settings[SettingKey]
		Btn.Text = "  " .. Text .. "  ➔  " .. (State and "ON" or "OFF")
		local CurTheme = Themes[Settings.CurrentTheme] or Themes["Midnight Blue"]
		TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = State and CurTheme.Accent or CurTheme.CardBg}):Play()
		SaveSettings()
		if Callback then Callback(State) end
	end)
	return Btn
end

local function CreateSlider(Parent, Text, SettingKey, Min, Max, Callback)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -8, 0, 48)
	Frame.BackgroundColor3 = Color3.fromRGB(24, 29, 44)
	Frame.Parent = Parent
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -20, 0, 20)
	Label.Position = UDim2.fromOffset(10, 6)
	Label.BackgroundTransparency = 1
	Label.Text = Text .. " : " .. tostring(Settings[SettingKey])
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextSize = 11
	Label.Font = Enum.Font.GothamBold
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	local SliderBg = Instance.new("Frame")
	SliderBg.Size = UDim2.new(1, -20, 0, 6)
	SliderBg.Position = UDim2.fromOffset(10, 32)
	SliderBg.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
	SliderBg.Parent = Frame
	Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

	local Fill = Instance.new("Frame")
	Fill.Size = UDim2.fromScale(math.clamp((Settings[SettingKey] - Min) / (Max - Min), 0, 1), 1)
	Fill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
	Fill.Parent = SliderBg
	Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
	table.insert(UI_SliderFills, Fill)

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.fromScale(1, 1)
	Button.BackgroundTransparency = 1
	Button.Text = ""
	Button.Parent = SliderBg

	local Dragging = false
	local function Update(Input)
		local Pct = math.clamp((Input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
		Fill.Size = UDim2.fromScale(Pct, 1)
		local Value = math.floor(Min + (Max - Min) * Pct)
		Settings[SettingKey] = Value
		Label.Text = Text .. " : " .. tostring(Value)
		SaveSettings()
		if Callback then Callback(Value) end
	end

	Button.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = true
			Update(Input)
		end
	end)
	UserInputService.InputChanged:Connect(function(Input)
		if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then Update(Input) end
	end)
	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
	end)
end

-- Toggles & Sliders
CreateToggle(MainTab, "ESP Tracker", "ESPEnabled", function(val)
	for _, Info in pairs(EggESP) do Info.gui.Enabled = val end
end)
CreateToggle(MainTab, "Radar Display", "RadarEnabled", function(val) end)
CreateToggle(MainTab, "Auto Claim & Grid Place", "AutoClaimEnabled", function(val) end)
CreateToggle(MainTab, "Auto TP zur Base (Nach Claim)", "AutoTPToBase", function(val) end)
CreateToggle(MainTab, "Fly Mode", "FlyEnabled", function(val)
	if val then StartFly() else StopFly() end
end)

CreateSlider(MainTab, "Walk Speed", "WalkSpeed", 16, 250, function(val)
	local Hum = GetHumanoid()
	if Hum and not Settings.FlyEnabled then Hum.WalkSpeed = val end
end)
CreateSlider(MainTab, "Fly Speed", "FlySpeed", 20, 300, function(val) end)

local BaseBtn = Instance.new("TextButton")
BaseBtn.Size = UDim2.new(1, -8, 0, 38)
BaseBtn.BackgroundColor3 = Color3.fromRGB(130, 40, 240)
BaseBtn.Text = "  Teleport To Baseplate Spot"
BaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BaseBtn.TextSize = 12
BaseBtn.Font = Enum.Font.GothamBold
BaseBtn.Parent = MainTab
Instance.new("UICorner", BaseBtn).CornerRadius = UDim.new(0, 8)
BaseBtn.MouseButton1Click:Connect(TeleportToBase)

local StatusCard = Instance.new("Frame")
StatusCard.Size = UDim2.new(1, -8, 0, 85)
StatusCard.BackgroundColor3 = Color3.fromRGB(18, 22, 34)
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
StatusText.Text = "RADAR STATUS\nScanning nearby area..."
StatusText.Parent = StatusCard

--==================================================
-- CUSTOMIZATION & SETTINGS TAB
--==================================================

CreateSlider(SettingsTab, "UI Transparenz", "UITransparency", 0, 80, function(val)
	ApplyTheme(Settings.CurrentTheme)
end)

CreateSlider(SettingsTab, "ESP Distanz", "ESPRange", 100, 2000, function(val)
	for _, Info in pairs(EggESP) do Info.gui.MaxDistance = val end
end)

local HopBtn = Instance.new("TextButton")
HopBtn.Size = UDim2.new(1, -8, 0, 38)
HopBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
HopBtn.Text = "Server Hop (Low Players)"
HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBtn.TextSize = 12
HopBtn.Font = Enum.Font.GothamBold
HopBtn.Parent = SettingsTab
Instance.new("UICorner", HopBtn).CornerRadius = UDim.new(0, 8)

HopBtn.MouseButton1Click:Connect(function()
	local ApiUrl = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
	local Success, Response = pcall(function() return HttpService:JSONDecode(game:HttpGet(ApiUrl)) end)
	if Success and Response and Response.data then
		for _, ServerData in ipairs(Response.data) do
			if ServerData.playing < ServerData.maxPlayers and ServerData.id ~= game.JobId then
				TeleportService:TeleportToPlaceInstance(game.PlaceId, ServerData.id, Player)
				return
			end
		end
	end
	TeleportService:Teleport(game.PlaceId, Player)
end)

local ThemeHeader = Instance.new("TextLabel")
ThemeHeader.Size = UDim2.new(1, 0, 0, 25)
ThemeHeader.BackgroundTransparency = 1
ThemeHeader.Text = "THEMES"
ThemeHeader.TextColor3 = Color3.fromRGB(180, 190, 210)
ThemeHeader.TextSize = 11
ThemeHeader.Font = Enum.Font.GothamBold
ThemeHeader.TextXAlignment = Enum.TextXAlignment.Left
ThemeHeader.Parent = SettingsTab

for ThemeName, _ in pairs(Themes) do
	local ThemeBtn = Instance.new("TextButton")
	ThemeBtn.Size = UDim2.new(1, -8, 0, 34)
	ThemeBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
	ThemeBtn.Text = "  " .. ThemeName
	ThemeBtn.TextColor3 = Color3.fromRGB(220, 225, 240)
	ThemeBtn.TextSize = 11
	ThemeBtn.Font = Enum.Font.GothamSemibold
	ThemeBtn.TextXAlignment = Enum.TextXAlignment.Left
	ThemeBtn.Parent = SettingsTab
	Instance.new("UICorner", ThemeBtn).CornerRadius = UDim.new(0, 8)
	ThemeBtn.MouseButton1Click:Connect(function() ApplyTheme(ThemeName) end)
end

--==================================================
-- FILTER TAB & TELEPORT TAB
--==================================================

local BulkFrame = Instance.new("Frame")
BulkFrame.Size = UDim2.new(1, -8, 0, 35)
BulkFrame.BackgroundTransparency = 1
BulkFrame.Parent = FilterTab

local SelectAllBtn = Instance.new("TextButton")
SelectAllBtn.Size = UDim2.new(0.5, -5, 1, 0)
SelectAllBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
SelectAllBtn.Text = "ENABLE ALL"
SelectAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectAllBtn.TextSize = 11
SelectAllBtn.Font = Enum.Font.GothamBold
SelectAllBtn.Parent = BulkFrame
Instance.new("UICorner", SelectAllBtn).CornerRadius = UDim.new(0, 8)

local DeselectAllBtn = Instance.new("TextButton")
DeselectAllBtn.Position = UDim2.new(0.5, 5, 0, 0)
DeselectAllBtn.Size = UDim2.new(0.5, -5, 1, 0)
DeselectAllBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 60)
DeselectAllBtn.Text = "DISABLE ALL"
DeselectAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DeselectAllBtn.TextSize = 11
DeselectAllBtn.Font = Enum.Font.GothamBold
DeselectAllBtn.Parent = BulkFrame
Instance.new("UICorner", DeselectAllBtn).CornerRadius = UDim.new(0, 8)

local SortedFilterList = {}
for EggName, Data in pairs(Eggs) do table.insert(SortedFilterList, {name = EggName, luck = Data.luck, rarity = Data.rarity}) end
table.sort(SortedFilterList, function(a, b) return a.luck < b.luck end)

local function RefreshFilterButton(Btn, Name, Rarity)
	local Active = Settings.AllowedEggs[Name]
	local CurTheme = Themes[Settings.CurrentTheme] or Themes["Midnight Blue"]
	TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Active and CurTheme.Accent or Color3.fromRGB(22, 26, 40)}):Play()
	Btn.Text = "  " .. (Active and "[✓] " or "[✕] ") .. Name .. " [" .. Rarity .. "]"
end

for i, EggData in ipairs(SortedFilterList) do
	local Name = EggData.name
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, -8, 0, 36)
	Btn.TextColor3 = RarityColors[EggData.rarity] or Color3.fromRGB(255, 255, 255)
	Btn.TextSize = 11
	Btn.Font = Enum.Font.GothamSemibold
	Btn.TextXAlignment = Enum.TextXAlignment.Left
	Btn.LayoutOrder = i
	Btn.Parent = FilterTab
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

	FilterButtons[Name] = Btn
	RefreshFilterButton(Btn, Name, EggData.rarity)

	Btn.MouseButton1Click:Connect(function()
		Settings.AllowedEggs[Name] = not Settings.AllowedEggs[Name]
		RefreshFilterButton(Btn, Name, EggData.rarity)
		SaveSettings()
	end)
end

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

local function UpdateTPList()
	if not NeedsTPListUpdate then return end
	NeedsTPListUpdate = false

	for _, Child in ipairs(TeleportTab:GetChildren()) do
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
		Item.Size = UDim2.new(1, -8, 0, 36)
		Item.BackgroundColor3 = Color3.fromRGB(22, 26, 40)
		Item.Text = "  Teleport To " .. EggData.Name .. " [" .. EggData.Rarity .. "]"
		Item.TextColor3 = RarityColors[EggData.Rarity] or Color3.new(1, 1, 1)
		Item.TextSize = 11
		Item.Font = Enum.Font.GothamSemibold
		Item.TextXAlignment = Enum.TextXAlignment.Left
		Item.LayoutOrder = i
		Item.Parent = TeleportTab
		Instance.new("UICorner", Item).CornerRadius = UDim.new(0, 8)

		local EggObj = EggData.Object
		Item.MouseButton1Click:Connect(function()
			if EggObj and EggObj.Parent then
				local Pos = GetObjectPosition(EggObj)
				if Pos then TeleportTo(Pos) end
			end
		end)
	end
end

--==================================================
-- WINDOW CONTROLS & KEYBIND TOGGLE
--==================================================

local Minimized = false

Minimize.MouseButton1Click:Connect(function()
	Minimized = not Minimized
	Sidebar.Visible = not Minimized
	Container.Visible = not Minimized
	local GoalSize = Minimized and UDim2.fromOffset(660, 50) or UDim2.fromOffset(660, 480)
	TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = GoalSize}):Play()
	Minimize.Text = Minimized and "+" or "−"
end)

Close.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
		Main.Visible = not Main.Visible
	end
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
-- FIXED AUTO CLAIM & AUTO TP SYSTEM
--==================================================

local function ClaimEgg(Egg)
	if not Egg or not Egg.Parent then return end
	local Prompt = Egg:FindFirstChildWhichIsA("ProximityPrompt", true)
	if Prompt then
		fireproximityprompt(Prompt)
	end
end

task.spawn(function()
	while true do
		task.wait(0.3)
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

				if NearestEgg and NearestEgg.Parent then
					local TargetPos = GetObjectPosition(NearestEgg)
					if TargetPos then
						-- Teleport zum Ei
						Root.CFrame = CFrame.new(TargetPos + Vector3.new(0, 2, 0))
						task.wait(0.15)
						
						-- Claimen
						ClaimEgg(NearestEgg)
						
						-- Warte bis das Ei verschwunden/geclaimt ist
						local timer = 0
						repeat
							task.wait(0.05)
							timer += 0.05
						until not NearestEgg.Parent or timer >= 0.5

						-- Teleport zurück zur Base (falls aktiviert)
						if Settings.AutoTPToBase then
							task.wait(0.1)
							TeleportToBase()
							task.wait(0.4) -- Kurze Pause an der Base
						end
					end
				end
			end
		end
	end
end)

--==================================================
-- FLY SYSTEM & RENDER LOOPS
--==================================================

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
				Info.text.Text = Egg.Name .. "\n" .. Data.rarity .. " • " .. FormatNumber(Data.luck) .. "\n" .. math.floor(Distance) .. " studs"

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
		local ActiveStatus = Settings.AllowedEggs[NearestName] and " [Claim: ON]" or " [Claim: IGNORED]"
		StatusText.Text = "NEAREST EGG\n" .. NearestName .. ActiveStatus .. "\n" .. Data.rarity .. " • Luck: " .. FormatNumber(Data.luck) .. "\n" .. math.floor(NearestDistance) .. " studs"
		StatusText.TextColor3 = RarityColors[Data.rarity] or Color3.new(1, 1, 1)
	elseif Settings.RadarEnabled then
		StatusText.Text = "NEAREST EGG\nNo active eggs nearby."
		StatusText.TextColor3 = Color3.fromRGB(150, 160, 180)
	else
		StatusText.Text = "RADAR OFF"
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

print("Ride A Pet Ultra Hub V9 Loaded Successfully!")
