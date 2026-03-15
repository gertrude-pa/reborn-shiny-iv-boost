# Shiny IV Boost — Pokemon Reborn Mod

A simple mod for **Pokemon Reborn v19.5.0** that gives shiny Pokemon better IVs.

## What it does

When a shiny Pokemon is generated (wild encounter, gift, egg, legendary), this mod:

1. **Advantage roll** — Rolls each IV a second time and keeps the higher value
2. **Minimum floor** — Rerolls any IV that lands at 5 or below

Non-shiny Pokemon are completely unaffected. Game switches like `Full_IVs` and `Empty_IVs_Password` still take priority.

## Install

1. Navigate to your Pokemon Reborn game folder
2. Create the directory `patch/Mods/` if it doesn't already exist
3. Copy **both** files from `src/` into `patch/Mods/`:
   - `shiny_iv_boost.rb` — the mod itself
   - `shiny_iv_boost_config.rb` — your settings
4. Launch the game — that's it

## Uninstall

Delete both `shiny_iv_boost.rb` and `shiny_iv_boost_config.rb` from `patch/Mods/`.

## Configuration

Edit `shiny_iv_boost_config.rb` in `patch/Mods/` — the mod file itself never needs to be touched.

| Setting | Default | Description |
|---------|---------|-------------|
| `ENABLED` | `true` | Master toggle for the entire mod |
| `ADVANTAGE_ROLLS` | `true` | Roll each IV twice, keep the higher |
| `MIN_IV_FLOOR` | `5` | Reroll any IV at or below this value (set to `0` to disable) |
| `DEBUG_LOGGING` | `false` | Print shiny IV results to the console |

To see debug output in-game, press **F1** and check **Show Console**.

If the config file is missing, the mod still works using built-in defaults (same values as above).

## How it works

The mod uses Reborn's built-in mod system (`patch/Mods/`). It aliases `calcStats` on `PokeBattle_Pokemon` to inject the IV boost on first stat calculation — right after the base game assigns IVs but before stats are finalized. No base game files are modified.

## Compatibility

- **Pokemon Reborn v19.5.0** (MKXP engine, Ruby 3.1)
- Does not break existing save files
- Minimal conflict risk with other mods (only touches IV generation via `calcStats` alias)
