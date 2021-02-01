weaponUI = {}

weaponUI.colors = {frame = {0, 50, 255}, typeText = {255, 0, 0}}
weaponUI.typeBoxSize = {x = 425, y = 105}

function weaponUI.drawType(InventoryMaid, t)
    if InventoryMaid.settings.weaponSettings.sellPerType then
        weaponUI.typeBoxSize.y = 105
    else
        weaponUI.typeBoxSize.y = 80
    end

    ImGui.BeginChild(t.typeName, weaponUI.typeBoxSize.x, weaponUI.typeBoxSize.y, true)
    InventoryMaid.CPS.colorBegin("Text", weaponUI.colors.frame)
    ImGui.Text(t.displayName)
    ImGui.Separator()
    InventoryMaid.CPS.colorEnd(1)
    t.sellType =  ImGui.Checkbox("Sell items of this type", t.sellType)
    t.sellAll = ImGui.Checkbox("Sell all items of this type", t.sellAll)
    ImGui.SameLine()
    ImGui.Button("?")
    tooltips.draw(InventoryMaid, ImGui.IsItemHovered(), "sellAll")

    if InventoryMaid.settings.weaponSettings.sellPerType then
        if InventoryMaid.settings.weaponSettings.sellFilter == 0 then       
            t.filterValueTopX = ImGui.SliderInt("Filter value (x)", t.filterValueTopX, 0, 25, "%d")
        else      
            t.filterValuePercent = ImGui.SliderInt("Filter value (x)", t.filterValuePercent, 0, 100, "%d%%")
        end
    end

    ImGui.EndChild()    
end

function weaponUI.updateSubOptions(InventoryMaid, update, key)
    if update then
        if key == "toggleAll" then
            for _, k in pairs(InventoryMaid.settings.weaponSettings.typeOptions) do   
                k.sellType = InventoryMaid.settings.weaponSettings.sellWeapons
            end
        elseif key == "filterValue" then
            for _, k in pairs(InventoryMaid.settings.weaponSettings.typeOptions) do   
                k.filterValueTopX = InventoryMaid.settings.weaponSettings.filterValueTopX
                k.filterValuePercent = InventoryMaid.settings.weaponSettings.filterValuePercent
            end
        end
    end
end

function weaponUI.draw(InventoryMaid)

    tooltips = require (InventoryMaid.rootPath.. ".utility.tooltips")

    if InventoryMaid.settings.weaponSettings.forceSubOptionsUpdate then
        InventoryMaid.settings.weaponSettings.forceSubOptionsUpdate = false
        weaponUI.updateSubOptions(InventoryMaid, true, "filterValue")
    end

-- Sell weapons toggle
    InventoryMaid.settings.weaponSettings.sellWeapons, changed = ImGui.Checkbox("Sell weapons", InventoryMaid.settings.weaponSettings.sellWeapons)
    weaponUI.updateSubOptions(InventoryMaid, changed, "toggleAll")
    ImGui.SameLine()
	ImGui.Button("?")
    tooltips.draw(InventoryMaid, ImGui.IsItemHovered(), "toggleSellAll")
-- End Sell weapons toggle

-- Sell filter selection 
    InventoryMaid.settings.weaponSettings.sellFilter = ImGui.Combo("Sell filter", InventoryMaid.settings.weaponSettings.sellFilter, { "Sell to have only top x left", "Sell worst x %", "Sell x % worse than avg equipped"}, 3, 3)
    ImGui.SameLine()
	ImGui.Button("?")
    tooltips.draw(InventoryMaid, ImGui.IsItemHovered(), "sellFilter")
-- End Sell filter selection 

-- Sell filter value selection           
    if InventoryMaid.settings.weaponSettings.sellFilter == 0 then
        InventoryMaid.settings.weaponSettings.filterValueTopX, changed = ImGui.SliderInt("Filter value (x)", InventoryMaid.settings.weaponSettings.filterValueTopX, 0, 25, "%d")
    else
        InventoryMaid.settings.weaponSettings.filterValuePercent, changed = ImGui.SliderInt("Filter value (x)", InventoryMaid.settings.weaponSettings.filterValuePercent, 0, 100, "%d%%")
    end
    weaponUI.updateSubOptions(InventoryMaid, changed, "filterValue")
-- End Sell filter value selection

-- Sell qualitys selection
    if ImGui.ListBoxHeader("Sell qualitys", 6) then
		ImGui.SetWindowFontScale(1.0)
        InventoryMaid.settings.weaponSettings.sellQualitys.common = ImGui.Selectable("Sell common", InventoryMaid.settings.weaponSettings.sellQualitys.common)
		InventoryMaid.settings.weaponSettings.sellQualitys.uncommon = ImGui.Selectable("Sell uncommon", InventoryMaid.settings.weaponSettings.sellQualitys.uncommon)
		InventoryMaid.settings.weaponSettings.sellQualitys.rare = ImGui.Selectable("Sell rare", InventoryMaid.settings.weaponSettings.sellQualitys.rare)
		InventoryMaid.settings.weaponSettings.sellQualitys.epic = ImGui.Selectable("Sell epic", InventoryMaid.settings.weaponSettings.sellQualitys.epic)
        InventoryMaid.settings.weaponSettings.sellQualitys.legendary = ImGui.Selectable("Sell legendary", InventoryMaid.settings.weaponSettings.sellQualitys.legendary)
        InventoryMaid.settings.weaponSettings.sellQualitys.iconic = ImGui.Selectable("Sell iconic", InventoryMaid.settings.weaponSettings.sellQualitys.iconic)
		ImGui.ListBoxFooter()
    end
-- End Sell qualitys selection

-- Sell per type checkbox
    InventoryMaid.settings.weaponSettings.sellPerType = ImGui.Checkbox("Sell per type", InventoryMaid.settings.weaponSettings.sellPerType)
    ImGui.SameLine()
	ImGui.Button("?")
    tooltips.draw(InventoryMaid, ImGui.IsItemHovered(), "perType")
    ImGui.Separator()
-- End Sell per type checkbox

-- Draw type boxes
    InventoryMaid.CPS.colorBegin("Border", weaponUI.colors.frame)
    InventoryMaid.CPS.colorBegin("Separator", weaponUI.colors.frame)
    
    for _, k in pairs(InventoryMaid.settings.weaponSettings.typeOptions) do 
        weaponUI.drawType(InventoryMaid, k)
    end
    
    InventoryMaid.CPS.colorEnd(2)
-- End Draw type boxes
end

return weaponUI