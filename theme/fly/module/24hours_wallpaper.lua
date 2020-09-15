-- [[
-- 24 hours wallpaper
-- change wallpaper automaticaly by your location time
-- the whold day will be spilted to four duration:
-- sunrise start to sunrise end
-- daylight
-- sunset start to sunset end
-- night
-- Specification: https://www.esrl.noaa.gov/gmd/grad/solcalc/solareqns.PDF
-- ]]
local gears = require("gears")
local sig = require("theme.fly.signal")
local json = require("utils.json")
local beautiful = require("beautiful")
local Gio = require("lgi").Gio

local wallpaper = {}
local sunrise_time, sunset_time, civil_dusk, civil_dawn, after_sunrise, before_sunset -- minutes
local sunrise_time_next, sunset_time_next, civil_dusk_next, civil_dawn_next, after_sunrise_next, before_sunset_next -- minutes
local timer

local function is_leap_year(year)
    return (year % 4 == 0 and year % 100 ~= 0) or
            (year % 400 == 0) or
            (year % 3200 == 0 and year % 172800)
end


local function calculate_sunrise_and_sunset(lat, long, timezone, year, month, day, day_of_year, hour)
    local days = 365
    if is_leap_year(year) then
        days = 366
    end

    lat = math.rad(lat)

    local gamma = (2 * math.pi / days) * (day_of_year - 1 + (hour - 12) / 24)
    local decl = 0.006918 - 0.399912 * math.cos(gamma) + 0.070257 * math.sin(gamma) - 0.006758 * math.cos(2 * gamma) +
            0.000907 * math.sin(2 * gamma) - 0.002697 * math.cos(3 * gamma) + 0.00148 * math.sin(3 * gamma)
    local etime = 229.18 * (0.000075 + 0.001868 * math.cos(gamma) - 0.032077 * math.sin(gamma) - 0.014615 * math.cos(2 * gamma) - 0.040849 * math.sin(2 * gamma))
    local ha = math.acos(math.cos(math.rad(90.833)) / (math.cos(lat) * math.cos(decl)) - math.tan(lat) * math.tan(decl))
    local ha_civil = math.acos(math.cos(math.rad(96)) / (math.cos(lat) * math.cos(decl)) - math.tan(lat) * math.tan(decl))
    local ha_after = math.acos(math.cos(math.rad(84)) / (math.cos(lat) * math.cos(decl)) - math.tan(lat) * math.tan(decl))

    local sunrise_min = 720 - 4 * (long + math.deg(ha)) - etime + tonumber(timezone) * 60
    local sunset_min = 720 - 4 * (long - math.deg(ha)) - etime + tonumber(timezone) * 60

    local civil_dawn_min = 720 - 4 * (long + math.deg(ha_civil)) - etime + tonumber(timezone) * 60
    local civil_dusk_min = 720 - 4 * (long - math.deg(ha_civil)) - etime + tonumber(timezone) * 60

    local after_sunrise_min = 720 - 4 * (long + math.deg(ha_after)) - etime + tonumber(timezone) * 60
    local before_sunset_min = 720 - 4 * (long + math.deg(ha_after)) - etime + tonumber(timezone) * 60

    local sunrise_time = os.time {
        year = year,
        day = day,
        month = month,
        hour = math.floor(sunrise_min / 60),
        min = math.floor(sunrise_min - math.floor(sunrise_min / 60) * 60)
    }

    local sunset_time = os.time {
        year = year,
        day = day,
        month = month,
        hour = math.floor(sunset_min / 60),
        min = math.floor(sunset_min - math.floor(sunset_min / 60) * 60)
    }

    local civil_dawn = os.time {
        year = year,
        day = day,
        month = month,
        hour = math.floor(civil_dawn_min / 60),
        min = math.floor(civil_dawn_min - math.floor(civil_dawn_min / 60) * 60)
    }

    local civil_dusk = os.time {
        year = year,
        day = day,
        month = month,
        hour = math.floor(civil_dusk_min / 60),
        min = math.floor(civil_dusk_min - math.floor(civil_dusk_min / 60) * 60)
    }

    local after_sunrise = os.time {
        year = year,
        day = day,
        month = month,
        hour = math.floor(after_sunrise_min / 60),
        min = math.floor(after_sunrise_min - math.floor(after_sunrise_min / 60) * 60)
    }

    local before_sunset = os.time {
        year = year,
        day = day,
        month = month,
        hour = math.floor(before_sunset_min / 60),
        min = math.floor(before_sunset_min - math.floor(before_sunset_min / 60) * 60)
    }

    return sunrise_time, sunset_time, civil_dusk, civil_dawn, after_sunrise, before_sunset
