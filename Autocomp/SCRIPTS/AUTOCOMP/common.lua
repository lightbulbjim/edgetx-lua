-- Control weight of brake compensation curve.
-- Entry point is via cmpdec.lua and cmdinc.lua function scripts.

local common = {}

local inputName = string.lower("Spo")
local curveName = string.lower("Cmp")  -- Only custom curves are supported

local inputId
local inputFieldId
local curveId

local velocity = 1
local lastClickTime = 0

-- Returns the field ID of the spoiler stick input
local function findInputId()
    for i = 0, 32 do
        -- Only the first input line is used
        local input = model.getInput(i, 0)

        if input ~= nil and string.lower(input.inputName) == inputName then
            return i
        end
    end

    return nil
end

-- Returns the index of the elevator compensation curve
local function findCurveId()
    for i = 0, 31 do
        local curve = model.getCurve(i)

        if string.lower(curve.name) == curveName then
            return i
        end
    end

    return nil
end

-- Returns the index of the point with value closest to sample
local function findPoint(value, points)
    local closest = 1
    local delta = 200

    for i, v in ipairs(points) do
        local d = math.abs(value - v)
        if d < delta then
            closest = i
            delta = d
        end
    end

    return closest
end

function common.init()
    inputId = findInputId()
    if inputId ~= nil then
        inputFieldId = getSourceIndex(CHAR_INPUT .. inputName)
    end

    curveId = findCurveId()
end

function common.adjust(step)
    local theTime = getTime()

    -- Reset to slow speed when the trim hasn't been touched for a while
    if theTime - lastClickTime > 45 then
        velocity = 1
    end

    -- Gradually increase adjustment speed as trim switch is held.
    -- There's no sleep(), so just noop until it's time for action.
    if velocity == 0 then
        lastClickTime = theTime
        return
    elseif velocity <= 3 and theTime - lastClickTime < 30 then
        return
    elseif velocity <= 7 and theTime - lastClickTime < 11 then
        return
    end

    velocity = velocity + 1
    lastClickTime = theTime

    -- Guard against unconfigured input or curve
    if inputFieldId == nil or curveId == nil then return end

    -- Guard against the input being moved/renamed
    local input = model.getInput(inputId, 0)
    if input == nil or string.lower(input.inputName) ~= inputName then return end

    -- Guard against the curve being moved/renamed or non-custom
    local curve = model.getCurve(curveId)
    if curve == nil or string.lower(curve.name) ~= curveName or curve.x == nil then return end

    -- We need the source value to be a percentage
    local inputValue = math.ceil(getSourceValue(inputFieldId) / 10.24)
    local pointIndex = findPoint(inputValue, curve.x)

    -- Write the new value to the curve point
    curve.y[pointIndex] = curve.y[pointIndex] + step
    model.setCurve(curveId, curve)

    -- Beeps and boops
    if curve.y[pointIndex] == 0 then
        playFile("SYSTEM/midtrim.wav")
        playHaptic(10, 30, PLAY_NOW)
        velocity = 1
    elseif curve.y[pointIndex] >= 100 then
        playFile("SYSTEM/maxtrim.wav")
        playHaptic(10, 30, PLAY_NOW)
        velocity = 0
    elseif curve.y[pointIndex] <= -100 then
        playFile("SYSTEM/mintrim.wav")
        playHaptic(10, 30, PLAY_NOW)
        velocity = 0
    else
        playTone(1000 + (curve.y[pointIndex] * 2), 50, 30, PLAY_NOW, 0)
    end
end

return common
