-- utils functions

local naughty = require("naughty")

-- http://awesome.naquadah.org/wiki/Naughty/fr
function dbg(vars)
    local text = ""
    for i=1, #vars do text = text .. vars[i] .. " | " end
    naughty.notify({ text = text, timeout = 0 })
end

