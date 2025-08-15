



local function printWinners(answers, correctAnswer)
    local winners = {}

    for name, answ in pairs(answers) do
        if answ == correctAnswer then
            table.insert(winners, name)
        end
    end

    local count = table.Count(winners)
    local multiAnswers = false
    
    local finalMsg = 'Игроки '

    if count == 0 then
        finalMsg = 'Никто не дал правильного ответа, правильный ответ был: ' .. correctAnswer .. '.'
    end

    for _, v in ipairs(winners) do
        if count == 1 and !multiAnswers then
            finalMsg = 'Игрок ' .. v .. ' дал правильный ответ: ' .. correctAnswer .. '.'
        
        elseif count == 1 and multiAnswers then
            finalMsg = string.sub(finalMsg, 1, string.len(finalMsg)-2)
            finalMsg = finalMsg .. ' и ' .. v .. ' дали правильные ответы!'

        end

        if count > 1 then
            count = count - 1
            multiAnswers = true
            finalMsg = finalMsg .. v .. ', '

        end
    end


    PrintMessage(HUD_PRINTTALK, finalMsg)
end


local function startQuizz()
    local question, answer = table.Random(quizz.questions)    
    local plyAnswer = {
        ['chelog'] = answer,
        ['Walther White'] = answer
    }

    PrintMessage(HUD_PRINTTALK, 'Викторина начинается! Давайте ответ в формате: "слово"')
    PrintMessage(HUD_PRINTTALK, question)    

    hook.Add('PlayerSay', 'quizz.Answers', function(ply, txt)
        plyAnswer[ply:Nick()] = string.Trim(txt)
    end)

    timer.Simple(timeToAnswer, function()
        hook.Remove('PlayerSay', 'quizz.Answers')         
        printWinners(plyAnswer, answer)     
    end)
end


hook.Add('PlayerSay', 'quizz.Start', function(ply, txt)
    if string.Trim(string.lower(txt)) == '!start' then
        startQuizz()
        return false
    end
end)


util.AddNetworkString('quizz_add.start')

concommand.Add('quizz_add', function(ply)
    net.Start('quizz_add.start')
    net.Send(ply)
end)