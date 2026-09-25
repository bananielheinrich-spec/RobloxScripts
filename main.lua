--// RIDE A PET - ULTRA HUB V8 (MODERN UI + PERFORMANCE SETTINGS)
--// Put in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

local ScriptLoadstring = [[
	loadstring(game:HttpGet("https://raw.githubusercontent.com/bananielheinrich-spec/RobloxScripts/refs/heads/main/main.lua"))()
]]

--==================================================
-- THEMES DATABASE
--==================================================

local Themes = {
	["Midnight Blue"] = {
		MainBg = Color3.fromRGB(10, 12, 18),
		SidebarBg = Color3.fromRGB(14, 16, 24),
		TopbarBg = Color3.fromRGB(16, 19, 28),
		Accent = Color3.fromRGB(0, 140, 255),
		AccentDim = Color3.fromRGB(0, 80, 140),
		CardBg = Color3.fromRGB(20, 24, 36),
		CardHover = Color3.fromRGB(28, 34, 50),
		Stroke = Color3.fromRGB(0, 160, 220),
		Text = Color3.fromRGB(235, 240, 250),
		TextDim = Color3.fromRGB(140, 150, 170),
	},
	["Cyberpunk Purple"] = {
		MainBg = Color3.fromRGB(14, 8, 22),
		SidebarBg = Color3.fromRGB(18, 10, 30),
		TopbarBg = Color3.fromRGB(24, 12, 40),
		Accent = Color3.fromRGB(170, 0, 255),
		AccentDim = Color3.fromRGB(90, 0, 140),
		CardBg = Color3.fromRGB(30, 16, 48),
		CardHover = Color3.fromRGB(40, 22, 60),
		Stroke = Color3.fromRGB(200, 0, 255),
		Text = Color3.fromRGB(240, 230, 250),
		TextDim = Color3.fromRGB(150, 140, 170),
	},
	["Emerald Green"] = {
		MainBg = Color3.fromRGB(8, 18, 12),
		SidebarBg = Color3.fromRGB(10, 22, 16),
		TopbarBg = Color3.fromRGB(12, 28, 20),
		Accent = Color3.fromRGB(0, 210, 130),
		AccentDim = Color3.fromRGB(0, 110, 70),
		CardBg = Color3.fromRGB(16, 36, 26),
		CardHover = Color3.fromRGB(24, 46, 34),
		Stroke = Color3.fromRGB(0, 240, 150),
		Text = Color3.fromRGB(230, 245, 235),
		TextDim = Color3.fromRGB(130, 150, 140),
	},
	["Dark Minimal"] = {
		MainBg = Color3.fromRGB(12, 12, 14),
		SidebarBg = Color3.fromRGB(18, 18, 20),
		TopbarBg = Color3.fromRGB(24, 24, 26),
		Accent = Color3.fromRGB(200, 200, 205),
		AccentDim = Color3.fromRGB(100, 100, 110),
		CardBg = Color3.fromRGB(30, 30, 34),
		CardHover = Color3.fromRGB(40, 40, 46),
		Stroke = Color3.fromRGB(80, 80, 90),
		Text = Color3.fromRGB(240, 240, 245),
		TextDim = Color3.fromRGB(130, 130, 140),
	},
	["Sunset Orange"] = {
		MainBg = Color3.fromRGB(20, 12, 10),
		SidebarBg = Color3.fromRGB(26, 16, 12),
		TopbarBg = Color3.fromRGB(32, 20, 14),
		Accent = Color3.fromRGB(255, 130, 50),
		AccentDim = Color3.fromRGB(140, 70, 25),
		CardBg = Color3.fromRGB(36, 22, 18),
		CardHover = Color3.fromRGB(46, 30, 24),
		Stroke = Color3.fromRGB(255, 160, 80),
		Text = Color3.fromRGB(250, 240, 230),
		TextDim = Color3.fromRGB(160, 140, 130),
	},
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
	["Asteroid Egg"] = {luck = 5000, rarity = "Epic"},
	["Glass Egg"] = {luck = 10000, rarity = "Legendary"},
	["Golden Egg"] = {luck = 30000, rarity = "Legendary"},
	["Diamond Egg"] = {luck = 50000, rarity = "Legendary"},
	["Crystal Egg"] = {luck = 150000, rarity = "Mythic"},
	["Giant Egg"] = {luck = 250000, rarity = "Mythic"},
	["Skull Egg"] = {luck = 400000, rarity = "Mythic"},
	["Dominus Egg"] = {luck = 700000, rarity = "Mythic"},
	["Flaming Egg"] = {luck = 1000000, rarity = "Mythic"},
	["Sinister Egg"] = {luck = 3000000, rarity = "Mythic"},
	["Dragon Egg"] = {luck = 5000000, rarity = "Mythic"},
	["Devil Fruit Egg"] = {luck = 8000000, rarity = "Mythic"},
	["Soul Egg"] = {luck = 12000000, rarity = "Mythic"},
	["Admin Egg"] = {luck = 50000000, rarity = "Mythic"},
	["Aurora Egg"] = {luck = 300000000, rarity = "Divine"},
	["Galaxy Egg"] = {luck = 1500000000, rarity = "Divine"},
	["Solaris Egg"] = {luck = 5000000000, rarity = "Divine"},
	["Blackhole Egg"] = {luck = 100000000000, rarity = "Etheral"},
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
-- EGG IMAGE DATABASE
--==================================================

local EggImages = {
	["White Egg"] = "rbxassetid://125038257015442",
	["Brown Egg"] = "rbxassetid://112468794619740",
	["Cracked Egg"] = "rbxassetid://114193947640513",
	["Easter Egg"] = "rbxassetid://117359829225239",
	["Stone Egg"] = "rbxassetid://79058788270843",
	["Leaf Egg"] = "rbxassetid://120429977049854",
	["Mushroom Egg"] = "rbxassetid://96481268142716",
	["Flower Egg"] = "rbxassetid://110454294010876",
	["Slime Egg"] = "rbxassetid://85370733217796",
	["Ice Egg"] = "rbxassetid://91452074178973",
	["Asteroid Egg"] = "rbxassetid://115067675032185",
	["Glass Egg"] = "",
	["Golden Egg"] = "rbxassetid://91745471271627",
	["Diamond Egg"] = "rbxassetid://101061954214117",
	["Crystal Egg"] = "rbxassetid://96591557012606",
	["Giant Egg"] = "rbxassetid://82122268428375",
	["Skull Egg"] = "rbxassetid://133763014063788",
	["Dominus Egg"] = "rbxassetid://96517858714236",
	["Flaming Egg"] = "rbxassetid://855109219",
	["Sinister Egg"] = "rbxassetid://100010318153363",
	["Dragon Egg"] = "rbxassetid://99395219574570",
	["Devil Fruit Egg"] = "rbxassetid://74540048396159",
	["Soul Egg"] = "rbxassetid://113516441036388",
	["Admin Egg"] = "rbxassetid://90780216228766",
	["Aurora Egg"] = "rbxassetid://77285302950274",
	["Galaxy Egg"] = "rbxassetid://100174338199842",
	["Solaris Egg"] = "rbxassetid://82445068315176",
	["Blackhole Egg"] = "",
	["Cherub Egg"] = "rbxassetid://94168267204117",
}

--==================================================
-- SETTINGS & CONFIG
--==================================================

local SettingsFile = "RideAPet_HubSettings_V8.json"

local Settings = {
	ESPEnabled = true,
	RadarEnabled = true,
	FlyEnabled = false,
	AutoClaimEnabled = false,
	AutoTPToBase = false,
	WalkSpeed = 16,
	FlySpeed = 60,
	CurrentTheme = "Midnight Blue",
	AllowedEggs = {},
	NotifyEggs = {},
	NotifyEnabled = true,
	ScanInterval = 500,
	ESPMaxDistance = 600,
	NotifyDuration = 4,
	LowQualityMode = false,
	DisableParticles = false,
	MaxSpawnLogEntries = 15,
}

local GridSpacing = 6
local MaxColumns = 5

for EggName, _ in pairs(Eggs) do
	Settings.AllowedEggs[EggName] = true
	Settings.NotifyEggs[EggName] = true
end

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
					elseif k == "NotifyEggs" and type(v) == "table" then
						for egg, val in pairs(v) do Settings.NotifyEggs[egg] = val end
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
local NeedsSpawnLogUpdate = false
local FilterButtons = {}
local UI_Toggles = {}
local UI_SliderFills = {}
local AutoTPDebounce = false
local FlyVelocity = nil
local FlyBody = nil
local EggSpawnLog = {}

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
-- UI ANIMATION HELPERS
--==================================================

local function CreateClickBounce(Button)
	Button.MouseButton1Down:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(Button.Size.X.Scale, Button.Size.X.Offset - 4, Button.Size.Y.Scale, Button.Size.Y.Offset - 2)}):Play()
	end)
	Button.MouseButton1Up:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Size = UDim2.new(Button.Size.X.Scale, Button.Size.X.Offset + 4, Button.Size.Y.Scale, Button.Size.Y.Offset + 2)}):Play()
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

