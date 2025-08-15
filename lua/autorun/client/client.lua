
--local function quizz_AddInfo(scroll, answer, question)

local function quizz_AddInfo(scroll)
    local answerButton = scroll:Add('DButton')
    answerButton:Dock(TOP)
    answerButton:DockMargin(5, 5, 100, 0)
    answerButton:SetSize(100, 20)
    --answerButton:SetText(answer)
    answerButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(77, 126, 155, 143))
    end

    answerButton.DoClick = function()

    end

    local questionButton = scroll:Add('DButton')
    questionButton:Dock(BOTTOM)
    questionButton:DockMargin(100, 5, 5, 0)
    questionButton:SetSize(100, 20)
    --questionButton:SetText(question)
    questionButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(77, 126, 155, 143))
    end

    answerButton.DoClick = function()

    end

end


net.Receive('quizz_add.start', function()

    local baseMenu = vgui.Create('DFrame')
    baseMenu:SetTitle('Добавление "вопрос-ответ" в quizz')
    baseMenu:SetSize(700, 500)
    baseMenu:Center()
    baseMenu:SetDraggable(false)
    baseMenu:MakePopup()
    baseMenu.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(77, 126, 155))
    end

    local addButton = vgui.Create('DButton', baseMenu)
    addButton:SetText('+')
    addButton:SetSize(30, 30)
    addButton:SetPos(668, 468)

    addButton.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(132, 198, 236))
    end

    addButton.DoClick = function()

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

    local questionEntry = vgui.Create('DTextEntry', baseMenu)
    questionEntry:SetSize(180, 30)
    questionEntry:SetPlaceholderText('Вопрос?')
    questionEntry:SetPos(245, 80)
    questionEntry.OnChange = function(self)
        print(self:GetValue())
    end

    local answerEntry = vgui.Create('DTextEntry', baseMenu)
    answerEntry:SetSize(180, 30)
    answerEntry:SetPlaceholderText('Ответ!')
    answerEntry:SetPos(480, 80)
    answerEntry.OnChange = function(self)
        print(self:GetValue())
    end


    local deleteButton = vgui.Create('DButton', baseMenu)
    deleteButton:SetText('DELETE')
    deleteButton:SetPos(390, 200)
    deleteButton:SetSize(40, 40)
    deleteButton.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(132, 198, 236))
    end

    deleteButton.DoClick = function()

    end

    local saveButton = vgui.Create('DButton', baseMenu)
    saveButton:SetText('SAVE')
    saveButton:SetPos(480, 200)
    saveButton:SetSize(40, 40)
    saveButton.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(132, 198, 236))
    end

    saveButton.DoClick = function()

    end

    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)
    quizz_AddInfo(scroll)


end)





