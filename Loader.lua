-- SafeTrollWarning.lua
-- Полезное предупреждение вместо вредного троллинга
-- Добавлено предупреждение про файлы из лички и чатов

local imgui = require 'mimgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local window = imgui.new.bool(false)

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        wait(100)
        return
    end

    -- Ждём 17 секунд (классика троллинга)
    wait(17000)

    sampAddChatMessage("[Скрипт] Прошло время... открываю окно", -1)
    print("[Скрипт] Показываем предупреждение новичку")

    window[0] = true

    imgui.OnFrame(function() return window[0] end, function(player)
        local resX, resY = getScreenResolution()

        imgui.SetNextWindowPos(imgui.ImVec2(0, 0), imgui.Cond.Always)
        imgui.SetNextWindowSize(imgui.ImVec2(resX, resY), imgui.Cond.Always)

        imgui.Begin(u8"ВНИМАНИЕ! Это могло быть опасно", window,
            imgui.WindowFlags.NoTitleBar +
            imgui.WindowFlags.NoResize +
            imgui.WindowFlags.NoMove +
            imgui.WindowFlags.NoCollapse +
            imgui.WindowFlags.NoScrollbar +
            imgui.WindowFlags.NoBringToFrontOnFocus +
            imgui.WindowFlags.NoSavedSettings
        )

        local centerX = resX / 2
        local centerY = resY / 2

        imgui.SetCursorPos(imgui.ImVec2(centerX - 380, centerY - 180))
        imgui.TextColored(imgui.ImVec4(0.1, 0.8, 0.1, 1.0), u8"На этот раз тебе ПОВЕЗЛО!")
        imgui.Spacing()
        imgui.TextColored(imgui.ImVec4(1, 1, 0.2, 1), u8"Это обычная пустышка — просто троллинг-окно.")
        imgui.Spacing()
        imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), u8"Но в следующий раз это МОЖЕТ БЫТЬ СТИЛЛЕР!")

        imgui.Dummy(imgui.ImVec2(0, 20))

        imgui.SetCursorPosX(centerX - 320)
        imgui.Text(u8"Самые важные правила безопасности (читай внимательно!)")

        local tips = {
            u8"• НИКОГДА не скачивай и не устанавливай .lua файлы, которые тебе скинули в личку, в чатах Discord/Telegram/VK или на форумах от незнакомцев!",
            u8"• Массивы чисел вместо ссылок: {104,116,116,112,115,58,47,47...} — это почти всегда скрытый загрузчик стиллера!",
            u8"• Есть requests.get / requests.post → особенно на discord.com/api/webhooks",
            u8"• Есть io.open в %appdata% или Local Storage (крадёт токены Discord)",
            u8"• Есть loadfile / loadstring / dofile с URL (скачивает ещё код)",
            u8"• Есть os.execute, os.remove, os.rename → запускает/удаляет файлы",
            u8"• Проверки debug.getinfo, traceback, string.dump → анти-тампер (скрывает вред)",
            u8"• Окно ImGui без кнопки закрытия + NoMove/NoResize → классический троллинг"
        }

        for i, tip in ipairs(tips) do
            imgui.SetCursorPosX(centerX - 380)
            imgui.TextColored(imgui.ImVec4(0.9, 0.9, 0.9, 1), tip)
            imgui.Dummy(imgui.ImVec2(0, 4))
        end

        imgui.Dummy(imgui.ImVec2(0, 30))

        imgui.SetCursorPos(imgui.ImVec2(centerX - 200, centerY + 120))
        imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), u8"Всегда открывай .lua в Notepad++ или VS Code ПЕРЕД запуском!")
        imgui.SetCursorPos(imgui.ImVec2(centerX - 180, centerY + 150))
        imgui.TextColored(imgui.ImVec4(1, 0.6, 0, 1), u8"Не верь 'бесплатным премиумам' с форумов и тг")

        -- Окно остаётся открытым навсегда
        window[0] = true

        imgui.End()
    end)
end
