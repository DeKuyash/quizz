if SERVER then
    include('quizz/server/sv_quizz_create.lua')
    include('quizz/server/sv_quizz_data.lua')
    include('quizz/server/sv_quizz_main.lua')

    AddCSLuaFile('quizz/client/cl_quizz.lua')
end


if CLIENT then
    include('quizz/client/cl_quizz.lua')

end