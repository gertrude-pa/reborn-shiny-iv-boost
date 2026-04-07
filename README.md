# Shiny IV Boost — Pokemon Reborn & Rejuvenation Mod

A simple mod for **Pokemon Reborn** and **Pokemon Rejuvenation** that gives shiny Pokemon better IVs.

## What it does

When a shiny Pokemon is generated (wild encounter, gift, egg, legendary), this mod:

1. **Advantage roll** — Rolls each IV a second time and keeps the higher value
2. **Minimum floor** — Rerolls any IV that lands at 5 or below

Non-shiny Pokemon are completely unaffected. Game switches like `Full_IVs` and `Empty_IVs_Password` still take priority.

## Install — Pokemon Reborn (v19.5.0)

Reborn has built-in mod support via its `patch/Mods/` system. Just drop in the files:

1. Navigate to your Pokemon Reborn game folder
2. Create the directory `patch/Mods/` if it doesn't already exist
3. Copy **both** files from `src/` into `patch/Mods/`:
   - `shiny_iv_boost.rb` — the mod itself
   - `shiny_iv_boost_config.rb` — your settings
4. Launch the game

## Install — Pokemon Rejuvenation (v13.5.0)

Rejuvenation uses its own script loader instead of Reborn's `patch/Mods/` system, so the install is slightly different:

1. Navigate to your Pokemon Rejuvenation game folder
2. Copy **both** files from `src/` into the `Scripts/` directory:
   - `shiny_iv_boost.rb`
   - `shiny_iv_boost_config.rb`
3. Open `Scripts/Rejuv/Bootstrap.rb` in a text editor
4. Find the `'Main',` line near the bottom of the `SCRIPTS` list and add the mod entries just above it:
   ```ruby
   # Shiny IV Boost mod - must load after Pokemon.rb
   'shiny_iv_boost_config',
   'shiny_iv_boost',

   'Main',
   ```
5. Launch the game

## Uninstall

**Reborn:** Delete `shiny_iv_boost.rb` and `shiny_iv_boost_config.rb` from `patch/Mods/`.

**Rejuvenation:** Delete both files from `Scripts/` and remove the two `shiny_iv_boost` lines you added to `Scripts/Rejuv/Bootstrap.rb`.

## Configuration

Edit `shiny_iv_boost_config.rb` — the mod file itself never needs to be touched.

| Setting | Default | Description |
|---------|---------|-------------|
| `ENABLED` | `true` | Master toggle for the entire mod |
| `ADVANTAGE_ROLLS` | `true` | Roll each IV twice, keep the higher |
| `MIN_IV_FLOOR` | `5` | Reroll any IV at or below this value (set to `0` to disable) |
| `DEBUG_LOGGING` | `false` | Log shiny IV results to `shiny_iv_boost.log` |

When `DEBUG_LOGGING` is enabled, each shiny generation writes a line to `shiny_iv_boost.log` in your game folder showing the before/after IVs:

```
[2026-03-15 14:02:31] SLAKOTH — before: [4, 12, 28, 3, 17, 9] → after: [22, 18, 28, 14, 24, 15]
```

If the config file is missing, the mod still works using built-in defaults (same values as above).

## How it works

The mod aliases `calcStats` on `PokeBattle_Pokemon` to inject the IV boost on first stat calculation — right after the base game assigns IVs but before stats are finalized. No base game files are modified (Reborn). For Rejuvenation, the only change is two lines added to `Bootstrap.rb` to register the scripts.

## Compatibility

- **Pokemon Reborn v19.5.0** — works out of the box via `patch/Mods/`
- **Pokemon Rejuvenation v13.5.0** — works by adding to the script loader
- Does not break existing save files
- Minimal conflict risk with other mods (only touches IV generation via `calcStats` alias)
