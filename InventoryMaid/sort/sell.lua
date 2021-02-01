sell = {}

function sell.sell(InventoryMaid)
    local ts = Game.GetTransactionSystem()
    baseSort = require (InventoryMaid.rootPath.. ".sort.baseSort")
    baseSort.generateSellList(InventoryMaid)

    Game.AddToInventory("Items.money", sell.calculateMoney())
    for _, v in ipairs(baseSort.finalSellList) do
        ts:RemoveItem(Game.GetPlayer(), v:GetID(), 1)
    end  

    removeJunk = require (InventoryMaid.rootPath.. ".sort.removeJunk")
    removeJunk.sellJunk(InventoryMaid)  
end 

function sell.disassemble(InventoryMaid)
    baseSort = require (InventoryMaid.rootPath.. ".sort.baseSort")
    baseSort.generateSellList(InventoryMaid)

    for _, v in ipairs(baseSort.finalSellList) do
        local craftingSystem = Game.GetScriptableSystemsContainer():Get(CName.new('CraftingSystem'))
        craftingSystem:DisassembleItem(Game.GetPlayer(), v:GetID(), 1)
    end  

    removeJunk = require (InventoryMaid.rootPath.. ".sort.removeJunk")
    removeJunk.sellJunk(InventoryMaid) 
end

function sell.calculateMoney()
    sellPrice = 0
    local ssc = Game.GetScriptableSystemsContainer()
    local espd = ssc:Get("EquipmentSystem"):GetPlayerData(Game.GetPlayer())
    local imgr = espd:GetInventoryManager()
    for _, v in ipairs(baseSort.finalSellList) do
        sellPrice = sellPrice + imgr:GetSellPrice(Game.GetPlayer(), v:GetID())
    end
    return sellPrice
end

function sell.preview(InventoryMaid)
    baseSort = require (InventoryMaid.rootPath.. ".sort.baseSort")
    tableFunctions = require (InventoryMaid.rootPath.. ".utility.tableFunctions")
    baseSort.generateSellList(InventoryMaid)
    nItems = baseSort.nItems
    nItemsAfter = nItems - tableFunctions.getLength(baseSort.finalSellList)
    money = sell.calculateMoney()
    return string.format("Items currently: %d, After: %d, \nMoney gained: %d",nItems, nItemsAfter, money)
end

return sell