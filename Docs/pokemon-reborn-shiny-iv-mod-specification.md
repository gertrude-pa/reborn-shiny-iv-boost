# Pokemon Reborn Shiny IV Boost Mod - Complete Implementation Specification

**Target Platform:** Windows with RPG Maker XP  
**Pokemon Reborn Version:** v19.5.41 (Pokemon Essentials v19)  
**Developer:** Claude Code Opus 4.6  
**Mod Type:** Standalone with configuration file

## 🎯 IMPLEMENTATION REQUIREMENTS

### Core Functionality
**When a Pokemon is generated as shiny, apply enhanced IV generation:**

1. **Advantage Roll System:** Roll each IV twice, take the higher value
2. **Minimum IV Floor:** Any IV that results in 5 or less gets rerolled until 6+
3. **Universal Application:** Apply to ALL shiny Pokemon types:
   - Wild encounters  
   - Gift Pokemon (starters, events, etc.)
   - Egg hatches
   - Legendary encounters

### Technical Implementation
```ruby
# Pseudocode for shiny IV enhancement
if pokemon.isShiny?
  for i in 0..5  # For each IV (HP, ATK, DEF, SPE, SPATK, SPDEF)
    # Advantage roll: roll twice, take higher
    roll1 = rand(32)
    roll2 = rand(32)
    @iv[i] = [roll1, roll2].max
    
    # Minimum floor: reroll if 5 or less
    while @iv[i] <= 5
      @iv[i] = rand(32)
    end
  end
end
```

## 📁 PROJECT STRUCTURE TO CREATE

```
pokemon-reborn-shiny-mod/
├── src/
│   ├── modified_scripts/     # Modified .rb files
│   └── config/
│       └── shiny_config.rb   # Configuration file
├── backup/
│   └── original_scripts/     # Backup of original files
├── installation/
│   ├── install_guide.md
│   └── script_locations.md
├── testing/
│   ├── test_cases.md
│   └── validation_checklist.md
└── README.md
```

## 🔧 CONFIGURATION FILE SPECIFICATION

### `src/config/shiny_config.rb`
```ruby
# Pokemon Reborn Shiny IV Boost Configuration
module ShinyIVConfig
  # Enable/disable the entire mod
  ENABLED = true
  
  # Advantage roll system (roll twice, take higher)
  ADVANTAGE_ROLL_ENABLED = true
  
  # Minimum IV floor for shinies (any IV <= this value gets rerolled)
  MINIMUM_IV_FLOOR = 5
  
  # Which Pokemon types get the boost
  BOOST_WILD_ENCOUNTERS = true
  BOOST_GIFT_POKEMON = true  
  BOOST_EGG_HATCHES = true
  BOOST_LEGENDARY_ENCOUNTERS = true
  
  # Debug logging (set to true for testing, false for release)
  DEBUG_LOGGING = false
  
  # Debug messages
  def self.log_debug(message)
    if DEBUG_LOGGING
      puts "[SHINY IV MOD] #{message}"
    end
  end
  
  def self.log_shiny_generation(pokemon)
    if DEBUG_LOGGING
      puts "[SHINY IV MOD] Shiny #{pokemon.name} generated with IVs: #{pokemon.iv}"
    end
  end
end
```

## 📋 FILES TO LOCATE AND MODIFY

### Primary Target: Pokemon Generation
**File:** `PokeBattle_Pokemon.rb` or `Pokemon.rb`  
**Location:** In extracted Scripts.rxdata  
**Method:** `initialize` method where IVs are assigned

**Search Pattern:** Look for IV assignment loop:
```ruby
@iv = []
for i in 0..5
  @iv.push(rand(32))
end
```

### Implementation Strategy
**Insert AFTER the standard IV loop, BEFORE any other stat calculations:**

```ruby
# Original IV generation code (leave unchanged)
@iv = []
for i in 0..5
  @iv.push(rand(32))
end

# === INSERT SHINY IV BOOST HERE ===
# Load configuration
require_relative 'config/shiny_config'

# Apply shiny IV boost if enabled and Pokemon is shiny
if ShinyIVConfig::ENABLED && self.isShiny?
  ShinyIVConfig.log_debug("Applying shiny IV boost to #{@species}")
  
  # Apply advantage roll if enabled
  if ShinyIVConfig::ADVANTAGE_ROLL_ENABLED
    for i in 0..5
      roll1 = @iv[i]  # Keep original roll
      roll2 = rand(32)
      @iv[i] = [roll1, roll2].max
    end
  end
  
  # Apply minimum IV floor
  for i in 0..5
    while @iv[i] <= ShinyIVConfig::MINIMUM_IV_FLOOR
      @iv[i] = rand(32)
    end
  end
  
  ShinyIVConfig.log_shiny_generation(self)
end
# === END SHINY IV BOOST ===
```

