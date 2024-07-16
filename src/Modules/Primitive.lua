--[[

	AirHub V2 by Exunys © CC0 1.0 Universal (2023 - 2024)
	https://github.com/Exunys

	[i] Degraded version to support weaker / free exploits

]]

--// Loaded Check

if AirHubV2Loaded or AirHub then
	return
end

--// Cache

local game = game
local loadstring, typeof, select, next, pcall, tostring = loadstring, typeof, select, next, pcall, tostring
local tablefind, tablesort = table.find, table.sort
local mathfloor = math.floor
local stringgsub, stringmatch, stringbyte = string.gsub, string.match, string.byte
local wait, delay, spawn = task.wait, task.delay, task.spawn
local osdate = os.date

local UserInputService = game:GetService("UserInputService")

--// Launching

loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Roblox-Functions-Library/main/Library.lua"))()

local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/AirHub-V2/main/src/UI%20Libraries/UI%20Library%202.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/ESP.lua"))()
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src/Aimbot.lua"))()

repeat wait() until ESP and Aimbot
repeat wait() until ESP.Load

--// Variables

local MainFrame = GUI:CreateWindow({WindowName = "AirHub V2", Color = Color3.fromRGB(150, 100, 150), Keybind = Enum.KeyCode.RightShift}, game.CoreGui)

local ESP_DeveloperSettings = ESP.DeveloperSettings
local ESP_Settings = ESP.Settings
local ESP_Properties = ESP.Properties
local Crosshair = ESP_Properties.Crosshair
local CenterDot = Crosshair.CenterDot

local Aimbot_DeveloperSettings = Aimbot.DeveloperSettings
local Aimbot_Settings = Aimbot.Settings
local Aimbot_FOV = Aimbot.FOVSettings

ESP_Settings.LoadConfigOnLaunch = false
ESP_Settings.Enabled = false
Crosshair.Enabled = false
Aimbot_Settings.Enabled = false

local Fonts = {"Roboto", "Legacy", "SourceSans", "RobotoMono"}
local TracerPositions = {"Bottom", "Center", "Mouse"}
local HealthBarPositions = {"Top", "Bottom", "Left", "Right"}

--// Tabs

local General = MainFrame:CreateTab("General")
local _Aimbot = MainFrame:CreateTab("Aimbot")
local _ESP = MainFrame:CreateTab("ESP")
local _Crosshair = MainFrame:CreateTab("Crosshair")
local Settings = MainFrame:CreateTab("Settings")

--// Functions

local FixName = function(Name)
	return stringgsub(Name, "(%l)(%u)", function(...)
		return select(1, ...).." "..select(2, ...)
	end)
end

local FixKey = function(Key)
	return string.match(tostring(Key), "Enum%.[[KeyCode]*[UserInputType]*]*%.(%w+)")
end

