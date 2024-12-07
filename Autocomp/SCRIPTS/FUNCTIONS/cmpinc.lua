-- Increase weight of brake compensation curve.
-- Place in /SCRIPTS/FUNCTIONS and call from a special function.

local common = loadScript("/SCRIPTS/AUTOCOMP/common.lua")()

local function init()
    common.init()
end

local function run()
    common.adjust(1)
end

return { init = init, run = run }
