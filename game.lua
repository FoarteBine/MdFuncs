--[[
@Name: Game
@Author: FoarteBine
@Version: v1.1
]]

local Module = {}

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

function Module:Init(api)
    local ServerSection = api:Section("SERVER")

    ServerSection:Button("Rejoin", function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)

    ServerSection:Button("Server Hop", function()
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)

        if success then
            local servers = {}
            for _, v in pairs(result.data) do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(servers, v.id)
                end
            end

            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
            else
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end
        end
    end)

    local CopySection = api:Section("COPY INFO")

    CopySection:Button("Copy JobId", function()
        if setclipboard then
            setclipboard(tostring(game.JobId))
        end
    end)

    CopySection:Button("Copy PlaceId", function()
        if setclipboard then
            setclipboard(tostring(game.PlaceId))
        end
    end)

    local UtilsSection = api:Section("UTILITIES")

    local AntiAFK_Enabled = false
    UtilsSection:Toggle("Anti-AFK", false, function(v)
        AntiAFK_Enabled = v
    end)

    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        if AntiAFK_Enabled then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

return Module