local AddValues = function(Section, Object, Exceptions)
	local Keys, Copy = {}, {}

	for Index, _ in next, Object do
		Keys[#Keys + 1] = Index
	end

	tablesort(Keys, function(A, B)
		return A < B
	end)

	for _, Value in next, Keys do
		Copy[Value] = Object[Value]
	end

	for Index, Value in next, Copy do
		if typeof(Value) ~= "boolean" or (Exceptions and tablefind(Exceptions, Index)) then
			continue
		end

		Section:CreateToggle({
			Name = FixName(Index),
			Default = Value,
			Callback = function(_Value)
				Object[Index] = _Value
			end
		})
	end

	for Index, Value in next, Copy do
		if typeof(Value) ~= "Color3" or (Exceptions and tablefind(Exceptions, Index)) then
			continue
		end

		Section:CreateColorpicker({
			Name = FixName(Index),
			Default = Value,
			Callback = function(_Value)
				Object[Index] = _Value
			end
		})
	end
end

--// General Tab

local AimbotSection = General:CreateSection("Aimbot Settings")
local ESPSection = General:CreateSection("ESP Settings")
local ESPDeveloperSection = General:CreateSection("ESP Developer Settings")

AddValues(ESPDeveloperSection, ESP_DeveloperSettings, {})

ESPDeveloperSection:CreateDropdown({
	Name = "Update Mode",
	Flag = "ESP_UpdateMode",
	Content = {"RenderStepped", "Stepped", "Heartbeat"},
	Default = ESP_DeveloperSettings.UpdateMode,
	Callback = function(Value)
		ESP_DeveloperSettings.UpdateMode = Value
	end
})

ESPDeveloperSection:CreateDropdown({
	Name = "Team Check Option",
	Flag = "ESP_TeamCheckOption",
	Content = {"TeamColor", "Team"},
	Default = ESP_DeveloperSettings.TeamCheckOption,
	Callback = function(Value)
		ESP_DeveloperSettings.TeamCheckOption = Value
	end
})

ESPDeveloperSection:CreateSlider({
	Name = "Rainbow Speed",
	Flag = "ESP_RainbowSpeed",
	Default = ESP_DeveloperSettings.RainbowSpeed * 10,
	Min = 5,
	Max = 30,
	Callback = function(Value)
		ESP_DeveloperSettings.RainbowSpeed = Value / 10
	end
})

ESPDeveloperSection:CreateSlider({
	Name = "Width Boundary",
	Flag = "ESP_WidthBoundary",
	Default = ESP_DeveloperSettings.WidthBoundary * 10,
	Min = 5,
	Max = 30,
	Callback = function(Value)
		ESP_DeveloperSettings.WidthBoundary = Value / 10
	end
})

ESPDeveloperSection:CreateButton({
	Name = "Refresh",
	Callback = function()
		ESP:Restart()
	end
})

AddValues(ESPSection, ESP_Settings, {"LoadConfigOnLaunch", "PartsOnly"})

AimbotSection:CreateToggle({
	Name = "Enabled",
	Flag = "Aimbot_Enabled",
	Default = Aimbot_Settings.Enabled,
	Callback = function(Value)
		Aimbot_Settings.Enabled = Value
	end
})

AddValues(AimbotSection, Aimbot_Settings, {"Enabled", "Toggle", "OffsetToMoveDirection"})

local AimbotDeveloperSection = General:CreateSection("Aimbot Developer Settings")

AimbotDeveloperSection:CreateDropdown({
	Name = "Update Mode",
	Flag = "Aimbot_UpdateMode",
	Content = {"RenderStepped", "Stepped", "Heartbeat"},
	Default = Aimbot_DeveloperSettings.UpdateMode,
	Callback = function(Value)
		Aimbot_DeveloperSettings.UpdateMode = Value
	end
})

AimbotDeveloperSection:CreateDropdown({
	Name = "Team Check Option",
	Flag = "Aimbot_TeamCheckOption",
	Content = {"TeamColor", "Team"},
	Default = Aimbot_DeveloperSettings.TeamCheckOption,
	Callback = function(Value)
		Aimbot_DeveloperSettings.TeamCheckOption = Value
	end
})

AimbotDeveloperSection:CreateSlider({
	Name = "Rainbow Speed",
	Flag = "Aimbot_RainbowSpeed",
	Default = Aimbot_DeveloperSettings.RainbowSpeed * 10,
	Min = 5,
	Max = 30,
	Callback = function(Value)
		Aimbot_DeveloperSettings.RainbowSpeed = Value / 10
	end
})

AimbotDeveloperSection:CreateButton({
	Name = "Refresh",
	Callback = function()
		Aimbot.Restart()
	end
})

--// Aimbot Tab

local AimbotPropertiesSection = _Aimbot:CreateSection("Properties")

AimbotPropertiesSection:CreateToggle({
	Name = "Toggle",
	Flag = "Aimbot_Toggle",
	Default = Aimbot_Settings.Toggle,
	Callback = function(Value)
		Aimbot_Settings.Toggle = Value
	end
})

AimbotPropertiesSection:CreateToggle({
	Name = "Offset To Move Direction",
	Flag = "Aimbot_OffsetToMoveDirection",
	Default = Aimbot_Settings.OffsetToMoveDirection,
	Callback = function(Value)
		Aimbot_Settings.OffsetToMoveDirection = Value
	end
})

AimbotPropertiesSection:CreateSlider({
	Name = "Offset Increment",
	Flag = "Aimbot_OffsetIncrementy",
	Default = Aimbot_Settings.OffsetIncrement,
	Min = 1,
	Max = 30,
	Callback = function(Value)
		Aimbot_Settings.OffsetIncrement = Value
	end
})

AimbotPropertiesSection:CreateSlider({
	Name = "Animation Sensitivity (ms)",
	Flag = "Aimbot_Sensitivity",
	Default = Aimbot_Settings.Sensitivity * 100,
	Min = 0,
	Max = 100,
	Callback = function(Value)
		Aimbot_Settings.Sensitivity = Value / 100
	end
})

AimbotPropertiesSection:CreateSlider({
	Name = "mousemoverel Sensitivity",
	Flag = "Aimbot_Sensitivity2",
	Default = Aimbot_Settings.Sensitivity2 * 100,
	Min = 0,
	Max = 500,
	Callback = function(Value)
		Aimbot_Settings.Sensitivity2 = Value / 100
	end
})

AimbotPropertiesSection:CreateDropdown({
	Name = "Lock Mode",
	Flag = "Aimbot_Settings_LockMode",
	Content = {"CFrame", "mousemoverel"},
	Default = Aimbot_Settings.LockMode == 1 and "CFrame" or "mousemoverel",
	Callback = function(Value)
		Aimbot_Settings.LockMode = Value == "CFrame" and 1 or 2
	end
})

AimbotPropertiesSection:CreateDropdown({
	Name = "Lock Part",
	Flag = "Aimbot_LockPart",
	Content = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "LowerTorso", "RightUpperLeg"},
	Default = Aimbot_Settings.LockPart,
	Callback = function(Value)
		Aimbot_Settings.LockPart = Value
	end
})

