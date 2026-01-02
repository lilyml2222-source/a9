-- CONFIG.LUA - Configuration & Variables
-- File ini akan di-generate otomatis oleh web generator
local Config = {}

-- ============================================
-- CUSTOM USER SETTINGS (AUTO-GENERATED)
-- ============================================
Config.CustomSettings = {
    -- User's GitHub Repository
    GitHubUser = "USERNAME_PLACEHOLDER",
    Branch = "main",
    
    -- User's Mount Name
    MountName = "MOUNTNAME_PLACEHOLDER",
    
    -- UI Customization
    UITitle = "TITLE_PLACEHOLDER",
    UIAuthor = "AUTHOR_PLACEHOLDER"
}

-- ============================================
-- INTERNAL VARIABLES (JANGAN DIUBAH)
-- ============================================
Config.TASDataCache = {}
Config.isCached = false
Config.isPlaying = false
Config.isLooping = false
Config.autoRespawnLoop = false
Config.SavedCP = 0
Config.SavedFrame = 1
Config.END_CP = 1000
Config.CurrentRepoURL = ""
Config.FlipOffset = 0
Config.PlaybackSpeed = 1

return Config
