local naughty = require("naughty")

-- http://awesome.naquadah.narkive.com/f5MrgAjx/zap-naughty-notifications
-- destroy notifications by keys {{{
function close_last_naughty_msg()
    screen = naughty.config.defaults.screen
    for p,pos in pairs(naughty.notifications[screen]) do
        for i,n in pairs(naughty.notifications[screen][p]) do
            naughty.destroy(n)
            return true
        end
    end
    return false
end

function close_all_naughty_msg()
    n = close_last_naughty_msg()
    while n do
        n = close_last_naughty_msg()
    end
end
-- }}}

function check_tunnel(widget, script)
    fh = assert(io.popen(script .. " status", "r"))
    output = fh:read()
    if output == "active" then
        socks_status = "<span color='green'>✔</span>"
    else
        socks_status = "<span color='red'>✘</span>"
    end
    widget:set_markup("|"..script..":"..socks_status.."| ")
    fh:close()
end

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
    fh = assert(io.popen("acpi | cut -d, -f 2,3 - | sed -e 's/[a-z.,-]//g' -e 's/ *$//g' -e 's/^ //g'", "r"))
    widget:set_markup("| <span color='"..bat_color.."'>" .. fh:read("*l") .. "</span> | ")
    fh:close()
end

