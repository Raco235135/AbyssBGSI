-- Luna Initialization (unchanged)
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/main/source.lua", true))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NetworkRemote = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent
local NetworkFunction = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteFunction

-- Luna Window Setup (unchanged)
local Window = Luna:CreateWindow({
	Name = "Abyss BGSI",
	Subtitle = "The Ultimate BGSI Solution",
	LogoID = "82795327169782",
	LoadingEnabled = true,
	LoadingTitle = "Abyss BGSI",
	LoadingSubtitle = "",
	ConfigSettings = {
		RootFolder = nil,
		ConfigFolder = "AbyssBGSI"
	},
	KeySystem = false,
	KeySettings = {
		Title = "Luna Example Key",
		Subtitle = "Key System",
		Note = "Use HWID-based key system",
		SaveInRoot = false,
		SaveKey = true,
		Key = {"Example Key"},
		SecondAction = {
			Enabled = true,
			Type = "Link",
			Parameter = ""
		}
	}
})

-- Tab Setup
local ExploitsTab = Window:CreateTab({ Name = "Exploits", Icon = "alarm_add", ImageSource = "Material", ShowTitle = true })
local MinigamesTab = Window:CreateTab({ Name = "Minigames", Icon = "videogame_asset", ImageSource = "Material", ShowTitle = true })
local PotionsTab = Window:CreateTab({ Name = "Potions", Icon = "local_drink", ImageSource = "Material", ShowTitle = true })
local CompetitiveTab = Window:CreateTab({ Name = "Competitive", Icon = "badge", ImageSource = "Material", ShowTitle = true })
local MiscTab = Window:CreateTab({ Name = "Misc", Icon = "book", ImageSource = "Material", ShowTitle = true })
MinigamesTab:CreateSection("Configuration")

-- Utility for thread management
local function setupToggleThread(toggleFlagName, threadVarName, loopFunction, delay)
	_G[toggleFlagName] = false
	return function(Value)
		_G[toggleFlagName] = Value
		if Value then
			if _G[threadVarName] and coroutine.status(_G[threadVarName]) ~= "dead" then return end
			_G[threadVarName] = task.spawn(function()
				while _G[toggleFlagName] do
					loopFunction()
					task.wait(delay)
				end
			end)
		end
	end
end


--------------------------------------
--             Exploits
--------------------------------------

local eggType = "Basic"

-- Auto Claim Chests
local function chestsLoop()
	NetworkRemote:FireServer("ClaimChest", "Infinity Chest", true)
    task.wait(1)
	NetworkRemote:FireServer("ClaimChest", "Giant Chest", true)
    task.wait(1)
	NetworkRemote:FireServer("ClaimChest", "Void Chest", true)
    task.wait(1)
	NetworkRemote:FireServer("ClaimChest", "Ticket Chest", true)
    task.wait(1)
end

-- Auto Bubble
local function bubbleLoop()
	NetworkRemote:FireServer("BlowBubble")
end

-- Auto Sell
local function sellLoop()
	NetworkRemote:FireServer("SellBubble")
end

-- Auto Genie Quest
local function genieLoop()
	NetworkRemote:FireServer("StartGenieQuest", math.random(1, 3))
end

-- Auto Pass
local function passLoop()
	NetworkRemote:FireServer("ClaimSeason")
end

-- Auto Equip
local function equipLoop()
	NetworkRemote:FireServer("EquipBestPets")
end

-- Auto Playtime
local function playtimeLoop()
	NetworkRemote:FireServer("ClaimAllPlaytime")
end


-- Auto Wheel Spin
local function wheelLoop()
    NetworkFunction:InvokeServer("WheelSpin")
    task.wait()
    NetworkRemote:FireServer("ClaimWheelSpinQueue")
end


-- Auto Egg
local function eggLoop()
	NetworkRemote:FireServer("HatchEgg", eggType, 6)
end


ExploitsTab:CreateSection("Configuration")

ExploitsTab:CreateDropdown({
	Name = "Egg Type",
	Options = {"Basic Egg", "Spikey Egg", "Underworld Egg", "Mining Egg", "Infinity Egg"},
	CurrentOption = "Basic Egg",
	Callback = function(opt)
  		eggType = opt
	end
}, "eggTypeDropdown")

ExploitsTab:CreateSection("Toggles")

-- Auto Bubble Toggle
ExploitsTab:CreateToggle({
	Name = "Auto Bubble",
	Description = nil,
	CurrentValue = false,
	Callback = setupToggleThread("autoBubbleEnabled", "autoBubbleThread", bubbleLoop, 0.5)
}, "AutoBubbleToggle")

-- Auto Sell Toggle
ExploitsTab:CreateToggle({
	Name = "Auto Sell",
	Description = "NOTE: Must be near sell pad",
	CurrentValue = false,
	Callback = setupToggleThread("autoSellEnabled", "autoSellThread", sellLoop, 3)
}, "AutoSellToggle")

