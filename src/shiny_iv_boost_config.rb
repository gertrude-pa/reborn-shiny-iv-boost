# Shiny IV Boost — Configuration
# Copy this file into: <Reborn game folder>/patch/Mods/shiny_iv_boost_config.rb
#
# Edit the values below to customize the mod. The mod file itself never needs
# to be touched. If this config file is missing, the mod uses built-in defaults.

module ShinyIVBoost
  # Master toggle — set to false to disable the mod without removing files
  ENABLED = true

  # Roll each IV a second time and keep the higher of the two rolls
  ADVANTAGE_ROLLS = true

  # Any IV at or below this value gets rerolled until it exceeds it (0-30)
  # Default 5 means every shiny IV will be at least 6
  # Set to 0 to disable the floor (advantage rolls still apply)
  MIN_IV_FLOOR = 5

  # Print shiny IV results to the console for verification
  # To see output: press F1 in-game > check "Show Console"
  DEBUG_LOGGING = false
end
