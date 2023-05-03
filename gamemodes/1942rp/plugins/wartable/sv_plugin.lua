local PLUGIN = PLUGIN

local function getTableEnt(pos)
    for _, ent in pairs(ents.FindByClass("wartable")) do
        if ent:GetPos():DistToSqr(pos) < 25000 then return ent end
    end

    return nil
end

netstream.Hook("ClearWarTable", function(ply, tableEnt)
    local tableEnt = getTableEnt(ply:GetPos())
    if not tableEnt then return end
    tableEnt:Clear()
end)

netstream.Hook("SetWarTableMap", function(ply, tableEnt, text)
    local tableEnt = getTableEnt(ply:GetPos())
    if not tableEnt then return end

    for _, imageType in pairs(PLUGIN.allowedImageTypes) do
        print(text, imageType)

        if string.find(text, string.lower(imageType)) then
            netstream.Start(player.GetAll(), "SetWarTableMap", tableEnt, text)
            break
        end
    end
end)

netstream.Hook("PlaceWarTableMarker", function(ply, pos, bodygroups)
    local tableEnt = getTableEnt(ply:GetPos())
    if not tableEnt then return end
    local tableEntFound = false

    for _, ent in pairs(ents.FindInSphere(pos, 1)) do
        if ent == tableEnt then
            tableEntFound = true
        end
    end

    if not tableEntFound then return end
    local marker = ents.Create("prop_physics")
    marker:SetPos(pos)
    marker:SetModel("models/william/war_marker/war_marker.mdl")
    marker:Spawn()

    for k, v in pairs(bodygroups) do
        marker:SetBodygroup(tonumber(k) or 0, tonumber(v) or 0)
    end

    marker:SetParent(tableEnt)
    marker:SetMoveType(MOVETYPE_NONE)
end)

netstream.Hook("RemoveWarTableMarker", function(ply, ent)
    local tableEnt = getTableEnt(ply:GetPos())
    if not tableEnt then return end
    ent:Remove()
end)

function PLUGIN:PhysgunPickup(ply, ent)
    if ent:GetModel() == "models/william/war_marker/war_marker.mdl" then return false end
end