-- Auto Egg Toggle
ExploitsTab:CreateToggle({
	Name = "Auto Egg",
	Description = nil,
	CurrentValue = false,
	Callback = setupToggleThread("autoEggEnabled", "AutoEggThread", eggLoop, 0.3)
}, "AutoEggToggle")


-- Auto Claim Chests Toggle
ExploitsTab:CreateToggle({
	Name = "Auto Claim Chests",
	Description = "Requires level 15 mastery",
	CurrentValue = false,
	Callback = setupToggleThread("autoChestsEnabled", "autoChestsThread", chestsLoop, 3)
}, "AutoChestsToggle")

-- Auto Genie Quest Toggle
ExploitsTab:CreateToggle({
	Name = "Auto Genie Quest",
	Description = "Selects a random genie quest",
	CurrentValue = false,
	Callback = setupToggleThread("autoGenieEnabled", "autoGenieThread", genieLoop, 3)
}, "AutoGenieToggle")

-- Auto Equip Toggle
ExploitsTab:CreateToggle({
	Name = "Auto Equip",
	Description = "Automatically equip your best pets",
	CurrentValue = false,
	Callback = setupToggleThread("autoEquipEnabled", "autoEquipThread", equipLoop, 5)
}, "AutoEquipToggle")

-- Auto Pass Claim Toggle
ExploitsTab:CreateToggle({
	Name = "Auto Claim Pass",
	Description = nil,
	CurrentValue = false,
	Callback = setupToggleThread("autoPassEnabled", "autoPassThread", passLoop, 1)
}, "AutoPassToggle")

-- Auto Wheel Spin Toggle
ExploitsTab:CreateToggle({
	Name = "Auto Wheel Spin",
	Description = nil,
	CurrentValue = false,
	Callback = setupToggleThread("autoWheelEnabled", "autoWheelThread", wheelLoop, 0.2)
}, "AutoWheelToggle")

-- Auto Playtime Toggle
ExploitsTab:CreateToggle({
	Name = "Auto Playtime",
	Description = "NOTE: Requires Mastery",
	CurrentValue = false,
	Callback = setupToggleThread("autoPlaytimeEnabled", "autoPlaytimeThread", playtimeLoop, 3)
}, "AutoPlaytimeToggle")

--------------------------------------
--          Minigames
--------------------------------------

local _minigame = "Robot Claw"
local difficulty = "Easy"
local useTickets = false

MinigamesTab:CreateDropdown({
	Name = "Minigame Difficulty",
	Options = {"Easy", "Medium", "Hard", "Insane"},
	CurrentOption = "Easy",
	Callback = function(opt)
		difficulty = opt
	end
}, "difficultyDropdown")

MinigamesTab:CreateToggle({
	Name = "Use Tickets",
	Description = "Use super tickets to skip the cooldown",
	CurrentValue = false,
	Callback = function(Value) useTickets = Value end
}, "Toggle")
MinigamesTab:CreateSection("Toggles")

-- Auto Claw Loop
local function clawLoop()
	NetworkRemote:FireServer("StartMinigame", "Robot Claw", difficulty)
	task.wait(3)
	local clawMachine = workspace:FindFirstChild("ClawMachine")
	if not clawMachine then warn("ClawMachine not found."); task.wait(2); return end
	local collectPart = clawMachine:FindFirstChild("CollectPart")
	if not collectPart then warn("CollectPart not found."); task.wait(2); return end
	collectPart.Size = collectPart.Size * 10.5
	collectPart.Transparency = 0.2
	for _, child in pairs(clawMachine:GetChildren()) do
		if child.Name == "Capsule" and child:FindFirstChild("HitBox") then
			child.HitBox.Position = Vector3.new(
				collectPart.Position.X,
				collectPart.Position.Y + 2.5,
				collectPart.Position.Z
			)
			task.wait()
		end
	end
	task.wait(0.5)
	NetworkRemote:FireServer("FinishMinigame")
	task.wait(0.1)
	if useTickets then
		NetworkRemote:FireServer("SkipMinigameCooldown", "Robot Claw")
	end
end

local function petMatch()
	NetworkRemote:FireServer("StartMinigame", "Pet Match", difficulty)
	task.wait(7)
    NetworkRemote:FireServer("FinishMinigame")
    task.wait(0.5)

    if useTickets then
		NetworkRemote:FireServer("SkipMinigameCooldown", "Pet Match")
	end
end


-- Auto Doggy Loop
local function doggyLoop()
    NetworkRemote:FireServer("DoggyJumpWin", 3)
end


-- Auto Claw
MinigamesTab:CreateToggle({
	Name = "Auto Claw",
	Description = nil,
	CurrentValue = false,
	Callback = setupToggleThread("autoClawEnabled", "autoClawThread", clawLoop, 1)
}, "AutoClawToggle")

-- Auto Pet Match
MinigamesTab:CreateToggle({
	Name = "Auto Pet Match",
	Description = nil,
	CurrentValue = false,
	Callback = setupToggleThread("autoPetMatchEnabled", "autoPetMatchThread", petMatch, 1)
}, "AutoPetMatchToggle")


