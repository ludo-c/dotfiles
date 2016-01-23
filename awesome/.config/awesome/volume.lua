-- WARNING ! Delete some "--" and change "0" to "1" !

-- Creates a volume display widget
-- Copied/adapted from https://awesome.naquadah.org/wiki/Davids_volume_widget
---------------------------------

local awful = require("awful")
require("autostart")
-- Get the sink index. https://wiki.archlinux.org/index.php/PulseAudio/Examples
local fd = io.popen("pacmd list-sinks | grep '* index' | awk '{print $3}'")
local sink = tonumber(fd:read("*all"))
fd:close()

-- Color constants
local normal_color = '#33cc33'
local over_100_color = '#3333cc'
local mute_color = '#cc3333'
local background_color = '#222222'
local background_over_100_color = normal_color

-- Functions to fetch volume information (pulseaudio)
function get_volume() -- returns the volume as a float (1.0 = 100%)
    local fd = io.popen("pactl list | grep -A 9001 'Sink #".. sink .."' | grep Volume | head -n 1 | awk -F / '{print $2}' | sed 's/[^0-9]*//g'")
    local volume_str = fd:read("*all")
    fd:close()
    return tonumber(volume_str) / 100
end

function get_mute() -- returns a true value if muted or a false value if not
    fd = io.popen("pactl list | grep -A 9001 'Sink #".. sink .."' | grep Mute | head -n 1")
    local mute_str = fd:read("*all")
    fd:close()
    return string.find(mute_str, "yes")
end

-- Updates the volume widget's display
local function update_volume(widget)
    local volume = get_volume()
    local mute = get_mute()

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

-- Volume control functions for external use
function inc_volume(widget)
    -- awful.util.spawn("amixer -D pulse set Master 5%+") 
    awful.util.spawn("pactl set-sink-volume ".. sink .." +3%", false)
    update_volume(widget)
end

function dec_volume(widget)
    awful.util.spawn("pactl set-sink-volume ".. sink .." -3%", false)
    update_volume(widget)
end

function mute_volume(widget)
    awful.util.spawn("pactl set-sink-mute ".. sink .." toggle", false)
    update_volume(widget)
end

function create_volume_widget()
    -- Define volume widget
    volume_widget = awful.widget.progressbar()
    volume_widget:set_width(8)
    volume_widget:set_vertical(true)
    volume_widget:set_border_color('#666666')
    -- Init the widget
    update_volume(volume_widget)

    volume_widget:buttons (awful.util.table.join (
          awful.button ({}, 1, function() run_once("pavucontrol") end),
          awful.button ({}, 4, function() inc_volume(volume_widget) end),
          awful.button ({}, 3, function() mute_volume(volume_widget) end),
          awful.button ({}, 5, function() dec_volume(volume_widget) end)
    ))

    -- Update the widget on a timer
    mytimer = timer({ timeout = 1 })
    mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
    mytimer:start()

    return volume_widget
end

