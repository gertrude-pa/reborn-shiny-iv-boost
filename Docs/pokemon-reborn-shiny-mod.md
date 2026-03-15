# Pokemon Reborn Shiny IV Boost Mod

**Date Started:** 2026-03-15
**Target:** Pokemon Reborn v19.5.0 (Ruby 3.1, MKXP engine)
**Goal:** Give shiny Pokemon better IVs via advantage rolls and a minimum floor

## How This Mod Works

Reborn v19.5.0 has a built-in mod system described in `Modding.txt`. The key points:

- Mods go in `patch/Mods/` as `.rb` files
- Only the specific functions/methods you define override the base game — not entire files
- No need to touch base game files at all
- File name inside `patch/Mods/` doesn't matter, only the method signatures

This means our mod is a **single `.rb` file** dropped into `patch/Mods/`. No script extraction, no binary editing, no RPG Maker XP needed.

## What We're Modifying

### Target: `Pokemon.rb` — the `initialize` method

The IV generation happens at line 106 of the base `Pokemon.rb`:

```ruby
@iv = [rand(32), rand(32), rand(32), rand(32), rand(32), rand(32)]
```

Shiny status is determined earlier via `rollPersonalID` (line 150-162), which sets `@personalID` before `initialize` calls `calcStats`. So by the time IVs are assigned, we can already check `self.isShiny?`.

### Existing IV logic we must preserve

- Undiscovered egg group / Manaphy get 3 guaranteed 31 IVs (line 107-111)
- `$game_switches[:Full_IVs]` forces all 31s (line 114)
- `$game_switches[:Empty_IVs_Password]` forces all 0s (line 115)
- `$game_switches[:Forced3IVs]` also forces 3 perfect IVs

Our boost should apply **after** the base IV roll but **before** the Full_IVs/Empty_IVs overrides (so those game switches still take priority).

## Implementation Plan

### The Mod File: `patch/Mods/shiny_iv_boost.rb`

The mod overrides the relevant section by redefining the method that handles IV generation for shiny Pokemon. Since Reborn's mod system only overrides specific methods, we need to be surgical.

**Approach:** Add a new method `applyShinyIVBoost` to the Pokemon class, and override `initialize` to call it at the right point. However, since overriding `initialize` means redefining the entire method, a safer approach is:

**Preferred approach:** Define a post-initialization hook or override `calcStats` to intercept, OR simply override `initialize` with the full method body plus our addition. Given that Reborn's mod system replaces individual methods entirely, we should override `initialize` with a copy that includes our boost logic.

**Simplest safe approach:** Add a standalone method and patch it in after IV assignment. We can override `calcStats` to inject the boost before stat calculation, since `calcStats` is called right after IV assignment (line 118).

```ruby
# Shiny IV Boost Mod for Pokemon Reborn v19.5.0
# Drop this file into: patch/Mods/shiny_iv_boost.rb

module ShinyIVBoost
  ENABLED = true
  ADVANTAGE_ROLLS = true    # Roll each IV twice, keep higher
  MIN_IV_FLOOR = 6          # Reroll any IV at or below this value
  DEBUG_LOGGING = false

  def self.apply(pokemon)
    return unless ENABLED
    return unless pokemon.isShiny?
    return if $game_switches[:Full_IVs] || $game_switches[:Empty_IVs_Password]

    for i in 0..5
      # Advantage roll: roll again, keep higher
      if ADVANTAGE_ROLLS
        pokemon.iv[i] = [pokemon.iv[i], rand(32)].max
      end

      # Minimum floor: reroll until above floor
      while pokemon.iv[i] <= MIN_IV_FLOOR
        pokemon.iv[i] = rand(32)
      end
    end

    if DEBUG_LOGGING
      puts "[SHINY IV BOOST] #{pokemon.name} IVs: #{pokemon.iv.inspect}"
    end
  end
end
```

### Hook Point

We need to call `ShinyIVBoost.apply(self)` after line 115 (after IV overrides) but before `calcStats` on line 118. The cleanest way with Reborn's mod system is to wrap `calcStats`:

```ruby
class PokeBattle_Pokemon
  alias_method :original_calcStats, :calcStats

  def calcStats
    # Apply shiny IV boost before calculating stats
    # Only runs on first calc (when @totalhp == 1, meaning just initialized)
    if @totalhp == 1
      ShinyIVBoost.apply(self)
    end
    original_calcStats
  end
end
```

**Note:** Need to verify the actual class name. The file is `Pokemon.rb` but the class may be `PokeBattle_Pokemon` or `Pokemon` — we'll confirm from the source.

## Installation Steps (for end users)

1. Navigate to your Pokemon Reborn game folder
2. Create `patch/Mods/` directory if it doesn't exist
3. Copy `shiny_iv_boost.rb` into `patch/Mods/`
4. Launch the game — that's it

To uninstall: delete `shiny_iv_boost.rb` from `patch/Mods/`.

## Testing Plan

1. Enable `DEBUG_LOGGING = true` in the mod
2. Use debug menu or encounter shinies
3. Check console output for IV values
4. Verify all shiny IVs are above the floor (6+)
5. Verify non-shiny Pokemon are unaffected
6. Verify Full_IVs and Empty_IVs switches still work

## About Pokemon Essentials v21.1

The user has Pokemon Essentials v21.1 installed at `C:\SRC\Pokemon Essentials v21.1 2023-07-30`. This is the **generic framework**, not what Reborn uses. Reborn v19.5.0 ships its own modified/forked scripts and does NOT use vanilla Essentials directly. The Essentials install could be useful as reference material for understanding the framework's conventions, but our mod targets Reborn's actual script files in `C:\SRC\Reborn-19.5.0-windows\Scripts\`.

## Project Files

```
reborn-shiny-iv-boost/
├── Docs/
│   ├── pokemon-reborn-shiny-mod.md          (this file - project overview)
│   └── pokemon-reborn-shiny-iv-mod-specification.md  (original spec, outdated)
├── src/
│   └── shiny_iv_boost.rb                    (the mod file to install)
└── README.md                                (GitHub readme for the repo)
```
