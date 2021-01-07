--
-- observation message
--
local Pack = require(GetScriptDirectory() .. "/utils/pack")

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
  table.insert(ability, slot)
  table.insert(ability, )
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
  local behavior = {}
  behavior["ABILITY_BEHAVIOR_PASSIVE"] = flagIsSet(a:GetBehavior(), ABILITY_BEHAVIOR_PASSIVE)
  behavior["ABILITY_BEHAVIOR_NO_TARGET"] = flagIsSet(a:GetBehavior(), ABILITY_BEHAVIOR_NO_TARGET)
  behavior["ABILITY_BEHAVIOR_UNIT_TARGET"] = flagIsSet(a:GetBehavior(), ABILITY_BEHAVIOR_UNIT_TARGET)
  behavior["ABILITY_BEHAVIOR_POINT"] = flagIsSet(a:GetBehavior(), ABILITY_BEHAVIOR_POINT)
  behavior["ABILITY_BEHAVIOR_AOE"] = flagIsSet(a:GetBehavior(), ABILITY_BEHAVIOR_AOE)
  behavior["ABILITY_BEHAVIOR_NOT_LEARNABLE"] = flagIsSet(a:GetBehavior(), ABILITY_BEHAVIOR_NOT_LEARNABLE)
  behavior["ABILITY_BEHAVIOR_CHANNELLED"] = flagIsSet(a:GetBehavior(), ABILITY_BEHAVIOR_CHANNELLED)
  ability["behavior"] = behavior

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
  ability["geTSecondaryCharges"] = a:GetSecondaryCharges()
  ability["getTargetTeam"] = a:GetTargetTeam()
  ability["getTargetType"] = a:GetTargetType()
  ability["isItem"] = a:IsItem()
  ability["canBeDisassembled"] = a:CanBeDisassembled()
  ability["isCombineLocked"] = a:IsCombineLocked()
  return ability
end

-- public
function observation.get()
  local obs = {}
  -- [1] GAME TIME
  obs["gameTime"] = GameTime()
  -- [2] DOTA TIME
  obs["dotaTime"] = DotaTime()
  -- [3] PLAYER ID
  obs["playerID"] = GetBot():GetPlayerID()
  -- [4] PLAYER CURRENT ACTION TYPE
  obs["currentActionType"] = GetBot():GetCurrentActionType()
  -- [5] TIME OF DAY
  obs["timeOfDay"] = GetTimeOfDay()
  -- [6] GLYPH COOLDOWN
  obs["glyphCooldown"] = GetGlyphCooldown()
  -- [7] ROSHAN KILL TIME
  obs["roshanKillTime"] = GetRoshanKillTime()
  -- [8] IS COURIER AVAILABLE
  obs["isCourierAvailable"] = IsCourierAvailable()
  -- [9] UNITS
  local unitList = GetUnitList(UNIT_LIST_ALL)
  local unitHandles = {}
  local units = {}
  local hu = 0
  for k,u in pairs(unitList) do
    hu = hu + 1
    unitHandles[hu] = u
    local unit = {}
    unit["handleID"] = hu -- handle ID
    unit["playerID"] = u:GetPlayerID()
    unit["team"] = u:GetTeam()
    unit["name"] = u:GetUnitName()
    unit["currentActionType"] = u:GetCurrentActionType()
    unit["isControlled"] = u == GetBot()
    unit["isHero"] = u:IsHero()
    unit["isCreep"] = u:IsCreep()
    unit["isAncientCreep"] = u:IsAncientCreep()
    unit["isBuilding"] = u:IsBuilding()
    unit["isTower"] = u:IsTower()
    unit["isFort"] = u:IsFort()
    unit["courierState"] = GetCourierState(u)
    unit["courierValue"] = u:GetCourierValue()
    unit["isFlyingCourier"] = IsFlyingCourier(u)
    unit["isIllusion"] = u:IsIllusion()
    unit["canBeSeen"] = u:CanBeSeen()
    unit["location"] = u:GetLocation()
    unit["facing"] = u:GetFacing()
    unit["velocity"] = u:GetVelocity()
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
    unit["lastAttackTime"] = u:GetLastAttackTime()
    unit["acquisitionRange"] = u:GetAcquisitionRange()
    unit["attackProjectileSpeed"] = u:GetAttackProjectileSpeed()
    unit["spellAmp"] = u:GetSpellAmp()
    unit["armor"] = u:GetArmor()
    unit["magicResist"] = u:GetMagicResist()
    unit["evasion"] = u:GetEvasion()
    unit["bountyXP"] = u:GetBountyXP()
    unit["bountyGoldMin"] = u:GetBountyGoldMin()
    unit["bountyGoldMax"] = u:GetBountyGoldMax()
    unit["XPNeededToLevel"] = u:GetXPNeededToLevel()
    unit["abilityPoints"] = u:GetAbilityPoints()
    unit["level"] = u:GetLevel()
    unit["gold"] = u:GetGold()
    unit["netWorth"] = u:GetNetWorth()
    unit["stashValue"] = u:GetStashValue()
    unit["lastHits"] = u:GetLastHits()
    unit["denies"] = u:GetDenies()
    unit["boundingRadius"] = u:GetBoundingRadius()
    unit["dayTimeVisionRange"] = u:GetDayTimeVisionRange()
    unit["nightTimeVisionRange"] = u:GetNightTimeVisionRange()
    unit["currentVisionRange"] = u:GetCurrentVisionRange()
    unit["healthRegenPerStr"] = u:GetHealthRegenPerStr()
    unit["manaRegenPerInt"] = u:GetManaRegenPerInt()
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
    -- nearby trees
    local nearbyTrees = {}
    local trees = u:GetNearbyTrees(1500)
    if trees ~= nil then
      for k,tid in pairs(trees) do
        table.insert(nearbyTrees, tid)
      end
    end
    unit["nearbyTrees"] = nearbyTrees
    --
    table.insert(units, unit)
  end
  obs["units"] = units
  -- [10] DROPPED ITEMS
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
      droppedItem["location"] = tbl.location
      table.insert(droppedItems, droppedItem)
    end
  end
  obs["droppedItems"] = droppedItems
  -- [11] RUNES
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
  obs["runes"] = runes
  -- [12] LANE FRONTS
  local laneFronts = {}
  local lanes = {LANE_TOP, LANE_MID, LANE_BOT}
  for k,l in pairs(lanes) do
    local lf = {}
    lf["lane"] = l
    lf["front"] = GetLaneFrontLocation(GetBot():GetTeam(), l, -300) -- slight delta
    laneFronts["lane"] = lf
  end
  obs["laneFronts"] = laneFronts
  -- return observation
  return Pack(obs, "observation"), unitHandles, droppedItemsHandles
end

return observation