local function PressKey2()
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
	task.wait(0.08)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameRemotes = ReplicatedStorage:FindFirstChild("Remotes")
GameRemotes = GameRemotes and GameRemotes:FindFirstChild("Game") or nil

local function GetUserPlot()
	local PlotsFolder = workspace:FindFirstChild("Plots")
	if PlotsFolder then
		for _, Plot in ipairs(PlotsFolder:GetChildren()) do
			local DataFolder = Plot:FindFirstChild("Data")
			if DataFolder then
				local OwnerValue = DataFolder:FindFirstChild("Owner")
				if OwnerValue then
					local owner = OwnerValue.Value
					if owner == Player then return Plot end
					if type(owner) == "number" and owner == Player.UserId then return Plot end
				end
			end
			if Plot:GetAttribute("OwnerUserId") == Player.UserId then return Plot end
			if Plot:GetAttribute("NestsOwnerLoaded") == Player.UserId then return Plot end
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
	return (Baseplate.CFrame * CFrame.new(OffsetX, (Baseplate.Size.Y / 2) + 2.5, OffsetZ)).Position
end

local function RearrangePlotEggs()
	local Plot = GetUserPlot()
	if not Plot then return end
	local Baseplate = Plot:FindFirstChild("Baseplate") or Plot.PrimaryPart or Plot:FindFirstChildWhichIsA("BasePart", true)
	if not Baseplate then return end
	local EggsFolder = Plot:FindFirstChild("Eggs")
	if not EggsFolder then return end
	local EggsList = EggsFolder:GetChildren()
	local BaseCFrame = Baseplate.CFrame
	local StartX = -((MaxColumns - 1) * GridSpacing) / 2
	local StartZ = -4
	for index, Egg in ipairs(EggsList) do
		local i = index - 1
		local Column = i % MaxColumns
		local Row = math.floor(i / MaxColumns)
		local OffsetX = StartX + (Column * GridSpacing)
		local OffsetZ = StartZ + (Row * GridSpacing)
		local TargetCFrame = BaseCFrame * CFrame.new(OffsetX, (Baseplate.Size.Y / 2) + 2.5, OffsetZ)
		if Egg:IsA("Model") then
			Egg:PivotTo(TargetCFrame)
		elseif Egg:IsA("BasePart") then
			Egg.CFrame = TargetCFrame
		end
	end
end

local function TeleportToBase()
	if GameRemotes then
		local TPEvent = GameRemotes:FindFirstChild("TeleportToPlot")
		if TPEvent then pcall(function() TPEvent:FireServer() end) end
	end
	local Spot = GetNextBaseplateSpot()
	if Spot then
		TeleportTo(Spot)
	else
		local Plot = GetUserPlot()
		if Plot then
			local Baseplate = Plot:FindFirstChild("Baseplate") or Plot.PrimaryPart
			if Baseplate then TeleportTo(Baseplate.Position + Vector3.new(0, 5, 0)) end
		else
			local SpawnLocation = workspace:FindFirstChildWhichIsA("SpawnLocation", true)
			if SpawnLocation then TeleportTo(SpawnLocation.Position) end
		end
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
-- FLY SYSTEM
--==================================================

local function StartFly()
	local Root = GetRoot()
	if not Root then return end
	if FlyVelocity then return end
	FlyVelocity = Instance.new("BodyVelocity")
	FlyVelocity.MaxForce = Vector3.new(1, 1, 1) * 1e9
	FlyVelocity.Velocity = Vector3.zero
	FlyVelocity.Parent = Root
	local Hum = GetHumanoid()
	if Hum then Hum.PlatformStand = true end
end

local function StopFly()
	if FlyVelocity then
		FlyVelocity:Destroy()
		FlyVelocity = nil
	end
	local Hum = GetHumanoid()
	if Hum then Hum.PlatformStand = false end
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
	Billboard.MaxDistance = Settings.ESPMaxDistance
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

	-- Egg image in ESP
	local EggImg = EggImages[Egg.Name] or ""
	if EggImg ~= "" then
		local Img = Instance.new("ImageLabel")
		Img.Size = UDim2.fromOffset(20, 20)
		Img.Position = UDim2.fromOffset(2, 2)
		Img.BackgroundTransparency = 1
		Img.Image = EggImg
		Img.Parent = Frame
		Text.Position = UDim2.fromOffset(24, 1)
		Text.Size = UDim2.new(1, -28, 1, -2)
	end

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

--==================================================
-- EGG SPAWN NOTIFICATION SYSTEM
--==================================================

local function GetTheme()
	return Themes[Settings.CurrentTheme] or Themes["Midnight Blue"]
end

local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "EggSpawnNotifications"
NotifyGui.ResetOnSpawn = false
NotifyGui.IgnoreGuiInset = true
NotifyGui.Parent = Player:WaitForChild("PlayerGui")

local NotifyContainer = Instance.new("Frame")
NotifyContainer.Size = UDim2.new(0, 300, 0, 0)
NotifyContainer.Position = UDim2.new(1, -320, 0, 20)
NotifyContainer.BackgroundTransparency = 1
NotifyContainer.AutomaticSize = Enum.AutomaticSize.Y
NotifyContainer.Parent = NotifyGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.Padding = UDim.new(0, 8)
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.Parent = NotifyContainer

