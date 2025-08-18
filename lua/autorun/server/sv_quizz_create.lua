
quizz = quizz or {}

-- for dev, your function must return results in format: return answer, question
function quizz_AddMode(func)
    local answer, question = func()

    if quizz.questions == nil then return end

    quizz.questions[answer] = question
    quizz_updateData(quizz.questions)
    quizz.questions = quizz_getData()
    net.Start('quizz_update.ToClient')
        net.WriteTable(quizz.questions)
    for _, v in ipairs(player:GetAll()) do
        net.Send(v) 
    end
end

--example
--[[
quizz_AddMode(function()
    local a = math.random(1, 100)
    local b = math.random(500, 1000)
    local result = a * b

    return result, string.format('Сколько будет %s * %s?', a, b)
end)
]]