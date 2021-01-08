
function ParseLocation(data)
    local loc = {}
    loc["x"] = data.x
    loc["y"] = data.y
    loc["z"] = data.z
    return loc
end

return ParseLocation