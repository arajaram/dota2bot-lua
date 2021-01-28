--
-- Think() is executed 30 times per seconds for each bot
-- require's are shared for each RADIANT and DIRE team
--

local action = require(GetScriptDirectory() .. "/protocol/action")
local pack = require(GetScriptDirectory() .. "/utils/pack")
local webserver = require(GetScriptDirectory() .. "/utils/webserver")
local modeGeneric = require(GetScriptDirectory() .. "/mode_generic_base")

function Think()
    local data = modeGeneric.getData()

    if data.unit ~= nil and data.unit.lastHits < 300 then
        -- Farm bot lane
        local lf = GetLaneFrontLocation(GetBot():GetTeam(), LANE_BOT, -300)
        GetBot():Action_MoveDirectly(lf)
    end
    modeGeneric.Think()
end

function GetDesire()
    return BOT_MODE_DESIRE_MODERATE
end

function onEnd()
    webserver.log(string.format("%v Exiting mode:  farm", GetBot():GetUnitName()))
end
function onStart()
    webserver.log(string.format("%v Entering mode: farm", GetBot():GetUnitName()))
end