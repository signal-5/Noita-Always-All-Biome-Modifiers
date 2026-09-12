-- =========================================================================
-- ALWAYS ALL BIOME MODIFIERS - Engine Hook & Multi-Modifier Injector
-- =========================================================================

local MOD_SETTING_PREFIX = "always_all_biome_modifiers."

-- Helper to safely retrieve boolean mod settings
local function get_mod_setting_bool( setting_name, default_value )
  local full_id = MOD_SETTING_PREFIX .. setting_name
  local val = ModSettingGet( full_id )
  if val == nil then
    val = ModSettingGetNextValue( full_id )
  end
  if type(val) == "boolean" then
    return val
  end
  return default_value
end

-- Global map of active modifiers list per biome
g_all_active_modifiers_by_biome = g_all_active_modifiers_by_biome or {}

-- Comprehensive roster of known Noita biomes
local ALL_COMPREHENSIVE_BIOMES = {
  "alchemist_secret", "boss_arena", "boss_arena_top", "boss_limbs_arena", "boss_victoryroom", "bridge",
  "clouds", "coalmine", "coalmine_alt", "crypt", "desert", "dragoncave",
  "empty", "ending_placeholder", "end_wall", "essenceroom", "essenceroom_air", "essenceroom_alc",
  "essenceroom_hell", "excavationsite", "excavationsite_cube_chamber", "forest", "friend_1", "friend_2",
  "friend_3", "friend_4", "friend_5", "friend_6", "fungicave", "fungiforest",
  "funroom", "ghost_secret", "gold", "gourd_room", "greed_room", "gun_room",
  "hills", "hills2", "hills_flat", "laboratory", "lake", "lake_blood",
  "lake_deep", "lake_statue", "lava", "lava_90percent", "lavalake", "lavalake_pit",
  "lavalake_racing", "liquidcave", "magic_gate", "mestari_secret", "moon_room", "mountain_center",
  "mountain_floating_island", "mountain_hall", "mountain_hall_2", "mountain_hall_3", "mountain_hall_4", "mountain_hall_trailer",
  "mountain_lake", "mountain_left", "mountain_left_2", "mountain_left_3", "mountain_left_entrance", "mountain_left_stub",
  "mountain_right", "mountain_right_2", "mountain_right_entrance", "mountain_right_entrance_2", "mountain_right_stub", "mountain_top",
  "mountain_tree", "mystery_teleport", "niilo_testroom", "niilo_testroom_b", "niilo_testroom_c", "niilo_testroom_d",
  "null", "null_room", "ocarina", "orbroom_00", "orbroom_01", "orbroom_02",
  "orbroom_03", "orbroom_04", "orbroom_05", "orbroom_06", "orbroom_07", "orbroom_08",
  "orbroom_09", "orbroom_10", "orbroom_11", "pyramid", "pyramid_entrance", "pyramid_hallway",
  "pyramid_left", "pyramid_right", "pyramid_top", "rainforest", "rainforest_dark", "rainforest_open",
  "roadblock", "robobase", "roboroom", "robot_egg", "rock_room", "sandcave",
  "sandroom", "scale", "secret_altar", "secret_entrance", "secret_lab", "shop_room",
  "smokecave_left", "smokecave_middle", "smokecave_right", "snowcastle", "snowcastle_cavern", "snowcastle_hourglass_chamber",
  "snowcave", "snowcave_secret_chamber", "snowcave_tunnel", "solid_wall", "solid_wall_damage", "solid_wall_hidden_cavern",
  "solid_wall_temple", "solid_wall_tower", "solid_wall_tower_1", "solid_wall_tower_10", "solid_wall_tower_2", "solid_wall_tower_3",
  "solid_wall_tower_4", "solid_wall_tower_5", "solid_wall_tower_6", "solid_wall_tower_7", "solid_wall_tower_8", "solid_wall_tower_9",
  "song_room", "teleroom", "temple_altar", "temple_altar_empty", "temple_altar_left", "temple_altar_left_empty",
  "temple_altar_right", "temple_altar_right_empty", "temple_altar_right_snowcastle", "temple_altar_right_snowcastle_empty", "temple_altar_right_snowcave", "temple_altar_right_snowcave_empty",
  "temple_altar_secret", "temple_wall", "temple_wall_ending", "the_end", "the_sky", "town_under",
  "vault", "vault_entrance", "vault_frozen", "wandcave", "water", "watercave",
  "winter", "winter_caves", "wizardcave", "wizardcave_entrance",
}

