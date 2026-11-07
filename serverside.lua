local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TriggerbotEvent = Instance.new("RemoteEvent")
TriggerbotEvent.Name = "TriggerbotEvent"
TriggerbotEvent.Parent = ReplicatedStorage

local CrosshairEvent = Instance.new("RemoteEvent")
CrosshairEvent.Name = "CrosshairEvent"
CrosshairEvent.Parent = ReplicatedStorage

local Players = game:GetService("Players")

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