local KeyboardInputs, KeyboardKey, MouseKey = false, Enum.KeyCode.E, Enum.UserInputType.MouseButton2

AimbotPropertiesSection:CreateDropdown({
	Name = "Trigger Key Input Type",
	Content = {"Keyboard", "Mouse"},
	Default = KeyboardInputs == true and "Keyboard" or "Mouse",
	Callback = function(Value)
		KeyboardInputs = Value == "Keyboard"
		Aimbot_Settings.TriggerKey = KeyboardInputs and KeyboardKey or MouseKey
	end
})

AimbotPropertiesSection:CreateLabel("Trigger Key (Mouse)", true)
local MouseLabel = AimbotPropertiesSection:CreateLabel("Mouse Keybind: "..FixKey(MouseKey), true)

local _MouseButton = AimbotPropertiesSection:CreateButton({
	Name = "Press to record",
	Callback = function() end
})

_MouseButton:ChangeCallback(function()
	Recording = true
	_MouseButton:SetText("...")
	MouseLabel:UpdateText("Mouse Keybind: RECORDING...")
end)

UserInputService.InputBegan:Connect(function(Input)
	if Input.UserInputType.Value ~= 4 and Recording then
		Recording = false
		MouseKey = Input.UserInputType
		_MouseButton:SetText("Press to record")
		MouseLabel:UpdateText("Mouse Keybind: "..FixKey(Input.UserInputType))

		Aimbot_Settings.TriggerKey = KeyboardInputs and KeyboardKey or MouseKey
	end
end)

AimbotPropertiesSection:CreateTextBox({
	Name = "Trigger Key (Keyboard)",
	Flag = "Aimbot_TriggerKey",
	--Default = tostring(Aimbot_Settings.TriggerKey),
	Placeholder = "Enum.KeyCode[<USER_INPUT>]",
	Callback = function(Keybind)
		for _, Keycode in Enum.KeyCode:GetEnumItems() do
			if Keycode.Value == stringbyte(Keybind, 1, 1) then
				KeyboardKey = Keycode
				Aimbot_Settings.TriggerKey = KeyboardInputs and KeyboardKey or MouseKey
			end
		end
	end
})