-- Ensure inject_spawn resets total_prob on the list so Noita's spawn director immediately registers new spawns
function inject_spawn(list, probability_mult, new_spawn)
  if list == nil then return end
  local existing_spawn = nil
  local max_prob = 0.0
  for _,it in ipairs(list) do
    max_prob = math.max(max_prob, it.prob or 0)
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
    table.insert(list, new_spawn)
  end
  list.total_prob = 0
end

-- Override get_modifier_mappings to support multi-modifier structure
function get_modifier_mappings()
  local ignore_restrictions = get_mod_setting_bool( "ignore_biome_restrictions", true )
  local apply_everywhere = get_mod_setting_bool( "apply_everywhere", true )

  -- Gather all modifiers toggled on in Mod Settings
  local active_defs = {}
  for _, mod in ipairs( biome_modifiers ) do
    local is_enabled = get_mod_setting_bool( "mod_" .. mod.id, true )
    if is_enabled then
      table.insert( active_defs, mod )
    end
  end

  -- Determine target biomes based on 'Apply modifiers everywhere'
  g_all_active_modifiers_definitions = active_defs
  local target_biomes = {}
  if apply_everywhere then
    for _, b_name in ipairs( ALL_COMPREHENSIVE_BIOMES ) do
      target_biomes[b_name] = true
    end
  else
    -- Use vanilla standard biomes tables
    for _, biome_group in ipairs( biomes ) do
      for _, b_name in ipairs( biome_group ) do
        target_biomes[b_name] = true
      end
    end
    -- Also include vanilla side biomes
    local vanilla_sides = {
      "forest", "hills", "hills2", "hills_flat", "mountain_center", "mountain_tree", "mountain_lake", "lake", "lake_deep", "lake_statue",
      "mountain_top", "mountain_floating_island", "winter", "winter_caves",
      "lavalake", "desert", "pyramid_entrance", "pyramid_left", "pyramid_top", "pyramid_right",
      "watercave", "lake_statue", "wandcave", "wizardcave", "alchemist_secret"
    }
    for _, b_name in ipairs( vanilla_sides ) do
      target_biomes[b_name] = true
    end
  end

  -- Build map of active modifiers per biome
  g_all_active_modifiers_by_biome = {}
  local single_mapping_compat = {}

  for biome_name, _ in pairs( target_biomes ) do
    local list_for_biome = {}
    for _, mod in ipairs( active_defs ) do
      local applies = true
      if not ignore_restrictions then
        applies = biome_modifier_applies_to_biome( mod, biome_name )
      end
      if applies then
        table.insert( list_for_biome, mod )
      end
    end
    g_all_active_modifiers_by_biome[biome_name] = list_for_biome
    if #list_for_biome > 0 then
      local base_mod = list_for_biome[1]
      local combined_mod = {}
      for k, v in pairs(base_mod) do combined_mod[k] = v end
      
      combined_mod.action = function(b_name, b_filename)
          -- Ensure tables exist so table.insert doesn't fail on surface biomes
          g_small_enemies = g_small_enemies or {}
          g_big_enemies = g_big_enemies or {}
          g_items = g_items or {}
          g_props = g_props or {}
          g_props2 = g_props2 or {}
          g_props3 = g_props3 or {}
          g_lamp = g_lamp or {}
          g_vines = g_vines or {}
          g_ghostlamp = g_ghostlamp or {}
          g_candles = g_candles or {}
          g_nest = g_nest or {}
          
          for _, m in ipairs(list_for_biome) do
              if m.action ~= nil then
                  pcall(function() m.action(b_name, b_filename) end)
              end
          end
      end
      
      single_mapping_compat[biome_name] = combined_mod
    end
  end

  return single_mapping_compat
end

