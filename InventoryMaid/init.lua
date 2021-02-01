InventoryMaid = {}

function InventoryMaid:new()
registerForEvent("onInit", function()
    function InventoryMaid.fileExists(filename)
        local f=io.open(filename,"r")
        if (f~=nil) then io.close(f) return true else return false end
    end

    function getCWD(mod_name) -- Made by Ming
        if InventoryMaid.fileExists("bin/x64/plugins/cyber_engine_tweaks/mods/"..mod_name.."/init.lua") then
            InventoryMaid.rootPathIO = "./bin/x64/plugins/cyber_engine_tweaks/mods/InventoryMaid/"
            return "bin/x64/plugins/cyber_engine_tweaks/mods/"..mod_name.."/"
        elseif InventoryMaid.fileExists("x64/plugins/cyber_engine_tweaks/mods/"..mod_name.."/init.lua") then
            return "x64/plugins/cyber_engine_tweaks/mods/"..mod_name.."/"
        elseif InventoryMaid.fileExists("plugins/cyber_engine_tweaks/mods/"..mod_name.."/init.lua") then
            InventoryMaid.rootPathIO = "./plugins/cyber_engine_tweaks/mods/InventoryMaid/"
            return "plugins/cyber_engine_tweaks/mods/"..mod_name.."/"
        elseif InventoryMaid.fileExists("cyber_engine_tweaks/mods/"..mod_name.."/init.lua") then
            return "cyber_engine_tweaks/mods/"..mod_name.."/"
        elseif InventoryMaid.fileExists("mods/"..mod_name.."/init.lua") then
            return "mods/"..mod_name.."/"
        elseif  InventoryMaid.fileExists(mod_name.."/init.lua") then
            InventoryMaid.rootPathIO = "./InventoryMaid/"
            return mod_name.."/"
        elseif  InventoryMaid.fileExists("init.lua") then
            return ""
        end
    end

    function InventoryMaid.resetSettings()
        InventoryMaid.settings = tableFunctions.deepcopy(InventoryMaid.originalSettings)
    end

    InventoryMaid.rootPath = getCWD("InventoryMaid")

    for k, _ in pairs(package.loaded) do
        if string.match(k, InventoryMaid.rootPath .. ".*") then
            package.loaded[k] = nil
        end
    end

 	InventoryMaid.CPS = require (InventoryMaid.rootPath.."CPStyling")
 	InventoryMaid.theme = InventoryMaid.CPS
    InventoryMaid.color = InventoryMaid.CPS

    InventoryMaid.baseUI = require (InventoryMaid.rootPath..".ui.baseUI")
    tableFunctions = require (InventoryMaid.rootPath.. ".utility.tableFunctions")
    
    drawWindow = false

    InventoryMaid.originalSettings = {globalSettings = {sellFilter = 0, filterValueTopX = 3, filterValuePercent = 20, sellQualitys = {common = true, uncommon = true, rare = false, epic = false, legendary = false, iconic = false}},
                                      weaponSettings = {sellWeapons = true, sellPerType = false, sellFilter = 0, filterValueTopX = 3, filterValuePercent = 20, sellQualitys = {common = true, uncommon = true, rare = false, epic = false, legendary = false, iconic = false}, forceSubOptionsUpdate = false,
                                                        typeOptions = {[1] = {displayName = "Assault rifle", typeName = "Wea_Rifle", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                       [2] = {displayName = "SMG", typeName = "Wea_SubmachineGun", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                       [3] = {displayName = "LMG", typeName = "Wea_LightMachineGun", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                       [4] = {displayName = "Shotgun", typeName = "Wea_Shotgun", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                       [5] = {displayName = "Double barrel shotgun", typeName = "Wea_ShotgunDual", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                       [6] = {displayName = "Pistol / Handgun", typeName = "Wea_Handgun", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                       [7] = {displayName = "Revolver", typeName = "Wea_Revolver", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                       [8] = {displayName = "Precision rifle", typeName = "Wea_PrecisionRifle", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                       [9] = {displayName = "Sniper rifle", typeName = "Wea_SniperRifle", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                       [10] = {displayName = "Katana", typeName = "Wea_Katana", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                       [11] = {displayName = "Knife", typeName = "Wea_Knife", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                       [12] = {displayName = "Long blade", typeName = "Wea_LongBlade", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                       [13] = {displayName = "Hammer", typeName = "Wea_Hammer", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                       [14] = {displayName = "One handed club", typeName = "Wea_OneHandedClub", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                       [15] = {displayName = "Two handed club", typeName = "Wea_TwoHandedClub", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3}}},
                                      armorSettings = {sellArmor = true, sellPerType = true, sellFilter = 0,  filterValueTopX = 3, filterValuePercent = 20, sellQualitys = {common = true, uncommon = true, rare = false, epic = false, legendary = false, iconic = false}, forceSubOptionsUpdate = false,
                                                        typeOptions = { [1] = {displayName = "Head", typeName = "Clo_Head", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                        [2] = {displayName = "Face", typeName = "Clo_Face", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                        [3] = {displayName = "Outer torso", typeName = "Clo_OuterChest", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                        [4] = {displayName = "Inner torso", typeName = "Clo_InnerChest", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                        [5] = {displayName = "Legs", typeName = "Clo_Legs", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3},
                                                                        [6] = {displayName = "Feet", typeName = "Clo_Feet", sellType = true, sellAll = false, filterValuePercent = 20, filterValueTopX = 3}}},
                                      fileSettings = {currentName = "Default", tableNames = {[1] = "Default", [2] = "Default", [3] = "Default", [4] = "Default", [5] = "Default"}},
                                      junkSettings = {[1] = {typeName = "Junk", percent = 100, sellType = true}, [2] = {typeName = "Alcohol", percent = 100, sellType = true}, [3] = {typeName = "Jewellery", percent = 100, sellType = true}}}

    InventoryMaid.resetSettings()

end)

registerForEvent("onDraw", function()
    if drawWindow then
        baseUI.Draw(InventoryMaid)
    end 
end)

registerHotkey("InventoryMaidWindowToggle", "Toggle Window", function()
    drawWindow = not drawWindow
end)

registerForEvent("onOverlayOpen", function()
    drawWindow = true
end)

registerForEvent("onOverlayClose", function()
    drawWindow = false
end)

end

return InventoryMaid:new()