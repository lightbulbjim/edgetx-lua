local name = "Signal"
-- A simple CRSF signal health display

--[[ TODO:
* More elegant coord system
* Handle single antenna receivers better
]]

local options = {}

local function create(zone, options)
    local widget = {
        zone = zone,
        options = options,
        telemetry = {
            ant = { source = getFieldInfo("ANT"), value = nil },
            rss1 = { source = getFieldInfo("1RSS"), value = 0 },
            rss2 = { source = getFieldInfo("2RSS"), value = 0 },
            rqly = { source = getFieldInfo("RQly"), value = 0 }
        },
        teleSwitchIndex = getSwitchIndex("Tele")
    }
    return widget
end

local function update(widget, options)
    widget.options = options
end

local function setSize(widget, event)
    widget.drawTitle = true
    widget.legendSize = SMLSIZE
    widget.valueSize = BOLD
    widget.border = 10
    widget.boxPad = 4

    if event ~= nil then
        widget.height = LCD_H
        widget.width = LCD_W
    else
        widget.height = widget.zone.h
        widget.width = widget.zone.w
    end

    if widget.height > 80 and widget.width > 390 then
        widget.valueSize = DBLSIZE
        if widget.width > 450 then
            widget.border = 40
        end
    elseif widget.height < 60 then
        widget.drawTitle = false
    end

    local rssW, rssH = lcd.sizeText("-999dB", widget.valueSize)
    widget.boxHeight = rssH + (widget.boxPad * 2)
    widget.boxWidth = rssW + (widget.boxPad * 2)
    widget.rss1Offset = rssW
    widget.rss2Offset = (rssW * 2) + 14
    widget.vOffset = (widget.height - rssH) / 2

    --lcd.drawText(widget.width, 0, widget.height .. "h," .. widget.width .. "w", widget.legendSize + COLOR_THEME_PRIMARY1 + RIGHT)
end

local function refreshTelemetry(widget)
    for _, sensor in pairs(widget.telemetry) do
        if sensor.source ~= nil then
            sensor.value = getValue(sensor.source.id)
        end
    end
end

local function refresh(widget, event, _)
    setSize(widget, event)

    local colour = COLOR_THEME_DISABLED

    if getSwitchValue(widget.teleSwitchIndex) then
        refreshTelemetry(widget)
        colour = COLOR_THEME_PRIMARY1
    end

    if widget.drawTitle then
        lcd.drawText(0, 0, CHAR_TELEMETRY .. "Signal", widget.legendSize + colour)
    end

    lcd.drawText(widget.border + widget.rss1Offset, widget.vOffset, widget.telemetry.rss1.value .. "dB",
            widget.valueSize + colour + RIGHT)

    lcd.drawText(widget.border + widget.rss2Offset, widget.vOffset, widget.telemetry.rss2.value .. "dB",
            widget.valueSize + colour + RIGHT)

    lcd.drawText(widget.width - widget.border, widget.vOffset, widget.telemetry.rqly.value .. "%",
            widget.valueSize + colour + RIGHT)

    if widget.telemetry.ant.value == 0 then
        lcd.drawRectangle(widget.border - widget.boxPad, widget.vOffset - widget.boxPad,
                widget.boxWidth, widget.boxHeight, colour, 1)
    elseif widget.telemetry.ant.value == 1 then
        lcd.drawRectangle(widget.border + widget.rss2Offset + widget.boxPad - widget.boxWidth,
                widget.vOffset - widget.boxPad, widget.boxWidth, widget.boxHeight, colour, 1)
    end
end

return {
    name = name,
    options = options,
    create = create,
    update = update,
    refresh = refresh,
}
