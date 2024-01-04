-- Configures timer one based on the value of a gvar

-- GVar used for setting timer values. Zero indexed.
local timerVar = 8

-- File to play when announcing sport mode.
local sportFile = "sport.wav"


local function init()
    -- Called once when the model is loaded
end

local function run(event, touchState)
    local minutes = model.getGlobalVariable(timerVar, 0)

    if minutes == 0 then  -- Sport mode
        model.setTimer(0,
                {
                    start = 0,
                    countdownBeep = 0,
                    minuteBeep = false,
                }
        )
        playFile(sportFile)
    elseif minutes > 0 then  -- Task mode
        model.setTimer(0,
                {
                    start = minutes * 60,
                    countdownBeep = 2,  -- Voice
                    minuteBeep = true,
                }
        )
        playNumber(minutes, 0)
    end

    -- Non-zero return value halts the script. We only need it to run once per invocation.
    return 1
end

return { run = run, init = init }
