--
-- Think() is executed 30 times per seconds for each bot
-- require's are shared for each RADIANT and DIRE team
--

local action = require(GetScriptDirectory() .. "/protocol/action")
local pack = require(GetScriptDirectory() .. "/utils/pack")

local botGeneric = require(GetScriptDirectory() .. "/bot_base")

function Think()
    botGeneric.Think()
end

function OnStart()
end

function OnEnd()
end

function GetDesire()
    return BOT_MODE_DESIRE_LOW
end

BotsInit = require("game/botsinit")
local MyModule = BotsInit.CreateGeneric();
MyModule.OnStart = OnStart
MyModule.OnEnd = OnEnd
MyModule.Think = Think
MyModule.GetDesire = GetDesire
MyModule.getData = botGeneric.getData
return MyModule