-- Configures timer one in quiet mode.
-- Place in /SCRIPTS/FUNCTIONS and call from a special function.

local function run(_, _)
    model.setTimer(0,
            {
                countdownBeep = 0, -- Silent
                minuteBeep = false,
            }
    )
    playTone(330, 200, 20, PLAY_NOW, 0)
end

return { run = run }
