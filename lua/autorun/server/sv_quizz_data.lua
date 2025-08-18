
function isAdmin(ply)
    local plyGroup = sql.Query("SELECT groupname FROM FAdmin_PlayerGroup WHERE steamid = '" .. ply:SteamID() .. "'")
    if plyGroup[1]['groupname'] == 'superadmin' then
        return true
    end
    return false
end


if not(file.Exists('quizz/config.txt', 'DATA')) then
    file.CreateDir('quizz')
    file.Write('quizz/config.txt', '')
end


function quizz_getData() -- из кфг в список
    local f = file.Read('quizz/config.txt', 'DATA')
    local newTbl = {}

    while f ~= '' do
        local startTo = string.find(f, "[%['%g+%p%g+]") -- ['кот;Кент?['
        local endTo = string.find(f, "[%['%g+%p%g+]%[") 
        local data = string.sub(f, startTo, endTo) -- ['кот;Кент?
        f = string.Replace(f, data, '') -- вырезаем первую пару
        data = string.sub(data, 3) -- кот; Кент?
        local pointStart = string.find(data, '%p')
        local answer = string.sub(data, 1, pointStart-1) -- кот
        local question = string.sub(data, pointStart+1) -- Кент?
        newTbl[answer] = question
    end

    return newTbl
end


util.AddNetworkString('quizz_update.ToServer')
util.AddNetworkString('quizz_update.ToClient')

function quizz_updateData(tbl) -- из списка в кфг
    f = file.Open('quizz/config.txt', 'w', 'DATA')
    f:Write('')
    f:Close()
    for answer, question in pairs(tbl) do
        file.Append('quizz/config.txt', "['" .. answer .. ';' .. question)
    end
end


quizz = quizz or {}
quizz.questions = quizz_getData()


net.Receive('quizz_update.ToServer', function()
    local tableToUpd = net.ReadTable()
    local ply = net.ReadPlayer()
    if isAdmin(ply) then
        quizz_updateData(tableToUpd)
        quizz.questions = quizz_getData()

        net.Start('quizz_update.ToClient')
            net.WriteTable(quizz.questions)
        net.Send(ply)
    end
end)