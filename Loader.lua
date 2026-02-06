local imgui = require 'mimgui'

local window = imgui.new.bool(false)
local blink_timer = 0

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        wait(100)
        return
    end

    local resX, resY = getScreenResolution()
    print(string.format("[Loader] Разрешение: %dx%d", resX, resY))

    wait(17000)

    sampAddChatMessage("[Loader] Прошло 17 сек → предупреждение!", -1)
    print("[Loader] Запуск компактного окна")

    imgui.GetIO().FontGlobalScale = 2.2

    imgui.OnFrame(function() return window[0] end, function()
        local resX, resY = getScreenResolution()

        -- Компактное окно по центру
        local winWidth  = resX * 0.80
        local winHeight = resY * 0.75
        local winX = (resX - winWidth) / 2
        local winY = (resY - winHeight) / 2 + resY * 0.05

        imgui.SetNextWindowPos(imgui.ImVec2(winX, winY), imgui.Cond.Always)
        imgui.SetNextWindowSize(imgui.ImVec2(winWidth, winHeight), imgui.Cond.Always)

        imgui.Begin("ВНИМАНИЕ! Это могло быть опасно", window,
            imgui.WindowFlags.NoTitleBar +
            imgui.WindowFlags.NoResize +
            imgui.WindowFlags.NoMove +
            imgui.WindowFlags.NoCollapse +
            imgui.WindowFlags.NoScrollbar +
            imgui.WindowFlags.NoSavedSettings
        )

        local centerX = winWidth * 0.5
        local y = 40

        blink_timer = blink_timer + 0.05
        local alpha = 0.7 + 0.3 * math.sin(blink_timer * 6)

        imgui.SetCursorPosX(centerX - 220)
        imgui.TextColored(imgui.ImVec4(0.1, 0.95, 0.1, alpha), "НА ЭТОТ РАЗ ТЕБЕ ПОВЕЗЛО!")

        y = y + 50
        imgui.SetCursorPosX(centerX - 180)
        imgui.TextWrapped("Это обычная пустышка — просто троллинг-окно.")

        y = y + 40
        imgui.SetCursorPosX(centerX - 200)
        imgui.TextWrapped("НО В СЛЕДУЮЩИЙ РАЗ ЭТО МОЖЕТ БЫТЬ СТИЛЛЕР!")

        y = y + 50
        imgui.SetCursorPosX(centerX - 260)
        imgui.TextColored(imgui.ImVec4(1, 0.4, 0.4, 1), "Скрипты из чатов, непонятных источников,")
        imgui.SetCursorPosX(centerX - 220)
        imgui.TextColored(imgui.ImVec4(1, 0.4, 0.4, 1), "кряки/сливы VIP-версий в 99% случаев")
        imgui.SetCursorPosX(centerX - 140)
        imgui.TextColored(imgui.ImVec4(1, 0.4, 0.4, 1), "ОПАСНЫ для устройства/аккаунта!")

        y = y + 60
        imgui.SetCursorPosX(centerX - 140)
        imgui.TextColored(imgui.ImVec4(1, 0.9, 0.2, 1), "ПРАВИЛА БЕЗОПАСНОСТИ")

        y = y + 40

        local tips = {
            "• Никогда не скачивай .lua от незнакомцев в Discord/Telegram/VK/форумах!",
            "• {104,116,116,112,...} — почти всегда скрытый стиллер!",
            "• requests на discord webhooks — крадут токены!",
            "• io.open в Local Storage / %appdata% — кража токенов",
            "• loadstring / dofile с URL — подгружает вредоносный код",
            "• os.execute / os.remove / os.rename — опасные команды",
            "• debug.getinfo / traceback / string.dump — скрывают вред",
            "• ImGui без крестика + NoMove/NoResize — классика обмана"
        }

        for _, tip in ipairs(tips) do
            imgui.SetCursorPosX(centerX - (winWidth * 0.45))
            imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.98, 0.98, 0.98, 1))
            imgui.TextWrapped(tip)
            imgui.PopStyleColor()
            y = y + 38
        end

        y = y + 50

        imgui.SetCursorPosX(centerX - 180)
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.4, 0.8, 1, 1))
        imgui.TextWrapped("Открывай .lua в Notepad++ / VS Code перед запуском!")
        imgui.PopStyleColor()

        y = y + 40

        imgui.SetCursorPosX(centerX - 160)
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 0.6, 0.2, 1))
        imgui.TextWrapped("Не верь 'бесплатным VIP' и 'премиуму за 0 руб'!")
        imgui.PopStyleColor()

        window[0] = true

        imgui.End()
    end)

    window[0] = true
end
