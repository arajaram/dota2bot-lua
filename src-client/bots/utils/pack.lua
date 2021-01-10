-- local json = require "game/dkjson"
local json = require(GetScriptDirectory() .. "/utils/json")
local base64 = require(GetScriptDirectory() .. "/utils/base64")
local MessagePack = require(GetScriptDirectory() .. "/utils/MessagePack")

local USE_JSON = true

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
    local messageTypeLen = tonumber(string.sub(str, 2, 4))
    -- print('messageTypeLen', messageTypeLen)
    local dataStr = string.sub(str, 5+messageTypeLen)
    -- print("type: ", type)
    -- print(string.format("datastr: '%s'", dataStr))
    local data = nil
    if type == "J" then
        data = json.decode(dataStr)
    else
        data = MessagePack.unpack(dataStr)
    end
    return data
end

return pack