local NotifyCount = 0

local function AddSpawnLogEntry(eggName, rarity, luck)
	local entry = {
		name = eggName,
		rarity = rarity,
		luck = luck,
		time = os.time(),
	}
	table.insert(EggSpawnLog, 1, entry)
	while #EggSpawnLog > Settings.MaxSpawnLogEntries do
		table.remove(EggSpawnLog)
	end
end

local function ShowNotification(eggName, body, color)
	if not Settings.NotifyEnabled then return end
	if NotifyCount >= 3 then return end

	NotifyCount += 1
	local Theme = GetTheme()

	local Toast = Instance.new("Frame")
	Toast.Size = UDim2.new(1, 0, 0, 0)
	Toast.BackgroundColor3 = Theme.MainBg
	Toast.BackgroundTransparency = 0.05
	Toast.Parent = NotifyContainer
	Toast.ClipsDescendants = true
	Instance.new("UICorner", Toast).CornerRadius = UDim.new(0, 12)

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = color or Theme.Accent
	Stroke.Thickness = 1.5
	Stroke.Transparency = 0.2
	Stroke.Parent = Toast

	-- Left color bar
	local Bar = Instance.new("Frame")
	Bar.Size = UDim2.new(0, 4, 1, 0)
	Bar.BackgroundColor3 = color or Theme.Accent
	Bar.BorderSizePixel = 0
	Bar.Parent = Toast
	Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

	-- Egg image
	local EggImage = Instance.new("ImageLabel")
	EggImage.Size = UDim2.fromOffset(42, 42)
	EggImage.Position = UDim2.fromOffset(12, 10)
	EggImage.BackgroundColor3 = Theme.CardBg
	EggImage.BackgroundTransparency = 0.5
	EggImage.Parent = Toast
	Instance.new("UICorner", EggImage).CornerRadius = UDim.new(0, 10)
	local imgSrc = EggImages[eggName] or ""
	if imgSrc ~= "" then
		EggImage.Image = imgSrc
		EggImage.ScaleType = Enum.ScaleType.Fit
	else
		EggImage.BackgroundColor3 = color or Theme.Accent
		EggImage.BackgroundTransparency = 0.3
	end

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -68, 0, 20)
	TitleLabel.Position = UDim2.fromOffset(62, 10)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = eggName .. " spawned!"
	TitleLabel.TextColor3 = Theme.Text
	TitleLabel.TextSize = 13
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = Toast

	local BodyLabel = Instance.new("TextLabel")
	BodyLabel.Size = UDim2.new(1, -68, 0, 22)
	BodyLabel.Position = UDim2.fromOffset(62, 30)
	BodyLabel.BackgroundTransparency = 1
	BodyLabel.Text = body
	BodyLabel.TextColor3 = color or Theme.Accent
	BodyLabel.TextSize = 11
	BodyLabel.Font = Enum.Font.GothamMedium
	BodyLabel.TextWrapped = true
	BodyLabel.TextXAlignment = Enum.TextXAlignment.Left
	BodyLabel.TextYAlignment = Enum.TextYAlignment.Top
	BodyLabel.Parent = Toast

	TweenService:Create(Toast, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 62)}):Play()

	task.delay(Settings.NotifyDuration, function()
		if Toast.Parent then
			TweenService:Create(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}):Play()
			task.wait(0.35)
			Toast:Destroy()
			NotifyCount = math.max(0, NotifyCount - 1)
		end
	end)
end

workspace.DescendantAdded:Connect(function(Object)
	if IsEgg(Object) then
		task.spawn(function()
			CreateESP(Object)
			local Data = Eggs[Object.Name]
			if Data then
				AddSpawnLogEntry(Object.Name, Data.rarity, Data.luck)
				if Settings.NotifyEggs[Object.Name] ~= false then
					ShowNotification(Object.Name, Data.rarity .. "  -  Luck: " .. FormatNumber(Data.luck), RarityColors[Data.rarity])
				end
				NeedsSpawnLogUpdate = true
			end
		end)
	end
end)

workspace.DescendantRemoving:Connect(function(Object)
	if EggESP[Object] then 
		RemoveESP(Object)
		if Settings.AutoTPToBase then
			task.spawn(function()
				task.wait(0.3)
				local GridSpot = GetNextBaseplateSpot()
				if GridSpot then
					TeleportTo(GridSpot)
				else
					TeleportToBase()
				end
			end)
		end
	end
end)

if GameRemotes then
	local ArrivalClaim = GameRemotes:FindFirstChild("EggArrivalClaim")
	if ArrivalClaim then
		ArrivalClaim.OnClientEvent:Connect(function()
			if Settings.AutoTPToBase then
				task.spawn(function()
					task.wait(0.2)
					local GridSpot = GetNextBaseplateSpot()
					if GridSpot then
						TeleportTo(GridSpot)
					else
						TeleportToBase()
					end
				end)
			end
		end)
	end
end

--==================================================
-- UI DESIGN & THEME ENGINE
--==================================================

local GUI = Instance.new("ScreenGui")
GUI.Name = "RideAPetUltraV9"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.Parent = Player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(680, 500)
Main.Position = UDim2.new(0.5, -340, 0.5, -250)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = GUI
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.3
MainStroke.Parent = Main

local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 52)
Topbar.BorderSizePixel = 0
Topbar.Parent = Main

local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(1, 0, 0, 3)
AccentLine.BorderSizePixel = 0
AccentLine.Parent = Topbar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 0, 24)
Title.Position = UDim2.fromOffset(20, 6)
Title.BackgroundTransparency = 1
Title.Text = "RIDE A PET"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -90, 0, 14)
SubTitle.Position = UDim2.fromOffset(20, 32)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Ultra Hub V9"
SubTitle.TextColor3 = Color3.fromRGB(130, 140, 160)
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Topbar

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(34, 34)
Minimize.Position = UDim2.new(1, -78, 0, 9)
Minimize.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
Minimize.Text = "-"
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = Topbar
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0, 10)

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(34, 34)
Close.Position = UDim2.new(1, -40, 0, 9)
Close.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 14
Close.Font = Enum.Font.GothamBold
Close.Parent = Topbar
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 10)

local Sidebar = Instance.new("Frame")
Sidebar.Position = UDim2.fromOffset(0, 52)
Sidebar.Size = UDim2.new(0, 170, 1, -52)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarDivider = Instance.new("Frame")
SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
SidebarDivider.Position = UDim2.new(1, -1, 0, 0)
SidebarDivider.BorderSizePixel = 0
SidebarDivider.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 6)
SidebarList.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 14)
SidebarPadding.PaddingLeft = UDim.new(0, 12)
SidebarPadding.PaddingRight = UDim.new(0, 12)
SidebarPadding.Parent = Sidebar

local Container = Instance.new("Frame")
Container.Position = UDim2.fromOffset(170, 52)
Container.Size = UDim2.new(1, -170, 1, -52)
Container.BackgroundTransparency = 1
Container.Parent = Main

