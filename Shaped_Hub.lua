
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

--Global Variables i cant be bothered to place anywhere else--

local Window = Fluent:CreateWindow({
    Title = "Shaped Hub",
    SubTitle = " by reshapedd",
    TabWidth = 120,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Aqua",
    MinimizeKey = Enum.KeyCode.RightControl
})

--https://lucide.dev/icons/ for the tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Player", Icon = "user" }),
	ESP = Window:AddTab({ Title = "ESP", Icon = "target"}),
    Game = Window:AddTab({ Title = "Game", Icon = "gamepad-2" }),
    Scripts = Window:AddTab({ Title = "Scripts", Icon = "folder-open" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options





--Main Tab Code--

do
	--Needed Variables--
	local player = game.Players.LocalPlayer
	local playerName = player.Name
	local humanoid = player.Character:FindFirstChild("Humanoid")
	local playerNames = {playerName}

 	local function updatePlayerNames()
        playerNames = {}
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player.Name ~= playerName then
                table.insert(playerNames, player.Name)
            end
        end
    end

    updatePlayerNames()

    game.Players.PlayerAdded:Connect(updatePlayerNames)
	game.Players.PlayerRemoving:Connect(updatePlayerNames)




    Tabs.Main:AddParagraph({
        Title = "Player Modifers",
        Content = "These modify Player properties.\ne.g. Walkspeed, Jumppower"
    })



    Tabs.Main:AddButton({
        Title = "Respawn Character",
        Description = "Respawns the Player",
        Callback = function()
            Window:Dialog({
                Title = "Are you sure?",
                Content = "This will respawn your character and bring you back to this position.",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            local lastPosition = nil
							humanoid.Health = 0
							humanoid.Died:Connect(function()
								if player.Character.HumanoidRootPart and player.Character.HumanoidRootPart.Parent then
									lastPosition = player.Character.HumanoidRootPart.CFrame

								end
							end)

							player.CharacterAdded:Connect(function(character)
								if character == player.Character then
									wait(0.1)
									local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
									if lastPosition then
										humanoidRootPart.CFrame = lastPosition
									end
								end
							end)
						end
						},
                    {
                        Title = "Cancel",
                        Callback = function()
                        end
                    }
                }
            })
        end
    })



    
    local WalkspeedSlider = Tabs.Main:AddSlider("Slider", {
        Title = "Walkspeed",
        Description = "Modifies Character Walkspeed. Base is 18",
        Default = 2,
        Min = 0,
        Max = 250,
        Rounding = 0,
    })

    WalkspeedSlider:OnChanged(function(Value)
        humanoid = player.Character:FindFirstChild("Humanoid")
        humanoid.WalkSpeed = Value
    end)

    WalkspeedSlider:SetValue(18)

	local JumpowerSlider = Tabs.Main:AddSlider("Slider", {
    	Title = "Jumpower",
        Description = "Modifies Character Jumpower. Base is 50",
        Default = 2,
        Min = 0,
        Max = 250,
        Rounding = 0,
    })

    JumpowerSlider:OnChanged(function(Value)
        local humanoid = player.Character:FindFirstChild("Humanoid")
        humanoid.JumpPower = Value
    end)

    JumpowerSlider:SetValue(50)



    local TPDropdown = Tabs.Main:AddDropdown("PlayerTP", {
        Title = "Teleport to Player",
        Values = playerNames,
        Multi = false,
		Default = playerName,
    })


    TPDropdown:OnChanged(function(Value)
        local rootPart = player.Character.HumanoidRootPart
		local targetname = Value
		local targetplayer = game.workspace:FindFirstChild(targetname)
		if targetplayer and targetplayer:FindFirstChild("HumanoidRootPart") then
    		local tpRootPart = targetplayer.HumanoidRootPart
    		rootPart.CFrame = tpRootPart.CFrame
		end
    end)
end






--ESP Tab code--

do
	--Variables--
	local RunService = game:GetService("RunService")
	local ESPColour = Color3.fromRGB(255, 0, 0)
    local localplayer = game.Players.LocalPlayer
	local playerName = localplayer.Name

	Tabs.ESP:AddParagraph({
        Title = "ESP",
        Content = "Allows you to see extra information about players around you"
    })


	local ESPToggle = Tabs.ESP:AddToggle("ESPToggle", {Title = "Toggle ESP", Default = false })

    ESPToggle:OnChanged(function()
		local Players = game:GetService("Players")
		local esp = Instance.new("Highlight")
		esp.Name = "ESP"
		esp.FillColor = ESPColour

		local function applyESP(character)
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart and not humanoidRootPart:FindFirstChild("ESP") then
				local espClone = esp:Clone()
				espClone.Adornee = character
				espClone.Parent = humanoidRootPart
				espClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			end
		end

		local function onCharacterAdded(player)
    		if player.Character then
                if (player.Name) ~= string.lower(playerName) then
                    applyESP(player.Character)
                end
    		end
   			player.CharacterAdded:Connect(function(character)
                if string.lower(player.Name) ~= string.lower(playerName) then
                    applyESP(character)
                end
    		end)
		end

		for _, player in ipairs(Players:GetPlayers()) do
            if string.lower(player.Name) ~= string.lower(playerName) then
                onCharacterAdded(player)
            end
		end

		Players.PlayerAdded:Connect(function(player)
            if string.lower(player.Name) ~= string.lower(playerName) then
                onCharacterAdded(player)
            end
		end)

		while ESPToggle.Value == true do
			for _, player in ipairs(Players:GetPlayers()) do
        		if player.Character and string.lower(player.Name) ~= string.lower(playerName) then
            		applyESP(player.Character)
        		end
    		end
    		wait(0.2)
		end


		if ESPToggle.Value == false then
			for _, descendant in ipairs(game.workspace:GetDescendants()) do
				if descendant:IsA("Highlight") then
					descendant:Destroy()
				end
			end
		end

		local function refreshESPColours()
			for _, player in ipairs(Players:GetPlayers()) do
				for _, highlight in ipairs(player:GetDescendants()) do
					if highlight:IsA("Highlight") and highlight.Name == "ESP" then
						highlight.FillColor = Color3.fromRGB(ESPColour)
					end
				end
			end
		end

		RunService.Heartbeat:Connect(function()
			refreshESPColours()
		end)

    end)


    Options.ESPToggle:SetValue(false)




	local ESPColourpicker = Tabs.ESP:AddColorpicker("ESPColour", {
        Title = "ESP Colour Changer",
        Description = "Change the ESP colour",
        Default = Color3.fromRGB(255, 0, 0)
    })

    ESPColourpicker:OnChanged(function(newColor)
		ESPColour = newColor
		--ESPColour = ESPColourpicker.Value
		for _, descendant in ipairs(game.Workspace:GetDescendants()) do
        	if descendant:IsA("Highlight") and descendant.Name == "ESP" then
            	descendant.FillColor = ESPColour
       		end
    	end
    end)

end

















-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Shaped Hub",
    Content = "Thank you for using shaped hub",
    Duration = 8
})


-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