local Username

local UserBox = AimbotPropertiesSection:CreateTextBox({
	Name = "Player Name (shortened allowed)",
	Placeholder = "Username",
	Callback = function(Value)
		Username = Value
	end,
})

AimbotPropertiesSection:CreateButton({
	Name = "Blacklist (Ignore) Player",
	Callback = function()
		pcall(Aimbot.Blacklist, Aimbot, Username)
		UserBox:SetValue("")
	end
})

AimbotPropertiesSection:CreateButton({
	Name = "Whitelist Player",
	Callback = function()
		pcall(Aimbot.Whitelist, Aimbot, Username)
		UserBox:SetValue("")
	end
})

local AimbotFOVSection = _Aimbot:CreateSection("Field Of View Settings")

AddValues(AimbotFOVSection, Aimbot_FOV, {})

AimbotFOVSection:CreateSlider({
	Name = "Field Of View",
	Flag = "Aimbot_FOV_Radius",
	Default = Aimbot_FOV.Radius,
	Min = 0,
	Max = 720,
	Callback = function(Value)
		Aimbot_FOV.Radius = Value
	end
})

AimbotFOVSection:CreateSlider({
	Name = "Sides",
	Flag = "Aimbot_FOV_NumSides",
	Default = Aimbot_FOV.NumSides,
	Min = 3,
	Max = 60,
	Callback = function(Value)
		Aimbot_FOV.NumSides = Value
	end
})

AimbotFOVSection:CreateSlider({
	Name = "Transparency",
	Flag = "Aimbot_FOV_Transparency",
	Default = Aimbot_FOV.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		Aimbot_FOV.Transparency = Value / 10
	end
})

AimbotFOVSection:CreateSlider({
	Name = "Thickness",
	Flag = "Aimbot_FOV_Thickness",
	Default = Aimbot_FOV.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		Aimbot_FOV.Thickness = Value
	end
})

--// ESP Tab

local ESP_Properties_Section = _ESP:CreateSection("ESP Properties")

AddValues(ESP_Properties_Section, ESP_Properties.ESP, {})

ESP_Properties_Section:CreateDropdown({
	Name = "Text Font",
	Flag = "ESP_TextFont",
	Content = Fonts,
	Default = Fonts[ESP_Properties.ESP.Font + 1],
	Callback = function(Value)
		ESP_Properties.ESP.Font = Drawing.Fonts[Value]
	end
})

ESP_Properties_Section:CreateSlider({
	Name = "Transparency",
	Flag = "ESP_TextTransparency",
	Default = ESP_Properties.ESP.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.ESP.Transparency = Value / 10
	end
})

ESP_Properties_Section:CreateSlider({
	Name = "Font Size",
	Flag = "ESP_FontSize",
	Default = ESP_Properties.ESP.Size,
	Min = 1,
	Max = 20,
	Callback = function(Value)
		ESP_Properties.ESP.Size = Value
	end
})

ESP_Properties_Section:CreateSlider({
	Name = "Offset",
	Flag = "ESP_Offset",
	Default = ESP_Properties.ESP.Offset,
	Min = 10,
	Max = 30,
	Callback = function(Value)
		ESP_Properties.ESP.Offset = Value
	end
})

local Tracer_Properties_Section = _ESP:CreateSection("Tracer Properties")

AddValues(Tracer_Properties_Section, ESP_Properties.Tracer, {})

Tracer_Properties_Section:CreateDropdown({
	Name = "Position",
	Flag = "Tracer_Position",
	Content = TracerPositions,
	Default = TracerPositions[ESP_Properties.Tracer.Position],
	Callback = function(Value)
		ESP_Properties.Tracer.Position = tablefind(TracerPositions, Value)
	end
})

