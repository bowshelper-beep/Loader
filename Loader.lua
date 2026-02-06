-- Loader.lua — ИСПРАВЛЕНО: без encoding/u8 для Android MonetLoader

local imgui = require 'mimgui'

local window = imgui.new.bool(false)
local blink_timer = 0

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        wait(100)
        return
    end

    local resX, resY = getScreenResolution()
    print(string.format("[Loader FIXED] Разрешение: %dx%d", resX, resY))

    wait(17000)

    sampAddChatMessage("[Loader] Прошло 17 сек → предупреждение о безопасности!", -1)
    print("[Loader] Запуск нормального окна")

    -- Глобальный масштаб шрифта (для твоего высокого разрешения)
    imgui.GetIO().FontGlobalScale = 2.5  -- 2.0–3.0; подкрути, если мелко/крупно

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
        local leftMargin = resX * 0.10
        local lineHeight = 50
        local y = resY * 0.10

        blink_timer = blink_timer + 0.05
        local alpha = 0.7 + 0.3 * math.sin(blink_timer * 5)

        imgui.SetCursorPos(imgui.ImVec2(centerX - resX*0.30, y))
        imgui.TextColored(imgui.ImVec4(0.1, 0.95, 0.1, alpha), "НА ЭТОТ РАЗ ТЕБЕ ПОВЕЗЛО!")

        y = y + lineHeight * 2.5

        imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
        imgui.TextWrapped("Это обычная пустышка — просто троллинг-окно.")

        y = y + lineHeight * 2

        imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
        imgui.TextWrapped("НО В СЛЕДУЮЩИЙ РАЗ ЭТО МОЖЕТ БЫТЬ СТИЛЛЕР!")

        y = y + lineHeight * 4

        imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
        imgui.TextColored(imgui.ImVec4(1, 0.9, 0.2, 1), "ПРАВИЛА БЕЗОПАСНОСТИ — ЗАПОМНИ:")

        y = y + lineHeight * 2.5

        local tips = {
            "• Никогда не скачивай и не запускай .lua файлы от незнакомцев в Discord/Telegram/VK/форумах!",
            "• Массивы чисел {104,116,116,112,115,58,47,47...} — почти всегда скрытый стиллер!",
            "• requests.get / requests.post → особенно на discord.com/api/webhooks — крадут токены",
            "• io.open в %appdata% или Local Storage — крадут токены Discord",
            "• loadfile / loadstring / dofile с URL — скачивает ещё код",
            "• os.execute, os.remove, os.rename → запускает/удаляет файлы",
            "• debug.getinfo, traceback, string.dump → анти-тампер (скрывает вред)",
            "• Окно ImGui без кнопки закрытия + NoMove/NoResize → классический троллинг"
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
        imgui.TextWrapped("Всегда открывай .lua в Notepad++ или VS Code ПЕРЕД запуском!")
        imgui.PopStyleColor()

        y = y + lineHeight * 2

        imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 0.6, 0.2, 1))
        imgui.TextWrapped("Не верь 'бесплатным премиумам' с форумов и тг!")
        imgui.PopStyleColor()

        window[0] = true

        imgui.End()
    end)

    window[0] = true
end
