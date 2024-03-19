-- Configures timer one in voice mode.
-- Place in /SCRIPTS/FUNCTIONS and call from a special function.

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
