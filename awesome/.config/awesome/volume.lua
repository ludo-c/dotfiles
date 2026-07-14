-- Creates a volume display widget
-- Copied/adapted from https://awesome.naquadah.org/wiki/Davids_volume_widget
---------------------------------

--
-- useful commands
--
-- change input volume (mic) :
--   pactl list sources
--   pactl list short sources
--   pacmd set-source-volume <index> <volume>
-- change output volume (headphones) :
--   pactl list sinks
--   pactl list short sinks
--   pacmd set-sink-volume <index> <volume>
-- change application volume:
--   pactl list sink-inputs
--   pactl list short sink-inputs
--   pactl set-sink-input-volume [sink number] [volume percent]
--

-- WARNING: sink-inputs are not at 100% when created (don't know why)

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
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
local volume_step = 3 -- in percentage
local mute_real = nil

-- Functions to fetch volume information (pulseaudio)
local function get_volume() -- returns the volume as int (100 = 100%)
    local fd = io.popen("LANG=C pactl get-sink-volume @DEFAULT_SINK@")
    local line = fd:read("*l")
    fd:close()

    if not line then
        return 0
    end

    return tonumber(line:match("(%d+)%%")) or 0
end

local function get_mute() -- returns a true value if muted or a false value if not
    local fd = io.popen("LANG=C pactl get-sink-mute @DEFAULT_SINK@")
    local line = fd:read("*l")
    fd:close()

    return line and line:find("yes") ~= nil
end

local function update_volume(value, not_default)
    -- not_default -> do not update default sink
    -- os.execute("amixer -D pulse set Master 5%+")
    for k,v in pairs(sink_tab) do
        if not_default == nil or (not_default ~= nil and  v ~= default_sink) then
            --dbg({v})
            awful.spawn("pactl -- set-sink-volume ".. v .." ".. value)
        end
    end
    return step
end

local function update_mute(state, not_default)
    -- not_default -> do not update default sink
    local val = state
    for k,v in pairs(sink_tab) do
        if not_default == nil or (not_default ~= nil and  v ~= default_sink) then
            awful.spawn("pactl -- set-sink-mute ".. v .." ".. val)
        end
    end
end

local function refresh_sinks()
    -- call it BEFORE update_widget

    sink_tab = {}
    default_sink = nil

    -- Nom du sink par défaut
    local fd = io.popen("LANG=C pactl get-default-sink")
    local default_name = fd:read("*l")
    fd:close()

    -- Liste des sinks
    fd = io.popen("LANG=C pactl list short sinks")

    for line in fd:lines() do
        local id, name = line:match("^(%d+)%s+(%S+)")

        if id then
            id = tonumber(id)
            table.insert(sink_tab, id)

            if name == default_name then
                default_sink = id
            end
        end
    end

    fd:close()

    -- Synchronise les volumes
    local volume = tostring(get_volume()) .. "%"
    update_volume(volume)

    -- Synchronise le mute
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
        volume = get_volume() / 100
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

    widget.widget:set_color(color)
    widget.widget:set_background_color(bg_color)

    widget.widget:set_value(volume)
end

-- Volume control functions for external use
function inc_volume(widget)
    local value = "+".. volume_step
    update_volume(value .."%", nil)
    update_widget(widget, value)
end

function dec_volume(widget)
    local value = "-".. volume_step
    update_volume(value .."%", nil)
    update_widget(widget, value)
end

function mute_volume(widget)
    refresh_sinks()
    update_mute("toggle")
    update_widget(widget)
end

function create_volume_widget()
    -- Define volume widget
    volume_widget = wibox.widget {
	    {
		max_value     = 1,
		widget        = wibox.widget.progressbar,
	    },
	    --forced_height = 20,
	    forced_width  = 10,
	    direction     = 'east',
	    bar_border_color = '#666666',
	    layout        = wibox.container.rotate
	}
    -- Init the widget
    refresh_sinks()
    update_widget(volume_widget)

    volume_widget:buttons (gears.table.join (
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
