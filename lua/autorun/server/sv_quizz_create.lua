
quizz = quizz or {}
quizz.modes = quizz.modes or {}

-- for dev, your function must return results in format: return answer, question !!! answer must be string too
function quizz.addMode(name, func)
    quizz.modes[name] = func
end

--example

quizz.addMode('math', function()
    local a = math.random(1, 100)
    local b = math.random(500, 1000)
    local result = a + b

    return tostring(result), string.format('Сколько будет %s + %s?', a, b)
end)