local UiUrl = "https://raw.githubusercontent.com/FoarteBine/MdFuncs/refs/heads/main/ui.lua"

local Success, Library = pcall(function()
    return loadstring(game:HttpGet(UiUrl))()
end)

if not Success or not Library then return end

local Interface = Library:Init()

getgenv().MdFuncs = {
    Core = Interface,
    Registry = {},
    
    LoadModule = function(self, url)
        local requestSuccess, source = pcall(function() return game:HttpGet(url) end)
        if not requestSuccess or type(source) ~= "string" then return end
        
        local name = source:match("@Name:%s*(%S+)") or "Module"
        local author = source:match("@Author:%s*(%S+)") or "Unknown"
        local version = source:match("@Version:%s*(%S+)") or "1.0"
        
        local category = self.Registry[name]
        if not category then
            category = self.Core:Category(name)
            self.Registry[name] = category
            
            local info = "AUTHOR: " .. author .. " | VER: " .. version
            category:Button(info, function() end) 
        end
        
        local code = loadstring(source)
        if code then
            local module = code()
            if module and module.Init then
                module:Init(category)
            end
        end
    end
}
