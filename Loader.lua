local imgui = require 'mimgui'

local window = imgui.new.bool(false)
local blink_timer = 0

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        wait(100)
        return
    end

    local resX, resY = getScreenResolution()
    print(string.format("[Loader MOBILE] Разрешение: %dx%d", resX, resY))

    wait(17000)

    sampAddChatMessage("[Loader] Прошло 17 сек → открываю предупреждение!", -1)
    print("[Loader] Запуск окна без encoding")

    -- Увеличиваем шрифт глобально (для высокого разрешения 2712x1220)
    imgui.GetIO().FontGlobalScale = 2.8  -- подкрути 2.5–3.2, если текст мелкий/огромный

    imgui.OnFrame(function() return window[0] end, function()
        local resX, resY = getScreenResolution()

        imgui.SetNextWindowPos(imgui.ImVec2(0, 0), imgui.Cond.Always)
        imgui.SetNextWindowSize(imgui.ImVec2(resX, resY), imgui.Cond.Always)

        imgui.Begin("ВНИМАНИЕ! Это могло быть опасно", window,
            imgui.WindowFlags.NoTitleBar +
            imgui.WindowFlags.NoResize +
            imgui.WindowFlags.NoMove +
            imgui.WindowFlags.NoCollapse +
            imgui.WindowFlags.NoScrollbar +
            imgui.WindowFlags.NoBringToFrontOnFocus +
            imgui.WindowFlags.NoSavedSettings
        )

        local centerX = resX * 0.5
        local leftMargin = resX * 0.08  -- запас от края
        local lineHeight = 60
        local y = resY * 0.08  -- начало сверху

        blink_timer = blink_timer + 0.05
        local alpha = 0.7 + 0.3 * math.sin(blink_timer * 5)

        imgui.SetCursorPos(imgui.ImVec2(centerX - resX*0.35, y))
        imgui.TextColored(imgui.ImVec4(0.1, 0.95, 0.1, alpha), "НА ЭТОТ РАЗ ТЕБЕ ПОВЕЗЛО!")

        y = y + lineHeight * 2.2

        imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
        imgui.TextWrapped("Это обычная пустышка — просто троллинг-окно.")

        y = y + lineHeight * 1.8

        imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
        imgui.TextWrapped("НО В СЛЕДУЮЩИЙ РАЗ ЭТО МОЖЕТ БЫТЬ СТИЛЛЕР!")

        y = y + lineHeight * 3.5

        imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
        imgui.TextColored(imgui.ImVec4(1, 0.9, 0.2, 1), "ПРАВИЛА БЕЗОПАСНОСТИ — ЗАПОМНИ!")

        y = y + lineHeight * 2

        local tips = {
            "• Никогда не скачивай .lua файлы от незнакомцев в Discord/Telegram/VK/форумах!",
            "• Массивы чисел {104,116,116,112,...} — почти всегда скрытый стиллер!",
            "• requests.get / requests.post на discord webhooks — крадут токены!",
            "• io.open в Local Storage или %appdata% — кража Discord-токенов",
            "• loadstring / dofile / loadfile с URL — подгружает вредоносный код",
            "• os.execute / os.remove / os.rename — опасные команды",
            "• debug.getinfo / traceback / string.dump — скрывают вред",
            "• ImGui окно без крестика + NoMove/NoResize — классика обмана"
        }

        for _, tip in ipairs(tips) do
            imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
            imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.98, 0.98, 0.98, 1))
            imgui.TextWrapped(tip)
            imgui.PopStyleColor()
            y = y + lineHeight * 1.4
        end

        y = y + lineHeight * 3.5

        imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.4, 0.8, 1, 1))
        imgui.TextWrapped("Открывай .lua в Notepad++ или VS Code ПЕРЕД запуском!")
        imgui.PopStyleColor()

        y = y + lineHeight * 2

        imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 0.6, 0.2, 1))
        imgui.TextWrapped("Не верь 'бесплатным VIP' и 'премиуму за 0 руб'!")
        imgui.PopStyleColor()

        window[0] = true

        imgui.End()
    end)

    window[0] = true
end
