
quizz = quizz or {}
local actualButton = nil

local function quizz_AddInfo(scroll, answer, question, qEntry, aEntry)
    local infoButton = scroll:Add('DButton')
    infoButton:Dock(TOP)
    infoButton:DockMargin(5, 5, 5, 0)
    infoButton:DockPadding(5, 0, 2, 0)
    infoButton:SetSize(200, 20)
    infoButton:SetText(answer .. ' | ' .. question)
    infoButton:SetTextInset(5, 0)
    actualButton = infoButton
    infoButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(77, 126, 155, 143))
    end

    infoButton.DoClick = function()
        aEntry:SetValue(answer)
        qEntry:SetValue(question)
        actualButton = infoButton
    end
end


local function quizz_CreateMenu()
    local baseMenu = vgui.Create('DFrame')
    baseMenu:SetTitle('Добавление "вопрос-ответ" в quizz')
    baseMenu:SetSize(700, 500)
    baseMenu:Center()
    baseMenu:SetDraggable(false)
    baseMenu:MakePopup()
    baseMenu.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(77, 126, 155))
    end

    local scrollFrame = vgui.Create('DFrame', baseMenu)
    scrollFrame:ShowCloseButton(false)
    scrollFrame:SetTitle('')
    scrollFrame:SetSize(200, 460)
    scrollFrame:SetPos(10, 30)
    scrollFrame:SetDraggable(false)
    scrollFrame.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(104, 163, 197))
        draw.RoundedBox(3, 0, 0, w, 20, Color(22, 82, 117))
    end

    local scrollLabel = vgui.Create('DLabel', baseMenu)
    scrollLabel:SetText('Ответ | Вопрос')
    scrollLabel:SetPos(65, 30)
    scrollLabel:SetSize(200, 20)

    local scroll = vgui.Create('DScrollPanel', scrollFrame)
    scroll:SetSize(200, 420)
    scroll:SetPos(0, 30)

    local answerInfo = vgui.Create('DLabel', baseMenu)
    answerInfo:SetText('Ответ в формате: "слово"!')
    answerInfo:SetPos(482, 105)
    answerInfo:SetSize(200, 30)

    ---

    local questionEntry = vgui.Create('DTextEntry', baseMenu)
    questionEntry:SetSize(180, 30)
    questionEntry:SetPlaceholderText('Вопрос?')
    questionEntry:SetPos(245, 80)

    local answerEntry = vgui.Create('DTextEntry', baseMenu)
    answerEntry:SetSize(180, 30)
    answerEntry:SetPlaceholderText('Ответ!')
    answerEntry:SetPos(480, 80)

    local addButton = vgui.Create('DButton', baseMenu)
    addButton:SetText('+')
    addButton:SetSize(30, 30)
    addButton:SetPos(668, 468)

    addButton.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(132, 198, 236))
    end

    addButton.DoClick = function()
        quizz_AddInfo(scroll, '', '', questionEntry, answerEntry)
        answerEntry:SetValue('')
        questionEntry:SetValue('')
    end

    local deleteButton = vgui.Create('DButton', baseMenu)
    deleteButton:SetText('DELETE')
    deleteButton:SetPos(390, 200)
    deleteButton:SetSize(40, 40)
    deleteButton.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(132, 198, 236))
    end

    deleteButton.DoClick = function()
        if actualButton ~= nil then
            net.Start('quizz.update.delete.toServer')
                net.WriteString(questionEntry:GetValue())
                net.WritePlayer(LocalPlayer())
            net.SendToServer()

            answerEntry:SetValue('')
            questionEntry:SetValue('')
            actualButton:Remove()
            actualButton = nil

        end
    end

    local saveButton = vgui.Create('DButton', baseMenu)
    saveButton:SetText('SAVE')
    saveButton:SetPos(480, 200)
    saveButton:SetSize(40, 40)
    saveButton.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(132, 198, 236))
    end

    saveButton.DoClick = function()
        if actualButton ~= nil and string.Trim(answerEntry:GetValue()) ~= '' or string.Trim(questionEntry:GetValue()) ~= '' then
            net.Start('quizz.update.save.toServer')
                net.WriteString(answerEntry:GetValue())
                net.WriteString(questionEntry:GetValue())
                net.WritePlayer(LocalPlayer())
            net.SendToServer()

            actualButton:SetText(answerEntry:GetValue() .. ' | ' .. questionEntry:GetValue())
        end
    end


    if quizz.questions ~= nil then
        for answer, question in pairs(quizz.questions) do
            quizz_AddInfo(scroll, answer, question, questionEntry, answerEntry)
        end
    end

end


net.Receive('quizz.add.start', function()
    quizz.questions = net.ReadTable()
    quizz_CreateMenu()
end)