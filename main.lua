local success, result = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/FoarteBine/MdFuncs/refs/heads/main/loader.lua")
end)

if success then
    loadstring(result)()
    if getgenv().MdFuncs then
        getgenv().MdFuncs:LoadModule("https://raw.githubusercontent.com/FoarteBine/MdFuncs/refs/heads/main/visuals.lua")
    end
end
