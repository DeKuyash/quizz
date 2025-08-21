
function isAdmin(ply)
    local plyGroup = sql.Query("SELECT groupname FROM FAdmin_PlayerGroup WHERE steamid = '" .. ply:SteamID() .. "'")
    if plyGroup[1]['groupname'] == 'superadmin' then
        return true
    end
    return false
end


if not(file.Exists('quizz/quizz_cfg.json', 'DATA')) then
    file.CreateDir('quizz')
    file.Write('quizz/quizz_cfg.json', '[]')
end



quizz = quizz or {}



util.AddNetworkString('quizz.update.delete.toServer')
util.AddNetworkString('quizz.update.save.toServer')
util.AddNetworkString('quizz.update.toClient')

function quizz.getData()
    local f = file.Read('quizz/quizz_cfg.json', 'DATA')
    local newTbl = util.JSONToTable(f)

    return newTbl

end

function quizz.updateData(tbl)
    if tbl == nil then
        file.Write('quizz/quizz_cfg.json', '[]')
    end

    local f = util.TableToJSON(tbl)
    file.Write('quizz/quizz_cfg.json', f)

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
            net.WriteTable(quizz.questions or {})
        net.Send(ply)  
    end
end)