-- Log the current GPS coordinates to a file

local logfile = "/LOGS/crumbs.txt"

local function run()
    local position = getValue("GPS")
    if position == 0 then return end
    local fPosition = position.lat .. "," .. position.lon

    local time = getDateTime()
    local fTime = string.format("%d-%02d-%02dT%02d:%02d:%02d", time.year, time.mon, time.day, time.hour, time.min, time.sec)

    file = io.open(logfile, "a")
    io.write(file, fTime .. " " .. fPosition, "\r\n")
    io.close(file)

    playTone(200, 150, 20, PLAY_NOW, 8)
end

return { run = run }
