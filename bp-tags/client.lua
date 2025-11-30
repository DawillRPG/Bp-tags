local AdminTags = {} 

local function hexToRGB(hex)
    if type(hex) ~= 'string' then return 255,255,255 end
    hex = hex:gsub('#','')
    if #hex == 3 then
        local r = tonumber('0x'..hex:sub(1,1)..hex:sub(1,1)) or 255
        local g = tonumber('0x'..hex:sub(2,2)..hex:sub(2,2)) or 255
        local b = tonumber('0x'..hex:sub(3,3)..hex:sub(3,3)) or 255
        return r,g,b
    else
        local r = tonumber('0x'..hex:sub(1,2)) or 255
        local g = tonumber('0x'..hex:sub(3,4)) or 255
        local b = tonumber('0x'..hex:sub(5,6)) or 255
        return r,g,b
    end
end

local function lerp(a,b,t) return a + (b-a) * t end


RegisterNetEvent('bp-tags:sync', function(serverMap)
    AdminTags = serverMap or {}
end)

CreateThread(function()
 
    SetNuiFocus(false, false)
    TriggerServerEvent('bp-tags:requestSync')
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local myCoords = GetEntityCoords(ped)
        local items = {}

        for _, player in ipairs(GetActivePlayers()) do
            local sid = GetPlayerServerId(player)
            local tag = AdminTags[sid]
            if tag then
                local targetPed = GetPlayerPed(player)
                if targetPed ~= 0 and not IsPedDeadOrDying(targetPed, true) then
                    local tCoords = GetEntityCoords(targetPed)
                    local dist = #(tCoords - myCoords)
                    if dist <= (Config.DrawDistance or 25.0) then
                        local headPos = GetPedBoneCoords(targetPed, 0x796e, 0.0, 0.0, 0.0)
                        local x,y,z = headPos.x, headPos.y, headPos.z + (Config.OffsetZ or 1.05)
                        local onScreen, sx, sy = World3dToScreen2d(x, y, z)
                        if onScreen then
                            local g1 = tag.gradient and tag.gradient[1] or '#7F00FF'
                            local g2 = tag.gradient and tag.gradient[2] or '#E100FF'
                            local tr, tg, tb, ta = 255,255,255,230
                            if tag.textColor then
                                tr, tg, tb, ta = tag.textColor[1] or 255, tag.textColor[2] or 255, tag.textColor[3] or 255, tag.textColor[4] or 230
                            end
                            items[#items+1] = {
                                x = sx, y = sy - 0.012,
                                label = (tag.label or 'Admin'),
                                c1 = g1, c2 = g2,
                                txt = {tr, tg, tb, ta}
                            }
                        end
                    end
                end
            end
        end

     
        if #items > 0 then
            SendNUIMessage({ type = 'bp-tags:update', items = items })
        else
            SendNUIMessage({ type = 'bp-tags:update', items = {} })
        end
    end
end)
