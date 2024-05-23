﻿
function MODULE:Think()
    if not self.next_think then self.next_think = CurTime() end
    if self.next_think <= CurTime() then
        for _, v in next, player.Iterator() do
            local bac = v:GetNW2Int("lia_alcoholism_bac", 0)
            if bac > 0 then v:SetNW2Int("lia_alcoholism_bac", math.Clamp(bac - self.DegradeRate, 0, 100)) end
        end

        self.next_think = CurTime() + self.TickTime
    end
end


function MODULE:StartCommand(client, ucmd)
    if (client.nextDrunkCheck or 0) < CurTime() then
        client.nextDrunkCheck = CurTime() + 0.05
        if client:GetNW2Int("lia_alcoholism_bac", 0) > 30 then
            ucmd:ClearButtons()
            if (client.nextDrunkSide or 0) < CurTime() then
                client.nextDrunkSide = CurTime() + math.Rand(0.1, 0.3) + (client:GetNW2Int("lia_alcoholism_bac", 0) * 0.01)
                client.sideRoll = math.random(-1, 1)
                client.frontRoll = math.random(-1, 1)
            end

            if client.frontRoll == 1 then
                ucmd:SetForwardMove(100000)
            elseif client.frontRoll == -1 then
                ucmd:SetForwardMove(-100000)
            end

            if client.sideRoll == 1 then
                ucmd:SetSideMove(100000)
            elseif client.sideRoll == -1 then
                ucmd:SetSideMove(-100000)
            end
        end
    end
end


function MODULE:PlayerLoadedChar(client)
    client:ResetBAC()
end


function MODULE:PostPlayerLoadout(client)
    client:ResetBAC()
end

