local MessagePack = require(GetScriptDirectory() .. "/utils/MessagePack")

function Pack(data, messageType)
    local result = {}
    result["messageType"] = messageType
    result["data"] = data
    return MessagePack.pack(result)
end

return Pack