-- =========================================================================
-- ALWAYS ALL BIOME MODIFIERS - Biome Script Spawn Injector
-- Appended to data/scripts/biomes/*.lua to inject spawns directly into
-- g_small_enemies, g_big_enemies, g_props, g_lamp, g_vines, etc.
-- =========================================================================

-- Ensure biome_modifiers.lua is loaded
dofile_once( "data/scripts/biome_modifiers.lua" )

-- Ensure inject_spawn exists and properly resets total_prob
function inject_spawn( list, probability_mult, new_spawn )
  if list == nil then return end
  local existing_spawn = nil
  local max_prob = 0.0
  for _, it in ipairs( list ) do
    max_prob = math.max( max_prob, it.prob or 0 )
    if it.entity == new_spawn.entity then
      existing_spawn = it
    end
  end
  max_prob = math.max( max_prob, 0.3 )
  if existing_spawn then
    existing_spawn.prob = max_prob * probability_mult
    existing_spawn.min_count = new_spawn.min_count
    existing_spawn.max_count = new_spawn.max_count
    existing_spawn.offset_y = new_spawn.offset_y
  else
    new_spawn.prob = max_prob * probability_mult
    table.insert( list, new_spawn )
  end
  list.total_prob = 0
end

-- Helper to check if a modifier is enabled
local function is_mod_active( mod_id )
  if _ALWAYS_ALL_MODS_CACHE ~= nil and _ALWAYS_ALL_MODS_CACHE.enabled_mods ~= nil then
    local cached = _ALWAYS_ALL_MODS_CACHE.enabled_mods[mod_id]
    if cached ~= nil then return cached end
  end
  if ModSettingGet then
    local v = ModSettingGet( "always_all_biome_modifiers.mod_" .. mod_id )
    if v ~= nil then return v end
  end
  return true
end

local function should_ignore_restrictions()
  if _ALWAYS_ALL_MODS_CACHE ~= nil and _ALWAYS_ALL_MODS_CACHE.ignore_restrictions ~= nil then
    return _ALWAYS_ALL_MODS_CACHE.ignore_restrictions
  end
  if ModSettingGet then
    local v = ModSettingGet( "always_all_biome_modifiers.ignore_biome_restrictions" )
    if v ~= nil then return v end
  end
  return true
end

-- Execute spawn injection for all active modifiers
local function run_spawn_injections()
  if biome_modifiers == nil then return end

  local ignore_restrictions = should_ignore_restrictions()
  local injected_count = 0

  for _, mod in ipairs( biome_modifiers ) do
    if is_mod_active( mod.id ) and mod.inject_spawns_action ~= nil then
      local applies = true
      if not ignore_restrictions and BIOME_NAME ~= nil and mod.does_not_apply_to_biome ~= nil then
        for _, skip in ipairs( mod.does_not_apply_to_biome ) do
          if skip == BIOME_NAME then
            applies = false
            break
          end
        end
      end

      if applies then
        pcall( function()
          mod.inject_spawns_action( BIOME_NAME or "" )
          injected_count = injected_count + 1
        end )
      end
    end
  end

  -- Ensure any modified lists recalculate total_prob when queried by director
  if g_small_enemies ~= nil then g_small_enemies.total_prob = 0 end
  if g_big_enemies ~= nil then g_big_enemies.total_prob = 0 end
  if g_props ~= nil then g_props.total_prob = 0 end
  if g_props2 ~= nil then g_props2.total_prob = 0 end
  if g_props3 ~= nil then g_props3.total_prob = 0 end
  if g_lamp ~= nil then g_lamp.total_prob = 0 end
  if g_ghostlamp ~= nil then g_ghostlamp.total_prob = 0 end
  if g_vines ~= nil then g_vines.total_prob = 0 end
  if g_nest ~= nil then g_nest.total_prob = 0 end

  print( string.format( "[AlwaysAllModifiers] Injected %d modifier spawn tables into %s", injected_count, tostring( BIOME_NAME or "biome" ) ) )
end

run_spawn_injections()
