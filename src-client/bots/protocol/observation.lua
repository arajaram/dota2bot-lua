--
-- observation message
--
local pack = require(GetScriptDirectory() .. "/utils/pack")
local ParseLocation = require(GetScriptDirectory() .. "/utils/location")
local uuidv4 = require(GetScriptDirectory() .. "/utils/uuidv4")

-- returned module
local observation = {}

-- private
local function flagIsSet(bitfield, flag)
  return (bitfield % (2 * flag) >= flag)
end

-- private
local function getAbility(a, slot)
  local ability = {}
  ability["name"] = a:GetName()
  ability["slot"] = slot
  ability["canAbilityBeUpgraded"] = a:CanAbilityBeUpgraded()
  ability["getAutoCastState"] = a:GetAutoCastState() -- isAutoCast()
  ability["getToggleState"] = a:GetToggleState() -- isToggled()
  ability["isToggle"] = a:IsToggle() -- isToggle()
  ability["isActivated"] = a:IsActivated()
  ability["isChanneling"] = a:IsChanneling()
  ability["isCooldownReady"] = a:IsCooldownReady()
  ability["isFullyCastable"] = a:IsFullyCastable()
  ability["isHidden"] = a:IsHidden()
  ability["isInAbilityPhase"] = a:IsInAbilityPhase()
  ability["isOwnersManaEnough"] = a:IsOwnersManaEnough()
  ability["isPassive"] = a:IsPassive()
  ability["isStealable"] = a:IsStealable()
  ability["isStolen"] = a:IsStolen()
  ability["isTrained"] = a:IsTrained()
  ability["procsMagicStick"] = a:ProcsMagicStick()
  -- Behavior
  ability["behavior"] = a:GetBehavior()

  ability["getCastPoint"] = a:GetCastPoint()
  ability["getCastRange"] = a:GetCastRange()
  ability["getChanneledManaCostPerSecond"] = a:GetChannelledManaCostPerSecond()
  ability["getChannelTime"] = a:GetChannelTime()
  ability["getDuration"] = a:GetDuration()
  ability["getCooldownTimeRemaining"] = a:GetCooldownTimeRemaining()
  ability["getCurrentCharges"] = a:GetCurrentCharges()
  ability["getAbilityDamage"] = a:GetAbilityDamage()
  ability["getDamageType"] = a:GetDamageType()
  ability["getHeroLevelRequiredToUpgrade"] = a:GetHeroLevelRequiredToUpgrade()
  ability["getInitialCharges"] = a:GetInitialCharges()
  ability["getLevel"] = a:GetLevel()
  ability["getManaCost"] = a:GetManaCost()
  ability["getMaxLevel"] = a:GetMaxLevel()
  ability["getSecondaryCharges"] = a:GetSecondaryCharges()
  ability["getTargetTeam"] = a:GetTargetTeam()
  ability["getTargetType"] = a:GetTargetType()
  ability["isItem"] = a:IsItem()
  ability["canBeDisassembled"] = a:CanBeDisassembled()
  ability["isCombineLocked"] = a:IsCombineLocked()
  return ability
end


