local UiUrl = "https://raw.githubusercontent.com/FoarteBine/MdFuncs/refs/heads/main/ui.lua"
local NotifyUrl = "https://raw.githubusercontent.com/FoarteBine/MdFuncs/refs/heads/main/notify.lua"

local Success, Library = pcall(function()
    return loadstring(game:HttpGet(UiUrl))()
end)

if not Success or not Library then return end

local Interface = Library:Init()
local NotifyModule = loadstring(game:HttpGet(NotifyUrl))()

getgenv().MdFuncs = {
    Core = Interface,
    Registry = {},
    Notifications = NotifyModule,

    Notify = function(self, data)
        if self.Notifications and self.Notifications.Spawn then
            self.Notifications:Spawn(data)
        end
    end,
    
    LoadModule = function(self, url)
        local maxRetries = 10
        local retryDelay = 1

        local function Fetch()
            for i = 1, maxRetries do
                local s, r = pcall(function() return game:HttpGet(url) end)
                if s and type(r) == "string" and #r > 0 then
                    return r
                end
                task.wait(retryDelay)
            end
            return nil
        end

        local source = Fetch()
        if not source then return end
        
        local name = source:match("@Name:%s*(%S+)") or "Module"
        local author = source:match("@Author:%s*(%S+)") or "Unknown"
        local version = source:match("@Version:%s*(%S+)") or "1.0"
        
        local function RunCode(src, cat)
            local sl, code = pcall(loadstring, src)
            if sl and code then
                local m = code()
                if m and m.Init then
                    m:Init(cat)
                end
            end
        end

        if not self.Registry[name] then
            local category = self.Core:Category(name)
            self.Registry[name] = category
            
            category:Button("AUTHOR: " .. author .. " | VER: " .. version, function() end)
            
            RunCode(source, category)
        end
    end
}
