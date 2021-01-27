local config = require(GetScriptDirectory() .. "/config")
local pack = require(GetScriptDirectory() .. "/utils/pack")

local webserver = {}

function webserver.log(msg, level)
    level = level == nil and 'debug' or level
    local team = GetTeam()
    local httpRequest = CreateHTTPRequest(config.server[team])
    local data = {}
    data["message"] = msg
    data["level"] = level
    local message = pack.pack(data, "log")
    httpRequest:SetHTTPRequestRawPostBody("application/octet-stream", message)
    httpRequest:Send(function(res) end)
end
