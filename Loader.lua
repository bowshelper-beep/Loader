-- Loader.lua (мобильная версия для MonetLoader / MoonLoader Android)
-- Показывает предупреждение новичкам через 17 секунд
-- Это урок безопасности, а не стиллер

local imgui = require 'mimgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local window = imgui.new.bool(false)
local blink_timer = 0

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        wait(100)
        return
    end

    wait(17000)

    sampAddChatMessage("[Loader] Прошло 17 секунд... открываю предупреждение", -1)
    print("[Loader] Урок новичку")

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

        -- Масштаб под мобильный экран (узкий + высокий DPI)
        local scale = math.min(resX / 1080, resY / 1920) * 1.25  -- 1.25–1.5 обычно хорошо на телефонах
        local line = 24 * scale                                 -- высота строки
        local margin_left = resX * 0.06                         -- \~6% слева (запас от края)
        local centerX = resX * 0.5

        local y = resY * 0.22                                   -- начало сверху (можно подвинуть 0.18–0.25)

        blink_timer = blink_timer + 0.04
        local alpha = 0.75 + 0.25 * math.sin(blink_timer * 6)

        -- Главная надпись (мигание)
        imgui.SetCursorPos(imgui.ImVec2(centerX - 280 * scale, y))
        imgui.TextColored(imgui.ImVec4(0.1, 0.95, 0.1, alpha), u8"НА ЭТОТ РАЗ ТЕБЕ ПОВЕЗЛО!")

        y = y + line * 2.0
        imgui.SetCursorPos(imgui.ImVec2(centerX - 220 * scale, y))
        imgui.TextColored(imgui.ImVec4(1, 1, 0.4, 1), u8"Это просто троллинг-окно-пустышка.")

        y = y + line * 1.6
        imgui.SetCursorPos(imgui.ImVec2(centerX - 260 * scale, y))
        imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), u8"НО В СЛЕДУЮЩИЙ РАЗ МОЖЕТ БЫТЬ СТИЛЛЕР!")

        y = y + line * 3.5
        imgui.SetCursorPos(imgui.ImVec2(margin_left, y))
        imgui.TextColored(imgui.ImVec4(1, 0.85, 0.2, 1), u8"ПРАВИЛА БЕЗОПАСНОСТИ — ЗАПОМНИ:")

        y = y + line * 2.0

        local tips = {
            u8"• Никогда не запускай .lua файлы от незнакомцев (Discord, TG, VK, форумы)",
            u8"• Числа вида {104,116,116,112,...} — почти всегда скрытая ссылка на стиллер",
            u8"• requests.get/post на discord webhooks — 99% кража токенов",
            u8"• io.open в %appdata% или Local Storage — крадут Discord-токены",
            u8"• loadstring / dofile / loadfile с URL — подгружает вредоносный код",
            u8"• os.execute / os.remove / os.rename — опасные системные команды",
            u8"• debug.getinfo / traceback / string.dump — пытаются спрятать вред",
            u8"• ImGui без кнопки закрытия + NoMove/NoResize — классика фейковых загрузчиков"
        }

        for _, tip in ipairs(tips) do
            imgui.SetCursorPos(imgui.ImVec2(margin_left, y))
            imgui.TextColored(imgui.ImVec4(0.98, 0.98, 0.98, 1), tip)
            y = y + line * 1.35  -- расстояние между пунктами
        end

        y = y + line * 3.5

        imgui.SetCursorPos(imgui.ImVec2(centerX - 240 * scale, y))
        imgui.TextColored(imgui.ImVec4(0.4, 0.75, 1, 1), u8"Всегда открывай .lua в Notepad++ / VS Code перед запуском!")

        y = y + line * 1.7
        imgui.SetCursorPos(imgui.ImVec2(centerX - 210 * scale, y))
        imgui.TextColored(imgui.ImVec4(1, 0.55, 0.15, 1), u8"Не верь 'бесплатным VIP' и 'премиум за 0 руб'!")

        -- Окно остаётся открытым
        window[0] = true

        imgui.End()
    end)
end