-- Override init_biome_modifiers to apply ALL active modifiers to each biome
function init_biome_modifiers()
  print("[AlwaysAllModifiers] Executing init_biome_modifiers()...")
  get_modifier_mappings()

  for biome_name, active_mods in pairs( g_all_active_modifiers_by_biome ) do
    if #active_mods > 0 then
      local biome_filename = "data/biome/" .. biome_name .. ".xml"
      local last_deco = ""

      local has_freezing = false
      local has_hot = false
      local has_conductive = false
      
      -- Safe initializations for table injections that might happen in mods
      _G.g_small_enemies = _G.g_small_enemies or {}
      _G.g_big_enemies = _G.g_big_enemies or {}
      _G.g_items = _G.g_items or {}
      _G.g_props = _G.g_props or {}
      _G.g_props2 = _G.g_props2 or {}
      _G.g_props3 = _G.g_props3 or {}
      _G.g_lamp = _G.g_lamp or {}
      _G.g_ghostlamp = _G.g_ghostlamp or {}
      _G.g_vines = _G.g_vines or {}
      _G.g_candles = _G.g_candles or {}
      _G.g_nest = _G.g_nest or {}

      for _, modifier in ipairs( active_mods ) do
        if modifier.id == "FREEZING" then has_freezing = true end
        if modifier.id == "HOT" then has_hot = true end
        if modifier.id == "CONDUCTIVE" then has_conductive = true end
        
        pcall( function()
          if modifier.action ~= nil then
            modifier.action( biome_name, biome_filename )
          end
          if modifier.ui_decoration_file ~= nil and modifier.ui_decoration_file ~= "" then
            last_deco = modifier.ui_decoration_file
          end
        end )
      end

      -- Environmental harmony and cross-biome visual enhancements
      pcall( function()
        if has_freezing then
          BiomeObjectSetValue( biome_filename, "modifiers", "reaction_freeze_chance", 8 )
          BiomeVegetationSetValue( biome_filename, "grass", "tree_material", "grass_ice" )
          BiomeVegetationSetValue( biome_filename, "moss", "tree_material", "grass_ice" )
          BiomeVegetationSetValue( biome_filename, "plant_material", "tree_material", "grass_ice" )
          BiomeVegetationSetValue( biome_filename, "ceiling_plant_material", "tree_material", "ice_static" )
          BiomeVegetationSetValue( biome_filename, "snow", "tree_probability", 0.83 )
        end

        if has_hot then
          BiomeObjectSetValue( biome_filename, "modifiers", "reaction_unfreeze_chance", 12 )
          if has_freezing then
            -- Both active: grass is icy while other plants are dry, creating extreme climate clash
            BiomeVegetationSetValue( biome_filename, "plant_material", "tree_material", "grass_dry" )
          else
            BiomeVegetationSetValue( biome_filename, "grass", "tree_material", "grass_dry" )
          end
        end

        if has_conductive then
          BiomeObjectSetValue( biome_filename, "modifiers", "everything_is_conductive", true )
        end

      end )

      -- Set UI notification message for entering the biome
      pcall( function()
        local ui_text = "All Modifiers Active (" .. tostring(#active_mods) .. " active)"
        if #active_mods == 1 then
          ui_text = active_mods[1].ui_description
        end

        BiomeSetValue( biome_filename, "mModifierUIDescription", ui_text )
        if last_deco ~= "" then
          BiomeSetValue( biome_filename, "mModifierUIDecorationFile", last_deco )
        end
        biomes_with_modifier[biome_name] = true
        table.insert( biomes_with_modifier, biome_name )
      end )
    end
  end
  print("[AlwaysAllModifiers] init_biome_modifiers completed across all biomes.")
end

-- Override biome_modifiers_inject_spawns to run inject_spawns_action for ALL active modifiers
function biome_modifiers_inject_spawns( biome_name )
  local active_mods = g_all_active_modifiers_by_biome[biome_name]
  if active_mods == nil then
    get_modifier_mappings()
    active_mods = g_all_active_modifiers_by_biome[biome_name]
  end

  -- Fallback: if biome is an unlisted or custom chunk and apply_everywhere is enabled, apply all active modifiers
  if active_mods == nil and get_mod_setting_bool( "apply_everywhere", true ) then
    active_mods = g_all_active_modifiers_definitions or {}
  end

  if active_mods ~= nil and #active_mods > 0 then
    print( "[AlwaysAllModifiers] Injecting spawns for biome: " .. tostring(biome_name) .. " (" .. tostring(#active_mods) .. " modifiers)" )
    for _, modifier in ipairs( active_mods ) do
      if modifier.inject_spawns_action ~= nil then
        pcall( function()
          modifier.inject_spawns_action( biome_name )
        end )
      end
    end
  end
end
