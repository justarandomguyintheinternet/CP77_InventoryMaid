InventoryMaid = {}

function InventoryMaid:new()
registerForEvent("onInit", function()
    
    function InventoryMaid.fileExists(filename)
        local f=io.open(filename,"r")
        if (f~=nil) then io.close(f) return true else return false end
    end

    function InventoryMaid.resetSettings()
        InventoryMaid.settings = tableFunctions.deepcopy(InventoryMaid.originalSettings)
    end

    function InventoryMaid.loadStandardFile()
        
        local file = io.open("saves/startup.json", "r")
        local slot = json.decode(file:read("*a"))   
        file:close()   
        InventoryMaid.standardSlot = slot
        
        if slot ~= 0 then
            local file = io.open("saves/slot"..slot..".json", "r")
            local config = json.decode(file:read("*a"))
            file:close()
            InventoryMaid.settings = config
        end
    end

 	InventoryMaid.CPS = GetMod("CPStyling"):New()
 	InventoryMaid.theme = InventoryMaid.CPS
    InventoryMaid.color = InventoryMaid.CPS

    InventoryMaid.baseUI = require ("ui/baseUI.lua")
    tableFunctions = require ("utility/tableFunctions.lua")
    
    drawWindow = false
    drawWindowOneFrameSell = false
    drawWindowOneFrameDissasemble = false

    InventoryMaid.standardSlot = 0
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
                                      junkSettings = {[1] = {typeName = "Junk", percent = 100, sellType = true}, [2] = {typeName = "Alcohol", percent = 100, sellType = true}, [3] = {typeName = "Jewellery", percent = 100, sellType = true}},
                                      grenadeSettings = {sellGrenades = false, filterValuePercent = 20, sellQualitys = {common = true, uncommon = true, rare = false, epic = false}, forceSubOptionsUpdate = false,
                                      typeOptions = { [1] = {displayName = "Frag Grenade", typeName = "frag", sellType = false, sellAll = false, filterValuePercent = 20},
                                                      [2] = {displayName = "EMP Grenade", typeName = "emp", sellType = false, sellAll = false, filterValuePercent = 20},
                                                      [3] = {displayName = "Incendiary Grenade", typeName = "incendiary_grenade", sellType = false, sellAll = false, filterValuePercent = 20},
                                                      [4] = {displayName = "Flash Grenade", typeName = "flash", sellType = false, sellAll = false, filterValuePercent = 20},
                                                      [5] = {displayName = "Biohazard Grenade", typeName = "biohazard", sellType = false, sellAll = false, filterValuePercent = 20},
                                                      [6] = {displayName = "Recon Grenade", typeName = "recon", sellType = false, sellAll = false, filterValuePercent = 20},
                                                      [7] = {displayName = "Cutting Grenade", typeName = "cutting", sellType = false, sellAll = false, filterValuePercent = 20}}}
                                }

    
    InventoryMaid.resetSettings()
    InventoryMaid.loadStandardFile()
    
end)

registerForEvent("onDraw", function()
    if drawWindow then
        baseUI.Draw(InventoryMaid)
    elseif drawWindowOneFrameSell then
        baseUI.Draw(InventoryMaid)
        baseUI.generalUI.previewText = "Sold!"
        baseUI.generalUI.sell.sell(InventoryMaid)
        drawWindowOneFrameSell = false
    elseif drawWindowOneFrameDissasemble then
        baseUI.Draw(InventoryMaid)
        baseUI.generalUI.previewText = "Disassembled!"
        baseUI.generalUI.sell.disassemble(InventoryMaid)
        drawWindowOneFrameDissasemble = false
    end
end)

registerForEvent("onOverlayOpen", function()
    drawWindow = true
end)

registerForEvent("onOverlayClose", function()
    drawWindow = false
end)

registerHotkey("inventoryMaidSell", "Sell selected", function()	
	drawWindowOneFrameSell = true
end)

registerHotkey("inventoryMaidDisassemble", "Disassemble selected", function()	
	drawWindowOneFrameDissasemble = true
end)

end

return InventoryMaid:new()