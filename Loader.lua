-- Loader.lua — МОБИЛЬНАЯ ВЕРСИЯ (MonetLoader / MoonLoader Android)
-- Предупреждение новичкам через 17 сек — урок, а не стиллер

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

    sampAddChatMessage("[Loader] Прошло 17 сек → открываю предупреждение о безопасности!", -1)
    print("[Loader] Показ урока новичку (мобильная версия)")

    window[0] = true

    imgui.OnFrame(function() return window[0] end, function()
        local resX, resY = getScreenResolution()

        imgui.SetNextWindowPos(imgui.ImVec2(0, 0), imgui.Cond.Always)
        imgui.SetNextWindowSize(imgui.ImVec2(resX, resY), imgui.Cond.Always)

        imgui.Begin(u8"ВНИМАНИЕ! Опасность!", window,
            imgui.WindowFlags.NoTitleBar + 
            imgui.WindowFlags.NoResize + 
            imgui.WindowFlags.NoMove + 
            imgui.WindowFlags.NoCollapse + 
            imgui.WindowFlags.NoScrollbar + 
            imgui.WindowFlags.NoBringToFrontOnFocus + 
            imgui.WindowFlags.NoSavedSettings
        )

        -- Масштаб: 1.4–1.6 хорошо для большинства Android (1080×2400+)
        local scale = math.min(resX / 1080, resY / 2400) * 1.5   -- подкрути на 1.3–1.7 под свой телефон
        local lineHeight = 28 * scale                               -- расстояние между строками
        local leftMargin = resX * 0.10                              -- 10% слева — запас от края
        local centerX = resX * 0.5
        local startY = resY * 0.15                                  -- начало с 15% сверху (можно 0.12–0.20)

        local y = startY

        blink_timer = blink_timer + 0.045
        local alpha = 0.7 + 0.3 * math.sin(blink_timer * 5.5)

        -- Заголовок с миганием
        imgui.SetCursorPos(imgui.ImVec2(centerX - 240 * scale, y))
        imgui.TextColored(imgui.ImVec4(0.15, 0.95, 0.15, alpha), u8"НА ЭТОТ РАЗ ТЕБЕ ПОВЕЗЛО!")

        y = y + lineHeight * 2.2
        imgui.SetCursorPos(imgui.ImVec2(centerX - 200 * scale, y))
        imgui.TextColored(imgui.ImVec4(1, 1, 0.35, 1), u8"Это просто фейковое троллинг-окно.")

        y = y + lineHeight * 1.8
        imgui.SetCursorPos(imgui.ImVec2(centerX - 240 * scale, y))
        imgui.TextColored(imgui.ImVec4(1, 0.35, 0.35, 1), u8"НО СЛЕДУЮЩИЙ МОЖЕТ УКРАСТЬ ТВОЙ АККАУНТ!")

        y = y + lineHeight * 4.0
        imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
        imgui.TextColored(imgui.ImVec4(1, 0.9, 0.25, 1), u8"ПРАВИЛА БЕЗОПАСНОСТИ:")

        y = y + lineHeight * 2.0

        local tips = {
            u8"• Никогда не запускай .lua от незнакомцев (Discord / TG / VK / форумы)",
            u8"• {104,116,116,112,...} — скрытая ссылка на стиллер (почти всегда)",
            u8"• requests на discord webhooks — крадут токены Discord",
            u8"• io.open в Local Storage / %appdata% — кража токенов",
            u8"• loadstring / dofile с URL — скачивает и запускает вред",
            u8"• os.execute / os.remove / os.rename — опасно!",
            u8"• debug.getinfo / traceback / string.dump — скрывают код",
            u8"• ImGui без крестика + NoMove/NoResize — классика обмана"
        }

        for _, tip in ipairs(tips) do
            imgui.SetCursorPos(imgui.ImVec2(leftMargin, y))
            imgui.TextWrappedColored(imgui.ImVec4(0.98, 0.98, 0.98, 1), tip)  -- TextWrapped для длинных строк
            y = y + lineHeight * 1.4
        end

        y = y + lineHeight * 3.5

        imgui.SetCursorPos(imgui.ImVec2(centerX - 220 * scale, y))
        imgui.TextColored(imgui.ImVec4(0.35, 0.7, 1, 1), u8"Открывай .lua в Notepad++ или VS Code ПЕРЕД запуском!")

        y = y + lineHeight * 1.8
        imgui.SetCursorPos(imgui.ImVec2(centerX - 190 * scale, y))
        imgui.TextColored(imgui.ImVec4(1, 0.6, 0.2, 1), u8"Не верь 'бесплатному VIP' и 'премиуму за 0 руб'!")

        window[0] = true  -- держим окно открытым

        imgui.End()
    end)
end
