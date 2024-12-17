
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

--Global Variables i cant be bothered to place anywhere else--
local ESPColour = Color3.fromRGB(255, 0, 0)

local Window = Fluent:CreateWindow({
    Title = "Shaped Hub",
    SubTitle = " by reshapedd",
    TabWidth = 100,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Aqua",
    MinimizeKey = Enum.KeyCode.RightControl
})

--https://lucide.dev/icons/ for the tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Player", Icon = "user" }),
	ESP = Window:AddTab({ Title = "ESP", Icon = "target"}),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options





--Main Tab Code--

do
	--Needed Variables--
	local player = game.workspace.reshapedd
	local humanoid = player:WaitForChild("Humanoid")
	local players = game.Players:GetPlayers()



    Tabs.Main:AddParagraph({
        Title = "Player Modifers",
        Content = "These modify Player properties.\ne.g. Walkspeed, Jumppower"
    })



    Tabs.Main:AddButton({
        Title = "Button",
        Description = "Very important button",
        Callback = function()
            Window:Dialog({
                Title = "Title",
                Content = "This is a dialog",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            print("Confirmed the dialog.")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Cancelled the dialog.")
                        end
                    }
                }
            })
        end
    })



    local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Fly", Default = false })

    Toggle:OnChanged(function()
        print("Fly Toggle changed:", Options.MyToggle.Value)
    end)

    Options.MyToggle:SetValue(false)


    
    local WalkspeedSlider = Tabs.Main:AddSlider("Slider", {
        Title = "Walkspeed",
        Description = "Modifies Character Walkspeed. Base is 18",
        Default = 2,
        Min = 0,
        Max = 250,
        Rounding = 0,
        Callback = function(Value)
            print("Slider was changed:", Value)
        end
    })

    WalkspeedSlider:OnChanged(function(Value)
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
        humanoid.JumpPower = Value
    end)

    JumpowerSlider:SetValue(50)



    local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
        Title = "Dropdown",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = false,
        Default = 1,
    })

    Dropdown:SetValue("four")

    Dropdown:OnChanged(function(Value)
        print("Dropdown changed:", Value)
    end)


    
    local MultiDropdown = Tabs.Main:AddDropdown("MultiDropdown", {
        Title = "Dropdown",
        Description = "You can select multiple values.",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = true,
        Default = {"seven", "twelve"},
    })

    MultiDropdown:SetValue({
        three = true,
        five = true,
        seven = false
    })

    MultiDropdown:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        print("Mutlidropdown changed:", table.concat(Values, ", "))
    end)



    local Colorpicker = Tabs.Main:AddColorpicker("Colorpicker", {
        Title = "Colorpicker",
        Default = Color3.fromRGB(96, 205, 255)
    })

    Colorpicker:OnChanged(function()
        print("Colorpicker changed:", Colorpicker.Value)
    end)
    
    Colorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))



    local Keybind = Tabs.Main:AddKeybind("Keybind", {
        Title = "KeyBind",
        Mode = "Toggle", -- Always, Toggle, Hold
        Default = "LeftControl", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

        -- Occurs when the keybind is clicked, Value is `true`/`false`
        Callback = function(Value)
            print("Keybind clicked!", Value)
        end,

        -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
        ChangedCallback = function(New)
            print("Keybind changed!", New)
        end
    })

    -- OnClick is only fired when you press the keybind and the mode is Toggle
    -- Otherwise, you will have to use Keybind:GetState()
    Keybind:OnClick(function()
        print("Keybind clicked:", Keybind:GetState())
    end)

    Keybind:OnChanged(function()
        print("Keybind changed:", Keybind.Value)
    end)

    task.spawn(function()
        while true do
            wait(1)

            -- example for checking if a keybind is being pressed
            local state = Keybind:GetState()
            if state then
                print("Keybind is being held down")
            end

            if Fluent.Unloaded then break end
        end
    end)

    Keybind:SetValue("MB2", "Toggle") -- Sets keybind to MB2, mode to Hold


    local Input = Tabs.Main:AddInput("Input", {
        Title = "TP to player",
        Default = "",
        Placeholder = "(Case Sensitive)",
        Numeric = false, -- Only allows numbers
        Finished = true, -- Only calls callback when you press enter
        Callback = function(Value)
            print("Input changed:", Value)
        end
    })

    Input:OnChanged(function()
        local rootPart = game.workspace.reshapedd.HumanoidRootPart
		local targetname = Input.Value
		local targetplayer = game.workspace:FindFirstChild(targetname)
		if targetplayer and targetplayer:FindFirstChild("HumanoidRootPart") then
    		local tpRootPart = targetplayer.HumanoidRootPart
    		rootPart.CFrame = tpRootPart.CFrame
		
		elseif targetplayer and not targetplayer:FindFirstChild("HumanoidRootPart") then
			Fluent:Notify({
        		Title = "Failed to find Player",
        		Content = "Check you typed in the name correctly",
        		SubContent = "Ignore this message if you get it on startup, this is just a bug",
        		Duration = 3 -- Set to nil to make the notification not disappear
    		})
		end
    end)
end






--ESP Tab code--

do
	--Variables--
	local RunService = game:GetService("RunService")

	Tabs.ESP:AddParagraph({
        Title = "ESP",
        Content = "Allows you to see extra information about players around you"
    })


	local ESPToggle = Tabs.ESP:AddToggle("ESPToggle", {Title = "Toggle ESP", Default = false })

    ESPToggle:OnChanged(function()
		local Players = game:GetService("Players")
		local esp = Instance.new("Highlight")
		esp.Name = "ESP"

		local function applyESP(character)
			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart and not humanoidRootPart:FindFirstChild("ESP") then
				local espClone = esp:Clone()
				espClone.Adornee = character
				espClone.Parent = humanoidRootPart
				espClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				espClone.FillColor = ESPColour
				print("ESP applied to", character.Name)
			end
		end

		local function onCharacterAdded(player)
    		if player.Character then
        		applyESP(player.Character)
    		end
   			player.CharacterAdded:Connect(function(character)
        		applyESP(character)
    		end)
		end

		for _, player in ipairs(Players:GetPlayers()) do
    		onCharacterAdded(player)
		end

		Players.PlayerAdded:Connect(function(player)
    		onCharacterAdded(player)
		end)

		while ESPToggle.Value == true do
			for _, player in ipairs(Players:GetPlayers()) do
        		if player.Character then
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

		local function refreshESPColors()
			for _, player in ipairs(Players:GetPlayers()) do
				if player.Character then
					for _, highlight in ipairs(player.Character:GetDescendants()) do
						if highlight:IsA("Highlight") and highlight.Name == "ESP" then
							highlight.FillColor = ESPColour
						end
					end
				end
			end
		end

		RunService.Heartbeat:Connect(function()
    		refreshESPColors()
		end)
    end)


    Options.ESPToggle:SetValue(false)




	local ESPColourpicker = Tabs.ESP:AddColorpicker("ESPColour", {
        Title = "ESP Colour Changer",
        Description = "Change the ESP colour",
        Default = Color3.fromRGB(255, 0, 0)
    })

    ESPColourpicker:OnChanged(function()
		ESPColour = ESPColourpicker.Value
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