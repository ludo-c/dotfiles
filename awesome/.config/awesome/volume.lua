-- Creates a volume display widget
-- Copied/adapted from https://awesome.naquadah.org/wiki/Davids_volume_widget
---------------------------------

local awful = require("awful")
require("autostart")

-- Color constants
local normal_color = '#33cc33'
local over_100_color = '#3333cc'
local mute_color = '#cc3333'
local background_color = '#222222'
local background_over_100_color = normal_color

local sink_tab = {} -- new array with sinks index
local default_sink = nil
local volume_real = 0
local volume_step = 3
local mute_real = nil

-- Functions to fetch volume information (pulseaudio)
local function get_volume() -- returns the volume as a float (1.0 = 100%)
    -- 'pacmd dump-volumes' is faster than 'patcl list sinks'
    local fd = io.popen("LANG=C pacmd dump-volumes | grep 'Sink "..default_sink.."' | grep -o '...%' | sed 's/[^0-9]*//g'")
    local volume_str = fd:read() -- take only the first line (replace a '| head -n 1')
    fd:close()
    return tonumber(volume_str) / 100
end

local function get_mute() -- returns a true value if muted or a false value if not
    fd = io.popen("LANG=C pactl list sinks | grep -A 9001 'Sink #".. default_sink .."' | grep Mute")
    local mute_str = fd:read()
    fd:close()
    return string.find(mute_str, "yes")
end

local function update_mute(state, not_default)
    -- not_default -> do not update default sink
    local val = state
    for k,v in pairs(sink_tab) do
        if not_default == nil or (not_default ~= nil and  v ~= default_sink) then
            os.execute("pactl -- set-sink-mute ".. v .." ".. val, false)
        end
    end
end

local function refresh_sinks()
    -- call it BEFORE update_widget

    -- Get the default sink index. https://wiki.archlinux.org/index.php/PulseAudio/Examples
    local fd = io.popen("LANG=C pacmd list-sinks | grep '* index' | awk '{print $3}'")
    default_sink = tonumber(fd:read())
    fd:close()
    -- Get all sinks indexes
    local fd = io.popen("LANG=C pacmd list-sinks | grep index | grep -o '[0-9]*'")
    sink_tab = {} -- reset tab
    local i = 1 -- However, it is customary in Lua to start arrays with index 1 http://www.lua.org/pil/11.1.html
    for line in fd:lines() do
        sink_tab[i] = tonumber(line)
        i = i + 1
    end
    fd:close()

    -- set same volume everywhere
    local volume_str = get_volume() * 100
    volume_str = volume_str.."%"
    for k,v in pairs(sink_tab) do
        if v ~= default_sink then
            os.execute("pactl -- set-sink-volume ".. v .." "..volume_str, false)
        end
    end

    -- set same mute state everywhere
    if get_mute() then
        update_mute("yes", true)
    else
        update_mute("no", true)
    end

end

-- Updates the volume widget's display
local function update_widget(widget, step)
    local volume
    local mute

    if step == nil then
        volume = get_volume()
        mute = get_mute()
        mute_real = mute
    else
        volume = volume_real + tonumber(step / 100)
        --dbg({volume_real,step, tonumber(step / 100), volume})
        if volume < 0 then volume = 0 end
        mute = mute_real
    end
    volume_real = volume

    -- color
    color = normal_color
    bg_color = background_color
    if volume > 1 then
        color = over_100_color
        bg_color = background_over_100_color
        volume = volume % 1
    end
    color = (mute and mute_color) or color

    widget:set_color(color)
    widget:set_background_color(bg_color)

    widget:set_value(volume)
end

-- true -> increase, false -> decrease
local function update_volume(inc)
    -- os.execute("amixer -D pulse set Master 5%+")
    if inc == true then
        step = "+".. volume_step
    else
        step = "-".. volume_step
    end
    for k,v in pairs(sink_tab) do
        os.execute("pactl -- set-sink-volume ".. v .." ".. step .."%", false)
    end
    return step
end

-- Volume control functions for external use
function inc_volume(widget)
    local step = update_volume(true)
    update_widget(widget, step)
end

function dec_volume(widget)
    local step = update_volume(false)
    update_widget(widget, step)
end

function mute_volume(widget)
    refresh_sinks()
    update_mute("toggle")
    update_widget(widget)
end

function create_volume_widget()
    -- Define volume widget
    volume_widget = awful.widget.progressbar()
    volume_widget:set_width(8)
    volume_widget:set_vertical(true)
    volume_widget:set_border_color('#666666')
    -- Init the widget
    refresh_sinks()
    update_widget(volume_widget)

    volume_widget:buttons (awful.util.table.join (
          awful.button ({}, 1, function() run_once("pavucontrol") end),
          awful.button ({}, 4, function() inc_volume(volume_widget) end),
          awful.button ({}, 3, function() mute_volume(volume_widget) end),
          awful.button ({}, 5, function() dec_volume(volume_widget) end)
    ))

    -- Update the widget on a timer
    --mytimer = timer({ timeout = 1 })
    --mytimer:connect_signal("timeout", function () update_widget(volume_widget) end)
    --mytimer:start()

    return volume_widget
end