Tracer_Properties_Section:CreateSlider({
	Name = "Transparency",
	Flag = "Tracer_Transparency",
	Default = ESP_Properties.Tracer.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Tracer.Transparency = Value / 10
	end
})

Tracer_Properties_Section:CreateSlider({
	Name = "Thickness",
	Flag = "Tracer_Thickness",
	Default = ESP_Properties.Tracer.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.Tracer.Thickness = Value
	end
})

local HeadDot_Properties_Section = _ESP:CreateSection("Head Dot Properties")

AddValues(HeadDot_Properties_Section, ESP_Properties.HeadDot, {}, "HeadDot_Properties_")

HeadDot_Properties_Section:CreateSlider({
	Name = "Transparency",
	Flag = "HeadDot_Transparency",
	Default = ESP_Properties.HeadDot.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.HeadDot.Transparency = Value / 10
	end
})

HeadDot_Properties_Section:CreateSlider({
	Name = "Thickness",
	Flag = "HeadDot_Thickness",
	Default = ESP_Properties.HeadDot.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.HeadDot.Thickness = Value
	end
})

HeadDot_Properties_Section:CreateSlider({
	Name = "Sides",
	Flag = "HeadDot_Sides",
	Default = ESP_Properties.HeadDot.NumSides,
	Min = 3,
	Max = 30,
	Callback = function(Value)
		ESP_Properties.HeadDot.NumSides = Value
	end
})

local Chams_Properties_Section = _ESP:CreateSection("Chams Properties")

AddValues(Chams_Properties_Section, ESP_Properties.Chams, {}, "Chams_Properties_")

Chams_Properties_Section:CreateSlider({
	Name = "Transparency",
	Flag = "Chams_Transparency",
	Default = ESP_Properties.Chams.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Chams.Transparency = Value / 10
	end
})

Chams_Properties_Section:CreateSlider({
	Name = "Thickness",
	Flag = "Chams_Thickness",
	Default = ESP_Properties.Chams.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.Chams.Thickness = Value
	end
})

local Box_Properties_Section = _ESP:CreateSection("Box Properties")

AddValues(Box_Properties_Section, ESP_Properties.Box, {}, "Box_Properties_")

Box_Properties_Section:CreateSlider({
	Name = "Transparency",
	Flag = "Box_Transparency",
	Default = ESP_Properties.Box.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.Box.Transparency = Value / 10
	end
})

Box_Properties_Section:CreateSlider({
	Name = "Thickness",
	Flag = "Box_Thickness",
	Default = ESP_Properties.Box.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.Box.Thickness = Value
	end
})

local HealthBar_Properties_Section = _ESP:CreateSection("Health Bar Properties")

AddValues(HealthBar_Properties_Section, ESP_Properties.HealthBar, {}, "HealthBar_Properties_")

HealthBar_Properties_Section:CreateDropdown({
	Name = "Position",
	Flag = "HealthBar_Position",
	Content = HealthBarPositions,
	Default = HealthBarPositions[ESP_Properties.HealthBar.Position],
	Callback = function(Value)
		ESP_Properties.HealthBar.Position = tablefind(HealthBarPositions, Value)
	end
})

HealthBar_Properties_Section:CreateSlider({
	Name = "Transparency",
	Flag = "HealthBar_Transparency",
	Default = ESP_Properties.HealthBar.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		ESP_Properties.HealthBar.Transparency = Value / 10
	end
})

HealthBar_Properties_Section:CreateSlider({
	Name = "Thickness",
	Flag = "HealthBar_Thickness",
	Default = ESP_Properties.HealthBar.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		ESP_Properties.HealthBar.Thickness = Value
	end
})

HealthBar_Properties_Section:CreateSlider({
	Name = "Offset",
	Flag = "HealthBar_Offset",
	Default = ESP_Properties.HealthBar.Offset,
	Min = 4,
	Max = 12,
	Callback = function(Value)
		ESP_Properties.HealthBar.Offset = Value
	end
})

