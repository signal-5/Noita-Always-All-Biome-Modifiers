-- =========================================================================
-- Mod: All Biome Modifiers (always_all_biome_modifiers)
-- =========================================================================

function OnModPreInit()
  print("[AlwaysAllModifiers] PreInit: Preparing biome modifiers system...")
end

function OnModInit()
  print("[AlwaysAllModifiers] Init: Hooking data/scripts/biome_modifiers.lua...")

  local target_file = "data/scripts/biome_modifiers.lua"
  local content = ModTextFileGetContent( target_file )
  local hook_code = ModTextFileGetContent( "mods/always_all_biome_modifiers/files/biome_modifiers_hook.lua" )

  if content ~= nil and content ~= "" and hook_code ~= nil and hook_code ~= "" then
    -- Strip the default terminal 'return init_biome_modifiers' from vanilla file
    -- to allow appending our enhanced multi-modifier engine.
    local cleaned_content, count = string.gsub( content, "return%s+init_biome_modifiers", "-- [always_all_biome_modifiers hook point]" )

    local merged_content = cleaned_content .. "\n\n" ..
      "-- ===================================================================\n" ..
      "-- [ALWAYS ALL BIOME MODIFIERS] INJECTED ENGINE\n" ..
      "-- ===================================================================\n" ..
      hook_code .. "\n\n" ..
      "return init_biome_modifiers\n"

    ModTextFileSetContent( target_file, merged_content )
    print("[AlwaysAllModifiers] Successfully patched biome_modifiers.lua in virtual filesystem!")
  else
    print("[AlwaysAllModifiers] Warning: Failed to read biome_modifiers.lua or hook file.")
  end

  -- Pre-compile active settings cache for biome generator scripts
  local ignore_restrictions = true
  if ModSettingGet then
    local v = ModSettingGet( "always_all_biome_modifiers.ignore_biome_restrictions" )
    if v ~= nil then ignore_restrictions = v end
  end

  local cache_code = "_ALWAYS_ALL_MODS_CACHE = {\n" ..
    "  ignore_restrictions = " .. tostring(ignore_restrictions) .. ",\n" ..
    "  enabled_mods = {\n"

  local all_modifier_ids = {
    "MOIST", "FOG_OF_WAR_REAPPEARS", "HIGH_GRAVITY", "LOW_GRAVITY", "CONDUCTIVE",
    "FREEZING", "HOT", "GOLD_VEIN", "GOLD_VEIN_SUPER", "PLANT_INFESTED",
    "FURNISHED", "BOOBY_TRAPPED", "PERFORATED", "SPOOKY", "GRAVITY_FIELDS",
    "FUNGAL", "FLOODED", "GAS_FLOODED", "SHIELDED", "PROTECTION_FIELDS",
    "OMINOUS", "INVISIBILITY", "WORMY"
  }

  for _, id in ipairs( all_modifier_ids ) do
    local is_enabled = true
    if ModSettingGet then
      local val = ModSettingGet( "always_all_biome_modifiers.mod_" .. id )
      if val ~= nil then is_enabled = val end
    end
    cache_code = cache_code .. "    [\"" .. id .. "\"] = " .. tostring(is_enabled) .. ",\n"
  end
  cache_code = cache_code .. "  }\n}\n"

  ModTextFileSetContent( "mods/always_all_biome_modifiers/files/active_spawns_cache.lua", cache_code )

  -- Append spawn injector directly to all biome scripts
  -- This ensures g_small_enemies, g_props, etc. are modified directly where they are defined!
  local ALL_BIOME_SCRIPTS = {
    "coalmine.lua", "coalmine_alt.lua", "excavationsite.lua", "excavationsite_cube_chamber.lua",
    "snowcave.lua", "snowcave_petri.lua", "snowcave_secret_chamber.lua",
    "snowcastle.lua", "snowcastle_cavern.lua", "snowcastle_hourglass_chamber.lua",
    "rainforest.lua", "rainforest_dark.lua", "vault.lua", "vault_frozen.lua", "vault_entrance.lua",
    "crypt.lua", "fungicave.lua", "fungiforest.lua", "hills.lua", "desert.lua",
    "sandcave.lua", "wandcave.lua", "watercave.lua", "liquidcave.lua", "clouds.lua",
    "dragoncave.lua", "wizardcave.lua", "wizardcave_entrance.lua", "robobase.lua", "roboroom.lua",
    "pyramid.lua", "pyramid_hallway.lua", "pyramid_top.lua", "pyramid_left.lua", "pyramid_right.lua", "pyramid_entrance.lua",
    "lake.lua", "lake_deep.lua", "lake_statue.lua", "lavalake.lua", "lavalake_pit.lua", "lavalake_racing.lua",
    "the_end.lua", "tower.lua", "tower_end.lua", "temple_altar.lua", "temple_altar_empty.lua",
    "temple_altar_left.lua", "temple_altar_right.lua", "temple_altar_secret.lua", "temple_shared.lua",
    "boss_arena.lua", "boss_arena_top.lua", "boss_limbs_arena.lua", "bridge.lua", "default.lua",
    "friend_1.lua", "friend_2.lua", "friend_3.lua", "friend_4.lua", "friend_5.lua", "friend_6.lua",
    "ghost_secret.lua", "gourd_room.lua", "greed_room.lua", "gun_room.lua", "laboratory.lua",
    "magic_gate.lua", "mestari_secret.lua", "moon_room.lua", "mountain_lake.lua", "mountain_tree.lua",
    "mystery_teleport.lua", "null_room.lua", "ocarina.lua", "roadblock.lua", "robot_egg.lua",
    "rock_room.lua", "sandroom.lua", "scale.lua", "secret_altar.lua", "secret_entrance.lua", "secret_lab.lua",
    "shop_room.lua", "smokecave_left.lua", "smokecave_middle.lua", "smokecave_right.lua",
    "solid_wall_hidden_cavern.lua", "solid_wall_tower.lua", "song_room.lua", "teleroom.lua",
    "winter.lua", "town.lua"
  }

  for _, script_file in ipairs( ALL_BIOME_SCRIPTS ) do
    ModLuaFileAppend( "data/scripts/biomes/" .. script_file, "mods/always_all_biome_modifiers/files/inject_biome_spawns.lua" )
  end
  print( string.format( "[AlwaysAllModifiers] Appended spawn injector to %d biome scripts.", #ALL_BIOME_SCRIPTS ) )
end

function OnBiomeConfigLoaded()
  -- Called when the game loads biome configurations for the world.
  -- Force execution of our patched multi-modifier engine so XML, environmental, and material modifiers are applied.
  print("[AlwaysAllModifiers] OnBiomeConfigLoaded: Running multi-modifier engine pass across all biomes...")
  local init_fn = dofile( "data/scripts/biome_modifiers.lua" )
  if type(init_fn) == "function" then
    local ok, err = pcall( init_fn )
    if ok then
      print("[AlwaysAllModifiers] Successfully applied all active biome modifiers!")
    else
      print("[AlwaysAllModifiers] Error executing init_biome_modifiers: " .. tostring(err))
    end
  else
    print("[AlwaysAllModifiers] Error: dofile('data/scripts/biome_modifiers.lua') did not return a function.")
  end
end