function observation.getUnitInfo(u, abilities, items, trees)
  local unit = {}
  abilities = abilities == nil and true or abilities  -- defaults to true
  trees = trees == nil and false or trees          -- defaults to true
  unit["isBot"] = u:IsBot()
  unit["difficulty"] = u:GetDifficulty()
  unit["name"] = u:GetUnitName()
  unit["playerID"] = u:GetPlayerID()
  unit["team"] = u:GetTeam()
  unit["isHero"] = u:IsHero()
  unit["isIllusion"] = u:IsIllusion()
  unit["isCreep"] = u:IsCreep()
  unit["isAncientCreep"] = u:IsAncientCreep()
  unit["isBuilding"] = u:IsBuilding()
  unit["isTower"] = u:IsTower()
  unit["isFort"] = u:IsFort()

  unit["canBeSeen"] = u:CanBeSeen()

  unit["health"] = u:GetHealth()
  unit["maxHealth"] = u:GetMaxHealth()
  unit["healthRegen"] = u:GetHealthRegen()
  unit["mana"] = u:GetMana()
  unit["maxMana"] = u:GetMaxMana()
  unit["manaRegen"] = u:GetManaRegen()

  unit["baseMovementSpeed"] = u:GetBaseMovementSpeed()
  unit["currentMovementSpeed"] = u:GetCurrentMovementSpeed()

  unit["isAlive"] = u:IsAlive()
  unit["respawnTime"] = u:GetRespawnTime()
  unit["hasBuyback"] = u:HasBuyback()
  unit["buybackCost"] = u:GetBuybackCost()
  unit["buybackCooldown"] = u:GetBuybackCooldown()
  unit["remainingLifespan"] = u:GetRemainingLifespan()

  unit["baseDamage"] = u:GetBaseDamage()
  unit["baseDamageVariance"] = u:GetBaseDamageVariance()
  unit["attackDamage"] = u:GetAttackDamage()
  unit["attackRange"] = u:GetAttackRange()
  unit["attackSpeed"] = u:GetAttackSpeed()
  unit["secondsPerAttack"] = u:GetSecondsPerAttack()
  unit["attackPoint"] = u:GetAttackPoint()
  unit["lastAttackTime"] = u:GetLastAttackTime()
  unit["acquisitionRange"] = u:GetAcquisitionRange()
  unit["attackProjectileSpeed"] = u:GetAttackProjectileSpeed()

  unit["spellAmp"] = u:GetSpellAmp()
  unit["armor"] = u:GetArmor()
  unit["magicResist"] = u:GetMagicResist()
  unit["evasion"] = u:GetEvasion()

  unit["primaryAttribute"] = u:GetPrimaryAttribute()
  
  -- TODO: All attributes

  unit["bountyXP"] = u:GetBountyXP()
  unit["bountyGoldMin"] = u:GetBountyGoldMin()
  unit["bountyGoldMax"] = u:GetBountyGoldMax()

  unit["XPNeededToLevel"] = u:GetXPNeededToLevel()
  unit["abilityPoints"] = u:GetAbilityPoints()
  unit["level"] = u:GetLevel()

  unit["gold"] = u:GetGold()
  unit["netWorth"] = u:GetNetWorth()
  unit["stashValue"] = u:GetStashValue()
  unit["courierValue"] = u:GetCourierValue()

  unit["lastHits"] = u:GetLastHits()
  unit["denies"] = u:GetDenies()

  unit["boundingRadius"] = u:GetBoundingRadius()
  unit["location"] = ParseLocation(u:GetLocation())
  unit["facing"] = u:GetFacing()
  unit["velocity"] = ParseLocation(u:GetVelocity())
  
  unit["dayTimeVisionRange"] = u:GetDayTimeVisionRange()
  unit["nightTimeVisionRange"] = u:GetNightTimeVisionRange()
  unit["currentVisionRange"] = u:GetCurrentVisionRange()

  unit["healthRegenPerStr"] = u:GetHealthRegenPerStr()
  unit["manaRegenPerInt"] = u:GetManaRegenPerInt()

  -- unit["animationActivity"] = u:GetAnimationActivity()
  -- unit["animCycle"] = u:GetAnimCycle()

  unit["isChanneling"] = u:IsChanneling()
  unit["isUsingAbility"] = u:IsUsingAbility()
  unit["isCastingAbility"] = u:IsCastingAbility()

  unit["isAttackImmune"] = u:IsAttackImmune()
  unit["isBlind"] = u:IsBlind()
  unit["isBlockDisabled"] = u:IsBlockDisabled()
  unit["isDisarmed"] = u:IsDisarmed()
  unit["isDominated"] = u:IsDominated()
  unit["isEvadeDisabled"] = u:IsEvadeDisabled()
  unit["isHexed"] = u:IsHexed()
  unit["isInvisible"] = u:IsInvisible()
  unit["isInvulnerable"] = u:IsInvulnerable()
  unit["isMagicImmune"] = u:IsMagicImmune()
  unit["isMuted"] = u:IsMuted()
  unit["isNightmared"] = u:IsNightmared()
  unit["isRooted"] = u:IsRooted()
  unit["isSilenced"] = u:IsSilenced()
  unit["isSpeciallyDeniable"] = u:IsSpeciallyDeniable()
  unit["isStunned"] = u:IsStunned()
  unit["isUnableToMiss"] = u:IsUnableToMiss()
  unit["hasScepter"] = u:HasScepter()

  unit["timeSinceDamagedByAnyHero"] = u:TimeSinceDamagedByAnyHero()
  unit["timeSinceDamagedByCreep"] = u:TimeSinceDamagedByCreep()
  unit["timeSinceDamagedByTower"] = u:TimeSinceDamagedByTower()

  unit["currentActionType"] = u:GetCurrentActionType()
  unit["courierState"] = GetCourierState(u)
  unit["isFlyingCourier"] = IsFlyingCourier(u)
  if abilities then
    --  abilities
    local abilities = {}
    for slot = 0, 15 do
      local a = u:GetAbilityInSlot(slot)
      if a ~= nil then
        local ability = getAbility(a, slot)
        table.insert(abilities, ability)
      end
    end
    unit["abilities"] = abilities
  end
  if items then
    -- items
    local items = {}
    for slot = 0, 15 do
      local i = u:GetItemInSlot(slot)
      if i ~= nil then
        local item = getAbility(i, slot)
        table.insert(items, item)
      end
    end
    unit["items"] = items
  end
  if trees then
    -- nearby trees
    local nearbyTrees = {}
    local trees = u:GetNearbyTrees(1500)
    if trees ~= nil then
      for k,tid in pairs(trees) do
        local tree = {}
        tree["handleID"] = tid
        tree["location"] = ParseLocation(GetTreeLocation(tid))
        table.insert(nearbyTrees, tree)
      end
    end
    unit["nearbyTrees"] = nearbyTrees
  end
  return unit
