local json = require "game/dkjson"
local base64 = require(GetScriptDirectory() .. "/utils/base64")
local MessagePack = require(GetScriptDirectory() .. "/utils/MessagePack")

local USE_JSON = false

local pack = {}

function pack.pack(data, messageType, formatter)
    formatter = formatter or (USE_JSON and "J" or "M")
    local str = nil
    local format = nil
    local encoded = nil
    if USE_JSON then
        format = 'J'
        encoded = json.encode(data)
    else
        format = 'M'
        encoded = base64.encode(MessagePack.pack(data))
    end
    str = string.format("%s%03d%s%s", format, string.len(messageType), messageType, encoded)
    return str
end

function pack.unpack(str)
    local type = string.sub(str, 0, 1)
    local dataStr = string.sub(str, 2)
    print("datastr: ", dataStr)
    local data = {}
    if type == "J" then
        data = json.decode(dataStr)["data"]
    else
        data = MessagePack.unpack(dataStr)["data"]
    end
    return data
end

return pack