## 🧪 TESTING FRAMEWORK

### Test Cases Required

#### 1. Shiny Generation Validation
- **Test:** Generate 10 shiny Pokemon, verify all have IVs > 5
- **Test:** Verify advantage roll working (IVs should trend higher than normal)
- **Expected:** All shiny Pokemon should have enhanced IVs

#### 2. Normal Pokemon Unaffected  
- **Test:** Generate 10 normal Pokemon, verify standard IV distribution
- **Expected:** No change to non-shiny Pokemon generation

#### 3. All Pokemon Types Coverage
- **Test:** Shiny wild encounter, gift Pokemon, egg hatch, legendary
- **Expected:** All shiny types get IV boost regardless of source

#### 4. Configuration System
- **Test:** Toggle ENABLED = false, verify no boost applied
- **Test:** Adjust MINIMUM_IV_FLOOR, verify new floor respected
- **Expected:** Configuration changes take effect

### Testing Tools Needed
1. **Debug Mode:** Enable debug logging for IV tracking
2. **Save Editor:** For controlled shiny generation testing  
3. **IV Calculator:** To verify boost is working correctly

### Validation Checklist
- [ ] Shiny Pokemon have enhanced IVs (advantage roll + floor)
- [ ] Normal Pokemon unchanged
- [ ] All encounter types covered (wild, gift, egg, legendary)
- [ ] Configuration system functional
- [ ] No crashes or performance issues
- [ ] Debug logging works when enabled

## 📝 INSTALLATION GUIDE OUTLINE

### For End Users
1. **Backup** original Scripts.rxdata
2. **Extract** Scripts.rxdata to editable format
3. **Locate** PokeBattle_Pokemon.rb (or equivalent)
4. **Insert** shiny IV boost code at specified location
5. **Add** shiny_config.rb to project
6. **Test** with known shiny Pokemon
7. **Configure** settings in shiny_config.rb as desired

### For Distribution
- Pre-modified script files
- Configuration file with comments
- Installation instructions
- Uninstall instructions (restore backup)

## 🎮 POKEMON ESSENTIALS V19 CONSIDERATIONS

### Version-Specific Notes
- **Essentials v19** may have different file organization than v17/v18
- **Shiny detection** should still use `isShiny?` method
- **IV structure** should still be `@iv[0..5]` array
- **Configuration loading** may need adjustment for v19 structure

### Compatibility
- **Save Files:** Should not break existing saves
- **Online Play:** If applicable, may create imbalance (document this)
- **Other Mods:** Minimal conflict risk (only touches IV generation)

## 🚀 DELIVERABLES FOR WINDOWS IMPLEMENTATION

### Phase 1: Setup & Analysis
- [ ] Install RPG Maker XP
- [ ] Extract Pokemon Reborn v19.5.41 scripts
- [ ] Locate exact Pokemon generation files
- [ ] Identify precise insertion points for IV boost

### Phase 2: Implementation  
- [ ] Create configuration file system
- [ ] Implement shiny IV boost logic
- [ ] Add debug logging capabilities
- [ ] Test basic functionality

### Phase 3: Comprehensive Testing
- [ ] Validate all Pokemon types get boost
- [ ] Verify configuration system works
- [ ] Performance testing (no slowdowns)
- [ ] Edge case testing

### Phase 4: Documentation & Packaging
- [ ] Create installation guide
- [ ] Package for easy distribution
- [ ] Basic troubleshooting guide
- [ ] Configuration documentation

## 💡 TECHNICAL NOTES FOR IMPLEMENTER

### Critical Success Factors
1. **Find the exact IV assignment location** in Reborn v19.5.41
2. **Ensure shiny check happens AFTER** personalID/trainerID are set
3. **Test configuration loading** works properly in Essentials v19
4. **Verify no performance impact** on Pokemon generation

### Potential Gotchas
- Reborn may have custom Pokemon generation methods
- Config file loading path may need adjustment
- Some gift Pokemon might bypass normal generation
- Egg IV inheritance might need separate handling

### Success Metrics
- All shiny Pokemon have IVs > 5 (minimum floor working)
- Shiny IVs trend significantly higher than normal (advantage roll working)  
- Configuration changes take effect without game restart
- No crashes or performance degradation

---

## 🎯 FINAL NOTES

This specification provides everything needed for Windows implementation with Claude Code Opus 4.6. The approach is:

1. **Technically sound** - builds on solid Pokemon Essentials knowledge
2. **Configurable** - meets your preference for config file flexibility
3. **Comprehensive** - covers all Pokemon types as requested  
4. **Testable** - includes validation framework
5. **Distributable** - ready for community release

**Ready for Windows Claude Code handoff!** 🚀