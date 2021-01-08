--
-- Think() is executed 30 times per seconds for each bot
-- require's are shared for each RADIANT and DIRE team
--

local HOST_TIMESCALE = 10.0

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

local observationFrequency = 0.1 * HOST_TIMESCALE
local lastObservationTimestamp = -1000.0;

local worldUpdateFrequency = 0.5 * HOST_TIMESCALE
local lastWorldUpdateTimestamp = -1000.0;

local unitHandles = nil
local droppedItemsHandles = nil

function Think()
  local team = GetTeam()
  local gameTime = GameTime()

  local message = nil

  if not version.sent then

    version.sent = true
    -- send VERSION message only one time per team (1 version.sent for each TEAM)
    message = version.get()
    local httpRequest = CreateHTTPRequest(config.server[team])
    httpRequest:SetHTTPRequestRawPostBody("application/octet-stream", message)
    httpRequest:Send(function(res) end)
  end

  if not gameinfo.sent then
    gameinfo.sent = true
    -- send GAMEINFO message only one time per team (1 gameinfo.sent for each TEAM)
    message = gameinfo.get()
    local httpRequest = CreateHTTPRequest(config.server[team])
    httpRequest:SetHTTPRequestRawPostBody("application/octet-stream", message)
    httpRequest:Send(function(res) end)
  end

  if not observationInProgress and gameTime > lastObservationTimestamp then
    observationInProgress = true
    lastObservationTimestamp = gameTime + observationFrequency

    -- perform pending actions
    action.perform(GetBot(), pendingActions, pendingUnitHandles, pendingDroppedItemsHandles)
    -- send OBSERVATION message
    message = observation.get()
    local httpRequest = CreateHTTPRequest(config.server[team])
    httpRequest:SetHTTPRequestRawPostBody("application/octet-stream", message)
    httpRequest:Send(function(res)
      pendingActions = res.Body
      pendingUnitHandles = unitHandles
      pendingDroppedItemsHandles = droppedItemsHandles
      observationInProgress = false
    end)
  end

  if not lastWorldUpdateInProgress and gameTime > lastWorldUpdateTimestamp then
    lastWorldUpdateInProgress = true
    lastWorldUpdateTimestamp = gameTime + worldUpdateFrequency
    local worldInfo = nil
    worldInfo, unitHandles, droppedItemsHandles = observation.getWorldInfo()
    message = pack.pack(worldInfo, "world")
    local httpRequest = CreateHTTPRequest(config.server[team])
    httpRequest:SetHTTPRequestRawPostBody("application/octet-stream", message)
    httpRequest:Send(function(res)
      lastWorldUpdateInProgress = false
    end)
  end
end
