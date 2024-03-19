-- TNS|Clear logs|TNE

-- Poor man's enum.
PENDING = 0
NOLOGS = 1
WORKING = 2
COMPLETE = 3
ERROR = 4

local state = PENDING
local number_of_logs = nil

-- There's no `table` library on monochrome radios, so we have to be inelegant.
local function count_logs()
    local count = 0
    for file in dir("/LOGS") do
        if string.sub(file, -4, -1) == ".csv" then
            count = count + 1
        end
    end
    return count
end

local function delete_logs()
    local deleted = 0
    for file in dir("/LOGS") do
        if string.sub(file, -4, -1) == ".csv" then
            if del("/LOGS/" .. file) == 0 then
                deleted = deleted + 1
            else
                return ERROR
            end
        end
    end

    if deleted > 0 then
        return COMPLETE
    else
        return NOLOGS
    end
end

local function run(event, _)
    lcd.clear()
    if event == EVT_EXIT_BREAK then
        state = PENDING
        return 1
    end

    if number_of_logs == nil then
        number_of_logs = count_logs()
        if number_of_logs == 0 then
            state = NOLOGS
        end
    end

    if state == PENDING then
        popupConfirmation("Delete " .. number_of_logs .. " logs?", "", event)
        if event == EVT_VIRTUAL_ENTER then
            state = WORKING
        end
    elseif state == WORKING then
        lcd.clear()
        lcd.drawText(LCD_W / 2, LCD_H / 2, "Deleting...", CENTER, VCENTER)
        state = delete_logs(logs)
    elseif state == NOLOGS then
        popupWarning("No log files!", event)
    elseif state == COMPLETE then
        popupWarning("Logs cleared!", event)
    elseif state == ERROR then
        popupWarning("Error deleting files!", event)
    end

    return 0
end

return { run = run }
