# All Biome Modifiers (Noita Mod)

Forces all or selected biome modifiers to be activated simultaneously across biomes for extra challenge!

Default setting for extra spicy.

## Features
- **Simultaneous Activation**: All enabled modifiers apply together at the same time.
- **In-game Mod Settings**: Easily check/uncheck individual modifiers via Options -> Mod settings in Noita.
- **Ignore Biome Restrictions**: Option enabled by default allowing modifiers like Conductive, Plant Infested, or Flooded to trigger in any biome.
- **Apply Modifiers Everywhere**: Option enabled by default targeting all surface, side, and secret biomes throughout the world.
- **Pure Compatibility**: Patches `data/scripts/biome_modifiers.lua` dynamically via virtual filesystem without corrupting base game archives.


## Technical Limitations & Quirks
Due to how Noita's engine handles different biome generations, there are some hardcoded limitations:
- **Cave Biomes (Wang Tiles)**: Modifiers like Gravity Fields, Furniture, Mask infestation, etc., will spawn flawlessly indoors because they use grid-based spawn tables (`g_small_enemies`, `g_props`).
- **Surface Biomes (Perlin Noise)**: The Surface (Forest, Desert, etc.) uses mathematical heightmaps and completely ignores grid-based spawn tables. Therefore, structural spawns (like Worms, Gravity Fields, Furniture) **will not appear on the surface**. Only XML-driven material changes (like Freezing, Hot, Ionized) can affect the surface natively.

## Installation
1. Extract this mod folder (`always_all_biome_modifiers`) directly into your Noita mods directory:
   - **Steam (Default)**: `C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\always_all_biome_modifiers`
   - **GOG / DRM-Free**: `<Noita Installation Folder>\mods\always_all_biome_modifiers`
   - **User Save Directory**: `%USERPROFILE%\AppData\LocalLow\Nolla_Games_Noita\mods\always_all_biome_modifiers`
2. Launch Noita.
3. In the main menu, click **Mods**.
4. Enable **All Biome Modifiers** (check the box).
5. Open **Options** -> **Mod settings** -> **All Biome Modifiers** to configure your desired modifiers and options!
6. Start a **New Game** and enjoy the chaotic challenge!
