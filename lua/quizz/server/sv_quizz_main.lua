

timeToAnswer = timeToAnswer or 8

local function printWinners(answers, correctAnswer)
    local winners = {}

    if answers == nil then 
        PrintMessage(HUD_PRINTTALK, 'Увы, никто даже в чат не написал!')
        return
    end

    for ply, answ in pairs(answers) do
        if answ == correctAnswer then
            winners[#winners+1] = ply
        end
    end

    local count = #winners
    local finalMsg = 'Игроки '
    local winnersName = {}

    for k, v in ipairs(winners) do 
        winnersName[k] = v:Nick()
    end

    if count == 0 then
        finalMsg = 'Никто не дал правильного ответа, правильный ответ был: ' .. correctAnswer .. '.'
        PrintMessage(HUD_PRINTTALK, finalMsg)
        return
    end

    if count == 1 then
        finalMsg = 'Игрок ' .. winnersName[1] .. ' дал правильный ответ: ' .. correctAnswer .. '.'
        PrintMessage(HUD_PRINTTALK, finalMsg)
        return
    end

    finalMsg = finalMsg .. table.concat(winnersName, ', ', 1, #winnersName - 1)
    finalMsg = finalMsg .. ' и ' .. winnersName[#winnersName] .. ' дали правильный ответ: ' .. correctAnswer .. '.'

    PrintMessage(HUD_PRINTTALK, finalMsg)
    --return winners    -- возвращаю список победителей в виде player, чтобы в дальнейшем выдать награду
end

-- string, string, function
function quizz.startQuizz(question, answer, mode)
    if quizz.getStarted == true then return end
    local plyAnswer = {}

    if mode == nil then 
        if question == nil or answer == nil then return end

        quizz.getStarted = true
        PrintMessage(HUD_PRINTTALK, 'Викторина начинается! Давайте ответ в формате: "слово"')
        PrintMessage(HUD_PRINTTALK, question)    

        hook.Add('PlayerSay', 'quizz.answers', function(ply, txt)
            plyAnswer[ply] = string.Trim(txt)
        end)

        timer.Simple(timeToAnswer, function()
            hook.Remove('PlayerSay', 'quizz.answers')
            quizz.getStarted = false  
            printWinners(plyAnswer, answer)     
        end)

    else
        answer, question = mode()
        if question == nil or answer == nil then return end

        quizz.getStarted = true
        PrintMessage(HUD_PRINTTALK, 'Викторина начинается! Давайте ответ в формате: "слово"')
        PrintMessage(HUD_PRINTTALK, question)    

        hook.Add('PlayerSay', 'quizz.answers', function(ply, txt)
            plyAnswer[ply] = string.Trim(txt)
        end)

        timer.Simple(timeToAnswer, function()
            hook.Remove('PlayerSay', 'quizz.answers')
            quizz.getStarted = false  
            PrintTable(plyAnswer)
            printWinners(plyAnswer, answer)     
        end)

    end
end


hook.Add('PlayerSay', 'quizz.start', function(ply, txt)
    if not isAdmin(ply) then return false end

    if string.sub(string.Trim(string.lower(txt)), 1, 6) == '!start' then
        local mode = string.Trim(string.sub(txt, 7))
        if mode == '' then
            local question, answer = table.Random(quizz.question or {})
            quizz.startQuizz(question, answer, nil)

        else
            if quizz.modes[mode] == nil then return false end

            quizz.startQuizz('', '', quizz.modes[mode])

        end

        return false
    end
end)