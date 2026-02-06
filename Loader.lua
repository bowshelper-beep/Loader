-- Loader.lua — МОБИЛЬНАЯ ВЕРСИЯ для MonetLoader Android (разрешение 2712x1220)
-- Урок безопасности через 17 сек

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

    local resX, resY = getScreenResolution()
    print(string.format("[Loader] Разрешение экрана: %dx%d", resX, resY))

    wait(17000)

    sampAddChatMessage("[Loader] Прошло 17 сек → открываю предупреждение!", -1)
    print("[Loader] Запуск урока (должно появиться окно)")

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

        -- Глобальное увеличение шрифта (очень важно для высокого разрешения)
        imgui.GetIO().FontGlobalScale = 2.0  -- 2.0–2.5 под твой экран; если мелко — увеличь до 2.5

        local centerX = resX * 0.5
        local leftMargin = resX * 0.10  -- 10% слева — запас
        local lineHeight = 45          -- увеличенное расстояние между строками
        local y = resY * 0.10          -- старт с 10% сверху

        blink_timer = blink_timer + 0.05
        local alpha = 0.7 + 0.3 * math.sin(blink_timer * 5)

        -- Мигание главной строки
        imgui.SetCursorPos(imgui.ImVec2(centerX - resX*0.25, y))
        imgui.TextColored(imgui.ImVec4(0.1, 0.95, 0.1, alpha), u8"НА ЭТОТ РАЗ ТЕБЕ ПОВЕЗЛО!")

        y = y + lineHeight * 2.5

        imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
        imgui.TextWrapped(u8"Это обычное фейковое окно — просто троллинг.")

        y = y + lineHeight * 2

        imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
        imgui.TextWrapped(u8"НО В СЛЕДУЮЩИЙ РАЗ ЭТО МОЖЕТ БЫТЬ НАСТОЯЩИЙ СТИЛЛЕР!")

        y = y + lineHeight * 4

        imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
        imgui.TextColored(imgui.ImVec4(1, 0.9, 0.2, 1), u8"ПРАВИЛА БЕЗОПАСНОСТИ:")

        y = y + lineHeight * 2.5

        local tips = {
            u8"• Никогда не запускай .lua от незнакомцев в Discord/TG/VK/форумах",
            u8"• {104,116,116,112,...} — скрытая ссылка на стиллер",
            u8"• requests на discord webhooks — крадут токены",
            u8"• io.open в Local Storage / %appdata% — кража токенов",
            u8"• loadstring / dofile с URL — скачивает вред",
            u8"• os.execute / os.remove / os.rename — опасно",
            u8"• debug.getinfo / traceback / string.dump — прячут код",
            u8"• ImGui без крестика + NoMove/NoResize — обман"
        }

        for _, tip in ipairs(tips) do
            imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
            imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.98, 0.98, 0.98, 1))
            imgui.TextWrapped(tip)
            imgui.PopStyleColor()
            y = y + lineHeight * 1.6
        end

        y = y + lineHeight * 4

        imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.4, 0.8, 1, 1))
        imgui.TextWrapped(u8"Открывай .lua в Notepad++ или VS Code ПЕРЕД запуском!")
        imgui.PopStyleColor()

        y = y + lineHeight * 2

        imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 0.6, 0.2, 1))
        imgui.TextWrapped(u8"Не верь 'бесплатному VIP' и 'премиуму за 0 руб'!")
        imgui.PopStyleColor()

        window[0] = true

        imgui.End()
    end)

    window[0] = true
end