end

function wallpaper:calculate_timer()
    local now = os.time()

    if timer then
        timer:stop()
    end

    if now >= civil_dawn_next then
        sunrise_time, sunset_time, civil_dusk, civil_dawn, after_sunrise, before_sunset =
        calculate_sunrise_and_sunset(self.latitude, self.longitude, self.config.timezone,
            os.date("%Y"), os.date("%m"), os.date("%d"), os.date("%j"), os.date("%H"))

        sunrise_time_next, sunset_time_next, civil_dusk_next, civil_dawn_next, after_sunrise_next, before_sunset_next =
        calculate_sunrise_and_sunset(self.latitude, self.longitude, self.config.timezone,
            os.date("%Y"), os.date("%m"), os.date("%d") + 1, os.date("%j"), os.date("%H"))
    end

    local path, timeout, image_list, time_start, time_end

    -- duraion: sunrise start to sunrise end
    if now > civil_dawn and now < after_sunrise then
        image_list = self.theme.sunriseImageList
        time_start = civil_dawn
        time_end = after_sunrise
    end

    -- duration: daylight
    if now >= after_sunrise and now <= before_sunset then
        image_list = self.theme.dayImageList
        time_start = after_sunrise
        time_end = before_sunset
    end

    -- duration: sunset start to sunset end
    if now > before_sunset and now < civil_dusk then
        image_list = self.theme.sunsetImageList
        time_start = before_sunset
        time_end = civil_dusk
    end

    -- duration: night
    if now >= civil_dusk then
        image_list = self.theme.nightImageList
        time_start = civil_dusk
        time_end = civil_dawn_next
    end

    -- calculating and emit signal to update wallpaper
    local len = #image_list
    local duration = (time_end - time_start) / len

    local index = math.ceil((now - time_start) / duration)

    path = self.base_filename:gsub("*", image_list[index])
    timeout = index * duration - (now - time_start)

    if path then
        awesome.emit_signal(sig.wallpaper.update_wallpaper, path)
    end

    timer = gears.timer {
        timeout = timeout,
        autostart = true,
        call_now = false,
        callback = function()
            wallpaper:calculate_timer()
        end
    }
end

function wallpaper:init(config)
    self.config = config

    -- read theme config
    local content = io.open(config.assets_dir .. config.theme .. "/theme.json", "r")
    if content then
        self.theme = json.decode(content:read("*all"))
        content:close()

        self.base_filename = config.assets_dir .. config.theme .. "/" .. self.theme.imageFilename

        if config.mode == "auto" then
            awesome.connect_signal(sig.geoinfo.geoinfo_update, function(lat, long)
                wallpaper.latitude = lat
                wallpaper.longitude = long

                sunrise_time, sunset_time, civil_dusk, civil_dawn, after_sunrise, before_sunset =
                calculate_sunrise_and_sunset(lat, long, config.timezone,
                    os.date("%Y"), os.date("%m"), os.date("%d"), os.date("%j"), os.date("%H"))

                sunrise_time_next, sunset_time_next, civil_dusk_next, civil_dawn_next, after_sunrise_next, before_sunset_next =
                calculate_sunrise_and_sunset(lat, long, config.timezone,
                    os.date("%Y"), os.date("%m"), os.date("%d") + 1, os.date("%j"), os.date("%H"))

                wallpaper:calculate_timer()
            end)
        elseif config.mode == "manual" then
            self.latitude = config.latitude
            self.longitude = config.longitude

            sunrise_time, sunset_time, civil_dusk, civil_dawn, after_sunrise, before_sunset =
            calculate_sunrise_and_sunset(config.latitude, config.longitude, config.timezone,
                os.date("%Y"), os.date("%m"), os.date("%d"), os.date("%j"), os.date("%H"))

            sunrise_time_next, sunset_time_next, civil_dusk_next, civil_dawn_next, after_sunrise_next, before_sunset_next =
            calculate_sunrise_and_sunset(lat, long, config.timezone,
                os.date("%Y"), os.date("%m"), os.date("%d") + 1, os.date("%j"), os.date("%H"))

            wallpaper:calculate_timer()
        end
    end
end

return wallpaper