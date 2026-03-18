# Shiny IV Boost Mod for Pokemon Reborn v19.5.0
# Drop this file into: <Reborn game folder>/patch/Mods/shiny_iv_boost.rb
#
# When a Pokemon is generated as shiny, this mod:
#   1. Rolls each IV twice and keeps the higher value (advantage roll)
#   2. Rerolls any IV that lands at or below a minimum floor
#
# Respects game switches (Full_IVs, Empty_IVs_Password) — those override everything.
# Does not affect non-shiny Pokemon at all.
#
# Configuration: edit shiny_iv_boost_config.rb (placed alongside this file).
# If the config file is missing, the defaults below are used.

# Set defaults first, then let the config file override them.
# The config file defines the same module with the same constants,
# and since Reborn loads Mods/ files alphabetically, the config file
# (shiny_iv_boost_config.rb) loads before this file (shiny_iv_boost.rb).
module ShinyIVBoost
  ENABLED          = true  unless defined?(ENABLED)
  ADVANTAGE_ROLLS  = true  unless defined?(ADVANTAGE_ROLLS)
  MIN_IV_FLOOR     = 5     unless defined?(MIN_IV_FLOOR)
  DEBUG_LOGGING    = false unless defined?(DEBUG_LOGGING)

  LOG_FILE = "shiny_iv_boost.log"

  def self.log(message)
    return unless DEBUG_LOGGING
    File.open(LOG_FILE, "a") { |f| f.puts("[#{Time.now}] #{message}") }
  end

  def self.apply(pokemon)
    return unless ENABLED
    return unless pokemon.isShiny?
    # Let game switches take full priority
    return if $game_switches && ($game_switches[:Full_IVs] || $game_switches[:Empty_IVs_Password])

    original_ivs = pokemon.iv.dup

    for i in 0..5
      # Advantage roll: roll again, keep the higher value
      if ADVANTAGE_ROLLS
        pokemon.iv[i] = [pokemon.iv[i], rand(32)].max
      end

      # Minimum floor: reroll until above the floor
      while pokemon.iv[i] <= MIN_IV_FLOOR
        pokemon.iv[i] = rand(32)
      end
    end

    log("#{pokemon.species} — before: #{original_ivs.inspect} → after: #{pokemon.iv.inspect}")
  end
end

class PokeBattle_Pokemon
  alias_method :_shiny_iv_boost_original_calcStats, :calcStats

  def calcStats
    # Apply the shiny IV boost once, on first stat calculation (during initialize).
    unless @shiny_iv_boost_applied
      @shiny_iv_boost_applied = true
      ShinyIVBoost.apply(self)
    end
    _shiny_iv_boost_original_calcStats
  end
end
