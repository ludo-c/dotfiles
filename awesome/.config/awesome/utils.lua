-- utils functions

local naughty = require("naughty")

-- http://awesome.naquadah.org/wiki/Naughty/fr
function dbg(vars)
    local text = ""
    for i=1, #vars do text = text .. vars[i] .. " | " end
    naughty.notify({ text = text, timeout = 0 })
end

-- http://askubuntu.com/questions/611350/need-battery-applet-for-awesome-wm-and-ubuntu-14-04
function battery_status(widget)
    fh = assert(io.popen("acpi -b | grep -o '...%' | tr -d ',%'", "r"))
    if tonumber(fh:read("*l")) < 15 then
        bat_color = 'red'
    else
        bat_color = 'grey'
    end
    fh:close()
    fh = assert(io.popen("acpi | cut -d, -f 2,3 - | sed -e 's/[a-z.,-]//g' -e 's/ *$//g' -e 's/^ *//g' -e 's/\\(.*\\):.*/\\1/'", "r"))
    widget:set_markup("| <span color='"..bat_color.."'>" .. fh:read("*l") .. "</span> | ")
    fh:close()
end

