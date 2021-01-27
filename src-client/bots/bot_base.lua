--
-- Think() is executed 30 times per seconds for each bot
-- require's are shared for each RADIANT and DIRE team
--

local HOST_TIMESCALE = 8.0

local config = require(GetScriptDirectory() .. "/config")
local version = require(GetScriptDirectory() .. "/protocol/version")
local gameinfo = require(GetScriptDirectory() .. "/protocol/gameinfo")
local observation = require(GetScriptDirectory() .. "/protocol/observation")
local action = require(GetScriptDirectory() .. "/protocol/action")
local pack = require(GetScriptDirectory() .. "/utils/pack")

-- non-shared variables (1 local var for each bot)
local observationInProgress = false
local lastWorldUpdateInProgress = false
local pendingUnitHandles = nil
local pendingDroppedItemsHandles = nil
local pendingActions = nil

local observationFrequency = 0.3 * HOST_TIMESCALE
local lastObservationTimestamp = -1000.0;

local worldUpdateFrequency = 0.3 * HOST_TIMESCALE
local lastWorldUpdateTimestamp = -1000.0;

local teamObservationFrequency = 0.3 * HOST_TIMESCALE
local lastTeamObservationTimestamp = -1000.0;

local unitHandles = nil
local droppedItemsHandles = nil

local isDesignatedToSendWorldInfo = false

local Data = {}

function Think()
  local team = GetTeam()
  local gameTime = GameTime()

  local message = nil

  if not version.sent then

    version.sent = true
    -- send VERSION message only one time per team (1 version.sent for each TEAM)
    local ver = version.get()
    message = pack.pack(message, "version")
    local httpRequest = CreateHTTPRequest(config.server[team])
    httpRequest:SetHTTPRequestRawPostBody("application/octet-stream", message)
    httpRequest:Send(function(res) end)
  end

  if not gameinfo.sent then
    gameinfo.sent = true
    -- send GAMEINFO message only one time per team (1 gameinfo.sent for each TEAM)
    local info = gameinfo.get()
    message = pack.pack(info, "gameinfo")
    local httpRequest = CreateHTTPRequest(config.server[team])
    httpRequest:SetHTTPRequestRawPostBody("application/octet-stream", message)
    httpRequest:Send(function(res) end)
  end

  if not observationInProgress and gameTime > lastObservationTimestamp then
    observationInProgress = true
    lastObservationTimestamp = gameTime + observationFrequency

    local bot = GetBot()
    -- perform pending actions
    action.perform(bot, pendingActions, pendingUnitHandles, pendingDroppedItemsHandles)
    -- send OBSERVATION message
    local obs = observation.getUnitInfo(bot, true, true, false)
    Data.unit = obs
    message = pack.pack(obs, "observation")
    local httpRequest = CreateHTTPRequest(config.server[team])
    httpRequest:SetHTTPRequestRawPostBody("application/octet-stream", message)
    httpRequest:Send(function(res)
      if string.len(res.Body) > 3 then
        -- print(res.Body)
        local actions = pack.unpack(res.Body)
        for index, action in ipairs(actions) do
          local name = action["name"]
          local args = action["args"]
          if name == "sendWorldUpdate" then
            isDesignatedToSendWorldInfo = args
          end
        end
      end
      -- pendingActions = res.Body
      -- pendingUnitHandles = unitHandles
      -- pendingDroppedItemsHandles = droppedItemsHandles
      observationInProgress = false
    end)
  end

  if gameTime > lastTeamObservationTimestamp then
    lastTeamObservationTimestamp = gameTime + teamObservationFrequency
    local obs = observation.teamInfo()
    Data.teamInfo = obs
    message = pack.pack(obs, "team")
    local httpRequest = CreateHTTPRequest(config.server[team])
    httpRequest:SetHTTPRequestRawPostBody("application/octet-stream", message)
    httpRequest:Send(function(res) end)
  end

  if isDesignatedToSendWorldInfo and not lastWorldUpdateInProgress and gameTime > lastWorldUpdateTimestamp then
    lastWorldUpdateInProgress = true
    lastWorldUpdateTimestamp = gameTime + worldUpdateFrequency
    local worldInfo = nil
    worldInfo, unitHandles, droppedItemsHandles = observation.getWorldInfo()
    Data.worldInfo = worldInfo
    Data.unitHandles = unitHandles
    Data.droppedItemsHandles = droppedItemsHandles
    message = pack.pack(worldInfo, "world")
    print(string.format("%s sending world update", GetBot():GetUnitName()))
    local httpRequest = CreateHTTPRequest(config.server[team])
    httpRequest:SetHTTPRequestRawPostBody("application/octet-stream", message)
    httpRequest:Send(function(res)
      lastWorldUpdateInProgress = false
    end)
  end
end

local MyModule = {}
MyModule.Think = Think
MyModule.getData = function()
  return Data
end
return MyModule