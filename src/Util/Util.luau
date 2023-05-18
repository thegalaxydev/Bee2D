local Util = {}

Util.SafeRun = function(Function, ...)
    local Success, Error = pcall(Function, ...)
    if not Success then
        warn(Error)
    end
end

function Util.FormatTime(seconds)
    if seconds <= 0 then
        return "0 seconds"
    else
        local days = string.format("%02.f", math.floor(seconds/86400))
        local hours = string.format("%02.f", math.floor(seconds/3600 - (days*24)))
        local mins = string.format("%02.f", math.floor(seconds/60 - (days*1440) - (hours*60)))
        local secs = string.format("%02.f", math.floor(seconds - (days*86400) - (hours*3600) - (mins*60)))
        return days.." days, "..hours.." hours, "..mins.." minutes, "..secs.." seconds"
    end
end

return Util