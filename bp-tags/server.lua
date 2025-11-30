local Framework = nil
local isQbox = false

CreateThread(function()
    if GetResourceState('qb-core') == 'started' then
        Framework = exports['qb-core']:GetCoreObject()
    end
    if GetResourceState('qbx_core') == 'started' then
        isQbox = true
        if not Framework then
            Framework = exports['qbx_core']:GetCoreObject()
        end
    end
end)

local AdminTags = {} 
local Enabled = {}   

local function hasFrameworkGroupTag(src)
    if not Framework or not Config.FrameworkGroups then return nil end

    local player
    if isQbox then
        player = exports.qbx_core:GetPlayer(src)
    else
        if Framework and Framework.Functions and Framework.Functions.GetPlayer then
            player = Framework.Functions.GetPlayer(src)
        end
    end
    if not player then return nil end


    local groups = {}

    if isQbox and player.PlayerData and player.PlayerData.groups then
        for k,_ in pairs(player.PlayerData.groups) do groups[k] = true end
    end

    if not isQbox and player.PlayerData and player.PlayerData.group then
        groups[player.PlayerData.group] = true
    end


    if not isQbox and Framework.Functions and Framework.Functions.HasPermission then
        for g,_ in pairs(Config.FrameworkGroups) do
            if Framework.Functions.HasPermission(src, g) then
                return Config.FrameworkGroups[g]
            end
        end
    end

    for g,_ in pairs(groups) do
        if Config.FrameworkGroups[g] then
            return Config.FrameworkGroups[g]
        end
    end

    return nil
end

local function getAdminTagFor(src)
    local ids = GetPlayerIdentifiers(src)
    for _, id in ipairs(ids) do
        local conf = Config.Admins[id]
        if conf then
            return conf
        end
    end


    local grp = hasFrameworkGroupTag(src)
    if grp then return grp end

    return nil
end

local function recomputeAll()
    AdminTags = {}
    for _, s in ipairs(GetPlayers()) do
        local src = tonumber(s)
        local tag = getAdminTagFor(src)
        if tag and Enabled[src] then
            AdminTags[src] = tag
        end
    end
    TriggerClientEvent('bp-tags:sync', -1, AdminTags)
end

AddEventHandler('playerJoining', function()
    local src = source
    Enabled[src] = false 
    local tag = getAdminTagFor(src)
    AdminTags[src] = (tag and Enabled[src]) and tag or nil
    TriggerClientEvent('bp-tags:sync', -1, AdminTags)
end)

AddEventHandler('playerDropped', function()
    local src = source
    AdminTags[src] = nil
    Enabled[src] = nil
    TriggerClientEvent('bp-tags:sync', -1, AdminTags)
end)

RegisterNetEvent('bp-tags:requestSync', function()
    local src = source
    TriggerClientEvent('bp-tags:sync', src, AdminTags)
end)

RegisterCommand(Config.RefreshCommand, function(src)
    recomputeAll()
    if src and src > 0 then
        TriggerClientEvent('chat:addMessage', src, { args = { '^2bp-tags', 'Refrescado.' } })
    else
        print('[bp-tags] Refrescado via consola.')
    end
end, true)

RegisterCommand('tag', function(src)
    if not src or src <= 0 then
        print('[bp-tags] /tag solo puede usarse en juego.')
        return
    end
    local has = getAdminTagFor(src)
    if not has then
        TriggerClientEvent('chat:addMessage', src, { args = { '^1bp-tags', 'No tienes permiso para usar el tag.' } })
        return
    end
    Enabled[src] = not Enabled[src]
    if Enabled[src] then
        AdminTags[src] = has
        TriggerClientEvent('chat:addMessage', src, { args = { '^2bp-tags', 'Tag activado.' } })
    else
        AdminTags[src] = nil
        TriggerClientEvent('chat:addMessage', src, { args = { '^3bp-tags', 'Tag desactivado.' } })
    end
    TriggerClientEvent('bp-tags:sync', -1, AdminTags)
end)


CreateThread(function()
    Wait(5000)
    recomputeAll()
end)
