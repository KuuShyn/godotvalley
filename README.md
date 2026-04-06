# Previous Dev
@YuumaQ

# Godew Valley
Godew Valley is a Godot 4 top-down farming sandbox with grid-based world logic, crop growth, item economy, machine automation, and minigame-based item generation.

This README is a contributor guide focused on:
- Current project scope and architecture.
- What is already implemented.
- How to add new content using existing systems (plants, recipes, NPC/interactables, machines, and UI).

## Project Scope
The project currently supports these content pillars:
1. Farming loop: plant, wait, harvest, spend resources.
2. Tool-driven player actions and state-based interaction gating.
3. Automated machines (sprinkler, fisher, scarecrow) and unlock economy.
4. Minigames for progression (fishing and cooking).
5. Recipe-driven cooking pipeline via custom resources.
6. Cosmetic unlock flow (hats/styles) and shop UI patterns reusable for new menus.

## Repository Layout
- `scenes/`: all `.tscn` scenes organized by domain (`characters/`, `levels/`, `machines/`, `objects/`, `ui/`, `vfx/`).
- `src/`: all `.gd` scripts, mirroring `scenes/` folder structure.
- `graphics/`: sprites, icons, tilesets, UI textures.
- `audio/`: SFX/music assets.
- `resources/`: custom data resources (including `recipes/`).
- `premade/`: reusable snippets/templates.
- `shaders/`: shader files.

## Core Architecture
### Autoload Singletons
Defined in project settings and used globally:
1. `Enum` (`src/global/enums.gd`)
- Central enums for gameplay categories and state machines.
- Includes `Enum.State.COOKING`, `Enum.Shop.COOKING`, and expanded `Enum.Item` entries for recipe ingredients/results.

2. `Data` (`src/global/data.gd`)
- Core game balance and runtime state container.
- Holds constants and dictionaries such as `PLANT_DATA`, `MACHINE_UPGRADE_COST`, `STYLE_UPGRADES`, and `items`.
- Exposes `change_item(...)` for inventory mutation and UI refresh workflows.

### State-Driven Gameplay
Player behavior is gated by `Enum.State` values. Interaction scripts should move the player into a non-default state during modal experiences (shop/minigame/dialogue) and restore `DEFAULT` on close.

### Content-Through-Data Pattern
Most extensibility comes from adding entries to enums and data dictionaries/resources, not from hardcoding one-off logic in scene scripts.

## Implemented Systems
### Grid and World Rules
- Tile-based logic assumes `Data.TILE_SIZE = 16`.
- Coordinate math should remain consistent with this constant.

### Farming and Plants
- Plant definitions live in `Data.PLANT_DATA`.
- Existing crops: tomato, corn, pumpkin, wheat.
- Plant behavior script: `src/objects/plant.gd`.

### Machines
- Machine hierarchy uses `src/machines/machine.gd` as the base.
- Existing machine enum entries include sprinkler, fisher, scarecrow, delete.
- Upgrade economy is configured in `Data.MACHINE_UPGRADE_COST`.

### Shops and Unlocks
- Shop screen flow is implemented in `src/ui/shop_ui.gd` + `src/ui/shop_button.gd`.
- Cosmetic unlocks use `Data.STYLE_UPGRADES` and tracker arrays.

### Minigames
1. Fishing
- Script: `src/ui/fishing_game.gd`.
- Capture-bar style interaction loop.

2. Cooking
- Scripts: `src/ui/cooking_minigame.gd`, `src/ui/recipe_menu.gd`, `src/objects/stove.gd`.
- Recipe menu opens from stove interaction.
- Selected recipe can configure minigame difficulty and reward output.

### Recipes (Custom Resource Pipeline)
- Resource class: `src/resources/recipe_resource.gd` (`class_name RecipeResource`).
- Recipes are stored as `.tres` files under `resources/recipes/`.
- Typical fields: display name, result item, ingredient dictionary, icon, difficulty modifier.

## Add New Content
This section is the canonical workflow for extending game content.

### 1) Add a New Plant
1. Add identifiers in `src/global/enums.gd`:
- Add a new `Enum.Seed` entry.
- Add a corresponding `Enum.Item` harvest entry.
2. Add assets:
- Plant spritesheet in `graphics/plants/`.
- Icon in `graphics/icons/`.
3. Register plant data in `src/global/data.gd` (`PLANT_DATA`):
```gdscript
Enum.Seed.ONION: {
   'texture': "res://graphics/plants/onion.png",
   'icon_texture': "res://graphics/icons/onion.png",
   'name': 'Onion',
   'h_frames': 3,
   'grow_speed': 0.8,
   'death_max': 3,
   'reward': Enum.Item.ONION
}
```
4. If needed, expose the new item in `src/ui/resource_ui.gd` icon mappings.

### 2) Add a New Recipe
1. Ensure all ingredients and output exist in `Enum.Item`.
2. Ensure item keys are initialized in `Data.items` for save/runtime safety.
3. Create a recipe resource file in `resources/recipes/`:
- Use `RecipeResource`.
- Set `name`, `result_item`, `ingredients`, `icon`, `difficulty_modifier`.
4. Make it selectable:
- Add to the recipe menu exported array, or
- Load dynamically inside `src/ui/recipe_menu.gd`.
5. Verify stove flow:
- `src/objects/stove.gd` should open the menu, then launch minigame on selection.

### 3) Add a New NPC or Interactable
1. Create scene in `scenes/characters/` or `scenes/objects/`.
2. Add script in mirrored path under `src/`.
3. Implement an interaction entry point:

```gdscript
func interact(player: CharacterBody2D) -> void:
   if player.current_state != Enum.State.DEFAULT:
      return
   # Open your dialogue/menu/minigame here.
```

4. During modal UI/minigame:
- Set player state to an appropriate modal state.
- Restore `Enum.State.DEFAULT` on close.
5. Wire UI signals (`closed`, `tree_exited`, etc.) to cleanup methods.

### 4) Add a New Machine
1. Add enum entry in `Enum.Machine`.
2. Add balance entry in `Data.MACHINE_UPGRADE_COST`:
- Name
- Cost dictionary
- Icon
- Theme color

3. Create machine scene/script under `scenes/machines/` and `src/machines/`.
4. Inherit/reuse base behavior from `machine.gd` where possible.
5. Ensure placement/unlock flow is integrated in existing shop/build logic.

### 5) Add a New UI Menu (Pattern Reuse)
Use `shop_ui` and `recipe_menu` as templates.

Checklist:
1. Build scene under `scenes/ui/` and script under `src/ui/`.
2. Provide open/reveal function that populates entries dynamically.
3. Add keyboard/controller focus setup (`grab_focus()`).
4. Emit `closed` or equivalent signal for caller cleanup.
5. Keep player state lock/unlock logic in the caller (object/player script).

## Contributor Rules

1. Keep scene/script separation strict (`scenes/` vs `src/`).
2. Prefer data-driven additions (Enum/Data/Resources) over one-off hardcoded constants.
3. Reuse existing UI and interaction patterns before creating new frameworks.
4. Always restore player state after modal interactions.
5. Validate that new item keys, icons, and resource paths all exist to avoid runtime dictionary/path errors.
6. Fix warnings and runtime errors introduced by your change before merging.
