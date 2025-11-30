Config = {}

-- Distancia máxima para ver la etiqueta
Config.DrawDistance = 25.0

-- Altura extra sobre la cabeza
Config.OffsetZ = 0.50

-- Tamaño del texto
Config.TextScale = 0.35

-- Ancho extra del fondo
Config.BackgroundPaddingX = 0.008
Config.BackgroundPaddingY = 0.018

-- Solo administradores
Config.AdminOnly = true

-- Lista de administradores por identificador (pon aquí tus IDs)
-- Puedes usar 'license:', 'discord:', 'steam:' etc. Ejemplos abajo. Reemplázalos por los tuyos.
-- Cada entrada define el diseño único del tag.
Config.Admins = {
    ['discord:854932315726020658'] = { label = 'Developer',    gradient = { '#000000', '#FF0000' }, textColor = {255,255,255,230} },
    -- ['license:1234567890abcdef'] = { label = 'Owner',    gradient = { '#7F00FF', '#E100FF' }, textColor = {255,255,255,230} },
    -- ['license:abcdefabcdefabcd'] = { label = 'Admin',     gradient = { '#FF512F', '#DD2476' }, textColor = {255,255,255,235} },
}

-- Fallback opcional por grupos de framework (si quieres usar grupos/permits del core)
-- Si el jugador NO está en Config.Admins pero sí tiene un grupo listado aquí, se usará ese tag.
Config.FrameworkGroups = {
    -- admin   = { label = 'Admin',     gradient = { '#FF512F', '#F09819' }, textColor = {255,255,255,235} },
    -- god     = { label = 'Owner',     gradient = { '#7F00FF', '#E100FF' }, textColor = {255,255,255,230} },
    -- dev     = { label = 'Developer', gradient = { '#00F5A0', '#00D9F5' }, textColor = {15,15,15,235} },
}

-- Comando para refrescar los tags manualmente (server)
Config.RefreshCommand = 'bptags_refresh'
