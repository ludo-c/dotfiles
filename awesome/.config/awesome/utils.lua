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
    output = fh:read("*l")
    if output == "active" then
        socks_status = "<span color='green'>✔</span>"
    else
        socks_status = "<span color='red'>✘</span>"
    end
    widget:set_markup("|"..script..":"..socks_status.."| ")
    fh:close()
end

