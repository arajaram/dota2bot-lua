--
-- game info message
--
local pack = require(GetScriptDirectory() .. "/utils/pack")
local ParseLocation = require(GetScriptDirectory() .. "/utils/location")
local items = require(GetScriptDirectory() .. "/protocol/items")

-- returned module
local gameinfo = {}

-- public
gameinfo.sent = false

-- public
function gameinfo.get()
  local info = {}
  -- [1] GAME TIME
  info["gameTime"] = GameTime()
  -- [2] DOTA TIME
  info["dotaTime"] = DotaTime()
  -- [3] DAMAGE TYPE ENUM
  local damageTypes = {}
  damageTypes["DAMAGE_TYPE_PHYSICAL"] = DAMAGE_TYPE_PHYSICAL
  damageTypes["DAMAGE_TYPE_MAGICAL"] = DAMAGE_TYPE_MAGICAL
  damageTypes["DAMAGE_TYPE_PURE"] = DAMAGE_TYPE_PURE
  damageTypes["DAMAGE_TYPE_ALL"] = DAMAGE_TYPE_ALL
  info["damageTypes"] = damageTypes
  -- [4] TEAM ENUM
  local teamTypes = {}
  teamTypes["TEAM_RADIANT"] = TEAM_RADIANT
  teamTypes["TEAM_DIRE"] = TEAM_DIRE
  teamTypes["TEAM_NEUTRAL"] = TEAM_NEUTRAL
  teamTypes["TEAM_NONE"] = TEAM_NONE
  info["teamTypes"] = teamTypes
  -- [5] RUNE TYPE ENUM
  local runeTypes = {}
  runeTypes["RUNE_INVALID"] = RUNE_INVALID
  runeTypes["RUNE_DOUBLEDAMAGE"] = RUNE_DOUBLEDAMAGE
  runeTypes["RUNE_HASTE"] = RUNE_HASTE
  runeTypes["RUNE_ILLUSION"] = RUNE_ILLUSION
  runeTypes["RUNE_INVISIBILITY"] = RUNE_INVISIBILITY
  runeTypes["RUNE_REGENERATION"] = RUNE_REGENERATION
  runeTypes["RUNE_BOUNTY"] = RUNE_BOUNTY
  runeTypes["RUNE_ARCANE"] = RUNE_ARCANE
  info["runeTypes"] = runeTypes
  -- [6] RUNE STATUS ENUM
  local runeStatusTypes = {}
  runeStatusTypes["RUNE_STATUS_UNKNOWN"] = RUNE_STATUS_UNKNOWN
  runeStatusTypes["RUNE_STATUS_AVAILABLE"] = RUNE_STATUS_AVAILABLE
  runeStatusTypes["RUNE_STATUS_MISSING"] = RUNE_STATUS_MISSING
  info["runeStatusTypes"] = runeStatusTypes
  -- [7] RUNE SPAWN ENUM
  local runeSpawnTypes = {}
  runeSpawnTypes["RUNE_POWERUP_1"] = RUNE_POWERUP_1
  runeSpawnTypes["RUNE_POWERUP_2"] = RUNE_POWERUP_2
  runeSpawnTypes["RUNE_BOUNTY_1"] = RUNE_BOUNTY_1
  runeSpawnTypes["RUNE_BOUNTY_2"] = RUNE_BOUNTY_2
  runeSpawnTypes["RUNE_BOUNTY_3"] = RUNE_BOUNTY_3
  runeSpawnTypes["RUNE_BOUNTY_4"] = RUNE_BOUNTY_4
  info["runeSpawn"] = runeSpawnTypes
  -- [8] ITEM SLOT ENUM
  local itemSlotTypes = {}
  itemSlotTypes["ITEM_SLOT_TYPE_INVALID"] = ITEM_SLOT_TYPE_INVALID
  itemSlotTypes["ITEM_SLOT_TYPE_MAIN"] = ITEM_SLOT_TYPE_MAIN
  itemSlotTypes["ITEM_SLOT_TYPE_BACKPACK"] = ITEM_SLOT_TYPE_BACKPACK
  itemSlotTypes["ITEM_SLOT_TYPE_STASH"] = ITEM_SLOT_TYPE_STASH
  info["itemSlotTypes"] = itemSlotTypes
  -- [9] BOT ACTION TYPE ENUM
  local botActionTypes = {}
  botActionTypes["BOT_ACTION_TYPE_NONE"] = BOT_ACTION_TYPE_NONE
  botActionTypes["BOT_ACTION_TYPE_IDLE"] = BOT_ACTION_TYPE_IDLE
  botActionTypes["BOT_ACTION_TYPE_MOVE_TO"] = BOT_ACTION_TYPE_MOVE_TO
  botActionTypes["BOT_ACTION_TYPE_MOVE_TO_DIRECTLY"] = BOT_ACTION_TYPE_MOVE_TO_DIRECTLY
  botActionTypes["BOT_ACTION_TYPE_ATTACK"] = BOT_ACTION_TYPE_ATTACK
  botActionTypes["BOT_ACTION_TYPE_ATTACKMOVE"] = BOT_ACTION_TYPE_ATTACKMOVE
  botActionTypes["BOT_ACTION_TYPE_USE_ABILITY"] = BOT_ACTION_TYPE_USE_ABILITY
  botActionTypes["BOT_ACTION_TYPE_PICK_UP_RUNE"] = BOT_ACTION_TYPE_PICK_UP_RUNE
  botActionTypes["BOT_ACTION_TYPE_PICK_UP_ITEM"] = BOT_ACTION_TYPE_PICK_UP_ITEM
  botActionTypes["BOT_ACTION_TYPE_DROP_ITEM"] = BOT_ACTION_TYPE_DROP_ITEM
  botActionTypes["BOT_ACTION_TYPE_SHRINE"] = BOT_ACTION_TYPE_SHRINE
  botActionTypes["BOT_ACTION_TYPE_DELAY"] = BOT_ACTION_TYPE_DELAY
  info["botActionTypes"] = botActionTypes
  -- [10] COURIER ACTION ENUM
  local courierActionTypes = {}
  courierActionTypes["COURIER_ACTION_BURST"] = COURIER_ACTION_BURST
  courierActionTypes["COURIER_ACTION_ENEMY_SECRET_SHOP"] = COURIER_ACTION_ENEMY_SECRET_SHOP
  courierActionTypes["COURIER_ACTION_RETURN"] = COURIER_ACTION_RETURN
  courierActionTypes["COURIER_ACTION_SECRET_SHOP"] = COURIER_ACTION_SECRET_SHOP
  courierActionTypes["COURIER_ACTION_SIDE_SHOP"] = COURIER_ACTION_SIDE_SHOP
  courierActionTypes["COURIER_ACTION_SIDE_SHOP2"] = COURIER_ACTION_SIDE_SHOP2
  courierActionTypes["COURIER_ACTION_TAKE_STASH_ITEMS"] = COURIER_ACTION_TAKE_STASH_ITEMS
  courierActionTypes["COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS"] = COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS
  courierActionTypes["COURIER_ACTION_TRANSFER_ITEMS"] = COURIER_ACTION_TRANSFER_ITEMS
  info["courierActionTypes"] = courierActionTypes
  -- [11] COURIER STATE ENUM
  local courierStateTypes = {}
  courierStateTypes["COURIER_STATE_IDLE"] = COURIER_STATE_IDLE
  courierStateTypes["COURIER_STATE_AT_BASE"] = COURIER_STATE_AT_BASE
  courierStateTypes["COURIER_STATE_MOVING"] = COURIER_STATE_MOVING
  courierStateTypes["COURIER_STATE_DELIVERING_ITEMS"] = COURIER_STATE_DELIVERING_ITEMS
  courierStateTypes["COURIER_STATE_RETURNING_TO_BASE"] = COURIER_STATE_RETURNING_TO_BASE
  courierStateTypes["COURIER_STATE_DEAD"] = COURIER_STATE_DEAD
  info["courierStateTypes"] = courierStateTypes

  -- [12] SHOP ENUM
  local shopTypes = {}
  shopTypes["SHOP_HOME"] = SHOP_HOME
  shopTypes["SHOP_SIDE"] = SHOP_SIDE
  shopTypes["SHOP_SECRET"] = SHOP_SECRET
  shopTypes["SHOP_SIDE2"] = SHOP_SIDE2
  shopTypes["SHOP_SECRET2"] = SHOP_SECRET2
  info["shopTypes"] = shopTypes
  -- [13] ABILITY TARGET TEAM ENUM
  local abilityTargetTeamTypes = {}
  abilityTargetTeamTypes["ABILITY_TARGET_TEAM_NONE"] = ABILITY_TARGET_TEAM_NONE
  abilityTargetTeamTypes["ABILITY_TARGET_TEAM_FRIENDLY"] = ABILITY_TARGET_TEAM_FRIENDLY
  abilityTargetTeamTypes["ABILITY_TARGET_TEAM_ENEMY"] = ABILITY_TARGET_TEAM_ENEMY
  info["abilityTargetTeamTypes"] = abilityTargetTeamTypes
  -- [14] ABILITY TARGET TYPE ENUM
  local abilityTargetTypes = {}
  abilityTargetTypes["ABILITY_TARGET_TYPE_NONE"] = ABILITY_TARGET_TYPE_NONE
  abilityTargetTypes["ABILITY_TARGET_TYPE_HERO"] = ABILITY_TARGET_TYPE_HERO
  abilityTargetTypes["ABILITY_TARGET_TYPE_CREEP"] = ABILITY_TARGET_TYPE_CREEP
  abilityTargetTypes["ABILITY_TARGET_TYPE_BUILDING"] = ABILITY_TARGET_TYPE_BUILDING
  abilityTargetTypes["ABILITY_TARGET_TYPE_COURIER"] = ABILITY_TARGET_TYPE_COURIER
  abilityTargetTypes["ABILITY_TARGET_TYPE_OTHER"] = ABILITY_TARGET_TYPE_OTHER
  abilityTargetTypes["ABILITY_TARGET_TYPE_TREE"] = ABILITY_TARGET_TYPE_TREE
  abilityTargetTypes["ABILITY_TARGET_TYPE_BASIC"] = ABILITY_TARGET_TYPE_BASIC
  abilityTargetTypes["ABILITY_TARGET_TYPE_ALL"] = ABILITY_TARGET_TYPE_ALL
  info["abilityTargetTypes"] = abilityTargetTypes
  -- [15] LANE ENUM
  local laneTypes = {}
  laneTypes["LANE_NONE"] = LANE_NONE
  laneTypes["LANE_TOP"] = LANE_TOP
  laneTypes["LANE_MID"] = LANE_MID
  laneTypes["LANE_BOT"] = LANE_BOT
  info["laneTypes"] = laneTypes
  -- -- [16] Allied Team ID
  -- info["teamID"] = GetTeam()
  -- -- [17] Enemy Team ID
  -- info["opposingTeamID"] = GetOpposingTeam()

  local teamIds = {TEAM_RADIANT, TEAM_DIRE}
  -- [18] Players
  local teams = {}
  for k,tid in pairs(teamIds) do
    local team = {}
    local playerIds = GetTeamPlayers(tid)
    for k,pid in pairs(playerIds) do
      local player = {}
      player["teamID"] = tid
      player["playerID"] = pid
      player["selectedHeroName"] = GetSelectedHeroName(pid)
      player["isPlayerBot"] = IsPlayerBot(pid)
      table.insert(team, player)
    end
    table.insert(teams, team)
  end
  info["teams"] = teams
  -- [19] World Bounds min X
  -- [20] World Bounds min Y
  -- [21] World Bounds max X
  -- [22] World Bounds max Y
  info["worldBounds"] = GetWorldBounds()
  -- [23] Shop Locations
  local shopLocations = {}
  local shops = {SHOP_HOME, SHOP_SIDE, SHOP_SECRET, SHOP_SIDE2, SHOP_SECRET2}
  for k,tid in pairs(teamIds) do
    local teamShopLocations = {}
    for k,sid in pairs(shops) do
      teamShopLocations[sid] = ParseLocation(GetShopLocation(tid, sid))
    end
    shopLocations[tid] = teamShopLocations
  end
  info["shopLocations"] = shopLocations
  -- [24] Rune Spawn Locations
  local runeSpawnLocations = {}
  local spawns = {RUNE_POWERUP_1, RUNE_POWERUP_2,
    RUNE_BOUNTY_1, RUNE_BOUNTY_2, RUNE_BOUNTY_3, RUNE_BOUNTY_4}
  for k,sid in pairs(spawns) do
    runeSpawnLocations[sid] = ParseLocation(GetRuneSpawnLocation(sid))
  end
  info["runeSpawnLocations"] = runeSpawnLocations
  -- [25] Ancient Locations
  local ancientLocations = {}
  for k,tid in pairs(teamIds) do
    local a = GetAncient(tid)
    local aloc = a:GetLocation()
    ancientLocations[tid] = ParseLocation(aloc)
  end
  info["ancientLocations"] = ancientLocations
  -- [26] Items
  local itemTypes = {}
  for k,i in pairs(items.ALL_ITEMS) do
    local itemInfo = {}
    itemInfo["name"] = i
    itemInfo["cost"] = GetItemCost(i)
    itemInfo["isItemPurchasedFromSecretShop"] = IsItemPurchasedFromSecretShop(i)
    itemInfo["isItemPurchasedFromSideShop"] = IsItemPurchasedFromSideShop(i)
    itemTypes["name"] = itemInfo
  end
  info["itemTypes"] = itemTypes
  -- [27] Bot Modes
  local botModes = {}
  botModes["BOT_MODE_NONE"] = BOT_MODE_NONE
  botModes["BOT_MODE_LANING"] = BOT_MODE_LANING
  botModes["BOT_MODE_ATTACK"] = BOT_MODE_ATTACK
  botModes["BOT_MODE_ROAM"] = BOT_MODE_ROAM
  botModes["BOT_MODE_RETREAT"] = BOT_MODE_RETREAT
  botModes["BOT_MODE_SECRET_SHOP"] = BOT_MODE_SECRET_SHOP
  botModes["BOT_MODE_SIDE_SHOP"] = BOT_MODE_SIDE_SHOP
  botModes["BOT_MODE_PUSH_TOWER_TOP"] = BOT_MODE_PUSH_TOWER_TOP
  botModes["BOT_MODE_PUSH_TOWER_MID"] = BOT_MODE_PUSH_TOWER_MID
  botModes["BOT_MODE_PUSH_TOWER_BOT"] = BOT_MODE_PUSH_TOWER_BOT
  botModes["BOT_MODE_DEFEND_TOWER_TOP"] = BOT_MODE_DEFEND_TOWER_TOP
  botModes["BOT_MODE_DEFEND_TOWER_MID"] = BOT_MODE_DEFEND_TOWER_MID
  botModes["BOT_MODE_DEFEND_TOWER_BOT"] = BOT_MODE_DEFEND_TOWER_BOT
  botModes["BOT_MODE_ASSEMBLE"] = BOT_MODE_ASSEMBLE
  botModes["BOT_MODE_TEAM_ROAM"] = BOT_MODE_TEAM_ROAM
  botModes["BOT_MODE_FARM"] = BOT_MODE_FARM
  botModes["BOT_MODE_DEFEND_ALLY"] = BOT_MODE_DEFEND_ALLY
  botModes["BOT_MODE_EVASIVE_MANEUVERS"] = BOT_MODE_EVASIVE_MANEUVERS
  botModes["BOT_MODE_ROSHAN"] = BOT_MODE_ROSHAN
  botModes["BOT_MODE_ITEM"] = BOT_MODE_ITEM
  botModes["BOT_MODE_WARD"] = BOT_MODE_WARD
  info["botModeTypes"] = botModes
  -- [28] Action Desires
  local botActionDesireTypes = {}
  botActionDesireTypes["BOT_ACTION_DESIRE_NONE"] = BOT_ACTION_DESIRE_NONE
  botActionDesireTypes["BOT_ACTION_DESIRE_VERYLOW"] = BOT_ACTION_DESIRE_VERYLOW
  botActionDesireTypes["BOT_ACTION_DESIRE_LOW"] = BOT_ACTION_DESIRE_LOW
  botActionDesireTypes["BOT_ACTION_DESIRE_MODERATE"] = BOT_ACTION_DESIRE_MODERATE
  botActionDesireTypes["BOT_ACTION_DESIRE_HIGH"] = BOT_ACTION_DESIRE_HIGH
  botActionDesireTypes["BOT_ACTION_DESIRE_VERYHIGH"] = BOT_ACTION_DESIRE_VERYHIGH
  botActionDesireTypes["BOT_ACTION_DESIRE_ABSOLUTE"] = BOT_ACTION_DESIRE_ABSOLUTE
  info["botActionDesireTypes"] = botActionDesireTypes
  -- [29] Bot Mode Desires
  local botModeDesireTypes = {}
  botModeDesireTypes["BOT_MODE_DESIRE_NONE"] = BOT_MODE_DESIRE_NONE
  botModeDesireTypes["BOT_MODE_DESIRE_VERYLOW"] = BOT_MODE_DESIRE_VERYLOW
  botModeDesireTypes["BOT_MODE_DESIRE_LOW"] = BOT_MODE_DESIRE_LOW
  botModeDesireTypes["BOT_MODE_DESIRE_MODERATE"] = BOT_MODE_DESIRE_MODERATE
  botModeDesireTypes["BOT_MODE_DESIRE_HIGH"] = BOT_MODE_DESIRE_HIGH
  botModeDesireTypes["BOT_MODE_DESIRE_VERYHIGH"] = BOT_MODE_DESIRE_VERYHIGH
  botModeDesireTypes["BOT_MODE_DESIRE_ABSOLUTE"] = BOT_MODE_DESIRE_ABSOLUTE
  info["botModeDesireTypes"] = botModeDesireTypes
  -- [30] Towers
  local towerTypes = {}
  towerTypes["TOWER_TOP_1"] = TOWER_TOP_1
  towerTypes["TOWER_TOP_2"] = TOWER_TOP_2
  towerTypes["TOWER_TOP_3"] = TOWER_TOP_3
  towerTypes["TOWER_MID_1"] = TOWER_MID_1
  towerTypes["TOWER_MID_2"] = TOWER_MID_2
  towerTypes["TOWER_MID_3"] = TOWER_MID_3
  towerTypes["TOWER_BOT_1"] = TOWER_BOT_1
  towerTypes["TOWER_BOT_2"] = TOWER_BOT_2
  towerTypes["TOWER_BOT_3"] = TOWER_BOT_3
  towerTypes["TOWER_BASE_1"] = TOWER_BASE_1
  towerTypes["TOWER_BASE_2"] = TOWER_BASE_2
  info["towerTypes"] = towerTypes
  -- [31] Barracks
  local barrackTypes = {}
  barrackTypes["BARRACKS_TOP_MELEE"] = BARRACKS_TOP_MELEE
  barrackTypes["BARRACKS_TOP_RANGED"] = BARRACKS_TOP_RANGED
  barrackTypes["BARRACKS_MID_MELEE"] = BARRACKS_MID_MELEE
  barrackTypes["BARRACKS_MID_RANGED"] = BARRACKS_MID_RANGED
  barrackTypes["BARRACKS_BOT_MELEE"] = BARRACKS_BOT_MELEE
  barrackTypes["BARRACKS_BOT_RANGED"] = BARRACKS_BOT_RANGED
  info["barrackTypes"] = barrackTypes
  -- [32] Shrines
  local shrineTypes = {}
  shrineTypes["SHRINE_BASE_1"] = SHRINE_BASE_1
  shrineTypes["SHRINE_BASE_2"] = SHRINE_BASE_2
  shrineTypes["SHRINE_BASE_3"] = SHRINE_BASE_3
  shrineTypes["SHRINE_BASE_4"] = SHRINE_BASE_4
  shrineTypes["SHRINE_BASE_5"] = SHRINE_BASE_5
  shrineTypes["SHRINE_JUNGLE_1"] = SHRINE_JUNGLE_1
  shrineTypes["SHRINE_JUNGLE_2"] = SHRINE_JUNGLE_2
  info["shrineTypes"] = shrineTypes
  -- [33] Ability Target Flags
  local abilityTargetFlagTypes = {}
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_NONE"] = ABILITY_TARGET_FLAG_NONE
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_RANGED_ONLY"] = ABILITY_TARGET_FLAG_RANGED_ONLY
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_MELEE_ONLY"] = ABILITY_TARGET_FLAG_MELEE_ONLY
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_DEAD"] = ABILITY_TARGET_FLAG_DEAD
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES"] = ABILITY_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES"] = ABILITY_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_INVULNERABLE"] = ABILITY_TARGET_FLAG_INVULNERABLE
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_FOW_VISIBLE"] = ABILITY_TARGET_FLAG_FOW_VISIBLE
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_NO_INVIS"] = ABILITY_TARGET_FLAG_NO_INVIS
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_NOT_ANCIENTS"] = ABILITY_TARGET_FLAG_NOT_ANCIENTS
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_PLAYER_CONTROLLED"] = ABILITY_TARGET_FLAG_PLAYER_CONTROLLED
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_NOT_DOMINATED"] = ABILITY_TARGET_FLAG_NOT_DOMINATED
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_NOT_SUMMONED"] = ABILITY_TARGET_FLAG_NOT_SUMMONED
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_NOT_ILLUSIONS"] = ABILITY_TARGET_FLAG_NOT_ILLUSIONS
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_NOT_ATTACK_IMMUNE"] = ABILITY_TARGET_FLAG_NOT_ATTACK_IMMUNE
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_MANA_ONLY"] = ABILITY_TARGET_FLAG_MANA_ONLY
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_CHECK_DISABLE_HELP"] = ABILITY_TARGET_FLAG_CHECK_DISABLE_HELP
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_NOT_CREEP_HERO"] = ABILITY_TARGET_FLAG_NOT_CREEP_HERO
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_OUT_OF_WORLD"] = ABILITY_TARGET_FLAG_OUT_OF_WORLD
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_NOT_NIGHTMARED"] = ABILITY_TARGET_FLAG_NOT_NIGHTMARED
  abilityTargetFlagTypes["ABILITY_TARGET_FLAG_PREFER_ENEMIES"] = ABILITY_TARGET_FLAG_PREFER_ENEMIES
  info["abilityTargetFlagTypes"] = abilityTargetFlagTypes
  -- [34] Animation Activities
  local animationActivityTypes = {}
  animationActivityTypes["ACTIVITY_IDLE"] = ACTIVITY_IDLE
  animationActivityTypes["ACTIVITY_IDLE_RARE"] = ACTIVITY_IDLE_RARE
  animationActivityTypes["ACTIVITY_RUN"] = ACTIVITY_RUN
  animationActivityTypes["ACTIVITY_ATTACK"] = ACTIVITY_ATTACK
  animationActivityTypes["ACTIVITY_ATTACK2"] = ACTIVITY_ATTACK2
  animationActivityTypes["ACTIVITY_ATTACK_EVENT"] = ACTIVITY_ATTACK_EVENT
  animationActivityTypes["ACTIVITY_DIE"] = ACTIVITY_DIE
  animationActivityTypes["ACTIVITY_FLINCH"] = ACTIVITY_FLINCH
  animationActivityTypes["ACTIVITY_FLAIL"] = ACTIVITY_FLAIL
  animationActivityTypes["ACTIVITY_DISABLED"] = ACTIVITY_DISABLED
  animationActivityTypes["ACTIVITY_CAST_ABILITY_1"] = ACTIVITY_CAST_ABILITY_1
  animationActivityTypes["ACTIVITY_CAST_ABILITY_2"] = ACTIVITY_CAST_ABILITY_2
  animationActivityTypes["ACTIVITY_CAST_ABILITY_3"] = ACTIVITY_CAST_ABILITY_3
  animationActivityTypes["ACTIVITY_CAST_ABILITY_4"] = ACTIVITY_CAST_ABILITY_4
  animationActivityTypes["ACTIVITY_CAST_ABILITY_5"] = ACTIVITY_CAST_ABILITY_5
  animationActivityTypes["ACTIVITY_CAST_ABILITY_6"] = ACTIVITY_CAST_ABILITY_6
  animationActivityTypes["ACTIVITY_OVERRIDE_ABILITY_1"] = ACTIVITY_OVERRIDE_ABILITY_1
  animationActivityTypes["ACTIVITY_OVERRIDE_ABILITY_2"] = ACTIVITY_OVERRIDE_ABILITY_2
  animationActivityTypes["ACTIVITY_OVERRIDE_ABILITY_3"] = ACTIVITY_OVERRIDE_ABILITY_3
  animationActivityTypes["ACTIVITY_OVERRIDE_ABILITY_4"] = ACTIVITY_OVERRIDE_ABILITY_4
  animationActivityTypes["ACTIVITY_CHANNEL_ABILITY_1"] = ACTIVITY_CHANNEL_ABILITY_1
  animationActivityTypes["ACTIVITY_CHANNEL_ABILITY_2"] = ACTIVITY_CHANNEL_ABILITY_2
  animationActivityTypes["ACTIVITY_CHANNEL_ABILITY_3"] = ACTIVITY_CHANNEL_ABILITY_3
  animationActivityTypes["ACTIVITY_CHANNEL_ABILITY_4"] = ACTIVITY_CHANNEL_ABILITY_4
  animationActivityTypes["ACTIVITY_CHANNEL_ABILITY_5"] = ACTIVITY_CHANNEL_ABILITY_5
  animationActivityTypes["ACTIVITY_CHANNEL_ABILITY_6"] = ACTIVITY_CHANNEL_ABILITY_6
  animationActivityTypes["ACTIVITY_CHANNEL_END_ABILITY_1"] = ACTIVITY_CHANNEL_END_ABILITY_1
  animationActivityTypes["ACTIVITY_CHANNEL_END_ABILITY_2"] = ACTIVITY_CHANNEL_END_ABILITY_2
  animationActivityTypes["ACTIVITY_CHANNEL_END_ABILITY_3"] = ACTIVITY_CHANNEL_END_ABILITY_3
  animationActivityTypes["ACTIVITY_CHANNEL_END_ABILITY_4"] = ACTIVITY_CHANNEL_END_ABILITY_4
  animationActivityTypes["ACTIVITY_CHANNEL_END_ABILITY_5"] = ACTIVITY_CHANNEL_END_ABILITY_5
  animationActivityTypes["ACTIVITY_CHANNEL_END_ABILITY_6"] = ACTIVITY_CHANNEL_END_ABILITY_6
  animationActivityTypes["ACTIVITY_CONSTANT_LAYER"] = ACTIVITY_CONSTANT_LAYER
  animationActivityTypes["ACTIVITY_CAPTURE"] = ACTIVITY_CAPTURE
  animationActivityTypes["ACTIVITY_SPAWN"] = ACTIVITY_SPAWN
  animationActivityTypes["ACTIVITY_KILLTAUNT"] = ACTIVITY_KILLTAUNT
  animationActivityTypes["ACTIVITY_TAUNT"] = ACTIVITY_TAUNT
  info["activityTypes"] = animationActivityTypes
  -- return gameinfo
  return pack.pack(info, "gameinfo")
end

return gameinfo
