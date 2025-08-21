
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

quizz = quizz or {}


function quizz.getData() -- из кфг в список
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


util.AddNetworkString('quizz.update.delete.toServer')
util.AddNetworkString('quizz.update.save.toServer')
util.AddNetworkString('quizz.update.toClient')

function quizz.updateData(tbl) -- из списка в кфг
    f = file.Write('quizz/config.txt', '')
    for answer, question in pairs(tbl) do
        file.Append('quizz/config.txt', "['" .. answer .. ';' .. question)
    end
end

quizz.questions = quizz.getData()

net.Receive('quizz.update.save.toServer', function(len, selfPly)
    local answer = net.ReadString()
    local question = net.ReadString()
    local ply = net.ReadPlayer()
    if selfPly ~= ply then return end

    if isAdmin(ply) then
        quizz.questions[answer] = question
        quizz.updateData(quizz.questions)
        quizz.questions = quizz.getData()
    end
end)

net.Receive('quizz.update.delete.toServer', function(len, selfPly)
    local value = net.ReadString()
    local ply = net.ReadPlayer()
    if selfPly ~= ply then return end

    if isAdmin(ply) then
        table.RemoveByValue(quizz.questions, value)
        quizz.updateData(quizz.questions)
        quizz.questions = quizz.getData()
    end
end)


util.AddNetworkString('quizz.add.start')

concommand.Add('quizz_add', function(ply)
    if isAdmin(ply) then
        net.Start('quizz.add.start')
            quizz.question = quizz.getData()
            net.WriteTable(quizz.questions)
        net.Send(ply)  
    end
end)