local ActiveTabBtn = nil
local TabAccentBars = {}
local Pages = {}

local function ApplyTheme(ThemeName)
	local Theme = Themes[ThemeName] or Themes["Midnight Blue"]
	Settings.CurrentTheme = ThemeName
	SaveSettings()

	TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundColor3 = Theme.MainBg}):Play()
	TweenService:Create(Sidebar, TweenInfo.new(0.3), {BackgroundColor3 = Theme.SidebarBg}):Play()
	TweenService:Create(Topbar, TweenInfo.new(0.3), {BackgroundColor3 = Theme.TopbarBg}):Play()
	TweenService:Create(MainStroke, TweenInfo.new(0.3), {Color = Theme.Stroke}):Play()
	TweenService:Create(AccentLine, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Accent}):Play()
	TweenService:Create(SidebarDivider, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Stroke}):Play()
	SubTitle.TextColor3 = Theme.TextDim

	for Name, p in pairs(Pages) do
		local isActive = (p.btn == ActiveTabBtn)
		local bar = TabAccentBars[p.btn]
		if isActive then
			TweenService:Create(p.btn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.CardBg, TextColor3 = Theme.Text}):Play()
			if bar then TweenService:Create(bar, TweenInfo.new(0.2), {BackgroundTransparency = 0, Size = UDim2.new(0, 3, 0.65, 0)}):Play() end
		else
			TweenService:Create(p.btn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.SidebarBg, TextColor3 = Theme.TextDim}):Play()
			if bar then TweenService:Create(bar, TweenInfo.new(0.2), {BackgroundTransparency = 1, Size = UDim2.new(0, 3, 0, 0)}):Play() end
		end
	end

	for _, toggle in pairs(UI_Toggles) do
		local IsOn = Settings[toggle.Key]
		if toggle.Bg then
			TweenService:Create(toggle.Bg, TweenInfo.new(0.3), {BackgroundColor3 = IsOn and Theme.Accent or Color3.fromRGB(40, 44, 58)}):Play()
		end
		if toggle.Knob then
			local pos = IsOn and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
			TweenService:Create(toggle.Knob, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = pos}):Play()
		end
	end

	for _, fill in pairs(UI_SliderFills) do
		fill.BackgroundColor3 = Theme.Accent
	end
end

local function CreateTab(Name)
	local TabBtn = Instance.new("TextButton")
	TabBtn.Size = UDim2.new(1, 0, 0, 38)
	TabBtn.Text = "   " .. Name
	TabBtn.TextSize = 12
	TabBtn.Font = Enum.Font.GothamSemibold
	TabBtn.TextXAlignment = Enum.TextXAlignment.Left
	TabBtn.AutoButtonColor = false
	TabBtn.Parent = Sidebar
	Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 10)

	local AccentBar = Instance.new("Frame")
	AccentBar.Size = UDim2.new(0, 3, 0, 0)
	AccentBar.Position = UDim2.fromOffset(0, 7)
	AccentBar.BorderSizePixel = 0
	AccentBar.BackgroundTransparency = 1
	AccentBar.Parent = TabBtn
	Instance.new("UICorner", AccentBar).CornerRadius = UDim.new(1, 0)
	TabAccentBars[TabBtn] = AccentBar

	TabBtn.MouseEnter:Connect(function()
		if TabBtn ~= ActiveTabBtn then
			local T = GetTheme()
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.CardHover}):Play()
		end
	end)
	TabBtn.MouseLeave:Connect(function()
		if TabBtn ~= ActiveTabBtn then
			local T = GetTheme()
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = T.SidebarBg}):Play()
		end
	end)

	local Page = Instance.new("ScrollingFrame")
	Page.Size = UDim2.new(1, -24, 1, -24)
	Page.Position = UDim2.fromOffset(12, 12)
	Page.BackgroundTransparency = 1
	Page.BorderSizePixel = 0
	Page.ScrollBarThickness = 3
	Page.ScrollBarImageColor3 = Color3.fromRGB(80, 90, 110)
	Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
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

local MainTab = CreateTab("Dashboard")
local FilterTab = CreateTab("Egg Filter")
local TeleportTab = CreateTab("Teleports")
local PerfTab = CreateTab("Performance")
local SettingsTab = CreateTab("Settings & Server")

ActiveTabBtn = Pages["Dashboard"].btn
Pages["Dashboard"].page.Visible = true

--==================================================
-- UI CONTROLS
--==================================================

local function CreateToggle(Parent, TextLabel, SettingKey, Callback)
	local DefaultState = Settings[SettingKey]
	local Theme = GetTheme()

	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, -8, 0, 42)
	Row.BackgroundColor3 = Theme.CardBg
	Row.BorderSizePixel = 0
	Row.Parent = Parent
	Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 10)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -60, 1, 0)
	Label.Position = UDim2.fromOffset(14, 0)
	Label.BackgroundTransparency = 1
	Label.Text = TextLabel
	Label.TextColor3 = Theme.Text
	Label.TextSize = 12
	Label.Font = Enum.Font.GothamMedium
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Row

	local SwitchBg = Instance.new("TextButton")
	SwitchBg.Size = UDim2.fromOffset(44, 24)
	SwitchBg.Position = UDim2.new(1, -54, 0.5, -12)
	SwitchBg.BackgroundColor3 = DefaultState and Theme.Accent or Color3.fromRGB(40, 44, 58)
	SwitchBg.Text = ""
	SwitchBg.AutoButtonColor = false
	SwitchBg.Parent = Row
	Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

	local Knob = Instance.new("Frame")
	Knob.Size = UDim2.fromOffset(20, 20)
	Knob.Position = DefaultState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
	Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Knob.BorderSizePixel = 0
	Knob.Parent = SwitchBg
	Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

	Row.MouseEnter:Connect(function()
		local T = GetTheme()
		TweenService:Create(Row, TweenInfo.new(0.15), {BackgroundColor3 = T.CardHover}):Play()
	end)
	Row.MouseLeave:Connect(function()
		local T = GetTheme()
		TweenService:Create(Row, TweenInfo.new(0.15), {BackgroundColor3 = T.CardBg}):Play()
	end)

	table.insert(UI_Toggles, {Btn = SwitchBg, Bg = SwitchBg, Knob = Knob, Key = SettingKey})

	SwitchBg.MouseButton1Click:Connect(function()
		Settings[SettingKey] = not Settings[SettingKey]
		local State = Settings[SettingKey]
		local T = GetTheme()
		TweenService:Create(SwitchBg, TweenInfo.new(0.25), {BackgroundColor3 = State and T.Accent or Color3.fromRGB(40, 44, 58)}):Play()
		TweenService:Create(Knob, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = State and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}):Play()
		SaveSettings()
		if Callback then Callback(State) end
	end)
	return Row
end