HealthBar_Properties_Section:CreateSlider({
	Name = "Blue",
	Flag = "HealthBar_Blue",
	Default = ESP_Properties.HealthBar.Blue,
	Min = 0,
	Max = 255,
	Callback = function(Value)
		ESP_Properties.HealthBar.Blue = Value
	end
})

--// Crosshair Tab

local Crosshair_Settings = _Crosshair:CreateSection("Crosshair Settings (1 / 2)")

Crosshair_Settings:CreateToggle({
	Name = "Enabled",
	Flag = "Crosshair_Enabled",
	Default = Crosshair.Enabled,
	Callback = function(Value)
		Crosshair.Enabled = Value
	end
})

do
	local CursorVisible = UserInputService.MouseIconEnabled

	Crosshair_Settings:CreateToggle({
		Name = "Disable Cursor",
		Flag = "Cursor_Enabled",
		Default = false,
		Callback = SetMouseIconVisibility
	})

	SetMouseIconVisibility(CursorVisible)
end

AddValues(Crosshair_Settings, Crosshair, {"Enabled"}, "Crosshair_")

Crosshair_Settings:CreateDropdown({
	Name = "Position",
	Flag = "Crosshair_Position",
	Content = {"Mouse", "Center"},
	Default = ({"Mouse", "Center"})[Crosshair.Position],
	Callback = function(Value)
		Crosshair.Position = Value == "Mouse" and 1 or 2
	end
})

Crosshair_Settings:CreateSlider({
	Name = "Size",
	Flag = "Crosshair_Size",
	Default = Crosshair.Size,
	Min = 1,
	Max = 24,
	Callback = function(Value)
		Crosshair.Size = Value
	end
})

Crosshair_Settings:CreateSlider({
	Name = "Gap Size",
	Flag = "Crosshair_GapSize",
	Default = Crosshair.GapSize,
	Min = 0,
	Max = 24,
	Callback = function(Value)
		Crosshair.GapSize = Value
	end
})

Crosshair_Settings:CreateSlider({
	Name = "Rotation (Degrees)",
	Flag = "Crosshair_Rotation",
	Default = Crosshair.Rotation,
	Min = -180,
	Max = 180,
	Callback = function(Value)
		Crosshair.Rotation = Value
	end
})

Crosshair_Settings:CreateSlider({
	Name = "Rotation Speed",
	Flag = "Crosshair_RotationSpeed",
	Default = Crosshair.RotationSpeed,
	Min = 1,
	Max = 20,
	Callback = function(Value)
		Crosshair.RotationSpeed = Value
	end
})

Crosshair_Settings:CreateSlider({
	Name = "Pulsing Step",
	Flag = "Crosshair_PulsingStep",
	Default = Crosshair.PulsingStep,
	Min = 0,
	Max = 24,
	Callback = function(Value)
		Crosshair.PulsingStep = Value
	end
})

local _Crosshair_Settings = _Crosshair:CreateSection("Crosshair Settings (2 / 2)")

_Crosshair_Settings:CreateSlider({
	Name = "Pulsing Speed",
	Flag = "Crosshair_PulsingSpeed",
	Default = Crosshair.PulsingSpeed,
	Min = 1,
	Max = 20,
	Callback = function(Value)
		Crosshair.PulsingSpeed = Value
	end
})

_Crosshair_Settings:CreateSlider({
	Name = "Pulsing Boundary (Min)",
	Flag = "Crosshair_Pulse_Min",
	Default = Crosshair.PulsingBounds[1],
	Min = 0,
	Max = 24,
	Callback = function(Value)
		Crosshair.PulsingBounds[1] = Value
	end
})

_Crosshair_Settings:CreateSlider({
	Name = "Pulsing Boundary (Max)",
	Flag = "Crosshair_Pulse_Max",
	Default = Crosshair.PulsingBounds[2],
	Min = 0,
	Max = 24,
	Callback = function(Value)
		Crosshair.PulsingBounds[2] = Value
	end
})

