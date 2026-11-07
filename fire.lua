local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if RunService:IsServer() then
    local TriggerbotEvent = Instance.new("RemoteEvent")
    TriggerbotEvent.Name = "TriggerbotEvent"
    TriggerbotEvent.Parent = ReplicatedStorage

    local CrosshairEvent = Instance.new("RemoteEvent")
    CrosshairEvent.Name = "CrosshairEvent"
    CrosshairEvent.Parent = ReplicatedStorage

    local triggerbotEnabled = {}

    local function onPlayerAdded(player)
        triggerbotEnabled[player.UserId] = false
    end

    local function onPlayerRemoving(player)
        triggerbotEnabled[player.UserId] = nil
    end

    Players.PlayerAdded:Connect(onPlayerAdded)
    Players.PlayerRemoving:Connect(onPlayerRemoving)

    for _, player in pairs(Players:GetPlayers()) do
        onPlayerAdded(player)
    end

    TriggerbotEvent.OnServerEvent:Connect(function(player, enabled)
        triggerbotEnabled[player.UserId] = enabled
    end)

    CrosshairEvent.OnServerEvent:Connect(function(player, size, color)
        -- Handle crosshair update
    end)
else
    local TriggerbotEvent = ReplicatedStorage:WaitForChild("TriggerbotEvent")
    local CrosshairEvent = ReplicatedStorage:WaitForChild("CrosshairEvent")

    local orion = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
    local Window = orion:MakeWindow({Name = "Triggerbot", HidePremium = false})

    local triggerbotEnabled = false
    local crosshairEnabled = false

    local triggerbotToggle = Window:MakeToggle({
        Name = "Triggerbot",
        Icon = "rbxassetid://4482365853",
        Callback = function(enabled)
            triggerbotEnabled = enabled
            TriggerbotEvent:FireServer(enabled)
        end
    })

    local crosshairSize = 10
    local crosshairColor = Color3.new(1, 1, 1)

    local crosshairToggle = Window:MakeToggle({
        Name = "Crosshair",
        Icon = "rbxassetid://4482365853",
        Callback = function(enabled)
            crosshairEnabled = enabled
            if enabled then
                local crosshair = Instance.new("Drawings")
                crosshair.Name = "Crosshair"
                crosshair.Visible = true
                crosshair.Color = crosshairColor
                crosshair.Thickness = 2
                crosshair.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                crosshair.Size = crosshairSize

                RunService.RenderStepped:Connect(function()
                    crosshair.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                end)
            else
                -- Remove crosshair
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name == "Crosshair" and v:IsA("Drawing") then
                        v:Remove()
                    end
                end
            end
        end
    })

    local function onRenderStepped()
        if triggerbotEnabled then
            local mouse = UserInputService:GetMouseLocation()
            local ray = workspace:FindPartOnRay(Ray.new(mouse, Vector3.new(0, 0, -1000)))
            if ray and ray.Parent:FindFirstChild("Humanoid") then
                local player = Players:GetPlayerFromCharacter(ray.Parent)
                if player and player ~= Players.LocalPlayer then
                    -- Fire triggerbot event
                end
            end
        end
    end

    RunService.RenderStepped:Connect(onRenderStepped)
end