local function CreateSlider(Parent, TextLabel, SettingKey, Min, Max, Callback)
	local Theme = GetTheme()
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -8, 0, 52)
	Frame.BackgroundColor3 = Theme.CardBg
	Frame.BorderSizePixel = 0
	Frame.Parent = Parent
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -74, 0, 20)
	Label.Position = UDim2.fromOffset(14, 8)
	Label.BackgroundTransparency = 1
	Label.Text = TextLabel
	Label.TextColor3 = Theme.Text
	Label.TextSize = 12
	Label.Font = Enum.Font.GothamMedium
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	local ValueLbl = Instance.new("TextLabel")
	ValueLbl.Size = UDim2.fromOffset(60, 20)
	ValueLbl.Position = UDim2.new(1, -74, 0, 8)
	ValueLbl.BackgroundTransparency = 1
	ValueLbl.Text = tostring(Settings[SettingKey])
	ValueLbl.TextColor3 = Theme.Accent
	ValueLbl.TextSize = 12
	ValueLbl.Font = Enum.Font.GothamBold
	ValueLbl.TextXAlignment = Enum.TextXAlignment.Right
	ValueLbl.Parent = Frame

	local SliderBg = Instance.new("Frame")
	SliderBg.Size = UDim2.new(1, -28, 0, 7)
	SliderBg.Position = UDim2.fromOffset(14, 34)
	SliderBg.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
	SliderBg.BorderSizePixel = 0
	SliderBg.Parent = Frame
	Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

	local Fill = Instance.new("Frame")
	Fill.Size = UDim2.fromScale(math.clamp((Settings[SettingKey] - Min) / (Max - Min), 0, 1), 1)
	Fill.BackgroundColor3 = Theme.Accent
	Fill.BorderSizePixel = 0
	Fill.Parent = SliderBg
	Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
	table.insert(UI_SliderFills, Fill)

	local Knob = Instance.new("Frame")
	Knob.Size = UDim2.fromOffset(16, 16)
	Knob.Position = UDim2.fromScale(math.clamp((Settings[SettingKey] - Min) / (Max - Min), 0, 1), 0.5)
	Knob.AnchorPoint = Vector2.new(0.5, 0.5)
	Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Knob.BorderSizePixel = 0
	Knob.Parent = SliderBg
	Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
	local KnobStroke = Instance.new("UIStroke")
	KnobStroke.Color = Theme.Accent
	KnobStroke.Thickness = 2
	KnobStroke.Parent = Knob

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.fromScale(1, 1)
	Button.BackgroundTransparency = 1
	Button.Text = ""
	Button.Parent = SliderBg

	local Dragging = false
	local function Update(Input)
		local Pct = math.clamp((Input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
		Fill.Size = UDim2.fromScale(Pct, 1)
		Knob.Position = UDim2.fromScale(Pct, 0.5)
		local Value = math.floor(Min + (Max - Min) * Pct)
		Settings[SettingKey] = Value
		ValueLbl.Text = tostring(Value)
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
		if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
			Update(Input)
		end
	end)
	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = false
		end
	end)
end

--==================================================
-- DASHBOARD TAB
--==================================================

local MainLayout = Instance.new("UIListLayout")
MainLayout.Padding = UDim.new(0, 8)
MainLayout.Parent = MainTab

CreateToggle(MainTab, "ESP", "ESPEnabled", function(val)
	for Egg, Info in pairs(EggESP) do
		if Info.gui then Info.gui.Enabled = val end
	end
end)

CreateToggle(MainTab, "Radar / Scan", "RadarEnabled", function(val) end)

CreateToggle(MainTab, "Auto TP to Base", "AutoTPToBase", function(val) end)

CreateToggle(MainTab, "Notifications", "NotifyEnabled", function(val) end)

CreateToggle(MainTab, "Fly Mode", "FlyEnabled", function(val)
	if val then StartFly() else StopFly() end
end)

CreateSlider(MainTab, "Fly Speed", "FlySpeed", 20, 300, function(val) end)

local function CreateActionButton(Parent, Text, Color, Callback)
	local Theme = GetTheme()
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, -8, 0, 40)
	Btn.BackgroundColor3 = Color
	Btn.Text = Text
	Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	Btn.TextSize = 12
	Btn.Font = Enum.Font.GothamBold
	Btn.AutoButtonColor = false
	Btn.Parent = Parent
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)

	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(
			math.min(255, math.floor(Color.R * 255) + 20),
			math.min(255, math.floor(Color.G * 255) + 20),
			math.min(255, math.floor(Color.B * 255) + 20)
		)}):Play()
	end)
	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = Color}):Play()
	end)
	Btn.MouseButton1Down:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.08), {Size = UDim2.new(1, -12, 0, 36)}):Play()
	end)
	Btn.MouseButton1Up:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.08, Enum.EasingStyle.Bounce), {Size = UDim2.new(1, -8, 0, 40)}):Play()
	end)
	Btn.MouseButton1Click:Connect(Callback)
	return Btn
end

CreateActionButton(MainTab, "Teleport To Baseplate Spot", Color3.fromRGB(140, 40, 255), TeleportToBase)
CreateActionButton(MainTab, "Rearrange Eggs (Grid)", Color3.fromRGB(0, 140, 200), RearrangePlotEggs)

-- Status Card
local StatusCard = Instance.new("Frame")
StatusCard.Size = UDim2.new(1, -8, 0, 90)
StatusCard.BackgroundColor3 = Color3.fromRGB(18, 22, 34)
StatusCard.BorderSizePixel = 0
StatusCard.Parent = MainTab
Instance.new("UICorner", StatusCard).CornerRadius = UDim.new(0, 10)

local StatusAccent = Instance.new("Frame")
StatusAccent.Size = UDim2.new(0, 3, 1, 0)
StatusAccent.BorderSizePixel = 0
StatusAccent.Parent = StatusCard
Instance.new("UICorner", StatusAccent).CornerRadius = UDim.new(1, 0)

local StatusTitle = Instance.new("TextLabel")
StatusTitle.Size = UDim2.new(1, -20, 0, 18)
StatusTitle.Position = UDim2.fromOffset(12, 8)
StatusTitle.BackgroundTransparency = 1
StatusTitle.Text = "STATUS"
StatusTitle.TextColor3 = Color3.fromRGB(150, 160, 180)
StatusTitle.TextSize = 10
StatusTitle.Font = Enum.Font.GothamBold
StatusTitle.TextXAlignment = Enum.TextXAlignment.Left
StatusTitle.Parent = StatusCard

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -20, 1, -30)
StatusText.Position = UDim2.fromOffset(12, 26)
StatusText.BackgroundTransparency = 1
StatusText.TextColor3 = Color3.fromRGB(230, 235, 245)
StatusText.TextSize = 12
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextWrapped = true
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.TextYAlignment = Enum.TextYAlignment.Top
StatusText.Text = "Scanning..."
StatusText.Parent = StatusCard

local function UpdateStatus()
	local count = 0
	for _ in pairs(EggESP) do count = count + 1 end
	local Theme = GetTheme()
	StatusAccent.BackgroundColor3 = Settings.RadarEnabled and Theme.Accent or Color3.fromRGB(80, 90, 110)
	if Settings.RadarEnabled then
		StatusText.Text = "Scanning...  |  Eggs tracked: " .. count
		StatusText.TextColor3 = Color3.fromRGB(0, 200, 120)
	else
		StatusText.Text = "Scan disabled  |  Eggs tracked: " .. count
		StatusText.TextColor3 = Color3.fromRGB(100, 110, 130)
	end
