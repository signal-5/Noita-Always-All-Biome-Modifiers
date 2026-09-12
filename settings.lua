-- =========================================================================
-- Mod Settings: All Biome Modifiers
-- =========================================================================
dofile("data/scripts/lib/mod_settings.lua")

local mod_id = "always_all_biome_modifiers"
mod_settings_version = 1

mod_settings = {
  {
    category_id = "general_settings",
    ui_name = "Global Settings",
    ui_description = "Master controls for biome modifiers application",
    foldable = true,
    _folded = false,
    settings = {
      {
        id = "ignore_biome_restrictions",
        ui_name = "Ignore biome restrictions",
        ui_description = "Apply modifiers even if restricted or normally excluded from specific biomes (e.g. Coalmine, Holy Mountain entrance, etc.)",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "apply_everywhere",
        ui_name = "Apply modifiers everywhere",
        ui_description = "Apply enabled modifiers to every single biome across the entire world, not just primary progression biomes",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
    },
  },
  {
    category_id = "active_modifiers_selection",
    ui_name = "Active Biome Modifiers (All Simultaneous)",
    ui_description = "Toggle which modifiers are enabled simultaneously across all biomes",
    foldable = true,
    _folded = false,
    settings = {
      {
        id = "mod_MOIST",
        ui_name = "Moist / Humid",
        ui_description = "\"The air feels extremely humid\" - Fires die fast, high air drag, and entities get wet.",
        value_default = false,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_FOG_OF_WAR_REAPPEARS",
        ui_name = "Lingering Darkness",
        ui_description = "\"A mysterious darkness lingers in this place\" - Explored areas quickly fade back into darkness.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_HIGH_GRAVITY",
        ui_name = "High Gravity",
        ui_description = "\"The air feels heavy...\" - Projectiles and entities experience 1.5x gravity.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_LOW_GRAVITY",
        ui_name = "Low Gravity",
        ui_description = "\"The air feels light...\" - Projectiles and entities experience 0.5x gravity.",
        value_default = false,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_CONDUCTIVE",
        ui_name = "Ionized / Conductive",
        ui_description = "\"The air smells ionized\" - All materials conduct electricity! Spawns live wire traps, laser grids, and Thunderskulls.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_FREEZING",
        ui_name = "Freezing",
        ui_description = "\"The air feels freezing\" - Liquids freeze into ice, snow covers terrain, and Ukko / ice enemies appear.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_HOT",
        ui_name = "Dry & Hot",
        ui_description = "\"The air feels dry and hot\" - Evaporates water, melts ice into steam, and spawns fire traps and burning hazards.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_GOLD_VEIN",
        ui_name = "Gold Vein",
        ui_description = "\"You sense lucrative opportunities\" - Generates substantial natural gold veins embedded in rock and terrain.",
        value_default = false,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_GOLD_VEIN_SUPER",
        ui_name = "Super Gold Vein",
        ui_description = "\"You sense extremely lucrative opportunities\" - Massive motherlode veins of gold embedded in stone (ultra-rare vanilla spawn).",
        value_default = false,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_PLANT_INFESTED",
        ui_name = "Wet Soil / Overgrown",
        ui_description = "\"It smells like soil after rain\" - Jungle vegetation overgrows the area, with lush vines, explosive swamp bulbs, and plant foes.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_FURNISHED",
        ui_name = "Furnished / Cozy",
        ui_description = "\"It feels cozy in here\" - Populates the caves with civilized furniture, hanging lamps, statues, and decorative props.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_BOOBY_TRAPPED",
        ui_name = "Booby Trapped",
        ui_description = "\"You feel wary\" - Infests corridors with proximity landmines, hidden trigger plates, and explosive barrels.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_PERFORATED",
        ui_name = "Perforated / Roomy",
        ui_description = "\"It feels roomy in here\" - Worm tunnels carve voids, and worms spawn.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_SPOOKY",
        ui_name = "Spooky / Haunted",
        ui_description = "\"The hair in the back of your neck stands up\" - Ghostly companions, tombstones, and phantom spirits spawn.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_GRAVITY_FIELDS",
        ui_name = "Gravity Fields",
        ui_description = "\"You feel an invisible force pushing and pulling you\" - Gravity-wells and repulsion circles warp trajectories.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_FUNGAL",
        ui_name = "Fungal Spores",
        ui_description = "\"The air is filled with fungal spores\" - Spawns weird fungi, spore pods, and toxic enemies.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_FLOODED",
        ui_name = "Flooded Pipes",
        ui_description = "\"Where did all this water come from?\" - Leaking pipes create deep pools and spawn Märkiäinen.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_GAS_FLOODED",
        ui_name = "Gas Flooded / Corrosive",
        ui_description = "\"There's a smell of gas in the air\" - Corrosive gas pipes, acid, and toxic enemies.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_SHIELDED",
        ui_name = "Shielded Hostiles",
        ui_description = "\"This place feels exceptionally secure\" - Enemies frequently spawn with energy shields.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_PROTECTION_FIELDS",
        ui_name = "Sunlight / Protection Fields",
        ui_description = "\"Everything is glowing in a mysterious light...!\" - Radiant sunlight spheres glow softly across the terrain.",
        value_default = false,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_OMINOUS",
        ui_name = "Dark Sun / Ominous",
        ui_description = "\"There's an ominous atmosphere here...!\" - Dark void orbs and sinister energy fields.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_INVISIBILITY",
        ui_name = "Invisibility / Stalkers",
        ui_description = "\"You feel like you are being watched...\" - Enemies spawn with active invisibility cloaks.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
      {
        id = "mod_WORMY",
        ui_name = "Worm Infestation",
        ui_description = "\"The air smells of worms\" - Worms aggressively burrow through stone.",
        value_default = true,
        scope = MOD_SETTING_SCOPE_NEW_GAME,
      },
    },
  },
}

-- Required Noita settings lifecycle functions
function ModSettingsUpdate( init_scope )
  local old_version = mod_settings_get_version( mod_id )
  mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
  return mod_settings_gui_count( mod_id, mod_settings )
end

function ModSettingsGui( gui, in_main_menu )
  mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
