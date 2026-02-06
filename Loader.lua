-- Loader.lua
-- Показывает полезное предупреждение новичкам через 17 секунд
-- Это не стиллер, а урок безопасности

local imgui = require 'mimgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local window = imgui.new.bool(false)
local blink_timer = 0  -- для мигания текста

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        wait(100)
        return
    end

    -- Ждём 17 секунд — как в классических троллинг-скриптах
    wait(17000)

    sampAddChatMessage("[Loader] Прошло 17 секунд... открываю важное предупреждение", -1)
    print("[Loader] Показываем урок новичку")

    window[0] = true

    imgui.OnFrame(function() return window[0] end, function()
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

        local cx = resX / 2
        local cy = resY / 2

        -- Мигание главной надписи
        blink_timer = blink_timer + 0.05
        local alpha = 0.7 + 0.3 * math.sin(blink_timer * 5)

        imgui.SetCursorPos(imgui.ImVec2(cx - 420, cy - 220))
        imgui.TextColored(imgui.ImVec4(0.1, 0.9, 0.1, alpha), u8"НА ЭТОТ РАЗ ТЕБЕ ПОВЕЗЛО!")

        imgui.SetCursorPos(imgui.ImVec2(cx - 340, cy - 160))
        imgui.TextColored(imgui.ImVec4(1, 1, 0.3, 1), u8"Это обычная пустышка — просто троллинг-окно.")

        imgui.SetCursorPos(imgui.ImVec2(cx - 380, cy - 120))
        imgui.TextColored(imgui.ImVec4(1, 0.4, 0.4, 1), u8"НО В СЛЕДУЮЩИЙ РАЗ ЭТО МОЖЕТ БЫТЬ СТИЛЛЕР!")

        imgui.Dummy(imgui.ImVec2(0, 40))

        imgui.SetCursorPosX(cx - 360)
        imgui.TextColored(imgui.ImVec4(1, 0.8, 0.2, 1), u8"ПРАВИЛА БЕЗОПАСНОСТИ — ЧИТАЙ И ЗАПОМНИ!")

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

        for _, tip in ipairs(tips) do
            imgui.SetCursorPosX(cx - 420)
            imgui.TextColored(imgui.ImVec4(0.95, 0.95, 0.95, 1), tip)
            imgui.Dummy(imgui.ImVec2(0, 6))
        end

        imgui.Dummy(imgui.ImVec2(0, 50))

        imgui.SetCursorPos(imgui.ImVec2(cx - 260, cy + 140))
        imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1, 1), u8"Всегда открывай .lua в Notepad++ или VS Code ПЕРЕД запуском!")

        imgui.SetCursorPos(imgui.ImVec2(cx - 240, cy + 180))
        imgui.TextColored(imgui.ImVec4(1, 0.6, 0.2, 1), u8"Не верь 'бесплатным премиумам' с форумов и тг!")

        -- Окно остаётся открытым навсегда
        window[0] = true

        imgui.End()
    end)
end