end

--==================================================
-- EGG FILTER TAB
--==================================================

local FilterLayout = Instance.new("UIListLayout")
FilterLayout.Padding = UDim.new(0, 6)
FilterLayout.Parent = FilterTab

local FilterHeader = Instance.new("TextLabel")
FilterHeader.Size = UDim2.new(1, -8, 0, 24)
FilterHeader.BackgroundTransparency = 1
FilterHeader.Text = "Toggle which eggs to track and notify"
FilterHeader.TextColor3 = Color3.fromRGB(170, 180, 200)
FilterHeader.TextSize = 11
FilterHeader.Font = Enum.Font.GothamMedium
FilterHeader.TextXAlignment = Enum.TextXAlignment.Left
FilterHeader.Parent = FilterTab

local SelectAllBtn = Instance.new("TextButton")
SelectAllBtn.Size = UDim2.new(1, -8, 0, 32)
SelectAllBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
SelectAllBtn.Text = "Select All Eggs"
SelectAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectAllBtn.TextSize = 12
SelectAllBtn.Font = Enum.Font.GothamBold
SelectAllBtn.Parent = FilterTab
Instance.new("UICorner", SelectAllBtn).CornerRadius = UDim.new(0, 8)

local DeselectAllBtn = Instance.new("TextButton")
DeselectAllBtn.Size = UDim2.new(1, -8, 0, 32)
DeselectAllBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
DeselectAllBtn.Text = "Deselect All Eggs"
DeselectAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DeselectAllBtn.TextSize = 12
DeselectAllBtn.Font = Enum.Font.GothamBold
DeselectAllBtn.Parent = FilterTab
Instance.new("UICorner", DeselectAllBtn).CornerRadius = UDim.new(0, 8)

-- Egg filter buttons with images
for EggName, Data in pairs(Eggs) do
	local Card = Instance.new("TextButton")
	Card.Size = UDim2.new(1, -8, 0, 40)
	Card.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
	Card.Text = ""
	Card.Parent = FilterTab
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

	-- Egg image
	local Img = Instance.new("ImageLabel")
	Img.Size = UDim2.fromOffset(30, 30)
	Img.Position = UDim2.fromOffset(5, 5)
	Img.BackgroundTransparency = 1
	Img.Parent = Card
	local imgSrc = EggImages[EggName] or ""
	if imgSrc ~= "" then
		Img.Image = imgSrc
	else
		Img.BackgroundColor3 = RarityColors[Data.rarity]
		Img.BackgroundTransparency = 0.3
	end

	-- Egg name label
	local NameLbl = Instance.new("TextLabel")
	NameLbl.Size = UDim2.new(1, -80, 1, 0)
	NameLbl.Position = UDim2.fromOffset(40, 0)
	NameLbl.BackgroundTransparency = 1
	NameLbl.Text = EggName .. "  (" .. Data.rarity .. ")"
	NameLbl.TextColor3 = Color3.fromRGB(220, 225, 240)
	NameLbl.TextSize = 11
	NameLbl.Font = Enum.Font.GothamMedium
	NameLbl.TextXAlignment = Enum.TextXAlignment.Left
	NameLbl.Parent = Card

	-- Rarity color stripe
	local Stripe = Instance.new("Frame")
	Stripe.Size = UDim2.fromOffset(3, 30)
	Stripe.Position = UDim2.new(1, -12, 0, 5)
	Stripe.BackgroundColor3 = RarityColors[Data.rarity]
	Stripe.BorderSizePixel = 0
	Stripe.Parent = Card
	Instance.new("UICorner", Stripe).CornerRadius = UDim.new(1, 0)

	-- State indicator
	local StateLbl = Instance.new("TextLabel")
	StateLbl.Size = UDim2.fromOffset(30, 20)
	StateLbl.Position = UDim2.new(1, -45, 0, 10)
	StateLbl.BackgroundTransparency = 1
	StateLbl.Text = Settings.AllowedEggs[EggName] and "ON" or "OFF"
	StateLbl.TextColor3 = Settings.AllowedEggs[EggName] and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(150, 80, 80)
	StateLbl.TextSize = 10
	StateLbl.Font = Enum.Font.GothamBold
	StateLbl.Parent = Card

	FilterButtons[EggName] = {card = Card, state = StateLbl}

	Card.MouseButton1Click:Connect(function()
		Settings.AllowedEggs[EggName] = not Settings.AllowedEggs[EggName]
		Settings.NotifyEggs[EggName] = Settings.AllowedEggs[EggName]
		local entry = FilterButtons[EggName]
		if entry then
			entry.state.Text = Settings.AllowedEggs[EggName] and "ON" or "OFF"
			entry.state.TextColor3 = Settings.AllowedEggs[EggName] and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(150, 80, 80)
		end
		SaveSettings()
	end)
end

SelectAllBtn.MouseButton1Click:Connect(function()
	for EggName, _ in pairs(Eggs) do
		Settings.AllowedEggs[EggName] = true
		Settings.NotifyEggs[EggName] = true
		local entry = FilterButtons[EggName]
		if entry then
			entry.state.Text = "ON"
			entry.state.TextColor3 = Color3.fromRGB(0, 200, 120)
		end
	end
	SaveSettings()
end)

DeselectAllBtn.MouseButton1Click:Connect(function()
	for EggName, _ in pairs(Eggs) do
		Settings.AllowedEggs[EggName] = false
		Settings.NotifyEggs[EggName] = false
		local entry = FilterButtons[EggName]
		if entry then
			entry.state.Text = "OFF"
			entry.state.TextColor3 = Color3.fromRGB(150, 80, 80)
		end
	end
	SaveSettings()
end)

--==================================================
-- TELEPORT TAB
--==================================================

local TPLayout = Instance.new("UIListLayout")
TPLayout.Padding = UDim.new(0, 6)
TPLayout.Parent = TeleportTab

local TPHeader = Instance.new("TextLabel")
TPHeader.Size = UDim2.new(1, -8, 0, 24)
TPHeader.BackgroundTransparency = 1
TPHeader.Text = "Click an egg to teleport to it"
TPHeader.TextColor3 = Color3.fromRGB(170, 180, 200)
TPHeader.TextSize = 11
TPHeader.Font = Enum.Font.GothamMedium
TPHeader.TextXAlignment = Enum.TextXAlignment.Left
TPHeader.Parent = TeleportTab

local TPRefreshBtn = Instance.new("TextButton")
TPRefreshBtn.Size = UDim2.new(1, -8, 0, 32)
TPRefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
TPRefreshBtn.Text = "Refresh Egg List"
TPRefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TPRefreshBtn.TextSize = 12
TPRefreshBtn.Font = Enum.Font.GothamBold
TPRefreshBtn.Parent = TeleportTab
Instance.new("UICorner", TPRefreshBtn).CornerRadius = UDim.new(0, 8)