_Crosshair_Settings:CreateSlider({
	Name = "Transparency",
	Flag = "Crosshair_Transparency",
	Default = Crosshair.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		Crosshair.Transparency = Value / 10
	end
})

_Crosshair_Settings:CreateSlider({
	Name = "Thickness",
	Flag = "Crosshair_Thickness",
	Default = Crosshair.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		Crosshair.Thickness = Value
	end
})

local Crosshair_CenterDot = _Crosshair:CreateSection("Center Dot Settings")

Crosshair_CenterDot:CreateToggle({
	Name = "Enabled",
	Flag = "Crosshair_CenterDot_Enabled",
	Default = CenterDot.Enabled,
	Callback = function(Value)
		CenterDot.Enabled = Value
	end
})

AddValues(Crosshair_CenterDot, CenterDot, {"Enabled"}, "Crosshair_CenterDot_")

Crosshair_CenterDot:CreateSlider({
	Name = "Size / Radius",
	Flag = "Crosshair_CenterDot_Radius",
	Default = CenterDot.Radius,
	Min = 2,
	Max = 8,
	Callback = function(Value)
		CenterDot.Radius = Value
	end
})

Crosshair_CenterDot:CreateSlider({
	Name = "Sides",
	Flag = "Crosshair_CenterDot_Sides",
	Default = CenterDot.NumSides,
	Min = 3,
	Max = 30,
	Callback = function(Value)
		CenterDot.NumSides = Value
	end
})

Crosshair_CenterDot:CreateSlider({
	Name = "Transparency",
	Flag = "Crosshair_CenterDot_Transparency",
	Default = CenterDot.Transparency * 10,
	Min = 1,
	Max = 10,
	Callback = function(Value)
		CenterDot.Transparency = Value / 10
	end
})

Crosshair_CenterDot:CreateSlider({
	Name = "Thickness",
	Flag = "Crosshair_CenterDot_Thickness",
	Default = CenterDot.Thickness,
	Min = 1,
	Max = 5,
	Callback = function(Value)
		CenterDot.Thickness = Value
	end
})

--// Settings Tab

--[[
local SettingsSection = Settings:CreateSection("Settings")
local ProfilesSection = Settings:CreateSection("Profiles")
]]

local InformationSection = Settings:CreateSection("Information")
local ControlSection = Settings:CreateSection("Control Panel")

--[[

SettingsSection:CreateKeybind({
	Name = "Show / Hide GUI",
	Flag = "UI Toggle",
	Default = Enum.KeyCode.RightShift,
	Blacklist = {Enum.UserInputType.MouseCreateButton1, Enum.UserInputType.MouseCreateButton2, Enum.UserInputType.MouseCreateButton3},
	Callback = function(_, NewKeybind)
		if not NewKeybind then
			GUI:Close()
		end
	end
})

]]

InformationSection:CreateLabel("Made by Exunys")

InformationSection:CreateButton({
	Name = "Copy GitHub",
	Callback = function()
		setclipboard("https://github.com/Exunys")
	end
})

InformationSection:CreateLabel("AirTeam © 2022 - "..osdate("%Y"))

InformationSection:CreateButton({
	Name = "Copy Discord Invite",
	Callback = function()
		setclipboard("https://discord.gg/Ncz3H3quUZ")
	end
})

InformationSection:CreateLabel("Press \"RightShift\" to toggle the GUI on/off.")

ControlSection:CreateButton({
	Name = "Unload Script",
	Callback = function()
		ESP:Exit()
		Aimbot:Exit()
		getgenv().AirHubV2Loaded = nil
		MainFrame:DestroyGUI()
	end
})

--//

ESP.Load()
Aimbot.Load()
getgenv().AirHubV2Loaded = true

local GUI_Toggled = true

UserInputService.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.RightShift then
		GUI_Toggled = not GUI_Toggled
		MainFrame:Toggle(GUI_Toggled)
	end
end)