-- Auto Doggy
MinigamesTab:CreateToggle({
	Name = "Auto Doggy Jump",
	Description = nil,
	CurrentValue = false,
	Callback = setupToggleThread("autoDoggyEnabled", "autoDoggyThread", doggyLoop, 10)
}, "AutoDoggyToggle")

--------------------------------------
--             Potions
--------------------------------------

PotionsTab:CreateSection("Configuration")
local potionType = "Lucky"
local potionTier = "1"

-- Auto Potion Use
local function potionLoop()
    NetworkRemote:FireServer("UsePotion", potionType, tonumber(potionTier))
end

PotionsTab:CreateDropdown({
	Name = "Potion Type",
    Description = nil,
	Options = {"Lucky", "Speed", "Coins", "Mythic", "Tickets"},
    	CurrentOption = "Lucky",
    	MultipleOptions = false,
    	SpecialType = nil,
    	Callback = function(Options)
            potionType = Options
	end
}, "potionTypeDropdown") 

PotionsTab:CreateDropdown({
	Name = "Potion Tier",
    Description = "Tier 6 = Evolved",
	Options = {"1", "2", "3", "4", "5", "6"},
    	CurrentOption = "1",
    	MultipleOptions = false,
    	SpecialType = nil,
    	Callback = function(Options)
            potionTier = Options
	end
}, "potionTierDropdown") 

PotionsTab:CreateSection("Toggles")

-- Auto Potion Toggle
PotionsTab:CreateToggle({
	Name = "Auto Potion Use",
	Description = nil,
	CurrentValue = false,
	Callback = setupToggleThread("autoPotionEnabled", "autoPotionThread", potionLoop, 0.5)
}, "AutoPotionToggle")


--------------------------------------
--           Competitive
--------------------------------------

local plrService = game:GetService("Players")
local workspace = game:GetService("Workspace")

local tasksFrame = plrService.LocalPlayer.PlayerGui:WaitForChild("ScreenGui").Competitive.Frame.Content.Tasks
local gifts = workspace:WaitForChild("Rendered").Gifts

local validChallenges = {
    ["Hatch 50 Shiny Pets"] = true,
	["Hatch 1 Mythic Pet"] = true,
	["Hatch 2 Mythic Pets"] = true,
	["Hatch 5 Legendary Pets"] = true,
	["Hatch 200 Common Pets"] = true,
	["Hatch 120 Epic Pets"] = true
}

CompetitiveTab:CreateSection("General Information")

local firstQuestType = CompetitiveTab:CreateLabel({
	Text = "First Quest: ?",
	Style = 2 
})

local secondQuestType = CompetitiveTab:CreateLabel({
	Text = "Second Quest: ?",
	Style = 2
})


local function reRollLoop()
	for _, v in tasksFrame:GetChildren() do 
		if v.Name == "3" or v.Name == "4" then
			local currentChallenge = v.Content.Label.Text
			local currentPercent = v.Content.Bar.Label.Text
			local percentNumber = tonumber(currentPercent:match("%d+")) or 0

			if not validChallenges[currentChallenge] and percentNumber <= 50 then
				NetworkRemote:FireServer("CompetitiveReroll", tonumber(v.Name))
			else
				if v.Name == "3" then
					firstQuestType:Set("First Quest: " .. currentChallenge .. " (" .. currentPercent .. ")")
				else
					secondQuestType:Set("Second Quest: " .. currentChallenge .. " (" .. currentPercent .. ")")
				end
			end
		end
	end
end



local function presentLoop()
	NetworkRemote:FireServer("UseGift", "Mystery Box", 10)
	
	task.wait(1)
	for _, v in gifts:GetChildren() do
		NetworkRemote:FireServer("ClaimGift", v.Name)
	end
end



CompetitiveTab:CreateSection("Season 2")

CompetitiveTab:CreateToggle({
	Name = "Auto Reroll Quests",
	Description = nil,
	CurrentValue = false,
	Callback = setupToggleThread("autoReroll", "autoRerollThread", reRollLoop, 1)
}, "AutoRerollToggle")

CompetitiveTab:CreateToggle({
	Name = "Auto Present Open",
	Description = nil,
	CurrentValue = false,
	Callback = setupToggleThread("autoPresent", "autoPresentThread", presentLoop, 1)
}, "AutoPresentToggle")



--------------------------------------
--              Misc
--------------------------------------

-- Anti AFK Loop
local function afkLoop()
	local virtualUser = game:GetService("VirtualUser")

	virtualUser:CaptureController()
    virtualUser:ClickButton2(Vector2.new())
end

-- Anti AFk
MiscTab:CreateToggle({
	Name = "Anti-AFK Kick",
	Description = nil,
	CurrentValue = false,
	Callback = setupToggleThread("antiAfk", "antiAfkThread", afkLoop, 20)
}, "AntiAfkToggle")



-- Destroy GUI Button
MiscTab:CreateButton({
	Name = "Destroy",
	Description = "NOTE: Does not toggle off scripts",
	Callback = function()
		Luna:Destroy()
	end
})