local TPListFrame = Instance.new("Frame")
TPListFrame.Size = UDim2.new(1, -8, 0, 0)
TPListFrame.BackgroundTransparency = 1
TPListFrame.AutomaticSize = Enum.AutomaticSize.Y
TPListFrame.Parent = TeleportTab

local TPListLayout = Instance.new("UIListLayout")
TPListLayout.Padding = UDim.new(0, 4)
TPListLayout.Parent = TPListFrame

local function RefreshTPList()
	for _, child in ipairs(TPListFrame:GetChildren()) do
		if child:IsA("GuiButton") then child:Destroy() end
	end
	for Egg, _ in pairs(EggESP) do
		if IsEgg(Egg) then
			local Data = Eggs[Egg.Name]
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1, 0, 0, 36)
			Btn.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
			Btn.Text = ""
			Btn.Parent = TPListFrame
			Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

			-- Egg image
			local Img = Instance.new("ImageLabel")
			Img.Size = UDim2.fromOffset(26, 26)
			Img.Position = UDim2.fromOffset(5, 5)
			Img.BackgroundTransparency = 1
			Img.Parent = Btn
			local imgSrc = EggImages[Egg.Name] or ""
			if imgSrc ~= "" then
				Img.Image = imgSrc
			else
				Img.BackgroundColor3 = RarityColors[Data.rarity]
				Img.BackgroundTransparency = 0.3
			end

			local NameLbl = Instance.new("TextLabel")
			NameLbl.Size = UDim2.new(1, -40, 1, 0)
			NameLbl.Position = UDim2.fromOffset(36, 0)
			NameLbl.BackgroundTransparency = 1
			NameLbl.Text = Egg.Name
			NameLbl.TextColor3 = RarityColors[Data.rarity] or Color3.fromRGB(255, 255, 255)
			NameLbl.TextSize = 11
			NameLbl.Font = Enum.Font.GothamMedium
			NameLbl.TextXAlignment = Enum.TextXAlignment.Left
			NameLbl.Parent = Btn

			Btn.MouseButton1Click:Connect(function()
				local pos = GetObjectPosition(Egg)
				if pos then TeleportTo(pos) end
			end)
		end
	end
end

TPRefreshBtn.MouseButton1Click:Connect(RefreshTPList)

--==================================================
-- SETTINGS & SERVER TAB
--==================================================

local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Padding = UDim.new(0, 8)
SettingsLayout.Parent = SettingsTab

-- Theme selector
local ThemeLabel = Instance.new("TextLabel")
ThemeLabel.Size = UDim2.new(1, -8, 0, 20)
ThemeLabel.BackgroundTransparency = 1
ThemeLabel.Text = "Theme"
ThemeLabel.TextColor3 = GetTheme().TextDim
ThemeLabel.TextSize = 11
ThemeLabel.Font = Enum.Font.GothamBold
ThemeLabel.TextXAlignment = Enum.TextXAlignment.Left
ThemeLabel.Parent = SettingsTab

local ThemeBtns = {}
for ThemeName, _ in pairs(Themes) do
	local ThemeBtn = Instance.new("TextButton")
	ThemeBtn.Size = UDim2.new(1, -8, 0, 36)
	ThemeBtn.BackgroundColor3 = Settings.CurrentTheme == ThemeName and GetTheme().Accent or GetTheme().CardBg
	ThemeBtn.Text = ThemeName
	ThemeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	ThemeBtn.TextSize = 12
	ThemeBtn.Font = Enum.Font.GothamMedium
	ThemeBtn.AutoButtonColor = false
	ThemeBtn.Parent = SettingsTab
	Instance.new("UICorner", ThemeBtn).CornerRadius = UDim.new(0, 10)
	ThemeBtns[ThemeName] = ThemeBtn

	ThemeBtn.MouseEnter:Connect(function()
		if Settings.CurrentTheme ~= ThemeName then
			local T = GetTheme()
			TweenService:Create(ThemeBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.CardHover}):Play()
		end
	end)
	ThemeBtn.MouseLeave:Connect(function()
		if Settings.CurrentTheme ~= ThemeName then
			local T = GetTheme()
			TweenService:Create(ThemeBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.CardBg}):Play()
		end
	end)

	ThemeBtn.MouseButton1Click:Connect(function()
		for name, btn in pairs(ThemeBtns) do
			local T = Themes[name]
			if name == ThemeName then
				TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = T.Accent}):Play()
			else
				TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = T.CardBg}):Play()
			end
		end
		ApplyTheme(ThemeName)
	end)
end

-- Egg Spawn Log section
local SpawnLogLabel = Instance.new("TextLabel")
SpawnLogLabel.Size = UDim2.new(1, -8, 0, 20)
SpawnLogLabel.BackgroundTransparency = 1
SpawnLogLabel.Text = "Egg Spawn Log"
SpawnLogLabel.TextColor3 = GetTheme().TextDim
SpawnLogLabel.TextSize = 11
SpawnLogLabel.Font = Enum.Font.GothamBold
SpawnLogLabel.TextXAlignment = Enum.TextXAlignment.Left
SpawnLogLabel.Parent = SettingsTab

local SpawnLogCard = Instance.new("Frame")
SpawnLogCard.Size = UDim2.new(1, -8, 0, 220)
SpawnLogCard.BackgroundColor3 = GetTheme().CardBg
SpawnLogCard.BorderSizePixel = 0
SpawnLogCard.Parent = SettingsTab
Instance.new("UICorner", SpawnLogCard).CornerRadius = UDim.new(0, 10)

local SpawnLogScroll = Instance.new("ScrollingFrame")
SpawnLogScroll.Size = UDim2.new(1, -16, 1, -16)
SpawnLogScroll.Position = UDim2.fromOffset(8, 8)
SpawnLogScroll.BackgroundTransparency = 1
SpawnLogScroll.BorderSizePixel = 0
SpawnLogScroll.ScrollBarThickness = 3
SpawnLogScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 90, 110)
SpawnLogScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SpawnLogScroll.Parent = SpawnLogCard

local SpawnLogLayout = Instance.new("UIListLayout")
SpawnLogLayout.Padding = UDim.new(0, 4)
SpawnLogLayout.Parent = SpawnLogScroll

local SpawnLogEmpty = Instance.new("TextLabel")
SpawnLogEmpty.Size = UDim2.new(1, 0, 0, 30)
SpawnLogEmpty.BackgroundTransparency = 1
SpawnLogEmpty.Text = "No eggs spawned yet..."
SpawnLogEmpty.TextColor3 = GetTheme().TextDim
SpawnLogEmpty.TextSize = 11
SpawnLogEmpty.Font = Enum.Font.GothamMedium
SpawnLogEmpty.Parent = SpawnLogScroll

local SpawnLogFrames = {}

