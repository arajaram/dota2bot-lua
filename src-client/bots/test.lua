function GetScriptDirectory()
    return "."
end

local pack = require("./utils/pack")
local dbg = require("./utils/debugger")
dbg.auto_where = 2

-- local data = {}
-- data["x"] = {}
-- data["x"]["y"] = 4.0

-- local str = pack.pack(data, "test", "J")
-- print("str:", str)
-- local obj = pack.unpack(str)

-- if obj["x"]["y"] == data["x"]["y"] then
--     print("Matched")
-- else
--     print("Failed")
-- end

local data = {}
local idx1 = {}
idx1["name"] = "sendWorldUpdate"
idx1["args"] = true
table.insert(data, idx1)
local str = pack.pack(data, "test", "J")

local encoded = "J004test[{\"name\":\"sendWorldUpdate\",\"args\":true}]"
assert(str == encoded)

-- Test MessagePack
local msgpackStr = pack.pack(data, "test", "M")
local msgpackData = pack.unpack(msgpackStr)
assert(msgpackData[1]["name"] == "sendWorldUpdate")