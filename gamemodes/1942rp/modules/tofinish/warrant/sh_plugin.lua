MODULE.name = "Warrants"
MODULE.desc = "Adds Warrants"
MODULE.author = "STEAM_0:1:176123778"
lia.util.include("sv_module.lua")
lia.util.include("cl_module.lua")
local playerMeta = FindMetaTable("Player")

function playerMeta:IsWanted()
    return self:getNetVar("wanted", false)
end