end

function observation.getUnits(type)
  type = type or UNIT_LIST_ALL
  local unitList = GetUnitList(type)
  local handleToUUID = {}
  setmetatable(handleToUUID, { __mode = "k" })
  for k,u in pairs(unitList) do
    local uuid = uuidv4.getUUID()
    handleToUUID[u] = uuid
  end
  local units = {}
  for k,u in pairs(unitList) do
    local unit = observation.getUnitInfo(u)
    unit["uuid"] = handleToUUID[u] -- handle ID
    local attackTarget = u:GetAttackTarget()
    unit["attackTarget"] = attackTarget == nil and nil or handleToUUID[attackTarget]
    --
    table.insert(units, unit)
  end
  return units, handleToUUID, unitList
end

function observation.getDroppedItems()
  local droppedItemsHandles = {}
  local droppedItems = {}
  local hdi = 0
  local droppedItemList = GetDroppedItemList()
  if droppedItemList ~= nil then
    for k,tbl in pairs(droppedItemList) do
      hdi = hdi + 1
      droppedItemsHandles[hdi] = tbl.item
      local droppedItem = {}
      droppedItem["handleID"] = hdi -- handle ID
      droppedItem["name"] = tbl.item:GetName()
      droppedItem["location"] = ParseLocation(tbl.location)
      table.insert(droppedItems, droppedItem)
    end
  end
  return droppedItems, droppedItemsHandles
end

function observation.getRunes()
  local runes = {}
  local runeSpawnList = {RUNE_POWERUP_1, RUNE_POWERUP_2,
    RUNE_BOUNTY_1, RUNE_BOUNTY_2, RUNE_BOUNTY_3, RUNE_BOUNTY_4}
  for k,rs in pairs(runeSpawnList) do
    local rune = {}
    rune["runeSpawn"] = rs
    rune["type"] = GetRuneType(rs)
    rune["status"] = GetRuneStatus(rs)
    rune["timeSinceSeen"] = GetRuneTimeSinceSeen(rs)
    table.insert(runes, rune)
  end
  return runes, runeSpawnList
end

function observation.getLaneFronts()
  local laneFronts = {}
  local lanes = {LANE_TOP, LANE_MID, LANE_BOT}
  for k,l in pairs(lanes) do
    local lf = {}
    lf["lane"] = l
    local lfLoc = GetLaneFrontLocation(GetBot():GetTeam(), l, -300) -- slight delta
    lf["front"] = ParseLocation(lfLoc)
    table.insert(laneFronts, lf)
  end
  return laneFronts
end

function observation.teamInfo()
    -- [6] GLYPH COOLDOWN
  local obs = {}
  obs["glyphCooldown"] = GetGlyphCooldown()
  return obs
end

function observation.getWorldInfo()
  local info = {}
  -- [1] GAME TIME
  info["gameTime"] = GameTime()
  -- [2] DOTA TIME
  info["dotaTime"] = DotaTime()
  -- [5] TIME OF DAY
  info["timeOfDay"] = GetTimeOfDay()
  -- [7] ROSHAN KILL TIME
  info["roshanKillTime"] = GetRoshanKillTime()

  local units, unitHandles, unitList = observation.getUnits()
  info["units"] = units

  local runes = observation.getRunes()
  info["runes"] = runes

  local droppedItems, droppedItemsHandles = observation.getDroppedItems()
  info["droppedItems"] = droppedItems

  info["laneFronts"] = observation.getLaneFronts()
  return info, unitHandles, droppedItemsHandles
end
return observation
