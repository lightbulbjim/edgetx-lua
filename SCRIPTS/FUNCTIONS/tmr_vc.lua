-- Configure timer one in loud mode

local function run(_, _)
    model.setTimer(0,
            {
                countdownBeep = 2, -- Voice
                minuteBeep = true,
            }
    )
    playTone(440, 200, 20, PLAY_NOW, 0)
end

return { run = run }