local function RefreshSpawnLog()
	for _, frame in ipairs(SpawnLogFrames) do
		frame:Destroy()
	end
	SpawnLogFrames = {}
	if #EggSpawnLog == 0 then
		SpawnLogEmpty.Visible = true
		return
	end
	SpawnLogEmpty.Visible = false
	local Theme = GetTheme()
	for i, entry in ipairs(EggSpawnLog) do
		local Row = Instance.new("Frame")
		Row.Size = UDim2.new(1, 0, 0, 36)
		Row.BackgroundColor3 = i % 2 == 0 and Theme.CardHover or Theme.CardBg
		Row.BorderSizePixel = 0
		Row.Parent = SpawnLogScroll
		Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 8)

		-- Egg image
		local Img = Instance.new("ImageLabel")
		Img.Size = UDim2.fromOffset(24, 24)
		Img.Position = UDim2.fromOffset(4, 6)
		Img.BackgroundTransparency = 1
		Img.Parent = Row
		local imgSrc = EggImages[entry.name] or ""
		if imgSrc ~= "" then
			Img.Image = imgSrc
			Img.ScaleType = Enum.ScaleType.Fit
		else
			Img.BackgroundColor3 = RarityColors[entry.rarity] or Theme.Accent
			Img.BackgroundTransparency = 0.3
		end

		-- Egg name + rarity
		local NameLbl = Instance.new("TextLabel")
		NameLbl.Size = UDim2.new(1, -90, 1, 0)
		NameLbl.Position = UDim2.fromOffset(32, 0)
		NameLbl.BackgroundTransparency = 1
		NameLbl.Text = entry.name
		NameLbl.TextColor3 = Theme.Text
		NameLbl.TextSize = 11
		NameLbl.Font = Enum.Font.GothamMedium
		NameLbl.TextXAlignment = Enum.TextXAlignment.Left
		NameLbl.Parent = Row

		-- Rarity tag
		local RarityLbl = Instance.new("TextLabel")
		RarityLbl.Size = UDim2.fromOffset(60, 16)
		RarityLbl.Position = UDim2.new(1, -110, 0, 10)
		RarityLbl.BackgroundTransparency = 1
		RarityLbl.Text = entry.rarity
		RarityLbl.TextColor3 = RarityColors[entry.rarity] or Theme.Text
		RarityLbl.TextSize = 9
		RarityLbl.Font = Enum.Font.GothamBold
		RarityLbl.Parent = Row

		-- Time
		local TimeStr = os.date("%H:%M:%S", entry.time)
		local TimeLbl = Instance.new("TextLabel")
		TimeLbl.Size = UDim2.fromOffset(50, 16)
		TimeLbl.Position = UDim2.new(1, -48, 0, 10)
		TimeLbl.BackgroundTransparency = 1
		TimeLbl.Text = TimeStr
		TimeLbl.TextColor3 = Theme.TextDim
		TimeLbl.TextSize = 9
		TimeLbl.Font = Enum.Font.GothamMedium
		TimeLbl.TextXAlignment = Enum.TextXAlignment.Right
		TimeLbl.Parent = Row

		table.insert(SpawnLogFrames, Row)
	end
end

-- Server section header
local ServerHeader = Instance.new("TextLabel")
ServerHeader.Size = UDim2.new(1, -8, 0, 20)
ServerHeader.BackgroundTransparency = 1
ServerHeader.Text = "Server"
ServerHeader.TextColor3 = GetTheme().TextDim
ServerHeader.TextSize = 11
ServerHeader.Font = Enum.Font.GothamBold
ServerHeader.TextXAlignment = Enum.TextXAlignment.Left
ServerHeader.Parent = SettingsTab

CreateActionButton(SettingsTab, "Rejoin Current Server", Color3.fromRGB(200, 140, 0), RejoinCurrentServer)
CreateActionButton(SettingsTab, "Server Hop (Low Players)", Color3.fromRGB(0, 160, 80), ServerHopLowPlayers)

--==================================================
-- PERFORMANCE TAB
--==================================================

local PerfLayout = Instance.new("UIListLayout")
PerfLayout.Padding = UDim.new(0, 8)
PerfLayout.Parent = PerfTab

local PerfHeader = Instance.new("TextLabel")
PerfHeader.Size = UDim2.new(1, -8, 0, 24)
PerfHeader.BackgroundTransparency = 1
PerfHeader.Text = "Tune scanning and visual performance"
PerfHeader.TextColor3 = GetTheme().TextDim
PerfHeader.TextSize = 11
PerfHeader.Font = Enum.Font.GothamMedium
PerfHeader.TextXAlignment = Enum.TextXAlignment.Left
PerfHeader.Parent = PerfTab

CreateSlider(PerfTab, "Scan Interval (ms)", "ScanInterval", 100, 3000, function(val) end)
CreateSlider(PerfTab, "ESP Max Distance", "ESPMaxDistance", 100, 2000, function(val)
	for _, Info in pairs(EggESP) do
		if Info.gui then Info.gui.MaxDistance = val end
	end
end)
CreateSlider(PerfTab, "Notify Duration (s)", "NotifyDuration", 2, 10, function(val) end)
CreateSlider(PerfTab, "Max Spawn Log Entries", "MaxSpawnLogEntries", 5, 50, function(val) end)

CreateToggle(PerfTab, "Low Quality Mode", "LowQualityMode", function(val)
	if val then
		for _, Info in pairs(EggESP) do
			if Info.gui then Info.gui.MaxDistance = 200 end
		end
	else
		for _, Info in pairs(EggESP) do
			if Info.gui then Info.gui.MaxDistance = Settings.ESPMaxDistance end
		end
	end
end)

CreateToggle(PerfTab, "Disable Particles", "DisableParticles", function(val)
	for _, descendant in ipairs(workspace:GetDescendants()) do
		if descendant:IsA("ParticleEmitter") then
			descendant.Enabled = not val
		end
	end
end)

--==================================================
-- WINDOW CONTROLS (MINIMIZE / CLOSE / DRAG)
--==================================================

local Minimized = false
Minimize.MouseButton1Click:Connect(function()
	Minimized = not Minimized
	if Minimized then
		TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(680, 52)}):Play()
	else
		TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(680, 500)}):Play()
	end
end)

Close.MouseButton1Click:Connect(function()
	GUI:Destroy()
	NotifyGui:Destroy()
	StopFly()
	for Egg, _ in pairs(EggESP) do
		RemoveESP(Egg)
	end
end)

-- Dragging
local Dragging = false
local DragStart = nil
local StartPos = nil
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
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = false
	end
end)

--==================================================
-- FLY RENDER LOOP
--==================================================

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

--==================================================
-- SCAN LOOP
--==================================================

task.spawn(function()
	while true do
		if Settings.RadarEnabled then
			ScanEggs()
		end
		UpdateStatus()
		if NeedsTPListUpdate then
			NeedsTPListUpdate = false
			RefreshTPList()
		end
		if NeedsSpawnLogUpdate then
			NeedsSpawnLogUpdate = false
			RefreshSpawnLog()
		end
		local interval = Settings.ScanInterval / 1000
		if Settings.LowQualityMode then interval = math.max(interval, 1) end
		task.wait(interval)
	end
end)

-- Initial scan
ScanEggs()
ApplyTheme(Settings.CurrentTheme)
UpdateStatus()

print("Ride A Pet Ultra Hub V9 Loaded (Modern UI + Performance Tab + Egg Spawn Log)")
